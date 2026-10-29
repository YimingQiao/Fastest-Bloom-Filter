//! Four-sector Bloom filter with a register-resident 16-entry rotation dictionary.
//! Twelve bits across four words; top24 address and eight offset bits are disjoint.

use crate::{k12_parallel as layout_parallel, SizeError};

const PATTERNS: [u32; 16] = [
    0xb, 0x211, 0x2041, 0x40101, 0x1003, 0x8005, 0x10011, 0x109,
    0x8041, 0x40081, 0x403, 0x25, 0x411, 0x8081, 0x2003, 0x4009,
];
const PREFETCH_THRESHOLD: usize = 1 << 21;

#[repr(C, align(64))]
#[derive(Clone, Copy, Default, Debug, PartialEq, Eq)]
struct Line([u32; 16]);

/// Append-only Bloom filter setting three bits in each of four words per cache line.
/// Writes require exclusive access; immutable filters support concurrent reads.
#[derive(Clone)]
pub struct FourSectorRange12BloomFilter {
    lines: Vec<Line>,
    line_count: u32,
    avx512: bool,
    avx2: bool,
}

impl FourSectorRange12BloomFilter {
    #[inline]
    fn base(hi: u32, count: u32) -> u32 {
        ((((hi >> 8) as u64 * count as u64) >> 24) as u32 * 16) | (hi & 3)
    }
    /// Physical cache line. Address bits40..63 never overlap offset/mask bits.
    #[inline]
    pub fn line_index(&self, hash: u64) -> usize {
        Self::base((hash >> 32) as u32, self.line_count) as usize >> 4
    }

    #[inline]
    fn probe(&self, hash: u64) -> ([u32; 4], [u32; 4]) {
        Self::probe_mask(hash, self.line_count)
    }
    #[inline]
    fn probe_mask(hash: u64, line_count: u32) -> ([u32; 4], [u32; 4]) {
        let hi = (hash >> 32) as u32;
        let lo = hash as u32;
        let a = Self::base(hi, line_count);
        let indices = [
            a,
            a ^ 4 ^ ((hi >> 2) & 3),
            a ^ 8 ^ ((hi >> 4) & 3),
            a ^ 12 ^ ((hi >> 6) & 3),
        ];
        let masks = std::array::from_fn(|j| {
            let code = lo.rotate_right(j as u32 * 8);
            PATTERNS[(code & 15) as usize].rotate_left((code >> 4) & 31)
        });
        (indices, masks)
    }

    #[inline]
    fn insert_one_scalar(lines: &mut [Line], begin: usize, line_count: u32, hash: u64) {
        let (indices, masks) = Self::probe_mask(hash, line_count);
        for (index, mask) in indices.into_iter().zip(masks) {
            lines[(index as usize >> 4) - begin].0[index as usize & 15] |= mask;
        }
    }
    /// Insert one uniformly distributed hash; duplicates are idempotent.
    #[inline]
    pub fn insert_hash(&mut self, hash: u64) {
        Self::insert_one_scalar(&mut self.lines, 0, self.line_count, hash);
    }
    /// False means absent, true means possibly present.
    #[inline]
    pub fn contains_hash(&self, hash: u64) -> bool {
        self.contains_scalar(hash)
    }
    /// Runtime batch backend; `disable-avx512` retains AVX2/scalar dispatch.
    pub fn backend(&self) -> &'static str {
        layout_parallel::backend(self.avx512, self.avx2)
    }
    /// Effective build workers; tiny inputs remain serial, request 0 uses available parallelism.
    pub fn build_workers(&self, n: usize, requested: usize) -> usize {
        layout_parallel::build_workers(n, requested, self.lines.len())
    }
    /// Peak explicit construction scratch, excluding allocator metadata and OS thread stacks.
    /// Panics with `build scratch size overflow` if a multiworker estimate cannot fit in `usize`.
    pub fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
        layout_parallel::scratch_bytes(n, requested, self.lines.len())
    }
    /// Exclusive cache-line-partitioned build, including partitioning and thread launch.
    pub fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
        let mask = self.line_count;
        let (avx512, avx2) = (self.avx512, self.avx2);
        layout_parallel::insert(
            &mut self.lines,
            hashes,
            requested,
            |h| (Self::base((h >> 32) as u32, mask) >> 4) as usize,
            |lines, begin, input| Self::insert_into(lines, begin, mask, avx512, avx2, input),
        );
    }
    /// Parallel immutable batch; independent read-only batches may run concurrently.
    pub fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        layout_parallel::lookup(hashes, out, requested, |h, o| self.lookup_hashes(h, o));
    }
    #[inline]
    fn contains_scalar(&self, hash: u64) -> bool {
        let (indices, masks) = self.probe(hash);
        // probe_mask changes only the low four word-index bits across sectors.
        let line = &self.lines[indices[0] as usize >> 4].0;
        let mut pass = true;
        for (index, mask) in indices.into_iter().zip(masks) {
            pass &= line[index as usize & 15] & mask == mask;
        }
        pass
    }
}

