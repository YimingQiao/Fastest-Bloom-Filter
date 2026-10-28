//! Experimental independent split-block layout, matching the frozen C++ mapping.
//! Eight independent five-bit hash fields select bits in eight u32 sectors.
use crate::{layout_parallel, SizeError};

#[repr(C, align(64))]
#[derive(Clone, Copy, Default, Debug, PartialEq, Eq)]
struct Line([[u32; 8]; 2]);

/// Native append-only filter over uniformly hashed u64 values.
///
/// Hash bits 0..39 select eight probes; bits 41..63 select a 32-byte bucket.
/// Bit 40 is unused. Two adjacent buckets share one owned 64-byte cache line.
/// This layout is not bitmap-compatible with Parquet or Split64.
#[derive(Clone)]
pub struct Independent32BloomFilter {
    lines: Vec<Line>,
    bucket_mask: u32,
    avx2: bool,
    vbmi: bool,
}

impl Independent32BloomFilter {
    /// Uses the existing strict-next-power-of-two capacity (128B..256MiB).
    pub fn new(n: usize, bpk: u32) -> Result<Self, SizeError> {
        let count = layout_parallel::line_count(n, bpk)?;
        #[cfg(target_arch = "x86_64")]
        let avx2 = std::is_x86_feature_detected!("avx2");
        #[cfg(target_arch = "x86_64")]
        let vbmi = !cfg!(feature = "disable-avx512")
            && avx2
            && std::is_x86_feature_detected!("avx512f")
            && std::is_x86_feature_detected!("avx512bw")
            && std::is_x86_feature_detected!("avx512vl")
            && std::is_x86_feature_detected!("avx512vbmi");
        #[cfg(not(target_arch = "x86_64"))]
        let (avx2, vbmi) = (false, false);
        Ok(Self {
            lines: vec![Line::default(); count],
            bucket_mask: (count * 2 - 1) as u32,
            avx2,
            vbmi,
        })
    }

    /// Actual bitmap backing allocation; object fields/allocator metadata excluded.
    pub fn size_in_bytes(&self) -> usize {
        self.lines.capacity() * 64
    }

