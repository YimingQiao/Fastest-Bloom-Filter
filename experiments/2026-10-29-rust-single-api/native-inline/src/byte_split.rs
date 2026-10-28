// SPDX-License-Identifier: Apache-2.0
//! Sixteen-byte split-block Bloom filter with the FastFilter Fixed16 mask mapping.
//!
//! Mask logic adapted from FastFilter/fastfilter_cpp, commit
//! 7c5bf187d5096ccbcec6a16e02975d0af3328b01, SimdBlockFilterFixed16.
//! Copyright 2018 the fastfilter_cpp authors; Apache License, Version 2.0.
//! Upstream credits Apache Impala (incubating). See this crate's LICENSE-APACHE
//! and NOTICE, and the repository's third_party/FastFilter/NOTICE.
//! Modified: direct power-of-two address reduction, typed cache-line storage,
//! portable scalar/runtime AVX2 kernels, and exclusive partitioned construction.
use crate::{layout_parallel, SizeError};

const SALTS: [u16; 8] = [
    0x47b5, 0x4497, 0x8823, 0xa2b7, 0x7053, 0x2df1, 0x9efc, 0x5c6b,
];
#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Line([u8; 64]);
impl Default for Line {
    fn default() -> Self {
        Self([0; 64])
    }
}

/// Append-only Bloom filter over uniformly hashed u64s, with four 16-byte buckets
/// per cache line. The FastFilter mask can leave byte lanes unconstrained; it is
/// preserved exactly, including its accuracy tradeoff. Writes require exclusive
/// access, while immutable filters support concurrent reads.
#[derive(Clone)]
pub struct ByteSplitBloomFilter {
    lines: Vec<Line>,
    bucket_mask: u32,
    avx2: bool,
}
impl ByteSplitBloomFilter {
    /// Strict-next-power-of-two payload sizing, from 128 bytes up to 256 MiB.
    /// Inspect `size_in_bytes()` for actual allocation, rather than requested bits/key.
    pub fn new(n: usize, bpk: u32) -> Result<Self, SizeError> {
        let count = layout_parallel::line_count(n, bpk)?;
        let (_, avx2) = layout_parallel::backends();
        Ok(Self {
            lines: vec![Line::default(); count],
            bucket_mask: (count * 4 - 1) as u32,
            avx2,
        })
    }
    /// Bitmap bytes, excluding object fields and allocator metadata.
    pub fn size_in_bytes(&self) -> usize {
        self.lines.capacity() * 64
    }
    /// Alias for `size_in_bytes()`.
    pub fn byte_len(&self) -> usize {
        self.size_in_bytes()
    }
    /// Runtime backend. The SIMD path uses AVX2-gated 128-bit instructions.
    pub fn backend(&self) -> &'static str {
        if self.avx2 {
            "avx2"
        } else {
            "scalar"
        }
    }
    #[inline]
    fn bucket(&self, h: u64) -> usize {
        ((h >> 32) as u32 & self.bucket_mask) as usize
    }
    #[inline]
    fn scalar_mask(h: u64) -> [u8; 16] {
        let mut mask = [0; 16];
        for (j, &salt) in SALTS.iter().enumerate() {
            let word = (h >> ((j & 1) * 16)) as u16 as i16 as i32;
            let product = word * (salt as i16 as i32);
            let high = ((product as u32) >> 16) as u16;
            for b in 0..2 {
                let control = (high >> (8 * b)) as u8;
                mask[j * 2 + b] = if control & 128 != 0 {
                    0
                } else {
                    128 >> (control & 7)
                };
            }
        }
        mask
    }
    #[inline]
    fn insert_one_scalar(lines: &mut [Line], begin: usize, bucket_mask: u32, h: u64) {
        let bucket = ((h >> 32) as u32 & bucket_mask) as usize;
        let line = &mut lines[(bucket >> 2) - begin].0;
        let offset = (bucket & 3) * 16;
        for (byte, mask) in line[offset..offset + 16]
            .iter_mut()
            .zip(Self::scalar_mask(h))
        {
            *byte |= mask;
        }
    }
    #[inline]
    fn contains_scalar(&self, h: u64) -> bool {
        let bucket = self.bucket(h);
        let line = &self.lines[bucket >> 2].0;
        let offset = (bucket & 3) * 16;
        let mut missing = 0;
        for (&byte, mask) in line[offset..offset + 16].iter().zip(Self::scalar_mask(h)) {
            missing |= !byte & mask;
        }
        missing == 0
    }
    /// Inserts one hash; duplicate insertion is idempotent.
    pub fn insert_hash(&mut self, h: u64) {
        self.insert_hashes(std::slice::from_ref(&h));
    }
    /// Returns false for definitely absent, true for possibly present.
    #[inline]
    pub fn contains_hash(&self, h: u64) -> bool {
        #[cfg(target_arch = "x86_64")]
        if self.avx2 {
            // SAFETY: runtime detection covers all instructions and storage is aligned.
            return unsafe { self.lookup_one_avx2(h) != 0 };
        }
        self.contains_scalar(h)
    }
    fn insert_into(lines: &mut [Line], begin: usize, mask: u32, avx2: bool, hashes: &[u64]) {
        #[cfg(target_arch = "x86_64")]
        if avx2 {
            // SAFETY: runtime-detected backend and each hash belongs to owned lines.
            unsafe { Self::insert_avx2(lines, begin, mask, hashes) };
            return;
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = avx2;
        for &h in hashes {
            Self::insert_one_scalar(lines, begin, mask, h);
        }
    }
    /// Exclusive insertion, retaining colliding updates and duplicate keys.
    pub fn insert_hashes(&mut self, hashes: &[u64]) {
        Self::insert_into(&mut self.lines, 0, self.bucket_mask, self.avx2, hashes);
    }
    /// Writes one 0/1 per input; rejects mismatched lengths before writing.
    #[inline]
    pub fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len(), "one output is required per input");
        if hashes.len() == 1 {
            out[0] = self.contains_hash(hashes[0]) as u32;
            return;
        }
        #[cfg(target_arch = "x86_64")]
        if self.avx2 {
            // SAFETY: runtime-detected backend, checked output length and bounded loads.
            unsafe { self.lookup_avx2(hashes, out) };
            return;
        }
        for (&h, answer) in hashes.iter().zip(out) {
            *answer = self.contains_scalar(h) as u32;
        }
    }
    /// Effective build workers; tiny inputs run serially and request 0 is automatic.
    pub fn build_workers(&self, n: usize, requested: usize) -> usize {
        layout_parallel::build_workers(n, requested, self.lines.len())
    }
    /// Explicit partition scratch estimate, excluding allocator/runtime thread overhead.
    /// Panics with `build scratch size overflow` if the estimate cannot fit in `usize`.
    pub fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
        layout_parallel::scratch_bytes(n, requested, self.lines.len())
    }
    /// Exclusive parallel insertion; each worker owns whole 64-byte cache lines,
    /// including all four buckets sharing a line.
    pub fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
        let mask = self.bucket_mask;
        let avx2 = self.avx2;
        layout_parallel::insert(
            &mut self.lines,
            hashes,
            requested,
            |h| (((h >> 32) as u32 & mask) >> 2) as usize,
            |lines, begin, input| Self::insert_into(lines, begin, mask, avx2, input),
        );
    }
    /// Parallel immutable queries; independent read-only calls may overlap.
    pub fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        layout_parallel::lookup(hashes, out, requested, |h, o| self.lookup_hashes(h, o));
    }
}