impl FourSectorRange12BloomFilter {
    /// Complete64-byte lines within128bytes..256MiB inclusive; no pow2 rounding.
    pub fn with_byte_budget(bytes: usize) -> Result<Self, SizeError> {
        if bytes < 128 { return Err(SizeError::InvalidSize); }
        if bytes > 1 << 28 { return Err(SizeError::CapacityExceeded); }
        let count = bytes / 64;
        let lines = vec![Line::default(); count];
        if lines.capacity().checked_mul(64).ok_or(SizeError::CapacityExceeded)? > bytes {
            return Err(SizeError::CapacityExceeded);
        }
        let (avx512, avx2) = layout_parallel::backends();
        Ok(Self { lines, line_count: count as u32, avx512, avx2 })
    }
    /// floor(n*bpk/8) byte ceiling; real n, no synthetic sizing value.
    pub fn new(n: usize, bpk: u32) -> Result<Self, SizeError> {
        if n == 0 || bpk == 0 { return Err(SizeError::InvalidSize); }
        let bits = n.checked_mul(bpk as usize).ok_or(SizeError::InvalidSize)?;
        Self::with_byte_budget(bits / 8)
    }
    /// Actual bitmap backing allocation, excluding allocator metadata.
    pub fn size_in_bytes(&self) -> usize { self.lines.capacity() * 64 }
    /// Read-only logical bitmap words for exact cross-language fixture validation.
    pub fn bitmap_words(&self) -> &[u32] {
        // SAFETY: Line is repr(C,align64), exactly16 contiguous initialized u32s.
        unsafe { std::slice::from_raw_parts(self.lines.as_ptr().cast(), self.lines.len()*16) }
    }

    fn insert_into(
        lines: &mut [Line],
        begin: usize,
        line_count: u32,
        avx512: bool,
        avx2: bool,
        hashes: &[u64],
    ) {
        #[cfg(target_arch = "x86_64")]
        {
            if avx512 {
                // SAFETY: detected CPU backend; only hashes owned by these complete lines are passed.
                unsafe {
                    if lines.len() * 64 > PREFETCH_THRESHOLD {
                        Self::insert_avx512::<true>(lines, begin, line_count, hashes);
                    } else {
                        Self::insert_avx512::<false>(lines, begin, line_count, hashes);
                    }
                }
                return;
            }
            if avx2 {
                // SAFETY: detected CPU backend; slice is exclusive and all rebased indices belong to it.
                unsafe {
                    if lines.len() * 64 > PREFETCH_THRESHOLD {
                        Self::insert_avx2::<true>(lines, begin, line_count, hashes);
                    } else {
                        Self::insert_avx2::<false>(lines, begin, line_count, hashes);
                    }
                }
                return;
            }
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = (avx512, avx2);
        for &hash in hashes {
            Self::insert_one_scalar(lines, begin, line_count, hash);
        }
    }
    /// Exclusive append-only insertion; duplicates and colliding hashes are safe.
    pub fn insert_hashes(&mut self, hashes: &[u64]) {
        Self::insert_into(
            &mut self.lines,
            0,
            self.line_count,
            self.avx512,
            self.avx2,
            hashes,
        );
    }

    /// Writes one 0/1 per input; panics before writing if slice lengths differ.
    pub fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len(), "one output is required per input");
        #[cfg(target_arch = "x86_64")]
        if self.avx512 && hashes.len() >= 4 {
            // SAFETY: checked CPU features, equal output length and masked tails.
            unsafe {
                let large = self.size_in_bytes() > PREFETCH_THRESHOLD;
                if hashes.len() < 64 && (hashes.len() <= 8 || large) {
                    if large {
                        use std::arch::x86_64::*;
                        for &hash in hashes {
                            let index = Self::base((hash >> 32) as u32, self.line_count) as usize;
                            _mm_prefetch::<_MM_HINT_T0>(
                                self.lines.as_ptr().cast::<u32>().add(index).cast(),
                            );
                        }
                    }
                    self.lookup_short_avx512(hashes, out);
                } else if large {
                    self.lookup_avx512::<true>(hashes, out);
                } else {
                    self.lookup_avx512::<false>(hashes, out);
                }
            }
            return;
        }
        #[cfg(target_arch = "x86_64")]
        if self.avx2 && hashes.len() >= 8 {
            // SAFETY: detected AVX2, equal slice lengths and bounded vector loads.
            unsafe {
                if self.size_in_bytes() > PREFETCH_THRESHOLD {
                    self.lookup_avx2::<true>(hashes, out);
                } else {
                    self.lookup_avx2::<false>(hashes, out);
                }
            }
            return;
        }
        for (&hash, answer) in hashes.iter().zip(out) {
            *answer = self.contains_scalar(hash) as u32;
        }
    }
}

