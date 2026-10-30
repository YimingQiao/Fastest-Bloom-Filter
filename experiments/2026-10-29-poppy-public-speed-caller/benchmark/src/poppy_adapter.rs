// Only public Poppy entry points. The eight-byte conversion, index iterator,
// cache and mandatory secondary hashing stay inside insertion/query clocks.
struct PoppyPublic<const ID: usize>(poppy_filters::v2::BloomFilter);

impl<const ID: usize> Filter for PoppyPublic<ID> {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let p = poppy_geometry::by_id(ID);
        p.check(n, bpk)?;
        let filter = poppy_filters::Params::new(n, f64::from_bits(p.fpp_bits))
            .opt(p.policy)
            .try_into_v2()?;
        assert_eq!(filter.capacity(), n);
        assert_eq!(filter.fpp().to_bits(), p.fpp_bits);
        assert_eq!(filter.size_in_bytes(), p.bucket_bytes + p.cache_bytes);
        Ok(Self(filter))
    }
    fn size_in_bytes(&self) -> usize {
        self.0.size_in_bytes()
    }
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        self.0.contains_bytes(hash.to_le_bytes())
    }
    fn insert_hashes(&mut self, hashes: &[u64]) {
        for &hash in hashes {
            self.0
                .insert_bytes(hash.to_le_bytes())
                .expect("public insertion within real capacity");
        }
    }
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len());
        for (&hash, answer) in hashes.iter().zip(out.iter_mut()) {
            *answer = self.0.contains_bytes(hash.to_le_bytes()) as u32;
        }
    }
}
