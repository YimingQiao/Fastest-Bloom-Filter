//! Source-only bounded build-request experiment over exact frozen public APIs.
use fastest_bloom_filter::{Split64BloomFilter, Split64RangeBloomFilter};

/// `batch_n` is this insertion slice's length, independently of allocation size.
#[inline]
pub const fn effective_request(batch_n: usize, bitmap_bytes: usize, requested: usize) -> usize {
    if batch_n <= 65_536 && bitmap_bytes <= 256 * 1024 {
        1
    } else {
        requested
    }
}

/// Static dispatch only; this trait does not erase a per-key or bulk call.
pub trait Native {
    fn size_in_bytes(&self) -> usize;
    fn build_workers(&self, n: usize, requested: usize) -> usize;
    fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize;
    fn insert_hashes(&mut self, hashes: &[u64]);
    fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize);
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]);
    fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize);
}

macro_rules! forward_native {
    ($native:ty) => {
        impl Native for $native {
            #[inline]
            fn size_in_bytes(&self) -> usize { <$native>::size_in_bytes(self) }
            #[inline]
            fn build_workers(&self, n: usize, requested: usize) -> usize {
                <$native>::build_workers(self, n, requested)
            }
            #[inline]
            fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
                <$native>::build_scratch_bytes(self, n, requested)
            }
            #[inline]
            fn insert_hashes(&mut self, hashes: &[u64]) { <$native>::insert_hashes(self, hashes) }
            #[inline]
            fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
                <$native>::insert_hashes_parallel(self, hashes, requested)
            }
            #[inline]
            fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
                <$native>::lookup_hashes(self, hashes, out)
            }
            #[inline]
            fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
                <$native>::lookup_hashes_parallel(self, hashes, out, requested)
            }
        }
    };
}
forward_native!(Split64BloomFilter);
forward_native!(Split64RangeBloomFilter);

/// Same typed wrapper for the disabled control and the one bounded candidate.
pub struct Filter<F: Native, const ENABLED: bool> {
    native: F,
}

impl<F: Native, const ENABLED: bool> Filter<F, ENABLED> {
    pub fn from_native(native: F) -> Self { Self { native } }
    #[inline]
    pub fn size_in_bytes(&self) -> usize { self.native.size_in_bytes() }
    #[inline]
    pub fn effective_build_request(&self, n: usize, requested: usize) -> usize {
        if ENABLED { effective_request(n, self.size_in_bytes(), requested) } else { requested }
    }
    #[inline]
    pub fn build_workers(&self, n: usize, requested: usize) -> usize {
        self.native.build_workers(n, self.effective_build_request(n, requested))
    }
    #[inline]
    pub fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
        self.native.build_scratch_bytes(n, self.effective_build_request(n, requested))
    }
    #[inline]
    pub fn insert_hashes(&mut self, hashes: &[u64]) { self.native.insert_hashes(hashes) }
    #[inline]
    pub fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
        let effective = self.effective_build_request(hashes.len(), requested);
        self.native.insert_hashes_parallel(hashes, effective);
    }
    #[inline]
    pub fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        self.native.lookup_hashes(hashes, out)
    }
    #[inline]
    pub fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        self.native.lookup_hashes_parallel(hashes, out, requested)
    }
}

pub type SplitControl = Filter<Split64BloomFilter, false>;
pub type SplitBounded = Filter<Split64BloomFilter, true>;
pub type RangeControl = Filter<Split64RangeBloomFilter, false>;
pub type RangeBounded = Filter<Split64RangeBloomFilter, true>;