#[cfg(target_arch = "x86_64")]
impl FourSectorRange12BloomFilter {
    #[inline]
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn base512(hi: std::arch::x86_64::__m512i, count: u32) -> std::arch::x86_64::__m512i {
        use std::arch::x86_64::*;
        let address = _mm512_srli_epi32::<8>(hi);
        let counts = _mm512_set1_epi32(count as i32);
        let even = _mm512_srli_epi64::<24>(_mm512_mul_epu32(address, counts));
        let odd = _mm512_srli_epi64::<24>(_mm512_mul_epu32(_mm512_srli_epi64::<32>(address), counts));
        let blocks = _mm512_or_si512(even, _mm512_slli_epi64::<32>(odd));
        _mm512_or_si512(_mm512_slli_epi32::<4>(blocks), _mm512_and_si512(hi, _mm512_set1_epi32(3)))
    }
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn base256(hi: std::arch::x86_64::__m256i, count: u32) -> std::arch::x86_64::__m256i {
        use std::arch::x86_64::*;
        let address = _mm256_srli_epi32::<8>(hi);
        let counts = _mm256_set1_epi32(count as i32);
        let even = _mm256_srli_epi64::<24>(_mm256_mul_epu32(address, counts));
        let odd = _mm256_srli_epi64::<24>(_mm256_mul_epu32(_mm256_srli_epi64::<32>(address), counts));
        let blocks = _mm256_or_si256(even, _mm256_slli_epi64::<32>(odd));
        _mm256_or_si256(_mm256_slli_epi32::<4>(blocks), _mm256_and_si256(hi, _mm256_set1_epi32(3)))
    }

    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn insert_avx512<const PREFETCH: bool>(
        lines: &mut [Line],
        begin: usize,
        line_count: u32,
        hashes: &[u64],
    ) {
        use std::arch::x86_64::*;
        let even = _mm512_setr_epi32(0, 0, 0, 0, 2, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6);
        let odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
        let rotations = _mm512_setr_epi32(0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24);
        let quarters = _mm512_setr_epi32(0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12);
        let offset_shifts = _mm512_setr_epi32(
            2, 2, 4, 6, 2, 2, 4, 6, 2, 2, 4, 6, 2, 2, 4, 6,
        );
        let offset_masks = _mm512_setr_epi32(0, 3, 3, 3, 0, 3, 3, 3, 0, 3, 3, 3, 0, 3, 3, 3);
        let table = _mm512_loadu_si512(PATTERNS.as_ptr().cast());
        let words = lines.as_mut_ptr().cast::<u32>();
        let mut i = 0;
        while i + 4 <= hashes.len() {
            if PREFETCH && i + 68 <= hashes.len() {
                for j in 0..4 {
                    let index =
                        Self::base((hashes[i + 64 + j] >> 32) as u32, line_count) as usize - begin * 16;
                    debug_assert!(index < lines.len() * 16);
                    _mm_prefetch::<_MM_HINT_T0>(words.add(index).cast());
                }
            }
            let packed = _mm512_castsi256_si512(_mm256_loadu_si256(hashes.as_ptr().add(i).cast()));
            let lo = _mm512_permutexvar_epi32(even, packed);
            let hi = _mm512_permutexvar_epi32(odd, packed);
            let code = _mm512_rorv_epi32(lo, rotations);
            let masks = _mm512_rolv_epi32(
                _mm512_permutexvar_epi32(code, table),
                _mm512_srli_epi32::<4>(code),
            );
            let offsets = _mm512_and_si512(_mm512_srlv_epi32(hi, offset_shifts), offset_masks);
            let indices = _mm512_xor_si512(
                Self::base512(hi, line_count),
                _mm512_xor_si512(quarters, offsets),
            );
            let mut index = [0u32; 16];
            let mut mask = [0u32; 16];
            _mm512_storeu_si512(
                index.as_mut_ptr().cast(),
                _mm512_sub_epi32(indices, _mm512_set1_epi32((begin * 16) as i32)),
            );
            _mm512_storeu_si512(mask.as_mut_ptr().cast(), masks);
            // Sequential ORs retain all bits if different keys select one word.
            for j in 0..16 {
                debug_assert!((index[j] as usize) < lines.len() * 16);
                *words.add(index[j] as usize) |= mask[j];
            }
            i += 4;
        }
        for &hash in &hashes[i..] {
            Self::insert_one_scalar(lines, begin, line_count, hash);
        }
    }

