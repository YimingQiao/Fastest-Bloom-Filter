// Public constructor controls only; the query/build adapter bodies below match
// the retained Fastbloom017 wrapper. No upstream private kernel is accessed.
struct FastbloomFixed<const K: u32>(fastbloom::BloomFilter);
type Fastbloom017K1 = FastbloomFixed<1>;
type Fastbloom017K2 = FastbloomFixed<2>;
type Fastbloom017K3 = FastbloomFixed<3>;
type Fastbloom017K4 = FastbloomFixed<4>;
type Fastbloom017K5 = FastbloomFixed<5>;
type Fastbloom017K6 = FastbloomFixed<6>;
type Fastbloom017K7 = FastbloomFixed<7>;
type Fastbloom017K8 = FastbloomFixed<8>;
type Fastbloom017K9 = FastbloomFixed<9>;
type Fastbloom017K10 = FastbloomFixed<10>;
type Fastbloom017K11 = FastbloomFixed<11>;
type Fastbloom017K12 = FastbloomFixed<12>;

fn fixed_fastbloom_name(k: u32) -> &'static str {
    match k {
        1 => "Fastbloom017K1",
        2 => "Fastbloom017K2",
        3 => "Fastbloom017K3",
        4 => "Fastbloom017K4",
        5 => "Fastbloom017K5",
        6 => "Fastbloom017K6",
        7 => "Fastbloom017K7",
        8 => "Fastbloom017K8",
        9 => "Fastbloom017K9",
        10 => "Fastbloom017K10",
        11 => "Fastbloom017K11",
        12 => "Fastbloom017K12",
        _ => panic!("only the twelve prespecified public probe counts are supported"),
    }
}

impl<const K: u32> Filter for FastbloomFixed<K> {
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        self.0.contains_hash(hash)
    }
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let g = geometry::plan(fixed_fastbloom_name(K), n, bpk)?;
        let filter = fastbloom::BloomFilter::with_num_bits(g.logical_bytes * 8).hashes(K);
        assert_eq!(filter.num_bits() / 8, g.allocated_bytes);
        assert_eq!(filter.num_hashes() as i32, g.effective_probes);
        Ok(Self(filter))
    }
    fn size_in_bytes(&self) -> usize {
        self.0.num_bits() / 8
    }
    fn insert_hashes(&mut self, h: &[u64]) {
        for &hash in h {
            self.0.insert_hash(hash);
        }
    }
    fn lookup_hashes(&self, h: &[u64], out: &mut [u32]) {
        assert_eq!(h.len(), out.len());
        for (&hash, v) in h.iter().zip(out.iter_mut()) {
            *v = self.0.contains_hash(hash) as u32;
        }
    }
}

#[cfg(test)]
mod fixed_probe_tests {
    use super::*;

    fn check<const K: u32>() {
        for n in [64, 65, 1024, 65_536] {
            for cap in [16, 24, 32] {
                let g = geometry::plan(fixed_fastbloom_name(K), n, cap).unwrap();
                let mut actual = <FastbloomFixed<K> as Filter>::new(n, cap).unwrap();
                let mut reference = fastbloom::BloomFilter::with_num_bits(g.logical_bytes * 8).hashes(K);
                assert_eq!(actual.0.num_hashes(), K);
                assert_eq!(actual.size_in_bytes(), g.allocated_bytes);
                assert!(actual.size_in_bytes() <= n * cap as usize / 8);
                let inserted: Vec<_> = (0..n.min(4096) as u64).map(hash64).collect();
                for batch in inserted.chunks(31) {
                    actual.insert_hashes(batch);
                    for &hash in batch { reference.insert_hash(hash); }
                }
                // Repeated keys and deliberately colliding public inputs remain
                // ordinary append-only writes with exact bitmap preservation.
                actual.insert_hashes(&[0, 0, u64::MAX, 0]);
                for hash in [0, 0, u64::MAX, 0] { reference.insert_hash(hash); }
                assert_eq!(actual.0.as_slice(), reference.as_slice());
                assert!(inserted.iter().all(|&hash| actual.contains_hash(hash)));
                let queries: Vec<_> = inserted.iter().copied().chain((0..8192).map(|i| hash64(1_000_000 + i))).collect();
                let before = actual.0.as_slice().to_vec();
                for offset in 0..4 {
                    for len in [0, 1, 2, 3, 4, 7, 8, 15, 16, 31, 63, 64, 127, 128, 129, 4096, 4097] {
                        let input = &queries[offset..offset + len];
                        let mut output = vec![0xfeed_u32; len + 2];
                        actual.lookup_hashes(input, &mut output[1..len + 1]);
                        assert_eq!(output[0], 0xfeed);
                        assert_eq!(output[len + 1], 0xfeed);
                        for (&hash, &answer) in input.iter().zip(&output[1..len + 1]) {
                            assert_eq!(answer, reference.contains_hash(hash) as u32);
                            assert_eq!(answer, actual.contains_hash(hash) as u32);
                        }
                    }
                }
                assert_eq!(actual.0.as_slice(), before);
                assert!(std::panic::catch_unwind(|| {
                    actual.lookup_hashes(&queries[..4], &mut [0u32; 3]);
                }).is_err());
            }
        }
        // Warm public default-hasher setup before measuring the actual retained
        // allocation; count both constructor temporaries and final deallocation.
        drop(<FastbloomFixed<K> as Filter>::new(1024, 16).unwrap());
        for n in [64, 1024, 65_536] {
            for cap in [16, 24, 32] {
                let (filter, counts) = tests::allocation::measure(|| <FastbloomFixed<K> as Filter>::new(n, cap).unwrap());
                assert_eq!(counts.allocations, 1);
                assert_eq!(counts.deallocations, 0);
                assert_eq!(counts.bytes, filter.size_in_bytes());
                let (_, freed) = tests::allocation::measure(|| drop(filter));
                assert_eq!(freed.deallocations, 1);
                assert_eq!(freed.freed_bytes, counts.bytes);
            }
        }
    }

    #[test]
    fn public_fixed_probe_adapters_preserve_bitmap_outputs_and_allocation() {
        check::<1>();
        check::<2>();
        check::<3>();
        check::<4>();
        check::<5>();
        check::<6>();
        check::<7>();
        check::<8>();
        check::<9>();
        check::<10>();
        check::<11>();
        check::<12>();
    }

    #[test]
    fn default_at16_and_fixed11_are_exact_quality_aliases() {
        for n in [64, 1024, 65_536] {
            let mut original = <Fastbloom017 as Filter>::new(n, 16).unwrap();
            let mut fixed = <Fastbloom017K11 as Filter>::new(n, 16).unwrap();
            assert_eq!(original.0.num_hashes(), 11);
            let inserted: Vec<_> = (0..n.min(8192) as u64).map(hash64).collect();
            original.insert_hashes(&inserted);
            fixed.insert_hashes(&inserted);
            assert_eq!(original.0.as_slice(), fixed.0.as_slice());
            let queries: Vec<_> = (0..16_384).map(hash64).collect();
            let mut a = vec![0; queries.len()];
            let mut b = a.clone();
            original.lookup_hashes(&queries, &mut a);
            fixed.lookup_hashes(&queries, &mut b);
            assert_eq!(a, b);
        }
    }
}
