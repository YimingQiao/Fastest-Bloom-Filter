//! Eight 64-bit split-block sectors in one cache line. This widens the public
//! Parquet/Impala multiply-shift construction and is not Parquet-compatible.
use crate::{layout_parallel, SizeError};

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

// Split64/Range only: n is this insertion's length, not constructor capacity.
#[inline]
pub(crate) fn build_request(n: usize, bytes: usize, requested: usize) -> usize {
    if n <= 65_536 && bytes <= 262_144 {
        1
    } else {
        requested
    }
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Default, Debug, PartialEq, Eq)]
struct Line([u64; 8]);

/// Append-only eight-probe split-block Bloom filter over uniformly hashed u64s.
/// Writes require exclusive access; immutable filters support concurrent reads.
/// Its bitmap mapping differs from both Parquet and `FastPatternBloomFilter`.
#[derive(Clone)]
pub struct Split64BloomFilter {
    lines: Vec<Line>,
    block_mask: u32,
    avx512: bool,
    avx2: bool,
}
impl Split64BloomFilter {
    fn line_count(n: usize, bpk: u32) -> Result<usize, SizeError> {
        layout_parallel::line_count(n, bpk)
    }
    /// Native strict-next-power-of-two sizing, with a 128-byte minimum and 256 MiB maximum.
    /// Inspect `size_in_bytes()` for actual allocation instead of assuming requested bits/key.
    pub fn new(n: usize, bpk: u32) -> Result<Self, SizeError> {
        let count = Self::line_count(n, bpk)?;
        let (avx512, avx2) = layout_parallel::backends();
        Ok(Self {
            lines: vec![Line::default(); count],
            block_mask: (count - 1) as u32,
            avx512,
            avx2,
        })
    }
    /// Bitmap bytes, excluding object fields and allocator metadata.
    pub fn size_in_bytes(&self) -> usize {
        self.lines.len() * 64
    }
    /// Runtime batch backend; `disable-avx512` retains AVX2/scalar dispatch.
    pub fn backend(&self) -> &'static str {
        layout_parallel::backend(self.avx512, self.avx2)
    }
    #[inline]
    fn block(&self, h: u64) -> usize {
        ((h >> 32) as u32 & self.block_mask) as usize
    }
    #[inline]
    fn insert_one_scalar(lines: &mut [Line], begin: usize, mask: u32, h: u64) {
        let index = ((h >> 32) as u32 & mask) as usize - begin;
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
        Self::insert_one_scalar(&mut self.lines, 0, self.block_mask, h);
    }
    /// Returns false for definitely absent, true for possibly present.
    #[inline]
    pub fn contains_hash(&self, h: u64) -> bool {
        self.contains_scalar(h)
    }
    fn insert_into(
        lines: &mut [Line],
        begin: usize,
        mask: u32,
        avx512: bool,
        avx2: bool,
        hashes: &[u64],
    ) {
        #[cfg(target_arch = "x86_64")]
        {
            if avx512 {
                // SAFETY: backend detected at construction; every hash belongs to owned lines.
                unsafe { Self::insert_avx512(lines, begin, mask, hashes) };
                return;
            }
            if avx2 {
                // SAFETY: backend detected at construction; owned lines are disjoint and aligned.
                unsafe { Self::insert_avx2(lines, begin, mask, hashes) };
                return;
            }
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = (avx512, avx2);
        for &hash in hashes {
            Self::insert_one_scalar(lines, begin, mask, hash);
        }
    }
    /// Exclusive bulk insertion, preserving duplicates and same-block collisions.
    pub fn insert_hashes(&mut self, hashes: &[u64]) {
        Self::insert_into(
            &mut self.lines,
            0,
            self.block_mask,
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
    /// Effective build workers. Batches up to 65,536 hashes in bitmaps up to
    /// 256 KiB use one worker. Outside that gate, request 0 uses available parallelism.
    pub fn build_workers(&self, n: usize, requested: usize) -> usize {
        let requested = build_request(n, self.size_in_bytes(), requested);
        layout_parallel::build_workers(n, requested, self.lines.len())
    }
    /// Peak explicit build scratch, excluding allocator metadata and OS thread stacks.
    /// Panics with `build scratch size overflow` if a multiworker estimate cannot fit in `usize`.
    pub fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
        let requested = build_request(n, self.size_in_bytes(), requested);
        layout_parallel::scratch_bytes(n, requested, self.lines.len())
    }
    /// Exclusive cache-line-partitioned construction, including partitioning and thread launch.
    pub fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
        let requested = build_request(hashes.len(), self.size_in_bytes(), requested);
        let mask = self.block_mask;
        let (avx512, avx2) = (self.avx512, self.avx2);
        layout_parallel::insert(
            &mut self.lines,
            hashes,
            requested,
            |h| ((h >> 32) as u32 & mask) as usize,
            |lines, begin, input| Self::insert_into(lines, begin, mask, avx512, avx2, input),
        );
    }
    /// Parallel immutable queries. Concurrent read-only batches are supported.
    pub fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        layout_parallel::lookup(hashes, out, requested, |h, o| self.lookup_hashes(h, o));
    }
}