    #[inline]
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn query_chunk<const MASKED: bool>(
        &self,
        hashes: *const u64,
        out: *mut u32,
        valid: u16,
        table: std::arch::x86_64::__m512i,
    ) {
        use std::arch::x86_64::*;
        let even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30);
        let odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
        let x = if MASKED {
            _mm512_maskz_loadu_epi64(valid as u8, hashes.cast())
        } else {
            _mm512_loadu_si512(hashes.cast())
        };
        // Forming hashes.add(8) itself requires at least eight input objects.
        let y = if MASKED {
            if valid >> 8 != 0 {
                _mm512_maskz_loadu_epi64((valid >> 8) as u8, hashes.add(8).cast())
            } else {
                _mm512_setzero_si512()
            }
        } else {
            _mm512_loadu_si512(hashes.add(8).cast())
        };
        let lo = _mm512_permutex2var_epi32(x, even, y);
        let hi = _mm512_permutex2var_epi32(x, odd, y);
        let a = Self::base512(hi, self.line_count);
        let b = _mm512_xor_si512(
            a,
            _mm512_or_si512(
                _mm512_set1_epi32(4),
                _mm512_and_si512(_mm512_srli_epi32::<2>(hi), _mm512_set1_epi32(3)),
            ),
        );
        let c = _mm512_xor_si512(
            a,
            _mm512_or_si512(
                _mm512_set1_epi32(8),
                _mm512_and_si512(_mm512_srli_epi32::<4>(hi), _mm512_set1_epi32(3)),
            ),
        );
        let d = _mm512_xor_si512(
            a,
            _mm512_or_si512(
                _mm512_set1_epi32(12),
                _mm512_and_si512(_mm512_srli_epi32::<6>(hi), _mm512_set1_epi32(3)),
            ),
        );
        let code2 = _mm512_ror_epi32::<8>(lo);
        let code3 = _mm512_ror_epi32::<16>(lo);
        let code4 = _mm512_ror_epi32::<24>(lo);
        let m1 = _mm512_rolv_epi32(
            _mm512_permutexvar_epi32(lo, table),
            _mm512_srli_epi32::<4>(lo),
        );
        let m2 = _mm512_rolv_epi32(
            _mm512_permutexvar_epi32(code2, table),
            _mm512_srli_epi32::<4>(code2),
        );
        let m3 = _mm512_rolv_epi32(
            _mm512_permutexvar_epi32(code3, table),
            _mm512_srli_epi32::<4>(code3),
        );
        let m4 = _mm512_rolv_epi32(
            _mm512_permutexvar_epi32(code4, table),
            _mm512_srli_epi32::<4>(code4),
        );
        let zero = _mm512_setzero_si512();
        let words = self.lines.as_ptr().cast::<i32>();
        let v1 = _mm512_mask_i32gather_epi32::<4>(zero, valid, a, words);
        let v2 = _mm512_mask_i32gather_epi32::<4>(zero, valid, b, words);
        let v3 = _mm512_mask_i32gather_epi32::<4>(zero, valid, c, words);
        let v4 = _mm512_mask_i32gather_epi32::<4>(zero, valid, d, words);
        let pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(v1, m1), m1)
            & _mm512_cmpeq_epi32_mask(_mm512_and_si512(v2, m2), m2)
            & _mm512_cmpeq_epi32_mask(_mm512_and_si512(v3, m3), m3)
            & _mm512_cmpeq_epi32_mask(_mm512_and_si512(v4, m4), m4);
        let answers = _mm512_maskz_set1_epi32(pass, 1);
        if MASKED {
            _mm512_mask_storeu_epi32(out.cast(), valid, answers);
        } else {
            _mm512_storeu_si512(out.cast(), answers);
        }
    }

    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn lookup_short_avx512(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        // Eight keys repeated across both halves: one gather probes sectors 0/1,
        // and the second probes sectors 2/3. Bitmap masks remain unchanged.
        let even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 0, 2, 4, 6, 8, 10, 12, 14);
        let odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
        let rotations = _mm512_setr_epi32(0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8);
        let quarters = _mm512_setr_epi32(0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4);
        let offset_mask = _mm512_setr_epi32(0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3);
        let shifts2 = _mm512_setr_epi32(
            4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6,
        );
        let table = _mm512_loadu_si512(PATTERNS.as_ptr().cast());
        let zero = _mm512_setzero_si512();
        let words = self.lines.as_ptr().cast::<i32>();
        let mut i = 0;
        while i < hashes.len() {
            let count = (hashes.len() - i).min(8);
            let valid = (1u16 << count) - 1;
            let packed = if count == 8 {
                _mm512_loadu_si512(hashes.as_ptr().add(i).cast())
            } else {
                _mm512_maskz_loadu_epi64(valid as u8, hashes.as_ptr().add(i).cast())
            };
            let lo = _mm512_permutexvar_epi32(even, packed);
            let hi = _mm512_permutexvar_epi32(odd, packed);
            let code = _mm512_rorv_epi32(lo, rotations);
            let mask = _mm512_rolv_epi32(
                _mm512_permutexvar_epi32(code, table),
                _mm512_srli_epi32::<4>(code),
            );
            let base = Self::base512(hi, self.line_count);
            let offsets = _mm512_and_si512(_mm512_srli_epi32::<2>(hi), offset_mask);
            let index = _mm512_xor_si512(base, _mm512_xor_si512(quarters, offsets));
            let lanes = valid * 0x101;
            let values = _mm512_mask_i32gather_epi32::<4>(zero, lanes, index, words);
            let offsets2 = _mm512_and_si512(_mm512_srlv_epi32(hi, shifts2), _mm512_set1_epi32(3));
            let index2 = _mm512_xor_si512(
                base,
                _mm512_xor_si512(_mm512_add_epi32(quarters, _mm512_set1_epi32(8)), offsets2),
            );
            let code2 = _mm512_ror_epi32::<16>(code);
            let mask2 = _mm512_rolv_epi32(
                _mm512_permutexvar_epi32(code2, table),
                _mm512_srli_epi32::<4>(code2),
            );
            let values2 = _mm512_mask_i32gather_epi32::<4>(zero, lanes, index2, words);
            let mut pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(values, mask), mask)
                & _mm512_cmpeq_epi32_mask(_mm512_and_si512(values2, mask2), mask2);
            pass &= pass >> 8;
            _mm512_mask_storeu_epi32(
                out.as_mut_ptr().add(i).cast(),
                valid,
                _mm512_maskz_set1_epi32(pass, 1),
            );
            i += 8;
        }
    }

    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn lookup_avx512<const PREFETCH: bool>(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        let table = _mm512_loadu_si512(PATTERNS.as_ptr().cast());
        let mut i = 0;
        while i + 16 <= hashes.len() {
            if PREFETCH && i + 80 <= hashes.len() {
                for j in 0..16 {
                    let index = Self::base((hashes[i + 64 + j] >> 32) as u32, self.line_count) as usize;
                    _mm_prefetch::<_MM_HINT_T0>(
                        self.lines.as_ptr().cast::<u32>().add(index).cast(),
                    );
                }
            }
            self.query_chunk::<false>(
                hashes.as_ptr().add(i),
                out.as_mut_ptr().add(i),
                u16::MAX,
                table,
            );
            i += 16;
        }
        if i < hashes.len() {
            self.query_chunk::<true>(
                hashes.as_ptr().add(i),
                out.as_mut_ptr().add(i),
                ((1u32 << (hashes.len() - i)) - 1) as u16,
                table,
            );
        }
    }
}

