use fastest_bloom_filter::{Split64BloomFilter, Split64RangeBloomFilter};
use native_build_policy_experiment::{Filter, Native};
use std::{collections::BTreeSet, hint::black_box, time::Instant};

const BLOCK: usize = 4096;
const QUERIES: usize = 32771;
const GUARD: u32 = 0xfeed;
const SCHEDULE: [[usize; 3]; 4] = [[0, 1, 2], [2, 1, 0], [0, 2, 1], [1, 2, 0]];
const ARMS: [&str; 3] = ["serial", "control", "candidate"];
extern "C" {
    fn sched_setaffinity(pid: i32, bytes: usize, mask: *const usize) -> i32;
    fn sched_getaffinity(pid: i32, bytes: usize, mask: *mut usize) -> i32;
}
fn affinity(cpus: &[usize]) {
    assert_eq!(std::mem::size_of::<usize>(), 8);
    let mut mask = [0usize; 16];
    for &cpu in cpus { assert!(cpu < 1024); mask[cpu / 64] |= 1usize << (cpu % 64); }
    // Linux affinity only. Bloom operations remain frozen native public calls.
    assert_eq!(unsafe { sched_setaffinity(0, std::mem::size_of_val(&mask), mask.as_ptr()) }, 0, "set affinity failed");
}
fn parse_cpus(text: &str, requested: usize) -> Vec<usize> {
    let mut allowed = [0usize; 16];
    assert_eq!(unsafe { sched_getaffinity(0, std::mem::size_of_val(&allowed), allowed.as_mut_ptr()) }, 0);
    let cpus: Vec<usize> = text.split(',').map(|s| {
        assert!(!s.is_empty() && s.bytes().all(|c| c.is_ascii_digit())); s.parse().unwrap()
    }).collect();
    assert_eq!(cpus.len(), requested); assert!([2, 3].contains(&cpus[0]));
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
        assert!(location.is_none() || location == Some((socket, nodes[0])));
        location = Some((socket, nodes[0]));
    }
    cpus
}
fn hash(index: u64) -> u64 {
    let mut z = 0x243f6a8885a308d3u64.wrapping_add(index.wrapping_add(1).wrapping_mul(0x9e3779b97f4a7c15));
    z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
    z ^ (z >> 31)
}
struct Case { id: usize, bytes: usize, n: usize, requested: usize, history: usize,
              seed: u64, base: u64, hotspot: bool, cpus: Vec<usize> }
