use fastest_bloom_filter::{
    hash64, BloomFilter, ByteSplitBloomFilter, FourSectorBloomFilter, Split64BloomFilter,
};
mod sbbf;
use sbbf::SbbfSafePinned;
use std::{
    alloc::{alloc, dealloc, handle_alloc_error, Layout},
    hint::black_box,
    ops::{Deref, DerefMut},
    ptr::NonNull,
    time::Instant,
};

// Optional external baseline: no dependency is added to the native library.
trait Filter: Sized {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>>;
    fn size_in_bytes(&self) -> usize;
    fn contains_hash(&self, hash: u64) -> bool;
    fn insert_hashes(&mut self, hashes: &[u64]);
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]);
}
impl<const P: bool> Filter for BloomFilter<P> {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(BloomFilter::new(n, bpk)?)
    }
    fn size_in_bytes(&self) -> usize {
        BloomFilter::size_in_bytes(self)
    }
    fn insert_hashes(&mut self, h: &[u64]) {
        BloomFilter::insert_hashes(self, h)
    }
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        BloomFilter::contains_hash(self, hash)
    }
    fn lookup_hashes(&self, h: &[u64], out: &mut [u32]) {
        BloomFilter::lookup_hashes(self, h, out)
    }
}
macro_rules! native_filter {
    ($filter:ty) => {
        impl Filter for $filter {
            fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
                Ok(<$filter>::new(n, bpk)?)
            }
            fn size_in_bytes(&self) -> usize {
                <$filter>::size_in_bytes(self)
            }
            fn insert_hashes(&mut self, hashes: &[u64]) {
                <$filter>::insert_hashes(self, hashes)
            }
            #[inline(always)]
            fn contains_hash(&self, hash: u64) -> bool {
                <$filter>::contains_hash(self, hash)
            }
            fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
                <$filter>::lookup_hashes(self, hashes, out)
            }
        }
    };
}
native_filter!(ByteSplitBloomFilter);
native_filter!(FourSectorBloomFilter);
native_filter!(Split64BloomFilter);

struct Fastbloom017(fastbloom::BloomFilter);
impl Filter for Fastbloom017 {
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        self.0.contains_hash(hash)
    }
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let mut bytes = 128;
        while bytes <= ((n * bpk as usize).max(512) / 8) {
            bytes *= 2;
        }
        Ok(Self(
            fastbloom::BloomFilter::with_num_bits(bytes * 8).expected_items(n),
        ))
    }
    fn size_in_bytes(&self) -> usize {
        self.0.num_bits() / 8
    }
    fn insert_hashes(&mut self, h: &[u64]) {
        for &hash in h {
            self.0.insert_hash(hash);
        }
    }
    fn lookup_hashes(&self, h: &[u64], out: &mut [u32]) {
        assert_eq!(h.len(), out.len());
        for (&hash, v) in h.iter().zip(out.iter_mut()) {
            *v = self.0.contains_hash(hash) as u32;
        }
    }
}

struct BloomsdayPinned {
    filter: bloomsday::BlockedBloomFilter,
    bytes: usize,
}
impl Filter for BloomsdayPinned {
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        self.filter.may_match_hash(hash)
    }
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let mut bytes = 128;
        while bytes <= ((n * bpk as usize).max(512) / 8) {
            bytes *= 2;
        }
        // The pinned upstream constructor computes ceil(-ln(fpr)/ln(2)^2)
        // bits/key, then ceil(n*bits_per_key/256) 32-byte blocks. Choose the
        // midpoint of the rounding interval, not a claimed target FPR.
        let bits_per_key = bytes * 8 / n;
        let sizing_fpr = (-(bits_per_key as f64 - 0.5) * std::f64::consts::LN_2.powi(2)).exp();
        let rounded_bpk = (-sizing_fpr.ln() / std::f64::consts::LN_2.powi(2)).ceil() as usize;
        assert_eq!(rounded_bpk, bits_per_key);
        assert_eq!((n * rounded_bpk).div_ceil(256) * 32, bytes);
        Ok(Self {
            filter: bloomsday::BlockedBloomFilter::new_with_seed(n, sizing_fpr, 0),
            bytes,
        })
    }
    fn size_in_bytes(&self) -> usize {
        self.bytes
    }
    fn insert_hashes(&mut self, hashes: &[u64]) {
        for &hash in hashes {
            self.filter.insert_hash(hash);
        }
    }
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len());
        for (&hash, result) in hashes.iter().zip(out.iter_mut()) {
            *result = self.filter.may_match_hash(hash) as u32;
        }
    }
}

