//! Native, append-only Bloom filters over uniformly hashed u64 inputs.
//! Construction requires exclusive access; immutable filters support concurrent reads.
//! Each filter layout has its own bitmap mapping; layouts are not interchangeable.
use std::fmt;

mod byte_split;
mod four_sector;
mod layout_parallel;
mod parallel;
mod patterns;
mod range_parallel;
mod split64;
mod split64_range;
pub use byte_split::ByteSplitBloomFilter;
pub use four_sector::FourSectorBloomFilter;
pub use parallel::AtomicFastPatternBloomFilter;
pub use split64::Split64BloomFilter;
pub use split64_range::Split64RangeBloomFilter;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SizeError {
    InvalidSize,
    CapacityExceeded,
}
impl fmt::Display for SizeError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for SizeError {}

/// A 64-byte aligned cache line. This keeps both sectors of every probe in one line.
#[repr(C, align(64))]
#[derive(Clone, Copy, Default)]
struct Line([u32; 16]);

/// Uses the original cache-sectorized seven-bit mask distribution.
pub type SectorizedBloomFilter = BloomFilter<false>;
/// Uses six or eight bits selected with a register-resident rotate-mask dictionary.
pub type FastPatternBloomFilter = BloomFilter<true>;

#[derive(Clone)]
pub struct BloomFilter<const PATTERN: bool = true> {
    lines: Vec<Line>,
    block_mask: u32,
    avx512: bool,
    avx2: bool,
    patterns: &'static [u32; 32],
}
impl<const PATTERN: bool> BloomFilter<PATTERN> {
    /// Matches the C++ legacy strict-next-power-of-two sizing, up to 256 MiB.
    /// `bits_per_key` is a request: inspect `size_in_bytes()` for actual allocation.
    pub fn new(keys: usize, bits_per_key: u32) -> Result<Self, SizeError> {
        let words = Self::word_count(keys, bits_per_key)?;
        #[cfg(target_arch = "x86_64")]
        let avx512 = !cfg!(feature = "disable-avx512") && std::is_x86_feature_detected!("avx512f");
        #[cfg(not(target_arch = "x86_64"))]
        let avx512 = false;
        #[cfg(target_arch = "x86_64")]
        let avx2 = std::is_x86_feature_detected!("avx2");
        #[cfg(not(target_arch = "x86_64"))]
        let avx2 = false;
        Ok(Self {
            lines: vec![Line::default(); words / 16],
            block_mask: (words - 1) as u32,
            avx512,
            avx2,
            patterns: if keys > words * 32 / 12 {
                &patterns::SPARSE
            } else {
                &patterns::DENSE
            },
        })
    }
    fn word_count(keys: usize, bits_per_key: u32) -> Result<usize, SizeError> {
        if bits_per_key == 0 {
            return Err(SizeError::InvalidSize);
        }
        let bits = keys
            .checked_mul(bits_per_key as usize)
            .ok_or(SizeError::InvalidSize)?
            .max(512);
        if bits >= 1usize << 31 {
            return Err(SizeError::CapacityExceeded);
        }
        let mut words = 32;
        while words <= bits / 32 {
            words *= 2;
        }
        Ok(words)
    }
    pub fn size_in_bytes(&self) -> usize {
        self.lines.len() * 64
    }
    pub fn backend(&self) -> &'static str {
        if self.avx512 {
            "avx512"
        } else if self.avx2 {
            "avx2"
        } else {
            "scalar"
        }
    }
    #[inline]
    fn block(&self, h: u64) -> usize {
        let a = if PATTERN {
            (h >> 32) as u32
        } else {
            (h as u32 & ((1 << 17) - 1)) | (((h >> 32) as u32).wrapping_shl(14) & (511 << 17))
        };
        (a & self.block_mask) as usize
    }
    #[inline]
    fn second(&self, h: u64, a: usize) -> usize {
        a ^ (8 + ((if PATTERN { h >> 20 } else { h >> 32 }) as usize & 7))
    }
    #[inline]
    fn masks(&self, h: u64) -> (u32, u32) {
        let lo = h as u32;
        let hi = (h >> 32) as u32;
        if PATTERN {
            (
                self.patterns[(lo & 31) as usize].rotate_left(lo >> 5),
                self.patterns[((lo >> 10) & 31) as usize].rotate_left(lo >> 15),
            )
        } else {
            (
                (1 << ((lo >> 17) & 31)) | (1 << ((lo >> 22) & 31)) | (1 << (lo >> 27)),
                (1 << ((hi >> 12) & 31))
                    | (1 << ((hi >> 17) & 31))
                    | (1 << ((hi >> 22) & 31))
                    | (1 << (hi >> 27)),
            )
        }
    }
    #[inline]
    pub fn insert_hash(&mut self, h: u64) {
        let a = self.block(h);
        let b = self.second(h, a);
        let (m1, m2) = self.masks(h);
        self.lines[a / 16].0[a % 16] |= m1;
        self.lines[b / 16].0[b % 16] |= m2;
    }
    /// Duplicate and colliding inserts are safe. No vector scatter loses updates.
    pub fn insert_hashes(&mut self, hashes: &[u64]) {
        #[cfg(target_arch = "x86_64")]
        if PATTERN && self.avx512 {
            // SAFETY: feature detection, valid slices, masked in-allocation indices.
            unsafe {
                if self.size_in_bytes() > (1 << 21) {
                    self.insert_avx512::<true>(hashes);
                } else {
                    self.insert_avx512::<false>(hashes);
                }
            }
            return;
        }
        #[cfg(target_arch = "x86_64")]
        if PATTERN && self.avx2 {
            // SAFETY: feature detection, valid slices and bounded bitmap indices.
            unsafe {
                if self.size_in_bytes() > (1 << 21) {
                    self.insert_avx2::<true>(hashes);
                } else {
                    self.insert_avx2::<false>(hashes);
                }
            }
            return;
        }
        for &h in hashes {
            self.insert_hash(h);
        }
    }
    #[inline]
    pub fn contains_hash(&self, h: u64) -> bool {
        let a = self.block(h);
        let b = self.second(h, a);
        let (m1, m2) = self.masks(h);
        ((self.lines[a / 16].0[a % 16] & m1) == m1) & ((self.lines[b / 16].0[b % 16] & m2) == m2)
    }
    /// Writes one 0/1 per input. Panics before writing if lengths differ.
    pub fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len(), "one output is required per input");
        // Tiny calls avoid SIMD setup and the cache-size/backend dispatch.
        if PATTERN && hashes.len() <= 3 {
            for (&hash, value) in hashes.iter().zip(out.iter_mut()) {
                *value = self.contains_hash(hash) as u32;
            }
            return;
        }
        #[cfg(target_arch = "x86_64")]
        if self.avx512 {
            // SAFETY: runtime feature detection; exact slice lengths checked above.
            unsafe {
                if self.size_in_bytes() > (1 << 21) {
                    self.lookup_avx512::<true>(hashes, out);
                } else {
                    self.lookup_avx512::<false>(hashes, out);
                }
            }
            return;
        }
        #[cfg(target_arch = "x86_64")]
        if self.avx2 {
            // SAFETY: runtime feature detection; output length checked above.
            unsafe {
                if self.size_in_bytes() > (1 << 21) {
                    self.lookup_avx2::<true>(hashes, out);
                } else {
                    self.lookup_avx2::<false>(hashes, out);
                }
            }
            return;
        }
        for (&h, v) in hashes.iter().zip(out.iter_mut()) {
            *v = self.contains_hash(h) as u32;
        }
    }

    #[cfg(target_arch = "x86_64")]
    #[target_feature(enable = "avx2")]
    unsafe fn insert_avx2<const PREFETCH: bool>(&mut self, hashes: &[u64]) {
        use std::arch::x86_64::*;
        let base = self.lines.as_mut_ptr().cast::<u32>();
        let mut i = 0;
        while i + 4 <= hashes.len() {
            if PREFETCH && i + 68 <= hashes.len() {
                for j in 0..4 {
                    _mm_prefetch::<_MM_HINT_T2>(base.add(self.block(hashes[i + 64 + j])).cast());
                }
            }
            let h = _mm256_loadu_si256(hashes.as_ptr().add(i).cast());
            let a = _mm256_and_si256(
                _mm256_shuffle_epi32::<0xf5>(h),
                _mm256_set1_epi32(self.block_mask as i32),
            );
            let delta = _mm256_or_si256(
                _mm256_set1_epi64x(8i64 << 32),
                _mm256_and_si256(_mm256_slli_epi64::<12>(h), _mm256_set1_epi64x(7i64 << 32)),
            );
            let code = _mm256_srlv_epi32(
                _mm256_shuffle_epi32::<0xa0>(h),
                _mm256_set1_epi64x(10i64 << 32),
            );
            let v = _mm256_i32gather_epi32::<4>(
                self.patterns.as_ptr().cast(),
                _mm256_and_si256(code, _mm256_set1_epi32(31)),
            );
            let r = _mm256_and_si256(_mm256_srli_epi32::<5>(code), _mm256_set1_epi32(31));
            let mask = _mm256_or_si256(
                _mm256_sllv_epi32(v, r),
                _mm256_srlv_epi32(v, _mm256_sub_epi32(_mm256_set1_epi32(32), r)),
            );
            let indexes: [u32; 8] = std::mem::transmute(_mm256_xor_si256(a, delta));
            let masks: [u32; 8] = std::mem::transmute(mask);
            for j in 0..8 {
                *base.add(indexes[j] as usize) |= masks[j];
            }
            i += 4;
        }
        for &h in &hashes[i..] {
            self.insert_hash(h);
        }
    }

    #[cfg(target_arch = "x86_64")]
    #[target_feature(enable = "avx2")]
    unsafe fn lookup_avx2<const PREFETCH: bool>(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        let order = _mm256_setr_epi32(0, 2, 4, 6, 1, 3, 5, 7);
        let one = _mm256_set1_epi32(1);
        let low5 = _mm256_set1_epi32(31);
        let base = self.lines.as_ptr().cast::<i32>();
        let mut i = 0;
        while i + 8 <= hashes.len() {
            if PREFETCH && i + 72 <= hashes.len() {
                for j in 0..8 {
                    _mm_prefetch::<_MM_HINT_T0>(base.add(self.block(hashes[i + 64 + j])).cast());
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
            let a = if PATTERN {
                _mm256_and_si256(hi, _mm256_set1_epi32(self.block_mask as i32))
            } else {
                _mm256_and_si256(
                    _mm256_set1_epi32(self.block_mask as i32),
                    _mm256_or_si256(
                        _mm256_and_si256(lo, _mm256_set1_epi32((1 << 17) - 1)),
                        _mm256_and_si256(_mm256_slli_epi32::<14>(hi), _mm256_set1_epi32(511 << 17)),
                    ),
                )
            };
            let sector = if PATTERN {
                _mm256_srli_epi32::<20>(lo)
            } else {
                hi
            };
            let b = _mm256_xor_si256(
                a,
                _mm256_or_si256(
                    _mm256_set1_epi32(8),
                    _mm256_and_si256(sector, _mm256_set1_epi32(7)),
                ),
            );
            let (m1, m2) = if PATTERN {
                let pattern = |code| {
                    let v = _mm256_i32gather_epi32::<4>(
                        self.patterns.as_ptr().cast(),
                        _mm256_and_si256(code, low5),
                    );
                    let r = _mm256_and_si256(_mm256_srli_epi32::<5>(code), low5);
                    _mm256_or_si256(
                        _mm256_sllv_epi32(v, r),
                        _mm256_srlv_epi32(v, _mm256_sub_epi32(_mm256_set1_epi32(32), r)),
                    )
                };
                (pattern(lo), pattern(_mm256_srli_epi32::<10>(lo)))
            } else {
                let mask = |v, shift| {
                    _mm256_sllv_epi32(
                        one,
                        _mm256_and_si256(_mm256_srlv_epi32(v, _mm256_set1_epi32(shift)), low5),
                    )
                };
                (
                    _mm256_or_si256(mask(lo, 17), _mm256_or_si256(mask(lo, 22), mask(lo, 27))),
                    _mm256_or_si256(
                        _mm256_or_si256(mask(hi, 12), mask(hi, 17)),
                        _mm256_or_si256(mask(hi, 22), mask(hi, 27)),
                    ),
                )
            };
            let v1 = _mm256_i32gather_epi32::<4>(base, a);
            let v2 = _mm256_i32gather_epi32::<4>(base, b);
            let pass = _mm256_and_si256(
                _mm256_cmpeq_epi32(_mm256_and_si256(v1, m1), m1),
                _mm256_cmpeq_epi32(_mm256_and_si256(v2, m2), m2),
            );
            _mm256_storeu_si256(out.as_mut_ptr().add(i).cast(), _mm256_and_si256(pass, one));
            i += 8;
        }
        for j in i..hashes.len() {
            out[j] = self.contains_hash(hashes[j]) as u32;
        }
    }

    #[cfg(target_arch = "x86_64")]
    #[target_feature(enable = "avx512f")]
    unsafe fn insert_avx512<const PREFETCH: bool>(&mut self, hashes: &[u64]) {
        use std::arch::x86_64::*;
        let table0 = _mm512_loadu_si512(self.patterns.as_ptr().cast());
        let table1 = _mm512_loadu_si512(self.patterns.as_ptr().add(16).cast());
        let base = self.lines.as_mut_ptr().cast::<u32>();
        let mut i = 0;
        while i + 8 <= hashes.len() {
            if PREFETCH && i + 72 <= hashes.len() {
                for j in 0..8 {
                    _mm_prefetch::<_MM_HINT_T2>(base.add(self.block(hashes[i + 64 + j])).cast());
                }
            }
            let h = _mm512_loadu_si512(hashes.as_ptr().add(i).cast());
            let a = _mm512_and_si512(
                _mm512_shuffle_epi32::<0xf5>(h),
                _mm512_set1_epi32(self.block_mask as i32),
            );
            let delta = _mm512_or_si512(
                _mm512_set1_epi64(8i64 << 32),
                _mm512_and_si512(_mm512_slli_epi64::<12>(h), _mm512_set1_epi64(7i64 << 32)),
            );
            let index = _mm512_xor_si512(a, delta);
            let code = _mm512_srlv_epi32(
                _mm512_shuffle_epi32::<0xa0>(h),
                _mm512_set1_epi64(10i64 << 32),
            );
            let mask = _mm512_rolv_epi32(
                _mm512_permutex2var_epi32(table0, code, table1),
                _mm512_srli_epi32::<5>(code),
            );
            let indexes: [u32; 16] = std::mem::transmute(index);
            let masks: [u32; 16] = std::mem::transmute(mask);
            // Sequential ORs preserve duplicate addresses within and across batches.
            for j in 0..16 {
                *base.add(indexes[j] as usize) |= masks[j];
            }
            i += 8;
        }
        for &h in &hashes[i..] {
            self.insert_hash(h);
        }
    }

    #[cfg(target_arch = "x86_64")]
    #[target_feature(enable = "avx512f")]
    unsafe fn lookup_avx512<const PREFETCH: bool>(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        let mut i = 0;
        let even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30);
        let odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
        let table0 = _mm512_loadu_si512(self.patterns.as_ptr().cast());
        let table1 = _mm512_loadu_si512(self.patterns.as_ptr().add(16).cast());
        let base = self.lines.as_ptr().cast::<i32>();
        while i + 16 <= hashes.len() {
            if PREFETCH && i + 80 <= hashes.len() {
                for j in 0..16 {
                    // All masked indices are within the backing allocation.
                    _mm_prefetch::<_MM_HINT_T0>(base.add(self.block(hashes[i + 64 + j])).cast());
                }
            }
            let x = _mm512_loadu_si512(hashes.as_ptr().add(i).cast());
            let y = _mm512_loadu_si512(hashes.as_ptr().add(i + 8).cast());
            let lo = _mm512_permutex2var_epi32(x, even, y);
            let hi = _mm512_permutex2var_epi32(x, odd, y);
            let a = if PATTERN {
                _mm512_and_si512(hi, _mm512_set1_epi32(self.block_mask as i32))
            } else {
                _mm512_and_si512(
                    _mm512_set1_epi32(self.block_mask as i32),
                    _mm512_or_si512(
                        _mm512_and_si512(lo, _mm512_set1_epi32((1 << 17) - 1)),
                        _mm512_and_si512(_mm512_slli_epi32::<14>(hi), _mm512_set1_epi32(511 << 17)),
                    ),
                )
            };
            let sector = if PATTERN {
                _mm512_srli_epi32::<20>(lo)
            } else {
                hi
            };
            let b = _mm512_xor_si512(
                a,
                _mm512_or_si512(
                    _mm512_set1_epi32(8),
                    _mm512_and_si512(sector, _mm512_set1_epi32(7)),
                ),
            );
            let (m1, m2) = if PATTERN {
                (
                    _mm512_rolv_epi32(
                        _mm512_permutex2var_epi32(table0, lo, table1),
                        _mm512_srli_epi32::<5>(lo),
                    ),
                    _mm512_rolv_epi32(
                        _mm512_permutex2var_epi32(table0, _mm512_srli_epi32::<10>(lo), table1),
                        _mm512_srli_epi32::<15>(lo),
                    ),
                )
            } else {
                let one = _mm512_set1_epi32(1);
                let low5 = _mm512_set1_epi32(31);
                let mask = |v, shift| {
                    _mm512_sllv_epi32(
                        one,
                        _mm512_and_si512(_mm512_srlv_epi32(v, _mm512_set1_epi32(shift)), low5),
                    )
                };
                (
                    _mm512_ternarylogic_epi32::<0xfe>(mask(lo, 17), mask(lo, 22), mask(lo, 27)),
                    _mm512_or_si512(
                        mask(hi, 12),
                        _mm512_ternarylogic_epi32::<0xfe>(mask(hi, 17), mask(hi, 22), mask(hi, 27)),
                    ),
                )
            };
            let v1 = _mm512_i32gather_epi32::<4>(a, base);
            let v2 = _mm512_i32gather_epi32::<4>(b, base);
            let pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(v1, m1), m1)
                & _mm512_cmpeq_epi32_mask(_mm512_and_si512(v2, m2), m2);
            _mm512_storeu_si512(
                out.as_mut_ptr().add(i).cast(),
                _mm512_maskz_set1_epi32(pass, 1),
            );
            i += 16;
        }
        // Pair the two sectors in adjacent lanes for a final group of eight.
        // A 64-bit equality comparison checks both sectors of each key at once.
        // Every load/store stays inside the checked input/output slices.
        if PATTERN && i + 8 <= hashes.len() {
            let h = _mm512_loadu_si512(hashes.as_ptr().add(i).cast());
            let a = _mm512_and_si512(
                _mm512_shuffle_epi32::<0xf5>(h),
                _mm512_set1_epi32(self.block_mask as i32),
            );
            let delta = _mm512_or_si512(
                _mm512_set1_epi64(8i64 << 32),
                _mm512_and_si512(_mm512_slli_epi64::<12>(h), _mm512_set1_epi64(7i64 << 32)),
            );
            let index = _mm512_xor_si512(a, delta);
            let code = _mm512_srlv_epi32(
                _mm512_shuffle_epi32::<0xa0>(h),
                _mm512_set1_epi64(10i64 << 32),
            );
            let mask = _mm512_rolv_epi32(
                _mm512_permutex2var_epi32(table0, code, table1),
                _mm512_srli_epi32::<5>(code),
            );
            let v = _mm512_i32gather_epi32::<4>(index, base);
            let pass = _mm512_cmpeq_epi64_mask(_mm512_and_si512(v, mask), mask);
            _mm256_storeu_si256(
                out.as_mut_ptr().add(i).cast(),
                _mm512_castsi512_si256(_mm512_maskz_set1_epi32(pass as u16, 1)),
            );
            i += 8;
        }
        for j in i..hashes.len() {
            out[j] = self.contains_hash(hashes[j]) as u32;
        }
    }
}

