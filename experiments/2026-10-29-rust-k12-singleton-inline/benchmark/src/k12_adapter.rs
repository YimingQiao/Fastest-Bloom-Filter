// Only public methods of the independently proved native Rust crate are called.
impl Filter for FourSectorRange12BloomFilter {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(Self::with_byte_budget(geometry::bytes(n, bpk)?)?)
    }
    fn size_in_bytes(&self) -> usize { Self::size_in_bytes(self) }
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool { Self::contains_hash(self, hash) }
    fn insert_hashes(&mut self, hashes: &[u64]) { Self::insert_hashes(self, hashes) }
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) { Self::lookup_hashes(self, hashes, out) }
}
