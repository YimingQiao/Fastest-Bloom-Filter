//! Static forwarding to actual public native methods; no policy here.
pub trait Native {
    const BOUNDED: bool;
    fn make(bytes: usize) -> Self;
    fn size_in_bytes(&self) -> usize;
    fn build_workers(&self, n: usize, requested: usize) -> usize;
    fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize;
    fn insert_hashes(&mut self, hashes: &[u64]);
    fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize);
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]);
    fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize);
}

macro_rules! forward_native {
    ($native:ty, $bounded:expr, $make:expr) => {
        impl Native for $native {
            const BOUNDED: bool = $bounded;
            fn make(bytes: usize) -> Self { ($make)(bytes) }
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
forward_native!(before_native::Split64BloomFilter, false, |bytes| before_native::Split64BloomFilter::new(bytes / 2, 8).unwrap());
forward_native!(before_native::Split64RangeBloomFilter, false, |bytes| before_native::Split64RangeBloomFilter::with_byte_budget(bytes).unwrap());
forward_native!(after_native::Split64BloomFilter, true, |bytes| after_native::Split64BloomFilter::new(bytes / 2, 8).unwrap());
forward_native!(after_native::Split64RangeBloomFilter, true, |bytes| after_native::Split64RangeBloomFilter::with_byte_budget(bytes).unwrap());
