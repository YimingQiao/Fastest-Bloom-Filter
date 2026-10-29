//! Public upstream safe API only; no private kernels or alternative probe logic.
use super::Filter;

pub(crate) struct SbbfSafePinned {
    filter: sbbf_rs_safe::Filter,
    backing_bytes: usize,
}

fn byte_budget(n: usize, bpk: u32) -> Result<usize, Box<dyn std::error::Error>> {
    Ok(super::geometry::bytes(n, bpk)? / 64 * 64)
}

impl SbbfSafePinned {
    fn from_logical_bytes(bytes: usize) -> Result<Self, Box<dyn std::error::Error>> {
        if bytes == 0 || !bytes.is_multiple_of(sbbf_rs::BUCKET_SIZE) || bytes > (1 << 28) {
            return Err("invalid SBBF logical byte count".into());
        }
        // At this immutable revision, these arguments set only the product
        // used for sizing. They avoid a temporary serialized bitmap and yield
        // exactly `bytes` logical bytes, with one upstream allocation.
        let filter = sbbf_rs_safe::Filter::new(8, bytes);
        assert_eq!(filter.as_bytes().len(), bytes);
        // Upstream Buf rounds the allocation Layout to ALIGNMENT, separately
        // from its logical 32-byte block length. Test builds count allocations.
        let backing_bytes = bytes.div_ceil(sbbf_rs::ALIGNMENT) * sbbf_rs::ALIGNMENT;
        Ok(Self {
            filter,
            backing_bytes,
        })
    }
}

impl Filter for SbbfSafePinned {
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        self.filter.contains_hash(hash)
    }
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let bytes = byte_budget(n, bpk)?;
        let filter = Self::from_logical_bytes(bytes)?;
        assert_eq!(filter.backing_bytes, bytes);
        Ok(filter)
    }

    fn size_in_bytes(&self) -> usize {
        self.backing_bytes
    }

    fn insert_hashes(&mut self, hashes: &[u64]) {
        for &hash in hashes {
            // Return values describe possible previous membership. The common
            // benchmark requires only append-only insertion, so discards them.
            self.filter.insert_hash(hash);
        }
    }

    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len(), "one output is required per input");
        for (&hash, result) in hashes.iter().zip(out.iter_mut()) {
            *result = self.filter.contains_hash(hash) as u32;
        }
    }
}