#[cfg(target_arch = "x86_64")]
impl ByteSplitBloomFilter {
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn mask_avx2(h: u64) -> std::arch::x86_64::__m128i {
        use std::arch::x86_64::*;
        let salts = _mm_setr_epi16(
            SALTS[0] as i16,
            SALTS[1] as i16,
            SALTS[2] as i16,
            SALTS[3] as i16,
            SALTS[4] as i16,
            SALTS[5] as i16,
            SALTS[6] as i16,
            SALTS[7] as i16,
        );
        let products = _mm_mulhi_epi16(salts, _mm_set1_epi32(h as i32));
        let table = _mm_setr_epi8(-128, 64, 32, 16, 8, 4, 2, 1, -128, 64, 32, 16, 8, 4, 2, 1);
        _mm_shuffle_epi8(table, products)
    }
    #[target_feature(enable = "avx2")]
    unsafe fn insert_avx2(lines: &mut [Line], begin: usize, mask: u32, hashes: &[u64]) {
        use std::arch::x86_64::*;
        for &h in hashes {
            let bucket = ((h >> 32) as u32 & mask) as usize;
            let relative_bucket = bucket - begin * 4;
            debug_assert!(relative_bucket < lines.len() * 4);
            // The owned slice spans complete lines, so the flat byte offset is
            // within the same allocation and remains aligned to 16 bytes.
            let p = lines
                .as_mut_ptr()
                .cast::<u8>()
                .add(relative_bucket * 16)
                .cast();
            _mm_store_si128(p, _mm_or_si128(_mm_load_si128(p), Self::mask_avx2(h)));
        }
    }
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn lookup_one_avx2(&self, h: u64) -> u32 {
        use std::arch::x86_64::*;
        let bucket = self.bucket(h);
        // Byte offset spans the complete Vec<Line> allocation, preserving its
        // 16-byte bucket alignment without split line/slot address arithmetic.
        let p = self.lines.as_ptr().cast::<u8>().add(bucket * 16).cast();
        (_mm_testc_si128(_mm_load_si128(p), Self::mask_avx2(h)) != 0) as u32
    }
    #[target_feature(enable = "avx2")]
    unsafe fn lookup_avx2(&self, hashes: &[u64], out: &mut [u32]) {
        for (&h, answer) in hashes.iter().zip(out) {
            *answer = self.lookup_one_avx2(h);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::hash64;

    // Independent byte-level oracle: signed high-half multiplication is computed
    // by floor division, then interpreted as pshufb controls, including zero lanes.
    fn reference_mask(h: u64) -> [u8; 16] {
        let salts = [
            0x47b5i64, 0x4497, 0x8823, 0xa2b7, 0x7053, 0x2df1, 0x9efc, 0x5c6b,
        ];
        let table = [128, 64, 32, 16, 8, 4, 2, 1, 128, 64, 32, 16, 8, 4, 2, 1];
        let mut out = [0; 16];
        for j in 0..8 {
            let unsigned = ((h >> (16 * (j % 2))) & 65535) as i64;
            let word = if unsigned >= 32768 {
                unsigned - 65536
            } else {
                unsigned
            };
            let salt = if salts[j] >= 32768 {
                salts[j] - 65536
            } else {
                salts[j]
            };
            let high = (word * salt).div_euclid(65536) as u16;
            for byte in 0..2 {
                let control = ((high >> (8 * byte)) & 255) as usize;
                out[j * 2 + byte] = if control >= 128 {
                    0
                } else {
                    table[control & 15]
                };
            }
        }
        out
    }
    fn reference_insert(bitmap: &mut [u8], h: u64) {
        let bucket = (h >> 32) as usize & (bitmap.len() / 16 - 1);
        for (byte, mask) in bitmap[bucket * 16..bucket * 16 + 16]
            .iter_mut()
            .zip(reference_mask(h))
        {
            *byte |= mask;
        }
    }
    fn reference_contains(bitmap: &[u8], h: u64) -> u32 {
        let bucket = (h >> 32) as usize & (bitmap.len() / 16 - 1);
        bitmap[bucket * 16..bucket * 16 + 16]
            .iter()
            .zip(reference_mask(h))
            .all(|(&byte, mask)| byte & mask == mask) as u32
    }
    fn bitmap(filter: &ByteSplitBloomFilter) -> Vec<u8> {
        filter.lines.iter().flat_map(|line| line.0).collect()
    }
    #[test]
    fn sizing_alignment_and_limits() {
        for (n, bpk, bytes) in [
            (0, 1, 128),
            (1, 16, 128),
            (1024, 8, 2048),
            (65536, 8, 131072),
        ] {
            let filter = ByteSplitBloomFilter::new(n, bpk).unwrap();
            assert_eq!(filter.size_in_bytes(), bytes);
            assert_eq!(filter.byte_len(), bytes);
            assert_eq!(filter.lines.as_ptr() as usize % 64, 0);
            assert_eq!(filter.lines.len(), filter.lines.capacity());
        }
        assert_eq!(std::mem::size_of::<Line>(), 64);
        assert!(ByteSplitBloomFilter::new(1, 0).is_err());
        assert!(ByteSplitBloomFilter::new(usize::MAX, 32).is_err());
        assert!(ByteSplitBloomFilter::new(1 << 27, 16).is_err());
    }
    #[test]
    fn scalar_and_simd_masks_match_independent_oracle() {
        let mut zero_lanes = 0;
        for h in [0, u64::MAX, 0x8000_8000, 0xffff_0000, 0xffff, 1u64 << 32]
            .into_iter()
            .chain((0..65536).map(hash64))
        {
            let expected = reference_mask(h);
            zero_lanes += expected.iter().filter(|&&x| x == 0).count();
            assert_eq!(ByteSplitBloomFilter::scalar_mask(h), expected);
            #[cfg(target_arch = "x86_64")]
            if std::is_x86_feature_detected!("avx2") {
                let mut actual = [0u8; 16];
                // SAFETY: detected backend and complete writable output array.
                unsafe {
                    std::arch::x86_64::_mm_storeu_si128(
                        actual.as_mut_ptr().cast(),
                        ByteSplitBloomFilter::mask_avx2(h),
                    );
                }
                assert_eq!(actual, expected);
            }
        }
        assert!(zero_lanes > 0, "oracle must retain shuffle zero semantics");
    }
    #[test]
    fn complete_bitmap_collisions_and_query_tails() {
        for force_scalar in [true, false] {
            for bpk in [4, 8, 16] {
                let mut filter = ByteSplitBloomFilter::new(4097, bpk).unwrap();
                if force_scalar {
                    filter.avx2 = false;
                }
                let mut input: Vec<_> = (0..4097).map(hash64).collect();
                input.extend((0..1024).map(|i| ((8 + i % 4) << 32) | (hash64(i) & 0xffff_ffff)));
                input.extend([0, u64::MAX, 0x8000_8000, 0xffff_ffff]);
                let mut expected = vec![0; filter.size_in_bytes()];
                for &h in &input {
                    reference_insert(&mut expected, h);
                }
                for chunk in input.chunks(31) {
                    filter.insert_hashes(chunk);
                }
                assert_eq!(bitmap(&filter), expected);
                filter.insert_hashes(&input);
                assert_eq!(bitmap(&filter), expected);
                assert!(input.iter().all(|&h| filter.contains_hash(h)));
                for len in 0..=131 {
                    for offset in 0..16 {
                        let queries: Vec<_> = (0..offset + len)
                            .map(|i| {
                                if i % 2 == 0 {
                                    input[i % input.len()]
                                } else {
                                    hash64(1_000_000 + i as u64)
                                }
                            })
                            .collect();
                        let queries = &queries[offset..];
                        let mut out = vec![0xfeed; len + 2];
                        filter.lookup_hashes(queries, &mut out[1..len + 1]);
                        assert_eq!(out[0], 0xfeed);
                        assert_eq!(out[len + 1], 0xfeed);
                        for (&h, &answer) in queries.iter().zip(&out[1..len + 1]) {
                            assert_eq!(answer, reference_contains(&expected, h));
                        }
                    }
                }
                assert_eq!(bitmap(&filter), expected);
                let cloned = filter.clone();
                assert_eq!(bitmap(&cloned), expected);
            }
        }
    }
    #[test]
    fn parallel_owns_whole_lines_and_matches_serial() {
        for same_line in [false, true] {
            let input: Vec<_> = (0..65539)
                .map(|i| {
                    if same_line {
                        ((8 + i % 4) << 32) | (hash64(i) & 0xffff_ffff)
                    } else {
                        hash64(i)
                    }
                })
                .collect();
            let mut serial = ByteSplitBloomFilter::new(input.len(), 8).unwrap();
            serial.avx2 = false;
            serial.insert_hashes(&input);
            for force_scalar in [true, false] {
                for workers in [1, 2, 3, 7] {
                    let mut parallel = ByteSplitBloomFilter::new(input.len(), 8).unwrap();
                    if force_scalar {
                        parallel.avx2 = false;
                    }
                    parallel.insert_hashes_parallel(&input, workers);
                    assert_eq!(parallel.lines, serial.lines);
                    parallel.insert_hashes_parallel(&input, workers);
                    assert_eq!(parallel.lines, serial.lines);
                    let mut queries = input.clone();
                    queries.extend((1_000_000..1_032_771).map(hash64));
                    let mut out = vec![0; queries.len()];
                    parallel.lookup_hashes_parallel(&queries, &mut out, workers);
                    assert!(out[..input.len()].iter().all(|&x| x == 1));
                    for (&h, &answer) in queries.iter().zip(&out) {
                        assert_eq!(answer, serial.contains_scalar(h) as u32);
                    }
                    if workers == 1 {
                        assert_eq!(parallel.build_scratch_bytes(input.len(), workers), 0);
                    } else {
                        assert!(
                            parallel.build_scratch_bytes(input.len(), workers) >= input.len() * 8
                        );
                    }
                }
            }
        }
        let mut empty = ByteSplitBloomFilter::new(0, 8).unwrap();
        empty.insert_hashes_parallel(&[], 0);
        empty.lookup_hashes_parallel(&[], &mut [], 8);
        empty.insert_hash(0);
        assert!(empty.contains_hash(0));
    }
    #[test]
    fn mismatched_output_is_rejected_before_writing() {
        let filter = ByteSplitBloomFilter::new(1, 8).unwrap();
        let mut out = [0xfeed];
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            filter.lookup_hashes(&[0, 1], &mut out)
        }));
        assert!(result.is_err());
        assert_eq!(out, [0xfeed]);
    }
}
