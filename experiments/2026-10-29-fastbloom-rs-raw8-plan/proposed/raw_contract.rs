//! All inputs are original raw u64 keys, encoded as eight little-endian bytes
//! only at byte-based public APIs. No prepared/prehashed ranking column exists.
use crate::{hash64, Filter};

pub trait RawFilter: Sized {
    fn new(real_n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>>;
    fn size_in_bytes(&self) -> usize;
    /// Required temporary hash words for this raw operation; no filter backing.
    fn scratch_words(input_len: usize) -> usize;
    fn contains_raw(&self, raw: u64) -> bool;
    fn insert_raw(&mut self, raw: &[u64], scratch: &mut [u64]);
    fn lookup_raw(&self, raw: &[u64], out: &mut [u32], scratch: &mut [u64]);
}

/// Unchanged native/external public prehash APIs receive the project common
/// hash inside each raw operation. This is a static wrapper, not a vtable.
pub struct CommonHash<F: Filter>(pub F);
impl<F: Filter> RawFilter for CommonHash<F> {
    fn new(real_n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(Self(F::new(real_n, bpk)?))
    }
    fn size_in_bytes(&self) -> usize { self.0.size_in_bytes() }
    fn scratch_words(input_len: usize) -> usize { input_len }
    #[inline(always)]
    fn contains_raw(&self, raw: u64) -> bool { self.0.contains_hash(hash64(raw)) }
    fn insert_raw(&mut self, raw: &[u64], scratch: &mut [u64]) {
        assert!(scratch.len() >= raw.len());
        for (prepared, &value) in scratch.iter_mut().zip(raw) { *prepared = hash64(value); }
        self.0.insert_hashes(&scratch[..raw.len()]);
    }
    fn lookup_raw(&self, raw: &[u64], out: &mut [u32], scratch: &mut [u64]) {
        assert_eq!(raw.len(), out.len(), "one output is required per raw input");
        assert!(scratch.len() >= raw.len());
        for (prepared, &value) in scratch.iter_mut().zip(raw) { *prepared = hash64(value); }
        self.0.lookup_hashes(&scratch[..raw.len()], out);
    }
}

#[inline(never)]
pub fn raw_batched<F: RawFilter>(filter: &F, raw: &[u64], out: &mut [u32], scratch: &mut [u64]) {
    filter.lookup_raw(raw, out, scratch);
}

/// Optimizer-visible public-singleton loop; mandatory hashing stays in-loop.
#[inline(never)]
pub fn raw_visible<F: RawFilter>(filter: &F, raw: &[u64], out: &mut [u32]) {
    assert_eq!(raw.len(), out.len(), "one output is required per raw input");
    for (&value, answer) in raw.iter().zip(out) { *answer = filter.contains_raw(value) as u32; }
}

#[inline(never)]
pub fn raw_insert<F: RawFilter>(filter: &mut F, raw: &[u64], scratch: &mut [u64]) {
    filter.insert_raw(raw, scratch);
}
