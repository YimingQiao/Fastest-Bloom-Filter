//! Eight 64-bit split-block sectors in one cache line. This widens the public
//! Parquet/Impala multiply-shift construction and is not Parquet-compatible.
use crate::{layout_parallel, range_parallel, SizeError};

const SALTS: [u32; 8] = [
    0x47b6_137b,
    0x4497_4d91,
    0x8824_ad5b,
    0xa2b7_289d,
    0x7054_95c7,
    0x2df1_424b,
    0x9efc_4947,
    0x5c6b_fb31,
];
const PREFETCH: usize = 32;
#[repr(C, align(64))]
#[derive(Clone, Copy, Default, Debug, PartialEq, Eq)]
struct Line([u64; 8]);

/// Append-only eight-probe split-block Bloom filter over uniformly hashed u64s.
/// Writes require exclusive access; immutable filters support concurrent reads.
/// Its bitmap mapping differs from both Parquet and `FastPatternBloomFilter`.
#[derive(Clone)]
pub struct Split64RangeBloomFilter {
    lines: Vec<Line>,
    block_count: u32,
    avx512: bool,
    avx2: bool,
}
impl Split64RangeBloomFilter {
    /// Allocate complete 64-byte lines within the supplied byte ceiling.
    /// Bounds are 128 bytes through 256 MiB, inclusive. This mapping differs
    /// from the original power-of-two type even at an equal allocation.
    pub fn with_byte_budget(bytes: usize) -> Result<Self, SizeError> {
        if bytes < 128 {
            return Err(SizeError::InvalidSize);
        }
        if bytes > (1usize << 28) {
            return Err(SizeError::CapacityExceeded);
        }
        let count = bytes / 64;
        let (avx512, avx2) = layout_parallel::backends();
        let lines = vec![Line::default(); count];
        if lines
            .capacity()
            .checked_mul(64)
            .ok_or(SizeError::CapacityExceeded)?
            > bytes
        {
            return Err(SizeError::CapacityExceeded);
        }
        Ok(Self {
            lines,
            block_count: count as u32,
            avx512,
            avx2,
        })
    }
    /// Use floor(n * bpk / 8) as an at-most byte budget, without rounding up.
    pub fn new(n: usize, bpk: u32) -> Result<Self, SizeError> {
        if n == 0 || bpk == 0 {
            return Err(SizeError::InvalidSize);
        }
        let bits = n.checked_mul(bpk as usize).ok_or(SizeError::InvalidSize)?;
        Self::with_byte_budget(bits / 8)
    }
    /// Bitmap bytes, excluding object fields and allocator metadata.
    pub fn size_in_bytes(&self) -> usize {
        self.lines.capacity() * 64
    }
    #[cfg(feature = "validation")]
    pub fn validation_words(&self) -> Vec<u64> {
        self.lines.iter().flat_map(|line| line.0).collect()
    }
    /// Runtime batch backend; `disable-avx512` retains AVX2/scalar dispatch.
    pub fn backend(&self) -> &'static str {
        layout_parallel::backend(self.avx512, self.avx2)
    }
    #[inline]
    fn block(&self, h: u64) -> usize {
        (((h >> 32) * self.block_count as u64) >> 32) as usize
    }
    #[inline]
    fn insert_one_scalar(lines: &mut [Line], begin: usize, count: u32, h: u64) {
        let index = (((h >> 32) * count as u64) >> 32) as usize - begin;
        for (word, salt) in lines[index].0.iter_mut().zip(SALTS) {
            *word |= 1u64 << ((h as u32).wrapping_mul(salt) >> 26);
        }
    }
    #[inline]
    fn contains_scalar(&self, h: u64) -> bool {
        let mut missing = 0;
        for (&word, salt) in self.lines[self.block(h)].0.iter().zip(SALTS) {
            missing |= !word & (1u64 << ((h as u32).wrapping_mul(salt) >> 26));
        }
        missing == 0
    }
    /// Sets the eight bits for one hash; duplicate insertion is idempotent.
    #[inline]
    pub fn insert_hash(&mut self, h: u64) {
        Self::insert_one_scalar(&mut self.lines, 0, self.block_count, h);
    }
    /// Returns false for definitely absent, true for possibly present.
    #[inline]
    pub fn contains_hash(&self, h: u64) -> bool {
        self.contains_scalar(h)
    }
    fn insert_into(
        lines: &mut [Line],
        begin: usize,
        count: u32,
        avx512: bool,
        avx2: bool,
        hashes: &[u64],
    ) {
        #[cfg(target_arch = "x86_64")]
        {
            if avx512 {
                // SAFETY: backend detected at construction; every hash belongs to owned lines.
                unsafe { Self::insert_avx512(lines, begin, count, hashes) };
                return;
            }
            if avx2 {
                // SAFETY: backend detected at construction; owned lines are disjoint and aligned.
                unsafe { Self::insert_avx2(lines, begin, count, hashes) };
                return;
            }
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = (avx512, avx2);
        for &hash in hashes {
            Self::insert_one_scalar(lines, begin, count, hash);
        }
    }
    /// Exclusive bulk insertion, preserving duplicates and same-block collisions.
    pub fn insert_hashes(&mut self, hashes: &[u64]) {
        Self::insert_into(
            &mut self.lines,
            0,
            self.block_count,
            self.avx512,
            self.avx2,
            hashes,
        );
    }
    /// Writes one 0/1 per input; panics before writing when lengths differ.
    pub fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len(), "one output is required per input");
        if hashes.len() == 1 {
            #[cfg(target_arch = "x86_64")]
            {
                if self.avx512 {
                    // SAFETY: detected AVX2/AVX512F and exactly one checked input/output.
                    out[0] = unsafe { self.lookup_one_avx512(hashes[0]) };
                    return;
                }
                if self.avx2 {
                    // SAFETY: detected AVX2 and exactly one checked input/output.
                    out[0] = unsafe { self.lookup_one_avx2(hashes[0]) };
                    return;
                }
            }
            out[0] = self.contains_scalar(hashes[0]) as u32;
            return;
        }

        #[cfg(target_arch = "x86_64")]
        {
            if self.avx512 {
                // SAFETY: detected backend, checked output length and bounded input/index loads.
                unsafe {
                    if hashes.len() < 16 {
                        self.lookup_short_avx512(hashes, out);
                    } else {
                        self.lookup_avx512(hashes, out);
                    }
                };
                return;
            }
            if self.avx2 {
                // SAFETY: detected backend, checked output length and bounded input/index loads.
                unsafe { self.lookup_avx2(hashes, out) };
                return;
            }
        }
        for (&h, answer) in hashes.iter().zip(out) {
            *answer = self.contains_scalar(h) as u32;
        }
    }
    /// Effective build workers; tiny inputs run serially, request 0 uses available parallelism.
    pub fn build_workers(&self, n: usize, requested: usize) -> usize {
        layout_parallel::build_workers(n, requested, self.lines.len())
    }
    /// Peak explicit build scratch, excluding allocator metadata and OS thread stacks.
    /// Panics with `build scratch size overflow` if a multiworker estimate cannot fit in `usize`.
    pub fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
        layout_parallel::scratch_bytes(n, requested, self.lines.len())
    }
    /// Exclusive cache-line-partitioned construction, including partitioning and thread launch.
    pub fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
        let count = self.block_count;
        let (avx512, avx2) = (self.avx512, self.avx2);
        range_parallel::insert(&mut self.lines, hashes, requested, |lines, begin, input| {
            Self::insert_into(lines, begin, count, avx512, avx2, input)
        });
    }
    /// Parallel immutable queries. Concurrent read-only batches are supported.
    pub fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        layout_parallel::lookup(hashes, out, requested, |h, o| self.lookup_hashes(h, o));
    }
}

