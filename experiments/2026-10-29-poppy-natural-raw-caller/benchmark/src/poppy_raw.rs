//! Original raw u64 inputs. Both public paths retain their own internal hashing.
use crate::{poppy_geometry, raw_contract::RawFilter};

pub struct PoppyRaw<const ID: usize, const TYPED: bool>(pub(crate) poppy_filters::v2::BloomFilter);

impl<const ID: usize, const TYPED: bool> RawFilter for PoppyRaw<ID, TYPED> {
    fn new(real_n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let p = poppy_geometry::by_id(ID);
        p.check(real_n, bpk)?;
        let filter = poppy_filters::Params::new(real_n, f64::from_bits(p.fpp_bits))
            .opt(p.policy)
            .try_into_v2()?;
        assert_eq!(filter.capacity(), real_n);
        assert_eq!(filter.fpp().to_bits(), p.fpp_bits);
        assert_eq!(filter.size_in_bytes(), p.bucket_bytes + p.cache_bytes);
        Ok(Self(filter))
    }
    fn size_in_bytes(&self) -> usize { self.0.size_in_bytes() }
    fn scratch_words(_input_len: usize) -> usize { 0 }
    #[inline(always)]
    fn contains_raw(&self, raw: u64) -> bool {
        if TYPED { self.0.contains(&raw) }
        else { self.0.contains_bytes(raw.to_le_bytes()) }
    }
    fn insert_raw(&mut self, raw: &[u64], _scratch: &mut [u64]) {
        for &value in raw {
            let result = if TYPED { self.0.insert(&value) }
                else { self.0.insert_bytes(value.to_le_bytes()) };
            result.expect("public natural-input insertion within real capacity");
        }
    }
    fn lookup_raw(&self, raw: &[u64], out: &mut [u32], _scratch: &mut [u64]) {
        assert_eq!(raw.len(), out.len(), "one output is required per raw input");
        for (&value, answer) in raw.iter().zip(out.iter_mut()) {
            *answer = self.contains_raw(value) as u32;
        }
    }
}