#[cfg(target_arch = "x86_64")]
impl Split64BloomFilter {
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
    unsafe fn insert_one_avx512(lines: &mut [Line], begin: usize, mask: u32, h: u64) {
        use std::arch::x86_64::*;
        let index = ((h >> 32) as u32 & mask) as usize - begin;
        debug_assert!(index < lines.len());
        let line = lines.as_mut_ptr().add(index).cast();
        _mm512_store_si512(
            line,
            _mm512_or_si512(_mm512_load_si512(line), Self::mask(h)),
        );
    }
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn insert_avx512(lines: &mut [Line], begin: usize, mask: u32, hashes: &[u64]) {
        use std::arch::x86_64::*;
        let prefetched = hashes.len().saturating_sub(PREFETCH);
        for (i, &h) in hashes[..prefetched].iter().enumerate() {
            let future = ((hashes[i + PREFETCH] >> 32) as u32 & mask) as usize - begin;
            debug_assert!(future < lines.len());
            _mm_prefetch::<_MM_HINT_T0>(lines.as_ptr().add(future).cast());
            Self::insert_one_avx512(lines, begin, mask, h);
        }
        for &h in &hashes[prefetched..] {
            Self::insert_one_avx512(lines, begin, mask, h);
        }
    }
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn insert_one_avx2(lines: &mut [Line], begin: usize, mask: u32, h: u64) {
        use std::arch::x86_64::*;
        let index = ((h >> 32) as u32 & mask) as usize - begin;
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
    unsafe fn insert_avx2(lines: &mut [Line], begin: usize, mask: u32, hashes: &[u64]) {
        use std::arch::x86_64::*;
        let prefetched = hashes.len().saturating_sub(PREFETCH);
        for (i, &h) in hashes[..prefetched].iter().enumerate() {
            let future = ((hashes[i + PREFETCH] >> 32) as u32 & mask) as usize - begin;
            debug_assert!(future < lines.len());
            _mm_prefetch::<_MM_HINT_T0>(lines.as_ptr().add(future).cast());
            Self::insert_one_avx2(lines, begin, mask, h);
        }
        for &h in &hashes[prefetched..] {
            Self::insert_one_avx2(lines, begin, mask, h);
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
mod tests {
    use super::*;
    use crate::hash64;

    #[test]
    fn allocation_and_alignment_match_cpp() {
        for (n, bpk, bytes) in [
            (0, 1, 128),
            (1, 16, 128),
            (64, 8, 128),
            (64, 16, 256),
            (65, 16, 256),
            (1024, 8, 2048),
            (1024, 16, 4096),
        ] {
            let bf = Split64BloomFilter::new(n, bpk).unwrap();
            assert_eq!(bf.size_in_bytes(), bytes);
            assert_eq!(bf.lines.as_ptr() as usize % 64, 0);
        }
        assert_eq!(
            Split64BloomFilter::line_count(1, 0),
            Err(SizeError::InvalidSize)
        );
        assert_eq!(
            Split64BloomFilter::line_count(usize::MAX, 2),
            Err(SizeError::InvalidSize)
        );
        assert_eq!(
            Split64BloomFilter::line_count(1 << 27, 16),
            Err(SizeError::CapacityExceeded)
        );
    }

    #[test]
    fn scalar_and_runtime_paths_match_at_batch_boundaries() {
        for n in [0, 1, 31, 32, 33, 64, 65, 4099] {
            let inserted: Vec<_> = (0..n).map(hash64).collect();
            let mut scalar = Split64BloomFilter::new(n as usize, 8).unwrap();
            scalar.avx512 = false;
            scalar.avx2 = false;
            scalar.avx2 = false;
            scalar.insert_hashes(&inserted);
            let mut runtime = Split64BloomFilter::new(n as usize, 8).unwrap();
            for batch in [1, 31, 32, 33, 4096] {
                runtime.lines.fill(Line::default());
                for chunk in inserted.chunks(batch) {
                    runtime.insert_hashes(chunk);
                }
                assert_eq!(
                    scalar.lines.iter().map(|line| line.0).collect::<Vec<_>>(),
                    runtime.lines.iter().map(|line| line.0).collect::<Vec<_>>()
                );
                runtime.insert_hashes(&inserted);
                assert_eq!(
                    scalar.lines.iter().map(|line| line.0).collect::<Vec<_>>(),
                    runtime.lines.iter().map(|line| line.0).collect::<Vec<_>>()
                );
            }
            let mut answers = vec![0; inserted.len()];
            runtime.lookup_hashes(&inserted, &mut answers);
            assert!(answers.iter().all(|&answer| answer == 1));

            let queries: Vec<_> = (0..8192).map(hash64).collect();
            for len in 0..=131 {
                for offset in 0..8 {
                    let slice = &queries[offset..offset + len];
                    let mut actual = vec![0xfeed; len + 2];
                    runtime.lookup_hashes(slice, &mut actual[1..1 + len]);
                    assert_eq!(actual[0], 0xfeed);
                    assert_eq!(actual[len + 1], 0xfeed);
                    for (&hash, &answer) in slice.iter().zip(&actual[1..1 + len]) {
                        assert_eq!(answer, scalar.contains_scalar(hash) as u32);
                    }
                }
            }
            let mut actual = vec![0; queries.len()];
            runtime.lookup_hashes(&queries, &mut actual);
            assert!(queries
                .iter()
                .zip(actual)
                .all(|(&hash, answer)| answer == scalar.contains_scalar(hash) as u32));
        }
    }

    #[test]
    #[should_panic(expected = "one output is required per input")]
    fn rejects_mismatched_output_before_writing() {
        let bf = Split64BloomFilter::new(1, 8).unwrap();
        bf.lookup_hashes(&[hash64(1)], &mut []);
    }
    #[test]
    fn all_backends_parallel_match_serial() {
        fn shareable<T: Send + Sync>() {}
        shareable::<Split64BloomFilter>();
        for backend in 0..3 {
            for hot in [false, true] {
                let mut inserted: Vec<_> = (0..65539)
                    .map(|i| {
                        if hot {
                            (7u64 << 32) | (hash64(i) & 0xffff_ffff)
                        } else {
                            hash64(i)
                        }
                    })
                    .collect();
                inserted[0] = 0;
                inserted[1] = u64::MAX;
                for bpk in [4, 16] {
                    let mut serial = Split64BloomFilter::new(65539, bpk).unwrap();
                    serial.avx512 = false;
                    serial.avx2 = false;
                    serial.insert_hashes(&inserted);
                    for workers in [1, 2, 3, 7, 8] {
                        let mut parallel = Split64BloomFilter::new(65539, bpk).unwrap();
                        if backend < 2 {
                            parallel.avx512 = false;
                        }
                        if backend == 0 {
                            parallel.avx2 = false;
                        }
                        parallel.insert_hashes_parallel(&inserted, workers);
                        assert_eq!(serial.lines, parallel.lines);
                        parallel.insert_hashes_parallel(&inserted, workers);
                        assert_eq!(serial.lines, parallel.lines);
                        for &h in &inserted {
                            assert!(parallel.contains_hash(h));
                        }
                        let query: Vec<_> = (0..131083).map(hash64).collect();
                        let mut out = vec![0; query.len()];
                        parallel.lookup_hashes_parallel(&query, &mut out, workers);
                        assert!(query
                            .iter()
                            .zip(&out)
                            .all(|(&h, &v)| v == serial.contains_hash(h) as u32));
                        assert_eq!(parallel.build_scratch_bytes(inserted.len(), 1), 0);
                        if workers > 1 {
                            assert!(
                                parallel.build_scratch_bytes(inserted.len(), workers)
                                    >= inserted.len() * 8
                            );
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn empty_small_and_large_owned_slices() {
        for n in [0usize, 1, 3, 4, 7, 8, 15, 16, 17, 31, 32, 33] {
            let hashes: Vec<_> = (0..n as u64).map(hash64).collect();
            let mut bf = Split64BloomFilter::new(n, 8).unwrap();
            bf.insert_hashes_parallel(&hashes, 0);
            let mut out = vec![0; n];
            bf.lookup_hashes_parallel(&hashes, &mut out, 8);
            assert!(out.iter().all(|&v| v == 1));
            assert_eq!(bf.build_workers(n, 8), 1);
        }
        let hashes: Vec<_> = (0..65539).map(hash64).collect();
        for backend in 0..3 {
            let mut serial = Split64BloomFilter::new(1 << 21, 16).unwrap();
            serial.avx512 = false;
            serial.avx2 = false;
            serial.insert_hashes(&hashes);
            let mut parallel = Split64BloomFilter::new(1 << 21, 16).unwrap();
            if backend < 2 {
                parallel.avx512 = false;
            }
            if backend == 0 {
                parallel.avx2 = false;
            }
            parallel.insert_hashes_parallel(&hashes, 2);
            assert_eq!(serial.lines, parallel.lines);
        }
        let mut bf = Split64BloomFilter::new(1, 8).unwrap();
        bf.insert_hash(0);
        bf.insert_hash(u64::MAX);
        assert!(bf.contains_hash(0) && bf.contains_hash(u64::MAX));
        if cfg!(feature = "disable-avx512") {
            assert_ne!(bf.backend(), "avx512");
        }
    }
    #[test]
    fn short_queries_match_scalar_and_previous_kernel() {
        let mut inserted: Vec<_> = (0..65539).map(hash64).collect();
        inserted[0] = 0;
        inserted[1] = u64::MAX;
        for (keys, bpk) in [(65539, 8), (1 << 20, 16)] {
            for backend in 0..3 {
                let mut filter = Split64BloomFilter::new(keys, bpk).unwrap();
                if backend < 2 {
                    filter.avx512 = false;
                }
                if backend == 0 {
                    filter.avx2 = false;
                }
                filter.insert_hashes(&inserted);
                let bitmap = filter.lines.clone();
                for len in 0..=131 {
                    for offset in 0..16 {
                        let input: Vec<_> = (0..len + offset)
                            .map(|j| {
                                if j % 11 == 0 {
                                    0
                                } else if j % 13 == 0 {
                                    u64::MAX
                                } else if j % 2 == 0 {
                                    inserted[(j * 71) % inserted.len()]
                                } else {
                                    hash64(1_000_000 + j as u64)
                                }
                            })
                            .collect();
                        let hashes = &input[offset..];
                        let mut actual = vec![0xfeed; len + 2];
                        filter.lookup_hashes(hashes, &mut actual[1..len + 1]);
                        assert_eq!(actual[0], 0xfeed);
                        assert_eq!(actual[len + 1], 0xfeed);
                        for (&h, &v) in hashes.iter().zip(&actual[1..len + 1]) {
                            assert_eq!(v, filter.contains_scalar(h) as u32);
                        }
                        #[cfg(target_arch = "x86_64")]
                        if filter.avx512 {
                            let mut old = vec![0xfeed; len + 2];
                            // SAFETY: runtime backend verified, matched slices, old bounded kernel.
                            unsafe {
                                filter.lookup_avx512(hashes, &mut old[1..len + 1]);
                            }
                            assert_eq!(actual, old);
                        }
                    }
                }
                assert_eq!(bitmap, filter.lines);
                assert!(inserted.iter().all(|&h| filter.contains_hash(h)));
            }
        }
    }
    #[test]
    #[cfg(target_arch = "x86_64")]
    fn wide_mask_is_identical_to_original_and_scalar() {
        if !layout_parallel::backends().0 {
            return;
        }
        use std::arch::x86_64::*;
        let special = [0, u64::MAX, 0x8000_0000, 0xffff_ffff, 0x1_0000_0000];
        for h in special.into_iter().chain((0..65536).map(hash64)) {
            let mut old = [0u64; 8];
            let mut wide = [0u64; 8];
            // SAFETY: detected backend; both complete 64-byte output arrays are writable.
            unsafe {
                _mm512_storeu_si512(old.as_mut_ptr().cast(), Split64BloomFilter::mask(h));
                _mm512_storeu_si512(wide.as_mut_ptr().cast(), Split64BloomFilter::wide_mask(h));
            }
            assert_eq!(old, wide);
            for j in 0..8 {
                assert_eq!(wide[j], 1u64 << ((h as u32).wrapping_mul(SALTS[j]) >> 26));
            }
        }
    }
}

#[cfg(test)]
#[path = "split64_build_policy_tests.rs"]
mod build_policy_tests;