#[cfg(target_arch = "x86_64")]
impl Split64RangeBloomFilter {
    #[inline]
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn mask(hash: u64) -> std::arch::x86_64::__m512i {
        use std::arch::x86_64::*;
        let positions = _mm256_srli_epi32::<26>(_mm256_mullo_epi32(
            _mm256_set1_epi32(hash as i32),
            _mm256_loadu_si256(SALTS.as_ptr().cast()),
        ));
        _mm512_sllv_epi64(_mm512_set1_epi64(1), _mm512_cvtepu32_epi64(positions))
    }
    #[inline]
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn wide_mask(hash: u64) -> std::arch::x86_64::__m512i {
        use std::arch::x86_64::*;
        let salts = _mm512_setr_epi64(
            0x47b6137b, 0x44974d91, 0x8824ad5b, 0xa2b7289d, 0x705495c7, 0x2df1424b, 0x9efc4947,
            0x5c6bfb31,
        );
        // Zero upper dwords keep each wrapped u32 product in one u64 lane.
        let products = _mm512_mullo_epi32(_mm512_set1_epi64(hash as u32 as i64), salts);
        _mm512_sllv_epi64(_mm512_set1_epi64(1), _mm512_srli_epi64::<26>(products))
    }
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn lookup_short_avx512(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        for (&hash, answer) in hashes.iter().zip(out) {
            let line = self.lines.as_ptr().add(self.block(hash)).cast();
            *answer = (_mm512_testn_epi64_mask(_mm512_load_si512(line), Self::wide_mask(hash)) == 0)
                as u32;
        }
    }
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn masks_avx2(hash: u64) -> (std::arch::x86_64::__m256i, std::arch::x86_64::__m256i) {
        use std::arch::x86_64::*;
        let positions = _mm256_srli_epi32::<26>(_mm256_mullo_epi32(
            _mm256_set1_epi32(hash as i32),
            _mm256_loadu_si256(SALTS.as_ptr().cast()),
        ));
        let one = _mm256_set1_epi64x(1);
        (
            _mm256_sllv_epi64(
                one,
                _mm256_cvtepu32_epi64(_mm256_castsi256_si128(positions)),
            ),
            _mm256_sllv_epi64(
                one,
                _mm256_cvtepu32_epi64(_mm256_extracti128_si256::<1>(positions)),
            ),
        )
    }
    #[inline]
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn insert_one_avx512(lines: &mut [Line], begin: usize, count: u32, h: u64) {
        use std::arch::x86_64::*;
        let index = (((h >> 32) * count as u64) >> 32) as usize - begin;
        debug_assert!(index < lines.len());
        let line = lines.as_mut_ptr().add(index).cast();
        _mm512_store_si512(
            line,
            _mm512_or_si512(_mm512_load_si512(line), Self::mask(h)),
        );
    }
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn insert_avx512(lines: &mut [Line], begin: usize, count: u32, hashes: &[u64]) {
        use std::arch::x86_64::*;
        let prefetched = hashes.len().saturating_sub(PREFETCH);
        for (i, &h) in hashes[..prefetched].iter().enumerate() {
            let future = (((hashes[i + PREFETCH] >> 32) * count as u64) >> 32) as usize - begin;
            debug_assert!(future < lines.len());
            _mm_prefetch::<_MM_HINT_T0>(lines.as_ptr().add(future).cast());
            Self::insert_one_avx512(lines, begin, count, h);
        }
        for &h in &hashes[prefetched..] {
            Self::insert_one_avx512(lines, begin, count, h);
        }
    }
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn insert_one_avx2(lines: &mut [Line], begin: usize, count: u32, h: u64) {
        use std::arch::x86_64::*;
        let index = (((h >> 32) * count as u64) >> 32) as usize - begin;
        debug_assert!(index < lines.len());
        let line = lines.as_mut_ptr().add(index).cast::<__m256i>();
        let (a, b) = Self::masks_avx2(h);
        _mm256_store_si256(line, _mm256_or_si256(_mm256_load_si256(line), a));
        _mm256_store_si256(
            line.add(1),
            _mm256_or_si256(_mm256_load_si256(line.add(1)), b),
        );
    }
    #[target_feature(enable = "avx2")]
    unsafe fn insert_avx2(lines: &mut [Line], begin: usize, count: u32, hashes: &[u64]) {
        use std::arch::x86_64::*;
        let prefetched = hashes.len().saturating_sub(PREFETCH);
        for (i, &h) in hashes[..prefetched].iter().enumerate() {
            let future = (((hashes[i + PREFETCH] >> 32) * count as u64) >> 32) as usize - begin;
            debug_assert!(future < lines.len());
            _mm_prefetch::<_MM_HINT_T0>(lines.as_ptr().add(future).cast());
            Self::insert_one_avx2(lines, begin, count, h);
        }
        for &h in &hashes[prefetched..] {
            Self::insert_one_avx2(lines, begin, count, h);
        }
    }
    #[inline]
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn lookup_one_avx512(&self, h: u64) -> u32 {
        use std::arch::x86_64::*;
        (_mm512_testn_epi64_mask(
            _mm512_load_si512(self.lines.as_ptr().add(self.block(h)).cast()),
            Self::mask(h),
        ) == 0) as u32
    }
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn lookup_one_avx2(&self, h: u64) -> u32 {
        use std::arch::x86_64::*;
        let line = self.lines.as_ptr().add(self.block(h)).cast::<__m256i>();
        let (a, b) = Self::masks_avx2(h);
        ((_mm256_testc_si256(_mm256_load_si256(line), a) != 0)
            & (_mm256_testc_si256(_mm256_load_si256(line.add(1)), b) != 0)) as u32
    }
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn lookup_avx512(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        let prefetched = hashes.len().saturating_sub(PREFETCH);
        for (i, (&h, answer)) in hashes[..prefetched]
            .iter()
            .zip(&mut out[..prefetched])
            .enumerate()
        {
            _mm_prefetch::<_MM_HINT_T0>(
                self.lines
                    .as_ptr()
                    .add(self.block(hashes[i + PREFETCH]))
                    .cast(),
            );
            *answer = self.lookup_one_avx512(h);
        }
        for (&h, answer) in hashes[prefetched..].iter().zip(&mut out[prefetched..]) {
            *answer = self.lookup_one_avx512(h);
        }
    }
    #[target_feature(enable = "avx2")]
    unsafe fn lookup_avx2(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        let prefetched = hashes.len().saturating_sub(PREFETCH);
        for (i, (&h, answer)) in hashes[..prefetched]
            .iter()
            .zip(&mut out[..prefetched])
            .enumerate()
        {
            _mm_prefetch::<_MM_HINT_T0>(
                self.lines
                    .as_ptr()
                    .add(self.block(hashes[i + PREFETCH]))
                    .cast(),
            );
            *answer = self.lookup_one_avx2(h);
        }
        for (&h, answer) in hashes[prefetched..].iter().zip(&mut out[prefetched..]) {
            *answer = self.lookup_one_avx2(h);
        }
    }
}

#[cfg(test)]
mod tests;
