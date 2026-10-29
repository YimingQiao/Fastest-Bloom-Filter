use fastest_bloom_filter::{hash64, Split64BloomFilter, Split64RangeBloomFilter};
use std::{collections::BTreeSet, hint::black_box, time::Instant};
const METRICS: [&str; 6] = ["serial_insert", "parallel_insert", "serial_allocate_insert", "parallel_allocate_insert", "serial_lookup", "parallel_lookup"];
const SCHEDULE: [[usize; 4]; 4] = [[0, 1, 3, 2], [1, 2, 0, 3], [2, 3, 1, 0], [3, 0, 2, 1]];
extern "C" {
    fn sched_setaffinity(pid: i32, bytes: usize, mask: *const usize) -> i32;
    fn sched_getaffinity(pid: i32, bytes: usize, mask: *mut usize) -> i32;
}
fn affinity(cpus: &[usize]) {
    assert_eq!(std::mem::size_of::<usize>(), 8);
    let mut mask = [0usize; 16];
    for &cpu in cpus { assert!(cpu < 1024); mask[cpu / 64] |= 1usize << (cpu % 64); }
    // Linux CPU affinity only; every Bloom operation remains a native Rust public call.
    assert_eq!(unsafe { sched_setaffinity(0, std::mem::size_of_val(&mask), mask.as_ptr()) }, 0, "set affinity failed");
}
fn parse_cpus(text: &str, workers: usize) -> Vec<usize> {
    let mut allowed = [0usize; 16];
    assert_eq!(unsafe { sched_getaffinity(0, std::mem::size_of_val(&allowed), allowed.as_mut_ptr()) }, 0);
    let cpus: Vec<usize> = text.split(',').map(|s| { assert!(!s.is_empty() && s.bytes().all(|c| c.is_ascii_digit())); s.parse().unwrap() }).collect();
    assert_eq!(cpus.len(), workers); assert_eq!(cpus[0], 3);
    let mut physical = BTreeSet::new(); let mut location = None;
    for &cpu in &cpus {
        assert!(cpu < 1024 && (allowed[cpu / 64] >> (cpu % 64)) & 1 != 0);
        let root = std::path::PathBuf::from(format!("/sys/devices/system/cpu/cpu{cpu}"));
        let number = |name: &str| std::fs::read_to_string(root.join("topology").join(name)).unwrap().trim().parse::<usize>().unwrap();
        let socket = number("physical_package_id"); let core = number("core_id");
        let nodes: Vec<usize> = std::fs::read_dir(&root).unwrap().filter_map(|entry| {
            let name = entry.unwrap().file_name().to_string_lossy().into_owned();
            name.strip_prefix("node").and_then(|n| n.parse().ok())
        }).collect();
        assert_eq!(nodes.len(), 1); assert!(physical.insert((socket, core)));
        assert!(location.is_none() || location == Some((socket, nodes[0]))); location = Some((socket, nodes[0]));
    }
    cpus
}
struct Rng(u64);
impl Rng { fn next(&mut self) -> u64 { self.0 = self.0.wrapping_add(0x9e3779b97f4a7c15); let mut z = self.0; z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9); z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb); z ^ (z >> 31) } }
fn shuffle<T>(v: &mut [T], rng: &mut Rng) { for i in (2..=v.len()).rev() { v.swap(i - 1, (rng.next() % i as u64) as usize); } }
struct Config { n: usize, q: usize, threads: usize, repeats: usize, calibration: usize, cap: u32, seed: u64, base: u64, hit: usize, cpus: Vec<usize> }
struct Data { inserted: Vec<u64>, query: Vec<u64>, truth: Vec<bool> }
fn workload(c: &mut Config, rng: &mut Rng) -> Data {
    c.base = rng.next() % ((1u64 << 32) - c.n as u64 - c.q as u64);
    let mut inserted: Vec<_> = (0..c.n).map(|i| hash64(c.base + i as u64)).collect(); shuffle(&mut inserted, rng);
    let mut truth = Vec::with_capacity(c.q); let mut query = Vec::with_capacity(c.q);
    for i in 0..c.q { let present = i % 100 < c.hit; truth.push(present); query.push(hash64(c.base + if present { rng.next() % c.n as u64 } else { (c.n + i) as u64 })); }
    for i in (2..=c.q).rev() { let j = (rng.next() % i as u64) as usize; query.swap(i - 1, j); truth.swap(i - 1, j); }
    Data { inserted, query, truth }
}
fn query_workers(n: usize, t: usize) -> usize { if n < 1 << 14 { 1 } else { t.min(n / 4096).clamp(1, 1024) } }
trait Filter: Sized {
    fn new(c: &Config) -> Self;
    fn bytes(&self) -> usize;
    fn stats(&self, n: usize, t: usize) -> (usize, usize);
    fn insert(&mut self, hashes: &[u64], parallel: bool, t: usize);
    fn lookup(&self, hashes: &[u64], out: &mut [u32], parallel: bool, t: usize);
}
macro_rules! filter_impl {
    ($type:ty, $constructor:expr) => {
        impl Filter for $type {
            fn new(c: &Config) -> Self { ($constructor)(c) }
            fn bytes(&self) -> usize { self.size_in_bytes() }
            fn stats(&self, n: usize, t: usize) -> (usize, usize) { (self.build_workers(n, t), self.build_scratch_bytes(n, t)) }
            fn insert(&mut self, h: &[u64], parallel: bool, t: usize) { if parallel { self.insert_hashes_parallel(h, t) } else { self.insert_hashes(h) } }
            fn lookup(&self, h: &[u64], out: &mut [u32], parallel: bool, t: usize) { if parallel { self.lookup_hashes_parallel(h, out, t) } else { self.lookup_hashes(h, out) } }
        }
    }
}
filter_impl!(Split64BloomFilter, |c: &Config| { assert!(c.cap == 16 || c.cap == 32); Split64BloomFilter::new(c.n, c.cap / 2).unwrap() });
filter_impl!(Split64RangeBloomFilter, |c: &Config| Split64RangeBloomFilter::with_byte_budget(c.n * c.cap as usize / 8).unwrap());
fn guards(out: &[u32], n: usize) { assert!(out[..16].iter().chain(out[n + 16..].iter()).all(|&v| v == 0xfeed)); }
fn validate_built<F: Filter>(bf: &F, d: &Data, expected: &[u32], out: &mut [u32]) {
    let mut check = [0u32; 4096];
    for chunk in d.inserted.chunks(check.len()) { check.fill(0xfeed); bf.lookup(chunk, &mut check[..chunk.len()], false, 1); assert!(check[..chunk.len()].iter().all(|&v| v == 1), "inserted false negative"); }
    out.fill(0xfeed); bf.lookup(&d.query, &mut out[16..16 + d.query.len()], false, 1); guards(out, d.query.len()); assert_eq!(expected, &out[16..16 + d.query.len()], "full built bitmap answers differ");
}
fn median(values: &[f64]) -> f64 { let mut v = values.to_vec(); v.sort_by(f64::total_cmp); if v.len() % 2 == 1 { v[v.len() / 2] } else { (v[v.len() / 2 - 1] + v[v.len() / 2]) / 2.0 } }
fn run<F: Filter>(name: &str, d: &Data, c: &Config) {
    let serial = [c.cpus[0]]; let mut expected = vec![0; c.q]; let mut out = vec![0xfeed; c.q + 32];
    let (bytes, bw, scratch);
    { affinity(&serial); let mut oracle = F::new(c); bytes = oracle.bytes(); assert_eq!(bytes, c.n * c.cap as usize / 8); (bw, scratch) = oracle.stats(c.n, c.threads); oracle.insert(&d.inserted, false, 1); oracle.lookup(&d.query, &mut expected, false, 1); validate_built(&oracle, d, &expected, &mut out); }
    let mut times: [Vec<f64>; 6] = std::array::from_fn(|_| Vec::new());
    for repeat in 0..c.repeats { for mode in SCHEDULE[(repeat + (c.seed % 4) as usize) % 4] {
        let parallel = mode % 2 == 1; affinity(&serial);
        if mode < 2 {
            let mut fresh = F::new(c); affinity(if parallel { &c.cpus } else { &serial });
            let start = Instant::now(); fresh.insert(black_box(&d.inserted), parallel, c.threads); let elapsed = start.elapsed();
            affinity(&serial); times[mode].push(elapsed.as_nanos() as f64 / c.n as f64); assert_eq!(fresh.bytes(), bytes); validate_built(&fresh, d, &expected, &mut out);
        } else {
            affinity(if parallel { &c.cpus } else { &serial }); let start = Instant::now(); let mut fresh = F::new(c);
            fresh.insert(black_box(&d.inserted), parallel, c.threads); let elapsed = start.elapsed();
            affinity(&serial); times[mode].push(elapsed.as_nanos() as f64 / c.n as f64); assert_eq!(fresh.bytes(), bytes); validate_built(&fresh, d, &expected, &mut out);
        }
    } }
    affinity(&serial); let mut bf = F::new(c); assert_eq!(bf.bytes(), bytes); bf.insert(&d.inserted, false, 1); validate_built(&bf, d, &expected, &mut out);
    for parallel in [false, true] { out.fill(0xfeed); affinity(if parallel { &c.cpus } else { &serial }); bf.lookup(&d.query, &mut out[16..16 + c.q], parallel, c.threads); affinity(&serial); guards(&out, c.q); assert_eq!(expected, out[16..16 + c.q]); }
    for repeat in 0..c.repeats { for phase in 0..2 {
        let parallel = (phase + repeat + (c.seed % 2) as usize) % 2 == 1; out.fill(0xfeed); affinity(if parallel { &c.cpus } else { &serial });
        let start = Instant::now(); bf.lookup(black_box(&d.query), black_box(&mut out[16..16 + c.q]), parallel, c.threads); let elapsed = start.elapsed();
        affinity(&serial); times[4 + usize::from(parallel)].push(elapsed.as_nanos() as f64 / c.q as f64); guards(&out, c.q); assert_eq!(expected, out[16..16 + c.q]); black_box(out[16..16 + c.q].iter().map(|&v| v as u64).sum::<u64>());
    } }
    let (mut present, mut fp, mut checksum) = (0usize, 0usize, 14695981039346656037u64);
    for (&answer, &hit) in expected.iter().zip(&d.truth) { assert!(answer <= 1 && (!hit || answer == 1)); present += usize::from(hit); if !hit { fp += answer as usize; } checksum = (checksum ^ answer as u64).wrapping_mul(1099511628211); }
    let mut hashes = [0u64; 4096]; let mut answers = [0u32; 4096]; let mut calfp = 0usize;
    for i in (0..c.calibration).step_by(hashes.len()) { let len = hashes.len().min(c.calibration - i); for (j, h) in hashes[..len].iter_mut().enumerate() { *h = hash64(c.base + (c.n + c.q + i + j) as u64); } answers.fill(0xfeed); bf.lookup(&hashes[..len], &mut answers[..len], false, 1); for &answer in &answers[..len] { assert!(answer <= 1); calfp += answer as usize; } }
    let qw = query_workers(c.q, c.threads);
    print!("rust,{name},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},prehashed64,scoped_workers_plus_caller,{},{},whole_array_native_api,build_williams4_query_alternating,insert_cpu3_allocate_allowed_set",
      c.n, c.q, c.cap, bytes, 8.0 * bytes as f64 / c.n as f64, c.threads, bw, qw, scratch, c.repeats, c.seed, c.hit, present, c.q - present, fp, checksum, c.calibration, calfp, c.base, if bw == 1 { 0 } else { bw }, if qw == 1 { 0 } else { qw });
    for values in &times { print!(",{},{},{},{}", median(values), values.iter().copied().reduce(f64::min).unwrap(), values.iter().copied().reduce(f64::max).unwrap(), values.iter().map(ToString::to_string).collect::<Vec<_>>().join("|")); } println!();
}
fn main() {
    let args: Vec<_> = std::env::args().collect(); assert_eq!(args.len(), 11, "POWER CAP QPOWER THREADS REPEATS SEED HIT CALPOWER FILTERS CPUS required");
    let number = |i: usize| { let s = &args[i]; assert!(!s.is_empty() && s.bytes().all(|c| c.is_ascii_digit())); s.parse::<u64>().unwrap() };
    let (kp, cap, qp, threads, repeats, seed, hit, cp) = (number(1), number(2), number(3), number(4), number(5), number(6), number(7), number(8));
    assert!((6..=25).contains(&kp) && (12..=27).contains(&qp) && [16, 24, 32].contains(&cap) && (1..=8).contains(&threads) && (4..=32).contains(&repeats) && repeats % 4 == 0 && hit <= 100 && (12..=27).contains(&cp));
    let cpus = parse_cpus(&args[10], threads as usize); let mut selected = BTreeSet::new();
    for name in args[9].split(',') { assert!(["Split64", "Split64Range"].contains(&name) && selected.insert(name), "unknown/empty/duplicate family"); }
    assert!(cap != 24 || !selected.contains("Split64"), "Split24 duplicates Split16 outside fixed selection");
    let mut c = Config { n: 1usize << kp, q: 1usize << qp, threads: threads as usize, repeats: repeats as usize, calibration: 1usize << cp, cap: cap as u32, seed, base: 0, hit: hit as usize, cpus };
    affinity(&[3]); let mut rng = Rng(seed); let d = workload(&mut c, &mut rng); let mut order: Vec<_> = ["Split64", "Split64Range"].into_iter().filter(|name| selected.contains(name)).collect(); shuffle(&mut order, &mut rng);
    print!("language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,core_budget,build_workers,query_workers,estimated_build_scratch_bytes,repeats,seed,hit_percent,present_queries,absent_queries,false_positives,result_checksum,calibration_absent_queries,calibration_false_positives,key_base,input_mode,scheduler_model,build_spawned_workers_per_pass,query_spawned_workers,query_contract,phase_order,parallel_first_touch");
    for metric in METRICS { for suffix in ["_ns", "_min_ns", "_max_ns", "_trials_ns"] { print!(",{metric}{suffix}"); } } println!();
    for name in order { match name { "Split64" => run::<Split64BloomFilter>(name, &d, &c), "Split64Range" => run::<Split64RangeBloomFilter>(name, &d, &c), _ => unreachable!() } }
}
