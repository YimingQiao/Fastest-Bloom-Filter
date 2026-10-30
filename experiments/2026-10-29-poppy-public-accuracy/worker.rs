//! Full-load independent accuracy, with no timer or throughput output.
use poppy_filters::{v2::BloomFilter, OptLevel, Params};

const Q: usize = 1 << 22;
const CALIBRATION: usize = 1 << 26;
const SEED: u64 = 42;
const LEDGER: &str = include_str!("../2026-10-29-poppy-public-geometry/constructors.tsv");

// Exact common hash and workload RNG from the frozen Rust comparison.
#[inline]
pub fn hash64(mut x: u64) -> u64 {
    x ^= x >> 32;
    x = x.wrapping_mul(0xd6e8feb86659fd93);
    x ^= x >> 32;
    x = x.wrapping_mul(0xd6e8feb86659fd93);
    x ^ (x >> 32)
}
struct SplitMix64(u64);
impl SplitMix64 {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9e3779b97f4a7c15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
        z ^ (z >> 31)
    }
}
fn shuffle<T>(v: &mut [T], rng: &mut SplitMix64) {
    for i in (2..=v.len()).rev() {
        v.swap(i - 1, (rng.next() % i as u64) as usize);
    }
}
fn digest(values: &[u64]) -> u64 {
    values.iter().fold(14695981039346656037, |h, value| {
        (h ^ value).wrapping_mul(1099511628211)
    })
}
fn policy(value: &str) -> OptLevel {
    match value {
        "none" => OptLevel::None,
        "space" => OptLevel::Space,
        "speed" => OptLevel::Speed,
        "best" => OptLevel::Best,
        _ => panic!("unknown frozen policy"),
    }
}

fn run(id: &str, check: bool) {
    let table: Vec<_> = LEDGER.lines().skip(1).collect();
    assert_eq!(table.len(), 86);
    let found: Vec<_> = table
        .iter()
        .filter(|line| line.split('\t').next() == Some(id))
        .collect();
    assert_eq!(found.len(), 1, "requires one frozen constructor ID");
    let fields: Vec<_> = found[0].split('\t').collect();
    assert_eq!(fields.len(), 9);
    let real_n: usize = fields[1].parse().unwrap();
    assert!(matches!(real_n, 65536 | 33554432));
    let fpp_bits = u64::from_str_radix(fields[3], 16).unwrap();
    let expected_bytes: usize = fields[8].parse().unwrap();
    let n = if check { 1031 } else { real_n };
    let q = if check { 8193 } else { Q };
    let calibration = if check { 4096 } else { CALIBRATION };
    let mut rng = SplitMix64(SEED);
    // The formal mode exactly preserves the old benchmark's base, shuffle,
    // mixed-key construction and RNG advancement. Check mode changes only
    // the bounded inserted/query counts; its public constructor keeps real n.
    let key_base = rng.next() % ((1u64 << 32) - real_n as u64 - Q as u64);
    let mut inserted: Vec<_> = (key_base..key_base + n as u64).collect();
    shuffle(&mut inserted, &mut rng);
    let mut query: Vec<_> = (0..q as u64)
        .map(|i| {
            key_base
                + if i % 100 < 50 {
                    rng.next() % n as u64
                } else {
                    real_n as u64 + i
                }
        })
        .collect();
    shuffle(&mut query, &mut rng);
    let input_digest = digest(&inserted);
    let query_digest = digest(&query);
    let calibration_begin = key_base + real_n as u64 + Q as u64;
    assert!(key_base + n as u64 <= key_base + real_n as u64);
    assert!(key_base + real_n as u64 + q as u64 <= calibration_begin);
    let calibration_end = calibration_begin.checked_add(calibration as u64).unwrap();

    let mut filter = Params::new(real_n, f64::from_bits(fpp_bits))
        .opt(policy(fields[2]))
        .try_into_v2()
        .unwrap();
    assert_eq!(filter.capacity(), real_n);
    assert_eq!(filter.size_in_bytes(), expected_bytes);
    assert_eq!(filter.fpp().to_bits(), fpp_bits);
    let mut insertion_new = 0;
    for &key in &inserted {
        insertion_new += usize::from(
            filter
                .insert_bytes(hash64(key).to_le_bytes())
                .expect("public insertion below real capacity must succeed"),
        );
    }
    assert_eq!(filter.count_estimate() as usize, insertion_new);
    assert!(insertion_new <= n);
    for &key in &inserted {
        assert!(
            filter.contains_bytes(hash64(key).to_le_bytes()),
            "false negative on inserted key"
        );
    }
    let (mut present, mut absent, mut mixed_fp) = (0usize, 0usize, 0usize);
    let mut result_checksum = 14695981039346656037u64;
    for &key in &query {
        let bytes = hash64(key).to_le_bytes();
        let answer = filter.contains_bytes(bytes);
        if check {
            assert_eq!(
                answer,
                filter
                    .contains_iter(BloomFilter::build_index_iter(&bytes.as_slice()))
                    .unwrap()
            );
        }
        result_checksum = (result_checksum ^ u64::from(answer)).wrapping_mul(1099511628211);
        if key >= key_base && key < key_base + n as u64 {
            present += 1;
            assert!(answer, "mixed positive false negative");
        } else {
            absent += 1;
            mixed_fp += usize::from(answer);
        }
    }
    assert_eq!(present, q / 100 * 50 + (q % 100).min(50));
    assert_eq!(present + absent, q);
    let mut calibration_fp = 0usize;
    for raw in calibration_begin..calibration_end {
        let bytes = hash64(raw).to_le_bytes();
        let answer = filter.contains_bytes(bytes);
        if check {
            assert_eq!(
                answer,
                filter
                    .contains_iter(BloomFilter::build_index_iter(&bytes.as_slice()))
                    .unwrap()
            );
        }
        calibration_fp += usize::from(answer);
    }
    assert_eq!(digest(&inserted), input_digest);
    assert_eq!(digest(&query), query_digest);
    assert_eq!(filter.size_in_bytes(), expected_bytes);
    let stage = if check { "check" } else { "accuracy" };
    println!("{{\"stage\":\"{stage}\",\"id\":\"{id}\",\"real_n\":{real_n},\"inserted_n\":{n},\"queries\":{q},\"policy\":\"{}\",\"fpp_bits\":\"{fpp_bits:016x}\",\"actual_bytes\":{expected_bytes},\"seed\":{SEED},\"key_base\":{key_base},\"inserted_checksum\":{input_digest},\"query_checksum\":{query_digest},\"insertions_returned_new\":{insertion_new},\"false_negatives\":0,\"present_queries\":{present},\"absent_queries\":{absent},\"mixed_false_positives\":{mixed_fp},\"result_checksum\":{result_checksum},\"calibration_begin\":{calibration_begin},\"calibration_end\":{calibration_end},\"calibration_queries\":{calibration},\"calibration_false_positives\":{calibration_fp},\"check_public_iterator_parity\":{check},\"timings\":false}}", fields[2]);
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    assert_eq!(args.len(), 3, "--check|--accuracy one-frozen-ID");
    let check = match args[1].as_str() {
        "--check" => true,
        "--accuracy" => false,
        _ => panic!("unknown fixed stage"),
    };
    run(&args[2], check);
}
