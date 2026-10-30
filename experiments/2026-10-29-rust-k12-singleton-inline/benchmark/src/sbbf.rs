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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::hash64;

    const SALTS: [u32; 8] = [
        0x47b6137b, 0x44974d91, 0x8824ad5b, 0xa2b7289d, 0x705495c7, 0x2df1424b, 0x9efc4947,
        0x5c6bfb31,
    ];

    // Independent byte-level Parquet oracle; no upstream descriptors or masks.
    fn bit_locations(bytes: usize, hash: u64) -> [(usize, u8); 8] {
        let block = ((u128::from(hash >> 32) * (bytes / 32) as u128) >> 32) as usize;
        std::array::from_fn(|lane| {
            let position =
                (((hash as u32 as u64 * SALTS[lane] as u64) & 0xffff_ffff) >> 27) as usize;
            (block * 32 + lane * 4 + position / 8, 1 << (position % 8))
        })
    }

    fn oracle_contains(bitmap: &[u8], hash: u64) -> bool {
        bit_locations(bitmap.len(), hash)
            .iter()
            .all(|&(byte, bit)| bitmap[byte] & bit != 0)
    }

    #[test]
    fn independent_bitmap_oracle_collisions_and_all_query_tails() {
        for bytes in [32, 64, 96, 128, 160, 1024, 131_072] {
            let mut filter = SbbfSafePinned::from_logical_bytes(bytes).unwrap();
            let mut oracle = vec![0u8; bytes];
            let mut inserted: Vec<_> = (0..1024).map(hash64).collect();
            // Force block collisions independently of low-word probe positions.
            inserted.extend((0..256).map(|x| (7u64 << 32) | (hash64(x) & 0xffff_ffff)));
            inserted.extend([0, u64::MAX, 1, 1 << 32, 0xffff_ffff]);
            for chunk in inserted.chunks(7) {
                filter.insert_hashes(chunk);
                for &hash in chunk {
                    for (byte, bit) in bit_locations(bytes, hash) {
                        oracle[byte] |= bit;
                    }
                }
            }
            assert_eq!(filter.filter.as_bytes(), oracle);
            filter.insert_hashes(&inserted);
            assert_eq!(
                filter.filter.as_bytes(),
                oracle,
                "duplicates changed bitmap"
            );
            for &hash in &inserted {
                assert!(filter.contains_hash(hash), "false negative");
            }
            for len in (0..=131).chain([4096, 4097]) {
                for offset in 0..8 {
                    let input: Vec<_> = (0..offset + len)
                        .map(|i| {
                            if i % 3 == 0 {
                                inserted[i % inserted.len()]
                            } else {
                                hash64(100_000 + i as u64)
                            }
                        })
                        .collect();
                    let input = &input[offset..];
                    let mut output = vec![0xfeed; len + 2];
                    filter.lookup_hashes(input, &mut output[1..=len]);
                    assert_eq!(output[0], 0xfeed);
                    assert_eq!(output[len + 1], 0xfeed);
                    for (&hash, &answer) in input.iter().zip(&output[1..=len]) {
                        assert_eq!(answer, u32::from(oracle_contains(&oracle, hash)));
                    }
                }
            }
            assert_eq!(filter.filter.as_bytes(), oracle, "queries changed bitmap");
        }
    }

    #[test]
    fn actual_allocation_includes_padding_and_only_one_bitmap() {
        // Initialize CPU detection before observing allocator calls.
        let _ = sbbf_rs::FilterFn::new();
        for bytes in [32, 64, 96, 128, 160, 1024, 131_072] {
            let (filter, counts) = crate::tests::allocation::measure(|| {
                SbbfSafePinned::from_logical_bytes(bytes).unwrap()
            });
            assert_eq!(counts.allocations, 1, "hidden allocation for {bytes}");
            assert_eq!(counts.bytes, filter.size_in_bytes());
            assert_eq!(counts.max_alignment, 64);
            assert_eq!(filter.size_in_bytes(), bytes.div_ceil(64) * 64);
            assert_eq!(filter.filter.as_bytes().as_ptr() as usize % 64, 0);
            let (_, freed) = crate::tests::allocation::measure(|| drop(filter));
            assert_eq!(freed.deallocations, 1);
            assert_eq!(freed.freed_bytes, counts.bytes);
        }
    }

    #[test]
    fn exact_budget_and_padding_contract() {
        for (n, bpk) in [(64, 16), (65_536, 16), (65_536, 24), (65_536, 32)] {
            let filter = SbbfSafePinned::new(n, bpk).unwrap();
            assert_eq!(filter.size_in_bytes(), n * bpk as usize / 8);
        }
        assert!(SbbfSafePinned::new(usize::MAX, 32).is_err());
        assert!(SbbfSafePinned::new(1 << 27, 32).is_err());
        assert!(SbbfSafePinned::new(1, 0).is_err());
        assert!(SbbfSafePinned::new(0, 16).is_err());
    }
}