    pub fn backend(&self) -> &'static str {
        if self.vbmi {
            "avx512vbmi"
        } else if self.avx2 {
            "avx2"
        } else {
            "scalar"
        }
    }

    #[inline]
    fn bucket(&self, hash: u64) -> usize {
        ((hash >> 41) as u32 & self.bucket_mask) as usize
    }

    #[inline]
    fn scalar_mask(hash: u64, sector: usize) -> u32 {
        1u32 << ((hash >> (5 * sector)) & 31)
    }

    #[inline]
    fn insert_scalar(lines: &mut [Line], begin: usize, mask: u32, hashes: &[u64]) {
        for &hash in hashes {
            let bucket = ((hash >> 41) as u32 & mask) as usize;
            let words = &mut lines[(bucket >> 1) - begin].0[bucket & 1];
            for (sector, word) in words.iter_mut().enumerate() {
                *word |= Self::scalar_mask(hash, sector);
            }
        }
    }

    #[inline]
    fn contains_scalar(&self, hash: u64) -> bool {
        let bucket = self.bucket(hash);
        let mut missing = 0;
        for (sector, &word) in self.lines[bucket >> 1].0[bucket & 1].iter().enumerate() {
            missing |= !word & Self::scalar_mask(hash, sector);
        }
        missing == 0
    }

    /// Duplicate insertion is idempotent; requires exclusive access.
    #[inline]
    pub fn insert_hash(&mut self, hash: u64) {
        self.insert_hashes(std::slice::from_ref(&hash));
    }

    /// False means absent; true means possibly present.
    // Keep the runtime backend branch visible to callers so a whole-array
    // caller can hoist it. Target-feature helpers retain their own contracts.
    #[inline(always)]
    pub fn contains_hash(&self, hash: u64) -> bool {
        #[cfg(target_arch = "x86_64")]
        {
            if self.vbmi {
                // SAFETY: construction detected every required CPU feature.
                return unsafe { self.lookup_one_vbmi(hash) };
            }
            if self.avx2 {
                // SAFETY: AVX2 detected; the masked bucket is inside the bitmap.
                return unsafe { self.lookup_one_avx2(hash) };
            }
        }
        self.contains_scalar(hash)
    }

    fn insert_into(
        lines: &mut [Line],
        begin: usize,
        mask: u32,
        avx2: bool,
        vbmi: bool,
        hashes: &[u64],
    ) {
        #[cfg(target_arch = "x86_64")]
        {
            if vbmi {
                // SAFETY: detected backend; every hash belongs to the owned lines.
                unsafe { Self::insert_vbmi(lines, begin, mask, hashes) };
                return;
            }
            if avx2 {
                // SAFETY: detected backend; every hash belongs to the owned lines.
                unsafe { Self::insert_avx2(lines, begin, mask, hashes) };
                return;
            }
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = (avx2, vbmi);
        Self::insert_scalar(lines, begin, mask, hashes);
    }

    /// Exclusive batch construction, with sequential ORs for colliding updates.
    pub fn insert_hashes(&mut self, hashes: &[u64]) {
        Self::insert_into(
            &mut self.lines,
            0,
            self.bucket_mask,
            self.avx2,
            self.vbmi,
            hashes,
        );
    }

    /// Writes one dense 0/1 result per input. Length mismatch panics before writes.
    pub fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len(), "one output is required per input");
        #[cfg(target_arch = "x86_64")]
        {
            if self.vbmi {
                // SAFETY: checked lengths and detected backend; input loads are bounded.
                unsafe { self.lookup_vbmi(hashes, out) };
                return;
            }
            if self.avx2 {
                // SAFETY: checked lengths and detected backend; input loads are bounded.
                unsafe { self.lookup_avx2(hashes, out) };
                return;
            }
        }
        for (&hash, answer) in hashes.iter().zip(out) {
            *answer = self.contains_scalar(hash) as u32;
        }
    }

    pub fn build_workers(&self, n: usize, requested: usize) -> usize {
        layout_parallel::build_workers(n, requested, self.lines.len())
    }

    /// Explicit heap scratch, excluding allocator metadata and OS thread stacks.
    pub fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
        layout_parallel::scratch_bytes(n, requested, self.lines.len())
    }

    /// Parallel construction owns complete lines, including both 32-byte buckets.
    pub fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
        let mask = self.bucket_mask;
        let (avx2, vbmi) = (self.avx2, self.vbmi);
        layout_parallel::insert(
            &mut self.lines,
            hashes,
            requested,
            |hash| (((hash >> 41) as u32 & mask) >> 1) as usize,
            |lines, begin, input| Self::insert_into(lines, begin, mask, avx2, vbmi, input),
        );
    }

    /// Concurrent immutable reads do not update filter state.
    pub fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        layout_parallel::lookup(hashes, out, requested, |input, output| {
            self.lookup_hashes(input, output)
        });
    }

    /// Validation-only flat bitmap export for the independently compiled C++ fixture.
    #[cfg(feature = "validation")]
    pub fn bitmap_words(&self) -> Vec<u32> {
        self.lines
            .iter()
            .flat_map(|line| line.0.iter().flatten().copied())
            .collect()
    }
}

#[cfg(target_arch = "x86_64")]
impl Independent32BloomFilter {
    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn mask_avx2(hash: u64) -> std::arch::x86_64::__m256i {
        use std::arch::x86_64::*;
        let fields = _mm256_srlv_epi64(
            _mm256_set1_epi64x(hash as i64),
            _mm256_setr_epi64x(0, 10, 20, 30),
        );
        let duplicated = _mm256_shuffle_epi32::<0xa0>(fields);
        let positions = _mm256_and_si256(
            _mm256_srlv_epi32(duplicated, _mm256_setr_epi32(0, 5, 0, 5, 0, 5, 0, 5)),
            _mm256_set1_epi32(31),
        );
        _mm256_sllv_epi32(_mm256_set1_epi32(1), positions)
    }

