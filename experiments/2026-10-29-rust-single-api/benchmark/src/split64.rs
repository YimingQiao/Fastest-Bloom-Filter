//! Experimental eight-sector, 64-byte split-block filter, matching C++ Split64P32.
//! The layout widens the Parquet/Impala multiply-shift construction to u64
//! sectors; it is not a Parquet-compatible bitmap.

use crate::Filter;
use fastest_bloom_filter::SizeError;

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
#[derive(Clone, Copy, Default)]
struct Line([u64; 8]);

pub(crate) struct Split64Experimental {
    lines: Vec<Line>,
    block_mask: u32,
    avx512: bool,
}

impl Split64Experimental {
    fn line_count(keys: usize, bits_per_key: u32) -> Result<usize, SizeError> {
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
        // Preserve the native C++ strict-next-power-of-two allocation rule.
        let mut words = 32;
        while words <= bits / 32 {
            words *= 2;
        }
        Ok(words / 16)
    }

    #[inline]
    fn block(&self, hash: u64) -> usize {
        ((hash >> 32) as u32 & self.block_mask) as usize
    }

    #[inline]
    fn insert_scalar(&mut self, hash: u64) {
        let index = self.block(hash);
        for (word, salt) in self.lines[index].0.iter_mut().zip(SALTS) {
            *word |= 1u64 << (hash as u32).wrapping_mul(salt).wrapping_shr(26);
        }
    }

    #[inline]
    fn contains_scalar(&self, hash: u64) -> bool {
        let mut missing = 0;
        for (&word, salt) in self.lines[self.block(hash)].0.iter().zip(SALTS) {
            missing |= !word & (1u64 << (hash as u32).wrapping_mul(salt).wrapping_shr(26));
        }
        missing == 0
    }
}

impl Filter for Split64Experimental {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let count = Self::line_count(n, bpk)?;
        #[cfg(target_arch = "x86_64")]
        let avx512 =
            std::is_x86_feature_detected!("avx512f") && std::is_x86_feature_detected!("avx2");
        #[cfg(not(target_arch = "x86_64"))]
        let avx512 = false;
        Ok(Self {
            lines: vec![Line::default(); count],
            block_mask: (count - 1) as u32,
            avx512,
        })
    }

    fn size_in_bytes(&self) -> usize {
        self.lines.len() * 64
    }

    fn insert_hashes(&mut self, hashes: &[u64]) {
        #[cfg(target_arch = "x86_64")]
        if self.avx512 {
            // SAFETY: runtime feature detection, valid slice, masked line indices.
            unsafe { self.insert_avx512(hashes) };
            return;
        }
        for &hash in hashes {
            self.insert_scalar(hash);
        }
    }

    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len(), "one output is required per input");
        #[cfg(target_arch = "x86_64")]
        if self.avx512 {
            // SAFETY: runtime feature detection, equal slice lengths, masked indices.
            unsafe { self.lookup_avx512(hashes, out) };
            return;
        }
        for (&hash, answer) in hashes.iter().zip(out) {
            *answer = self.contains_scalar(hash) as u32;
        }
    }
}

#[cfg(target_arch = "x86_64")]
impl Split64Experimental {
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
    unsafe fn insert_one_avx512(&mut self, hash: u64) {
        use std::arch::x86_64::*;
        let line = self.lines.as_mut_ptr().add(self.block(hash)).cast();
        _mm512_store_si512(
            line,
            _mm512_or_si512(_mm512_load_si512(line), Self::mask(hash)),
        );
    }

    #[inline]
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn lookup_one_avx512(&self, hash: u64) -> u32 {
        use std::arch::x86_64::*;
        let line = self.lines.as_ptr().add(self.block(hash)).cast();
        (_mm512_testn_epi64_mask(_mm512_load_si512(line), Self::mask(hash)) == 0) as u32
    }

    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn insert_avx512(&mut self, hashes: &[u64]) {
        use std::arch::x86_64::*;
        let prefetched = hashes.len().saturating_sub(PREFETCH);
        for (i, &hash) in hashes[..prefetched].iter().enumerate() {
            let future = self.block(hashes[i + PREFETCH]);
            _mm_prefetch::<_MM_HINT_T0>(self.lines.as_ptr().add(future).cast());
            self.insert_one_avx512(hash);
        }
        for &hash in &hashes[prefetched..] {
            self.insert_one_avx512(hash);
        }
    }

    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn lookup_avx512(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        let prefetched = hashes.len().saturating_sub(PREFETCH);
        for (i, (&hash, answer)) in hashes[..prefetched]
            .iter()
            .zip(&mut out[..prefetched])
            .enumerate()
        {
            let future = self.block(hashes[i + PREFETCH]);
            _mm_prefetch::<_MM_HINT_T0>(self.lines.as_ptr().add(future).cast());
            *answer = self.lookup_one_avx512(hash);
        }
        for (&hash, answer) in hashes[prefetched..].iter().zip(&mut out[prefetched..]) {
            *answer = self.lookup_one_avx512(hash);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use fastest_bloom_filter::hash64;

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
            let bf = Split64Experimental::new(n, bpk).unwrap();
            assert_eq!(bf.size_in_bytes(), bytes);
            assert_eq!(bf.lines.as_ptr() as usize % 64, 0);
        }
        assert_eq!(
            Split64Experimental::line_count(1, 0),
            Err(SizeError::InvalidSize)
        );
        assert_eq!(
            Split64Experimental::line_count(usize::MAX, 2),
            Err(SizeError::InvalidSize)
        );
        assert_eq!(
            Split64Experimental::line_count(1 << 27, 16),
            Err(SizeError::CapacityExceeded)
        );
    }

    #[test]
    fn scalar_and_runtime_paths_match_at_batch_boundaries() {
        for n in [0, 1, 31, 32, 33, 64, 65, 4099] {
            let inserted: Vec<_> = (0..n).map(hash64).collect();
            let mut scalar = Split64Experimental::new(n as usize, 8).unwrap();
            scalar.avx512 = false;
            scalar.insert_hashes(&inserted);
            let mut runtime = Split64Experimental::new(n as usize, 8).unwrap();
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
        let bf = Split64Experimental::new(1, 8).unwrap();
        bf.lookup_hashes(&[hash64(1)], &mut []);
    }
}
