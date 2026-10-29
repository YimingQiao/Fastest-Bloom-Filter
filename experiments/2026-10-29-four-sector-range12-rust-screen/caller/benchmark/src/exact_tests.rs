use super::*;

#[test]
fn geometry_rounding_and_capacity_limits() {
    for n in [64, 65_536, 1 << 25] {
        for cap in [16, 24, 32] {
            for name in FILTER_NAMES {
                let plan = geometry::plan(name, n, cap).unwrap();
                assert!(plan.allocated_bytes <= n * cap as usize / 8);
                assert!(plan.logical_bytes <= plan.allocated_bytes);
                assert!(plan.logical_bytes.is_multiple_of(plan.unit_bytes));
                if plan.kind == "native_pow2_lines" {
                    assert_eq!(plan.allocated_bytes, n * if cap == 32 { 4 } else { 2 });
                } else {
                    assert_eq!(plan.allocated_bytes, n * cap as usize / 8);
                }
            }
        }
    }
    for (n, cap) in [(0, 16), (1, 0), (1, 16), (usize::MAX, 32), (1 << 27, 32)] {
        for name in FILTER_NAMES {
            assert!(geometry::plan(name, n, cap).is_err());
        }
    }
    assert!(geometry::plan("unknown", 1024, 24).is_err());
    assert!(geometry::bloomsday_fpr(65, 24).is_err());
    for cap in [16, 24, 32] {
        let g = geometry::plan("Fastbloom017", 1024, cap).unwrap();
        assert_eq!(g.effective_probes, match cap { 16 => 11, 24 => 17, _ => 22 });
    }
}

fn allocation_contract<F: Filter>(name: &str) {
    // Resolve backend/default-hasher one-time setup before per-filter accounting.
    drop(F::new(1024, 16).unwrap());
    for n in [64, 1024, 65_536] {
        for cap in [16, 24, 32] {
            let g = geometry::plan(name, n, cap).unwrap();
            let (bf, allocated) = tests::allocation::measure(|| F::new(n, cap).unwrap());
            assert_eq!(allocated.allocations, 1, "{name}: hidden constructor allocation");
            assert_eq!(allocated.deallocations, 0, "{name}: hidden temporary allocation");
            assert_eq!(allocated.bytes, g.allocated_bytes, "{name}: backing byte mismatch");
            assert_eq!(bf.size_in_bytes(), allocated.bytes);
            let (_, freed) = tests::allocation::measure(|| drop(bf));
            assert_eq!(freed.deallocations, 1);
            assert_eq!(freed.freed_bytes, allocated.bytes);
        }
    }
}

#[test]
fn every_constructor_charges_observed_retained_heap() {
    allocation_contract::<BloomFilter<true>>("FastPatternBF");
    allocation_contract::<ByteSplitBloomFilter>("ByteSplitBloomFilter");
    allocation_contract::<FourSectorBloomFilter>("FourSectorBloomFilter");
    allocation_contract::<Split64BloomFilter>("Split64BloomFilter");
    allocation_contract::<Split64RangeBloomFilter>("Split64RangeBloomFilter");
    allocation_contract::<Fastbloom017>("Fastbloom017");
    allocation_contract::<BloomsdayPinned>("BloomsdayPinned");
    allocation_contract::<SbbfSafePinned>("SbbfSafePinned");
}

#[test]
fn public_external_twenty_four_bpk_matches_independent_split32_oracle() {
    const SALTS: [u32; 8] = [0x47b6137b, 0x44974d91, 0x8824ad5b, 0xa2b7289d,
        0x705495c7, 0x2df1424b, 0x9efc4947, 0x5c6bfb31];
    for n in [64, 1024, 65_536] {
        let bytes = n * 3;
        let mut oracle = vec![0u32; bytes / 4];
        let mut bloom = <BloomsdayPinned as Filter>::new(n, 24).unwrap();
        let mut sbbf = <SbbfSafePinned as Filter>::new(n, 24).unwrap();
        let inserted: Vec<_> = (0..n.min(4096) as u64).map(hash64).collect();
        let locations = |hash: u64| {
            let block = (((hash >> 32) as u128 * (bytes / 32) as u128) >> 32) as usize;
            std::array::from_fn::<_, 8, _>(|lane| {
                let bit = (((hash as u32 as u64 * SALTS[lane] as u64) & 0xffff_ffff) >> 27) as u32;
                (block * 8 + lane, 1u32 << bit)
            })
        };
        for &hash in &inserted {
            for (word, bit) in locations(hash) { oracle[word] |= bit; }
        }
        bloom.insert_hashes(&inserted);
        sbbf.insert_hashes(&inserted);
        for hash in inserted.iter().copied().chain((0..16_384).map(|x| hash64(1_000_000 + x))) {
            let expected = locations(hash).iter().all(|&(word, bit)| oracle[word] & bit != 0);
            assert_eq!(bloom.contains_hash(hash), expected);
            assert_eq!(sbbf.contains_hash(hash), expected);
        }
    }
}

#[test]
fn native_inverse_keeps_real_density_and_prior_equal_capacity_answers() {
    for n in [64, 65_536] {
        for cap in [16, 32] {
            let mut exact = <BloomFilter<true> as Filter>::new(n, cap).unwrap();
            let mut prior = BloomFilter::<true>::new(n, cap / 2).unwrap();
            let inserted: Vec<_> = (0..n.min(4096) as u64).map(hash64).collect();
            exact.insert_hashes(&inserted);
            prior.insert_hashes(&inserted);
            let queries: Vec<_> = (0..16_384).map(hash64).collect();
            let mut actual = vec![0; queries.len()];
            let mut expected = actual.clone();
            exact.lookup_hashes(&queries, &mut actual);
            prior.lookup_hashes(&queries, &mut expected);
            assert_eq!(actual, expected);
            assert_eq!(exact.size_in_bytes(), prior.size_in_bytes());
        }
    }
}