    #[inline]
    #[target_feature(enable = "avx2,avx512f,avx512bw,avx512vl,avx512vbmi")]
    unsafe fn mask_vbmi(hash: u64) -> std::arch::x86_64::__m256i {
        use std::arch::x86_64::*;
        let fields = _mm_multishift_epi64_epi8(
            _mm_set1_epi64x(0x231e19140f0a0500),
            _mm_set1_epi64x(hash as i64),
        );
        // Rotate counts use their low five bits, exactly fields0..39. The
        // extra extracted bits40..42 cannot influence the original eight probes.
        _mm256_rolv_epi32(_mm256_set1_epi32(1), _mm256_cvtepu8_epi32(fields))
    }

    #[target_feature(enable = "avx2")]
    unsafe fn insert_avx2(lines: &mut [Line], begin: usize, mask: u32, hashes: &[u64]) {
        use std::arch::x86_64::*;
        for &hash in hashes {
            let relative = (((hash >> 41) as u32 & mask) as usize) - begin * 2;
            debug_assert!(relative < lines.len() * 2);
            // Each owned line contains two aligned32B buckets. The whole32B
            // operation stays inside the same owned slice/allocation.
            let p = lines.as_mut_ptr().cast::<u8>().add(relative * 32).cast();
            _mm256_store_si256(
                p,
                _mm256_or_si256(_mm256_load_si256(p), Self::mask_avx2(hash)),
            );
        }
    }

    #[target_feature(enable = "avx2,avx512f,avx512bw,avx512vl,avx512vbmi")]
    unsafe fn insert_vbmi(lines: &mut [Line], begin: usize, mask: u32, hashes: &[u64]) {
        use std::arch::x86_64::*;
        for &hash in hashes {
            let relative = (((hash >> 41) as u32 & mask) as usize) - begin * 2;
            debug_assert!(relative < lines.len() * 2);
            // Same complete-line ownership and32B-aligned bounds as AVX2.
            let p = lines.as_mut_ptr().cast::<u8>().add(relative * 32).cast();
            _mm256_store_si256(
                p,
                _mm256_or_si256(_mm256_load_si256(p), Self::mask_vbmi(hash)),
            );
        }
    }

    #[inline]
    #[target_feature(enable = "avx2")]
    unsafe fn lookup_one_avx2(&self, hash: u64) -> bool {
        use std::arch::x86_64::*;
        let p = self
            .lines
            .as_ptr()
            .cast::<u8>()
            .add(self.bucket(hash) * 32)
            .cast();
        _mm256_testc_si256(_mm256_load_si256(p), Self::mask_avx2(hash)) != 0
    }

    #[inline]
    #[target_feature(enable = "avx2,avx512f,avx512bw,avx512vl,avx512vbmi")]
    unsafe fn lookup_one_vbmi(&self, hash: u64) -> bool {
        use std::arch::x86_64::*;
        let p = self
            .lines
            .as_ptr()
            .cast::<u8>()
            .add(self.bucket(hash) * 32)
            .cast();
        _mm256_testc_si256(_mm256_load_si256(p), Self::mask_vbmi(hash)) != 0
    }

    #[target_feature(enable = "avx2")]
    unsafe fn lookup_avx2(&self, hashes: &[u64], out: &mut [u32]) {
        for (&hash, answer) in hashes.iter().zip(out) {
            *answer = self.lookup_one_avx2(hash) as u32;
        }
    }

    #[target_feature(enable = "avx2,avx512f,avx512bw,avx512vl,avx512vbmi")]
    unsafe fn lookup_vbmi(&self, hashes: &[u64], out: &mut [u32]) {
        for (&hash, answer) in hashes.iter().zip(out) {
            *answer = self.lookup_one_vbmi(hash) as u32;
        }
    }
}

#[cfg(test)]
mod tests;
