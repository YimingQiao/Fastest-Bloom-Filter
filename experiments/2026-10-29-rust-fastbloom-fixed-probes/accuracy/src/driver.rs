// Untimed correctness/calibration entry. No clock, repetitions or timing entry
// is reached. The original public adapter implementations are copied exactly.
#[derive(Debug, PartialEq, Eq)]
struct AccuracyRow {
    bytes: usize,
    inserted_checked: usize,
    present: usize,
    absent: usize,
    false_positives: usize,
    checksum: u64,
    calibration_queries: usize,
    calibration_false_positives: usize,
}

fn accuracy_batch<F: Filter>(bf: &F, hashes: &[u64], storage: &mut [u32]) {
    assert!(storage.len() >= hashes.len() + 2);
    storage.fill(0xfeed);
    bf.lookup_hashes(hashes, &mut storage[1..hashes.len() + 1]);
    assert_eq!(storage[0], 0xfeed, "accuracy prefix guard changed");
    assert!(storage[hashes.len() + 1..].iter().all(|&v| v == 0xfeed), "accuracy suffix guard changed");
    for (&hash, &answer) in hashes.iter().zip(&storage[1..hashes.len() + 1]) {
        assert!(answer <= 1, "non-boolean accuracy answer");
        assert_eq!(answer, bf.contains_hash(hash) as u32, "public dense/singleton mismatch");
    }
}

fn accuracy_measure<F: Filter>(name: &str, inserted: &[u64], raw_query: &[u64], c: &Config) -> AccuracyRow {
    assert_eq!(inserted.len(), c.n);
    assert_eq!(raw_query.len(), c.q);
    assert_eq!(c.insert_batch, c.n);
    let g = geometry::plan(name, c.n, c.bpk).expect("unsupported accuracy geometry");
    // Exactly one constructor and one full-input insertion call per API/geometry.
    // The object is destroyed when this function returns, before the next API.
    let mut bf = F::new(c.n, c.bpk).expect("accuracy constructor failed");
    assert_eq!(bf.size_in_bytes(), g.allocated_bytes, "unaccounted backing bytes");
    bf.insert_hashes(inserted);
    let mut scratch = vec![0u64; c.batch];
    let mut output = vec![0u32; c.batch + 2];
    let mut inserted_checked = 0;
    for chunk in inserted.chunks(c.batch) {
        accuracy_batch(&bf, chunk, &mut output);
        assert!(output[1..chunk.len() + 1].iter().all(|&v| v == 1), "inserted key false negative");
        inserted_checked += chunk.len();
    }
    let mut row = AccuracyRow {
        bytes: bf.size_in_bytes(), inserted_checked, present: 0, absent: 0,
        false_positives: 0, checksum: 14695981039346656037,
        calibration_queries: 1usize << c.calibration_power,
        calibration_false_positives: 0,
    };
    for raw in raw_query.chunks(c.batch) {
        for (hash, &key) in scratch.iter_mut().zip(raw) { *hash = hash64(key); }
        accuracy_batch(&bf, &scratch[..raw.len()], &mut output);
        for (&key, &answer) in raw.iter().zip(&output[1..raw.len() + 1]) {
            row.checksum = (row.checksum ^ answer as u64).wrapping_mul(1099511628211);
            if key >= c.key_base && key < c.key_base + c.n as u64 {
                row.present += 1;
                assert_eq!(answer, 1, "present mixed query false negative");
            } else {
                row.absent += 1;
                row.false_positives += answer as usize;
            }
        }
    }
    // The same disjoint interval as the frozen q2^22 workload. No sample pool.
    for i in (0..row.calibration_queries).step_by(c.batch) {
        let len = c.batch.min(row.calibration_queries - i);
        for (j, hash) in scratch[..len].iter_mut().enumerate() {
            *hash = hash64(c.key_base + c.n as u64 + c.q as u64 + (i + j) as u64);
        }
        accuracy_batch(&bf, &scratch[..len], &mut output);
        row.calibration_false_positives += output[1..len + 1].iter().map(|&v| v as usize).sum::<usize>();
    }
    assert_eq!(row.inserted_checked, c.n);
    assert_eq!(row.present + row.absent, c.q);
    row
}

fn accuracy_emit<F: Filter>(name: &str, inserted: &[u64], raw_query: &[u64], c: &Config) {
    let row = accuracy_measure::<F>(name, inserted, raw_query, c);
    let g = geometry::plan(name, c.n, c.bpk).unwrap();
    println!("rust,{name},{},{},{},{},{},64,50,{},{},{},{},{},{},{},prehashed,{},{},{},1,{}",
        c.n, c.q, c.bpk, row.bytes, 8.0 * row.bytes as f64 / c.n as f64,
        row.present, c.batch, c.seed, row.absent, row.false_positives, row.checksum,
        c.key_base, row.calibration_queries, row.calibration_false_positives,
        row.inserted_checked, g.csv());
}