fn case(range: bool, id: usize, requested: usize, seed: u64, cpus: Vec<usize>) -> Case {
    let large = if range { 100663296 } else { 67108864 };
    let g = [(262144, 65536, 0, false), (262144, 65537, 0, false),
        (262144, 65536, 131072, true), (if range { 262208 } else { 524288 }, 65536, 0, false),
        (large, 65536, 0, false), (large, 65536, large / 2, true)][id];
    Case { id, bytes: g.0, n: g.1, requested, history: g.2, seed, base: seed << 42, hotspot: g.3, cpus }
}
trait Make: Native + Sized { fn make(bytes: usize) -> Self; }
impl Make for Split64BloomFilter {
    fn make(bytes: usize) -> Self { Self::new(bytes / 2, 8).unwrap() }
}
impl Make for Split64RangeBloomFilter {
    fn make(bytes: usize) -> Self { Self::with_byte_budget(bytes).unwrap() }
}
fn make<F: Make, const ENABLED: bool>(c: &Case) -> Filter<F, ENABLED> {
    Filter::from_native(F::make(c.bytes))
}
struct Data { batch: Vec<u64>, query: Vec<u64> }
fn workload(c: &Case) -> Data {
    let batch: Vec<_> = (0..c.n).map(|i| {
        let h = hash(c.base + (1u64 << 40) + i as u64);
        if c.hotspot { h & 0xffffffff } else { h }
    }).collect();
    let mut query: Vec<_> = (0..QUERIES).map(|i| hash(c.base + (2u64 << 40) + i as u64)).collect();
    for i in (0..QUERIES).step_by(3) { query[i] = batch[i % c.n]; }
    if c.history != 0 {
        for i in (1..QUERIES).step_by(3) { query[i] = hash(c.base + (i % c.history) as u64); }
    } else {
        for i in (1..QUERIES).step_by(3) { query[i] = batch[(i * 17) % c.n]; }
    }
    Data { batch, query }
}
fn digest(values: &[u64]) -> u64 {
    values.iter().fold(14695981039346656037u64, |sum, &v| (sum ^ v).wrapping_mul(1099511628211))
}
fn prefill<F: Native, const ENABLED: bool>(filter: &mut Filter<F, ENABLED>, c: &Case) {
    let mut hashes = [0u64; BLOCK];
    for begin in (0..c.history).step_by(BLOCK) {
        let len = BLOCK.min(c.history - begin);
        for (j, h) in hashes[..len].iter_mut().enumerate() { *h = hash(c.base + (begin + j) as u64); }
        filter.insert_hashes(&hashes[..len]);
    }
}
fn guards(out: &[u32], n: usize) {
    assert!(out[..16].iter().chain(out[n + 16..n + 32].iter()).all(|&x| x == GUARD), "output guard changed");
}
fn validate<F: Native, const ENABLED: bool>(filter: &Filter<F, ENABLED>, c: &Case, d: &Data,
                                          expected: &[u32], out: &mut [u32]) {
    assert_eq!(filter.size_in_bytes(), c.bytes, "actual allocation changed");
    let mut hashes = [0u64; BLOCK]; let mut answers = [GUARD; BLOCK + 32];
    for begin in (0..c.history).step_by(BLOCK) {
        let len = BLOCK.min(c.history - begin);
        for (j, h) in hashes[..len].iter_mut().enumerate() { *h = hash(c.base + (begin + j) as u64); }
        answers.fill(GUARD); filter.lookup_hashes(&hashes[..len], &mut answers[16..16 + len]);
        guards(&answers, len); assert!(answers[16..16 + len].iter().all(|&x| x == 1), "old key absent");
    }
    for chunk in d.batch.chunks(BLOCK) {
        answers.fill(GUARD); filter.lookup_hashes(chunk, &mut answers[16..16 + chunk.len()]);
        guards(&answers, chunk.len()); assert!(answers[16..16 + chunk.len()].iter().all(|&x| x == 1), "new key absent");
    }
    for parallel in [false, true] {
        out.fill(GUARD);
        if parallel {
            affinity(&c.cpus); filter.lookup_hashes_parallel(&d.query, &mut out[16..16 + QUERIES], c.requested);
        } else { filter.lookup_hashes(&d.query, &mut out[16..16 + QUERIES]); }
        affinity(&[c.cpus[0]]); guards(out, QUERIES);
        assert_eq!(expected, &out[16..16 + QUERIES], "full mixed answers differ");
    }
}
#[derive(Default)]
struct Stats { effective: usize, workers: usize, scratch: usize }
fn observe<F: Native, const ENABLED: bool>(filter: &Filter<F, ENABLED>, c: &Case, serial: bool) -> Stats {
    assert_eq!(filter.size_in_bytes(), c.bytes);
    let effective = if ENABLED && c.n <= 65536 && c.bytes <= 262144 { 1 } else { c.requested };
    let w = effective; // Fixed cases exceed native fallback/count bounds.
    let scratch = if w == 1 { 0 } else { c.n * 8 + w * w.div_ceil(8) * 64 + (w + 1) * 8 + w * w * 24 + w * 48 };
    assert_eq!(filter.effective_build_request(c.n, c.requested), effective);
    assert_eq!(filter.build_workers(c.n, c.requested), w);
    assert_eq!(filter.build_scratch_bytes(c.n, c.requested), scratch);
    if serial { Stats { effective: 1, workers: 1, scratch: 0 } }
    else { Stats { effective, workers: w, scratch } }
}
#[derive(Default)]
struct Samples { stats: Stats, ns: [Vec<u128>; 2], setup_ns: [Vec<u128>; 2] }
fn trial<F: Make, const ENABLED: bool>(c: &Case, d: &Data, expected: &[u32], out: &mut [u32],
                                      serial: bool, allocate: bool, samples: &mut Samples) {
    affinity(&[c.cpus[0]]);
    if !allocate {
        let mut filter = make::<F, ENABLED>(c);
        samples.stats = observe(&filter, c, serial);
        let setup_start = Instant::now(); prefill(&mut filter, c); let setup = setup_start.elapsed();
        if !serial { affinity(&c.cpus); }
        let start = Instant::now();
        if serial { filter.insert_hashes(black_box(&d.batch)); }
        else { filter.insert_hashes_parallel(black_box(&d.batch), c.requested); }
        let elapsed = start.elapsed();
        affinity(&[c.cpus[0]]); samples.ns[0].push(elapsed.as_nanos());
        samples.setup_ns[0].push(if c.history == 0 { 0 } else { setup.as_nanos() });
        validate(&filter, c, d, expected, out);
    } else {
        assert_eq!(c.history, 0, "populated allocation+build is unavailable");
        if !serial { affinity(&c.cpus); }
        let start = Instant::now();
        let mut filter = make::<F, ENABLED>(c);
        if serial { filter.insert_hashes(black_box(&d.batch)); }
        else { filter.insert_hashes_parallel(black_box(&d.batch), c.requested); }
        let elapsed = start.elapsed();
        affinity(&[c.cpus[0]]); samples.ns[1].push(elapsed.as_nanos()); samples.setup_ns[1].push(0);
        samples.stats = observe(&filter, c, serial); validate(&filter, c, d, expected, out);
    } // The bitmap is dropped before the next arm and outside every clock.
}
fn array(values: &[u128]) { print!("["); for (i, v) in values.iter().enumerate() { if i != 0 { print!(","); } print!("{v}"); } print!("]"); }
fn run<F: Make>(family: &str, c: &Case, corrupt: bool) {
    let d = workload(c); let batch_before = digest(&d.batch); let query_before = digest(&d.query);
    let mut expected = vec![0u32; QUERIES]; let mut out = vec![GUARD; QUERIES + 32];
    let mut samples: [Samples; 3] = std::array::from_fn(|_| Samples::default());
    let mut executed = Vec::new();
    affinity(&[c.cpus[0]]);
    { let mut oracle = make::<F, false>(c); assert_eq!(oracle.size_in_bytes(), c.bytes);
      prefill(&mut oracle, c); oracle.insert_hashes(&d.batch); oracle.lookup_hashes(&d.query, &mut expected);
      validate(&oracle, c, &d, &expected, &mut out); }
    assert!(expected.iter().all(|&x| x <= 1));
    if corrupt { expected[0] ^= 1; }
    for (repeat, schedule) in SCHEDULE.iter().enumerate() {
        let allocation_first = repeat == 1 || repeat == 2;
        let phases = if c.history == 0 { 2 } else { 1 };
        for phase in 0..phases {
            let allocate = c.history == 0 && if phase == 0 { allocation_first } else { !allocation_first };
            for &arm in schedule {
                if arm == 2 { trial::<F, true>(c, &d, &expected, &mut out, false, allocate, &mut samples[arm]); }
                else { trial::<F, false>(c, &d, &expected, &mut out, arm == 0, allocate, &mut samples[arm]); }
                executed.push(format!("{repeat}:{}:{}", if allocate { "allocate_insert" } else { "insert" }, ARMS[arm]));
            }
        }
    }
    assert_eq!(digest(&d.batch), batch_before, "input mutated"); assert_eq!(digest(&d.query), query_before, "input mutated");
    let mut checksum = 14695981039346656037u64; let mut positives = 0usize;
    for &x in &expected { checksum = (checksum ^ x as u64).wrapping_mul(1099511628211); positives += x as usize; }
    print!("{{\"language\":\"rust\",\"family\":\"{family}\",\"scenario\":{},\"bytes\":{},\"batch_n\":{},\"requested\":{},\"history_n\":{},\"hotspot\":{},\"seed\":{},\"input_base\":{},\"query_n\":{QUERIES},\"checksum\":{checksum},\"positives\":{positives},\"batch_checksum\":{batch_before},\"query_checksum\":{query_before},\"repeats\":4,\"phase_order\":\"serial_pair_abba4\",\"scheduler\":\"scoped_workers_plus_caller_or_serial_fallback\",\"time_unit\":\"absolute_ns\",\"cpus\":[",
        c.id, c.bytes, c.n, c.requested, c.history, c.hotspot, c.seed, c.base);
    for (i, cpu) in c.cpus.iter().enumerate() { if i != 0 { print!(","); } print!("{cpu}"); }
    print!("],\"executed_order\":[");
    for (i, entry) in executed.iter().enumerate() { if i != 0 { print!(","); } print!("\"{entry}\""); }
    print!("],\"arms\":{{");
    for (arm, s) in samples.iter().enumerate() {
        if arm != 0 { print!(","); }
        let spawned = if s.stats.workers == 1 { 0 } else { s.stats.workers };
        print!("\"{}\":{{\"effective\":{},\"workers\":{},\"scratch_bytes\":{},\"spawned_per_pass\":{spawned},\"insert_ns\":", ARMS[arm], s.stats.effective, s.stats.workers, s.stats.scratch);
        array(&s.ns[0]); print!(",\"allocate_insert_ns\":"); array(&s.ns[1]);
        print!(",\"insert_prefill_setup_ns\":"); array(&s.setup_ns[0]); print!("}}");
    }
    println!("}}}}");
}
fn main() {
    let args: Vec<_> = std::env::args().collect(); assert_eq!(args.len(), 7, "FAMILY SCENARIO REQUESTED SEED CPUS MODE required");
    assert!(["Split64", "Split64Range"].contains(&args[1].as_str()), "unknown family");
    let number = |i: usize| { let s = &args[i]; assert!(!s.is_empty() && s.bytes().all(|c| c.is_ascii_digit())); s.parse::<u64>().unwrap() };
    let (scenario, requested, seed) = (number(2), number(3), number(4));
    assert!(scenario < 6 && [4, 8].contains(&requested) && [74381, 164321].contains(&seed), "unregistered workload");
    assert!(["--measure", "--check-bad-output"].contains(&args[6].as_str()), "unknown mode");
    let cpus = parse_cpus(&args[5], requested as usize);
    let c = case(args[1] == "Split64Range", scenario as usize, requested as usize, seed, cpus);
    if args[1] == "Split64Range" { run::<Split64RangeBloomFilter>(&args[1], &c, args[6] == "--check-bad-output"); }
    else { run::<Split64BloomFilter>(&args[1], &c, args[6] == "--check-bad-output"); }
}