/// Same 64-bit hash finalizer as the C++ HashVector overload.
#[inline]
pub fn hash64(mut x: u64) -> u64 {
    x ^= x >> 32;
    x = x.wrapping_mul(0xd6e8feb86659fd93);
    x ^= x >> 32;
    x = x.wrapping_mul(0xd6e8feb86659fd93);
    x ^ (x >> 32)
}

#[cfg(test)]
mod tests {
    use super::*;
    fn check<const P: bool>(bpk: u32) {
        for n in [0, 1, 17, 255, 4096] {
            let mut bf = BloomFilter::<P>::new(n, bpk).unwrap();
            let keys: Vec<_> = (0..n as u64).map(hash64).collect();
            for chunk in keys.chunks(31) {
                bf.insert_hashes(chunk);
            }
            bf.insert_hashes(&keys);
            for &h in &keys {
                assert!(bf.contains_hash(h));
            }
            for offset in 0..8 {
                for len in 0..70 {
                    let query: Vec<_> =
                        (0..(offset + len) as u64).map(|x| hash64(x + 19)).collect();
                    let query = &query[offset..];
                    let mut output = vec![0xdeadbeef; len + 2];
                    bf.lookup_hashes(query, &mut output[1..len + 1]);
                    assert_eq!(output[0], 0xdeadbeef);
                    assert_eq!(output[len + 1], 0xdeadbeef);
                    for (j, &h) in query.iter().enumerate() {
                        assert_eq!(output[j + 1], bf.contains_hash(h) as u32);
                    }
                }
            }
            // Force the portable path and compare with the SIMD backend.
            let query: Vec<_> = (0..10003).map(hash64).collect();
            let mut vector = vec![0; query.len()];
            let mut scalar = vector.clone();
            bf.lookup_hashes(&query, &mut vector);
            bf.avx512 = false;
            bf.lookup_hashes(&query, &mut scalar);
            assert_eq!(scalar, vector);
            bf.avx2 = false;
            bf.lookup_hashes(&query, &mut scalar);
            assert_eq!(scalar, vector);
        }
    }
    #[test]
    fn sectorized() {
        check::<false>(16);
    }
    #[test]
    fn pattern() {
        for bpk in [4, 8, 16] {
            check::<true>(bpk);
        }
    }
    #[test]
    fn colliding_inserts() {
        for bpk in [4, 16] {
            let mut bf = FastPatternBloomFilter::new(4096, bpk).unwrap();
            let mut hashes: Vec<_> = (0..4096)
                .map(|i| (7u64 << 32) | (hash64(i) & 0xffff_ffff))
                .collect();
            hashes[0] = 0;
            hashes[1] = u64::MAX;
            bf.insert_hashes(&hashes);
            for h in hashes {
                assert!(bf.contains_hash(h));
            }
        }
    }
    #[test]
    fn sizes() {
        assert!(SectorizedBloomFilter::new(1, 0).is_err());
        assert!(SectorizedBloomFilter::new(usize::MAX, 32).is_err());
        assert!(SectorizedBloomFilter::new(1 << 27, 16).is_err());
        assert_eq!(
            SectorizedBloomFilter::new(1000, 16)
                .unwrap()
                .size_in_bytes(),
            2048
        );
    }
    #[test]
    #[should_panic]
    fn output_length() {
        SectorizedBloomFilter::new(1, 16)
            .unwrap()
            .lookup_hashes(&[0], &mut []);
    }
}
