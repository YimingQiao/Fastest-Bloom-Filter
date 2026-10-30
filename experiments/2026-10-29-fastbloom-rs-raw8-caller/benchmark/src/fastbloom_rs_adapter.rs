//! Public fastbloom-rs0.5.10 API only. Distinct from fastbloom0.17.
use fastbloom_rs::{BloomFilter as Upstream, FilterBuilder, Hashes, Membership};
use crate::raw_contract::RawFilter;

pub struct FastbloomRsRaw<const K: u32>(Upstream);
impl<const K: u32> RawFilter for FastbloomRsRaw<K> {
    fn new(real_n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        if real_n == 0 || !(1..=24).contains(&K) || ![16, 24, 32].contains(&bpk) {
            return Err("positive real n and the fixed public m/K panel are required".into());
        }
        if usize::BITS != 64 { return Err("this pinned allocation proof requires a64-bit target".into()); }
        let ceiling = crate::geometry::bytes(real_n, bpk)?;
        let bytes = ceiling / 8 * 8;
        let bits = u64::try_from(bytes.checked_mul(8).ok_or("bit capacity overflow")?)?;
        if bits == 0 || bits % 64 != 0 { return Err("nonempty whole native words required".into()); }
        // Normal public constructor. Its inferred expected_elements metadata is
        // not used as a synthetic benchmark n; real_n remains the workload n.
        let filter = FilterBuilder::from_size_and_hashes(bits, K).build_bloom_filter();
        assert_eq!(filter.config().size, bits);
        assert_eq!(filter.hashes(), K);
        assert_eq!(filter.get_u8_array().len(), bytes);
        Ok(Self(filter))
    }
    fn size_in_bytes(&self) -> usize {
        // Borrowed bitmap view; no serialization copy. A separate allocator
        // proof must establish equality to actual live backing bytes before run.
        self.0.get_u8_array().len()
    }
    fn scratch_words(_input_len: usize) -> usize { 0 }
    #[inline(always)]
    fn contains_raw(&self, raw: u64) -> bool {
        self.0.contains(&raw.to_le_bytes())
    }
    fn insert_raw(&mut self, raw: &[u64], _scratch: &mut [u64]) {
        for &value in raw { self.0.add(&value.to_le_bytes()); }
    }
    fn lookup_raw(&self, raw: &[u64], out: &mut [u32], _scratch: &mut [u64]) {
        assert_eq!(raw.len(), out.len(), "one output is required per raw input");
        for (&value, answer) in raw.iter().zip(out) {
            *answer = self.0.contains(&value.to_le_bytes()) as u32;
        }
    }
}

#[cfg(test)]
mod tests { include!("fastbloom_rs_tests.rs"); }