fn accuracy_workload(c: &mut Config, jobs: &mut [&str]) -> (Vec<u64>, Vec<u64>) {
    let mut rng = SplitMix64(c.seed);
    c.key_base = rng.next() % ((1u64 << 32) - c.n as u64 - c.q as u64);
    let mut inserted: Vec<_> = (c.key_base..c.key_base + c.n as u64).collect();
    shuffle(&mut inserted, &mut rng);
    let mut query: Vec<_> = (0..c.q as u64)
        .map(|i| {
            c.key_base
                + if i % 100 < c.hit { rng.next() % c.n as u64 } else { c.n as u64 + i }
        })
        .collect();
    shuffle(&mut query, &mut rng);
    shuffle(jobs, &mut rng);
    // In-place conversion reduces auxiliary storage without changing the raw
    // key sequence, insertion order, common hash or any filter input.
    for key in &mut inserted { *key = hash64(*key); }
    (inserted, query)
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    assert_eq!(args.len(), 7, "accuracy POWER BPK QUERY_POWER SEED CALIBRATION_POWER FILTERS");
    let number = |i: usize| -> u64 {
        let s = &args[i];
        assert!(!s.is_empty() && s.bytes().all(|c| c.is_ascii_digit()), "unsigned integers required");
        s.parse().expect("integer overflow")
    };
    let (power, bpk, qp, seed, cp) = (number(1), number(2), number(3), number(4), number(5));
    assert!((5..=26).contains(&power) && [16, 24, 32].contains(&bpk) &&
            (12..=27).contains(&qp) && (12..=27).contains(&cp), "invalid accuracy workload");
    let mut jobs = filter_selection::select_filters(&args[6], FILTER_NAMES).unwrap_or_else(|error| {
        eprintln!("{error}"); std::process::exit(2);
    });
    let mut c = Config { n: 1usize << power, q: 1usize << qp, bpk: bpk as u32,
        hit: 50, batch: 4096, insert_batch: 1usize << power, calibration_power: cp as u32,
        repeats: 0, seed, key_base: 0 };
    for name in &jobs { geometry::plan(name, c.n, c.bpk).expect("unsupported accuracy geometry"); }
    let (inserted, query) = accuracy_workload(&mut c, &mut jobs);
    eprintln!("Untimed accuracy only; one bitmap build per API; sbbf-rs0.2.8 backend:{}", sbbf_rs::FilterFn::new().which());
    println!("language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,hash_bits,hit_percent,present_queries,batch,seed,absent_queries,false_positives,result_checksum,key_base,input_mode,calibration_absent_queries,calibration_false_positives,inserted_checked,bitmap_builds,budget_bytes,logical_bytes,geometry_kind,unit_bytes,unit_count,effective_probes,probe_policy,constructor_argument,implementation_origin,size_contract");
    for name in jobs {
        match name {
            "FastPatternBF" => accuracy_emit::<BloomFilter<true>>(name, &inserted, &query, &c),
            "ByteSplitBloomFilter" => accuracy_emit::<ByteSplitBloomFilter>(name, &inserted, &query, &c),
            "FourSectorBloomFilter" => accuracy_emit::<FourSectorBloomFilter>(name, &inserted, &query, &c),
            "Split64BloomFilter" => accuracy_emit::<Split64BloomFilter>(name, &inserted, &query, &c),
            "Split64RangeBloomFilter" => accuracy_emit::<Split64RangeBloomFilter>(name, &inserted, &query, &c),
            "Fastbloom017" => accuracy_emit::<Fastbloom017>(name, &inserted, &query, &c),
            "Fastbloom017K1" => accuracy_emit::<Fastbloom017K1>(name, &inserted, &query, &c),
            "Fastbloom017K2" => accuracy_emit::<Fastbloom017K2>(name, &inserted, &query, &c),
            "Fastbloom017K3" => accuracy_emit::<Fastbloom017K3>(name, &inserted, &query, &c),
            "Fastbloom017K4" => accuracy_emit::<Fastbloom017K4>(name, &inserted, &query, &c),
            "Fastbloom017K5" => accuracy_emit::<Fastbloom017K5>(name, &inserted, &query, &c),
            "Fastbloom017K6" => accuracy_emit::<Fastbloom017K6>(name, &inserted, &query, &c),
            "Fastbloom017K7" => accuracy_emit::<Fastbloom017K7>(name, &inserted, &query, &c),
            "Fastbloom017K8" => accuracy_emit::<Fastbloom017K8>(name, &inserted, &query, &c),
            "Fastbloom017K9" => accuracy_emit::<Fastbloom017K9>(name, &inserted, &query, &c),
            "Fastbloom017K10" => accuracy_emit::<Fastbloom017K10>(name, &inserted, &query, &c),
            "Fastbloom017K11" => accuracy_emit::<Fastbloom017K11>(name, &inserted, &query, &c),
            "Fastbloom017K12" => accuracy_emit::<Fastbloom017K12>(name, &inserted, &query, &c),
            "BloomsdayPinned" => accuracy_emit::<BloomsdayPinned>(name, &inserted, &query, &c),
            "SbbfSafePinned" => accuracy_emit::<SbbfSafePinned>(name, &inserted, &query, &c),
            _ => unreachable!(),
        }
    }
}