#[cfg(target_arch = "x86_64")]
impl FourSectorRange12BloomFilter {
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn mask_avx2(
        code: std::arch::x86_64::__m256i,
        t0: std::arch::x86_64::__m256i,
        t1: std::arch::x86_64::__m256i,
    ) -> std::arch::x86_64::__m256i {
        use std::arch::x86_64::*;
        let select = _mm256_srai_epi32::<31>(_mm256_slli_epi32::<28>(code));
        let pattern = _mm256_blendv_epi8(
            _mm256_permutevar8x32_epi32(t0, code),
            _mm256_permutevar8x32_epi32(t1, code),
            select,
        );
        let r = _mm256_and_si256(_mm256_srli_epi32::<4>(code), _mm256_set1_epi32(31));
        _mm256_or_si256(
            _mm256_sllv_epi32(pattern, r),
            _mm256_srlv_epi32(pattern, _mm256_sub_epi32(_mm256_set1_epi32(32), r)),
        )
    }
    #[target_feature(enable = "avx2")]
    unsafe fn insert_avx2<const PREFETCH: bool>(
        lines: &mut [Line],
        begin: usize,
        line_count: u32,
        hashes: &[u64],
    ) {
        use std::arch::x86_64::*;
        let even = _mm256_setr_epi32(0, 0, 0, 0, 2, 2, 2, 2);
        let odd = _mm256_add_epi32(even, _mm256_set1_epi32(1));
        let rotations = _mm256_setr_epi32(0, 8, 16, 24, 0, 8, 16, 24);
        let reverse = _mm256_sub_epi32(_mm256_set1_epi32(32), rotations);
        let quarters = _mm256_setr_epi32(0, 4, 8, 12, 0, 4, 8, 12);
        let shifts = _mm256_setr_epi32(2, 2, 4, 6, 2, 2, 4, 6);
        let offset_masks = _mm256_setr_epi32(0, 3, 3, 3, 0, 3, 3, 3);
        let t0 = _mm256_loadu_si256(PATTERNS.as_ptr().cast());
        let t1 = _mm256_loadu_si256(PATTERNS.as_ptr().add(8).cast());
        let words = lines.as_mut_ptr().cast::<u32>();
        let mut i = 0;
        while i + 2 <= hashes.len() {
            if PREFETCH && i + 66 <= hashes.len() {
                for j in 0..2 {
                    let index =
                        Self::base((hashes[i + 64 + j] >> 32) as u32, line_count) as usize - begin * 16;
                    debug_assert!(index < lines.len() * 16);
                    _mm_prefetch::<_MM_HINT_T0>(words.add(index).cast());
                }
            }
            let packed = _mm256_castsi128_si256(_mm_loadu_si128(hashes.as_ptr().add(i).cast()));
            let lo = _mm256_permutevar8x32_epi32(packed, even);
            let hi = _mm256_permutevar8x32_epi32(packed, odd);
            let code = _mm256_or_si256(
                _mm256_srlv_epi32(lo, rotations),
                _mm256_sllv_epi32(lo, reverse),
            );
            let offsets = _mm256_and_si256(_mm256_srlv_epi32(hi, shifts), offset_masks);
            let indices = _mm256_sub_epi32(
                _mm256_xor_si256(
                    Self::base256(hi, line_count),
                    _mm256_xor_si256(quarters, offsets),
                ),
                _mm256_set1_epi32((begin * 16) as i32),
            );
            let mut index = [0u32; 8];
            let mut mask = [0u32; 8];
            _mm256_storeu_si256(index.as_mut_ptr().cast(), indices);
            _mm256_storeu_si256(mask.as_mut_ptr().cast(), Self::mask_avx2(code, t0, t1));
            for j in 0..8 {
                debug_assert!((index[j] as usize) < lines.len() * 16);
                *words.add(index[j] as usize) |= mask[j];
            }
            i += 2;
        }
        for &h in &hashes[i..] {
            Self::insert_one_scalar(lines, begin, line_count, h);
        }
    }
    #[target_feature(enable = "avx2")]
    unsafe fn lookup_avx2<const PREFETCH: bool>(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        let order = _mm256_setr_epi32(0, 2, 4, 6, 1, 3, 5, 7);
        let t0 = _mm256_loadu_si256(PATTERNS.as_ptr().cast());
        let t1 = _mm256_loadu_si256(PATTERNS.as_ptr().add(8).cast());
        let words = self.lines.as_ptr().cast::<i32>();
        let mut i = 0;
        while i + 8 <= hashes.len() {
            if PREFETCH && i + 72 <= hashes.len() {
                for j in 0..8 {
                    let index = Self::base((hashes[i + 64 + j] >> 32) as u32, self.line_count) as usize;
                    _mm_prefetch::<_MM_HINT_T0>(words.add(index).cast());
                }
            }
            let x = _mm256_permutevar8x32_epi32(
                _mm256_loadu_si256(hashes.as_ptr().add(i).cast()),
                order,
            );
            let y = _mm256_permutevar8x32_epi32(
                _mm256_loadu_si256(hashes.as_ptr().add(i + 4).cast()),
                order,
            );
            let lo = _mm256_permute2x128_si256::<0x20>(x, y);
            let hi = _mm256_permute2x128_si256::<0x31>(x, y);
            let a = Self::base256(hi, self.line_count);
            let b = _mm256_xor_si256(
                a,
                _mm256_or_si256(
                    _mm256_set1_epi32(4),
                    _mm256_and_si256(_mm256_srli_epi32::<2>(hi), _mm256_set1_epi32(3)),
                ),
            );
            let c = _mm256_xor_si256(
                a,
                _mm256_or_si256(
                    _mm256_set1_epi32(8),
                    _mm256_and_si256(_mm256_srli_epi32::<4>(hi), _mm256_set1_epi32(3)),
                ),
            );
            let d = _mm256_xor_si256(
                a,
                _mm256_or_si256(
                    _mm256_set1_epi32(12),
                    _mm256_and_si256(_mm256_srli_epi32::<6>(hi), _mm256_set1_epi32(3)),
                ),
            );
            let code2 = _mm256_or_si256(_mm256_srli_epi32::<8>(lo), _mm256_slli_epi32::<24>(lo));
            let code3 = _mm256_or_si256(_mm256_srli_epi32::<16>(lo), _mm256_slli_epi32::<16>(lo));
            let code4 = _mm256_or_si256(_mm256_srli_epi32::<24>(lo), _mm256_slli_epi32::<8>(lo));
            let m1 = Self::mask_avx2(lo, t0, t1);
            let m2 = Self::mask_avx2(code2, t0, t1);
            let m3 = Self::mask_avx2(code3, t0, t1);
            let m4 = Self::mask_avx2(code4, t0, t1);
            let v1 = _mm256_i32gather_epi32::<4>(words, a);
            let v2 = _mm256_i32gather_epi32::<4>(words, b);
            let v3 = _mm256_i32gather_epi32::<4>(words, c);
            let v4 = _mm256_i32gather_epi32::<4>(words, d);
            let p1 = _mm256_cmpeq_epi32(_mm256_and_si256(v1, m1), m1);
            let p2 = _mm256_cmpeq_epi32(_mm256_and_si256(v2, m2), m2);
            let p3 = _mm256_cmpeq_epi32(_mm256_and_si256(v3, m3), m3);
            let p4 = _mm256_cmpeq_epi32(_mm256_and_si256(v4, m4), m4);
            _mm256_storeu_si256(
                out.as_mut_ptr().add(i).cast(),
                _mm256_and_si256(
                    _mm256_and_si256(_mm256_and_si256(p1, p2), _mm256_and_si256(p3, p4)),
                    _mm256_set1_epi32(1),
                ),
            );
            i += 8;
        }
        for j in i..hashes.len() {
            out[j] = self.contains_scalar(hashes[j]) as u32;
        }
    }
}


#[cfg(test)]
#[path = "four_sector_range12_tests.rs"]
mod tests;

#[cfg(test)]
#[path = "simd_singleton_focused.rs"]
mod simd_singleton_focused;