#[cfg(test)]
mod accuracy_tests {
    use super::*;
    use std::cell::Cell;
    thread_local! {
        static CREATES: Cell<usize> = const { Cell::new(0) };
        static DROPS: Cell<usize> = const { Cell::new(0) };
        static FAULT_CALL: Cell<Option<usize>> = const { Cell::new(None) };
    }
    struct Fixture { hashes: std::collections::HashSet<u64>, calls: Cell<usize> }
    impl Drop for Fixture { fn drop(&mut self) { DROPS.with(|n| n.set(n.get() + 1)); } }
    impl Filter for Fixture {
        fn new(_: usize, _: u32) -> Result<Self, Box<dyn std::error::Error>> {
            CREATES.with(|n| n.set(n.get() + 1));
            Ok(Self { hashes: Default::default(), calls: Cell::new(0) })
        }
        fn size_in_bytes(&self) -> usize { 128 }
        fn contains_hash(&self, hash: u64) -> bool { self.hashes.contains(&hash) }
        fn insert_hashes(&mut self, hashes: &[u64]) { self.hashes.extend(hashes.iter().copied()); }
        fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
            assert_eq!(hashes.len(), out.len());
            for (&h, v) in hashes.iter().zip(out.iter_mut()) { *v = self.contains_hash(h) as u32; }
            let call = self.calls.get(); self.calls.set(call + 1);
            if FAULT_CALL.with(|f| f.get()) == Some(call) { *out.last_mut().unwrap() ^= 1; }
        }
    }
    fn fixture() -> (Config, Vec<u64>, Vec<u64>) {
        let mut c = Config { n: 64, q: 4096, bpk: 16, hit: 50, batch: 4096,
            insert_batch: 64, calibration_power: 12, repeats: 0, seed: 42, key_base: 0 };
        let (inserted, query) = accuracy_workload(&mut c, &mut ["Fastbloom017"]);
        (c, inserted, query)
    }
    #[test]
    fn exactly_one_bitmap_is_constructed_validated_and_destroyed() {
        let (c, inserted, query) = fixture();
        CREATES.with(|n| n.set(0)); DROPS.with(|n| n.set(0)); FAULT_CALL.with(|f| f.set(None));
        let row = accuracy_measure::<Fixture>("Fastbloom017", &inserted, &query, &c);
        assert_eq!(CREATES.with(Cell::get), 1); assert_eq!(DROPS.with(Cell::get), 1);
        assert_eq!(row.inserted_checked, 64); assert_eq!(row.false_positives, 0);
        assert_eq!(row.calibration_false_positives, 0);
    }
    #[test]
    fn inserted_mixed_and_calibration_last_answers_are_all_validated() {
        let (c, inserted, query) = fixture();
        for call in 0..3 {
            FAULT_CALL.with(|f| f.set(Some(call)));
            assert!(std::panic::catch_unwind(|| accuracy_measure::<Fixture>("Fastbloom017", &inserted, &query, &c)).is_err());
            FAULT_CALL.with(|f| f.set(None));
        }
    }
    #[test]
    fn accuracy_default_and_fixed11_match_at_all_fixture_counts() {
        let (c, inserted, query) = fixture();
        let a = accuracy_measure::<Fastbloom017>("Fastbloom017", &inserted, &query, &c);
        let b = accuracy_measure::<Fastbloom017K11>("Fastbloom017K11", &inserted, &query, &c);
        assert_eq!(a, b);
    }
    fn formal<const K: u32>() {
        // Empty constructor audit only: no formal inserted/calibration stream
        // is generated by this preflight test.
        drop(<FastbloomFixed<K> as Filter>::new(64, 16).unwrap());
        for n in [1usize << 16, 1usize << 25] {
            for cap in [16, 24, 32] {
                let (bf, counted) = tests::allocation::measure(|| <FastbloomFixed<K> as Filter>::new(n, cap).unwrap());
                assert_eq!(bf.0.num_bits(), n * cap as usize);
                assert_eq!(bf.0.num_hashes(), K);
                assert_eq!(counted.allocations, 1); assert_eq!(counted.deallocations, 0);
                assert_eq!(counted.bytes, bf.size_in_bytes());
                assert_eq!(counted.bytes, n * cap as usize / 8);
                let (_, freed) = tests::allocation::measure(|| drop(bf));
                assert_eq!(freed.deallocations, 1); assert_eq!(freed.freed_bytes, counted.bytes);
                println!("FORMAL_ALLOCATION,{},{},{},{},{},{},{}",
                    fixed_fastbloom_name(K), n, cap, n * cap as usize, K, counted.allocations, counted.bytes);
            }
        }
    }
    #[test]
    fn every_formal_fixed_k_constructor_reports_observed_bits_hashes_and_backing() {
        formal::<1>(); formal::<2>(); formal::<3>(); formal::<4>();
        formal::<5>(); formal::<6>(); formal::<7>(); formal::<8>();
        formal::<9>(); formal::<10>(); formal::<11>(); formal::<12>();
    }
}
