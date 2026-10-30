use fastest_bloom_filter::{Split64BloomFilter, Split64RangeBloomFilter};
use native_build_policy_experiment::{Filter, Native};
use std::{cell::RefCell, rc::Rc};

const GUARD: u32 = 0xfeed;
const BLOCK: usize = 4096;
const QUERY_COUNT: usize = 32771;
const NEW_BASE: u64 = 1 << 40;
const NEGATIVE_BASE: u64 = 2 << 40;

fn hash(index: u64) -> u64 {
    let mut z = 0x243f6a8885a308d3u64.wrapping_add(index.wrapping_add(1).wrapping_mul(0x9e3779b97f4a7c15));
    z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
    z ^ (z >> 31)
}

#[derive(Debug, PartialEq)]
struct Event { method: &'static str, n: usize, request: usize, input: usize, output: usize }
struct Spy { bytes: usize, events: Rc<RefCell<Vec<Event>>> }
impl Spy {
    fn record(&self, method: &'static str, n: usize, request: usize, input: usize, output: usize) {
        self.events.borrow_mut().push(Event { method, n, request, input, output });
    }
}
impl Native for Spy {
    fn size_in_bytes(&self) -> usize { self.bytes }
    fn build_workers(&self, n: usize, requested: usize) -> usize {
        self.record("workers", n, requested, 0, 0); requested + 7
    }
    fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
        self.record("scratch", n, requested, 0, 0); n + requested * 11 + self.bytes
    }
    fn insert_hashes(&mut self, hashes: &[u64]) {
        self.record("insert", hashes.len(), 0, hashes.as_ptr() as usize, 0);
    }
    fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
        self.record("parallel_insert", hashes.len(), requested, hashes.as_ptr() as usize, 0);
    }
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len());
        self.record("lookup", hashes.len(), 0, hashes.as_ptr() as usize, out.as_mut_ptr() as usize);
        if let Some(first) = out.first_mut() { *first = 17; }
    }
    fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        assert_eq!(hashes.len(), out.len());
        self.record("parallel_lookup", hashes.len(), requested, hashes.as_ptr() as usize, out.as_mut_ptr() as usize);
        if let Some(first) = out.first_mut() { *first = 19; }
    }
}

fn spy_cases<const ENABLED: bool>() -> usize {
    let input = vec![0; 65537]; let mut output = vec![0; 65537]; let mut count = 0;
    for n in [0, 1, 16383, 16384, 65535, 65536, 65537] {
        for bytes in [131072, 262144, 262208, 524288, 67108864, 100663296] {
            for request in [0, 1, 4, 8] {
                let small_batch = n != 65537;
                let small_bitmap = bytes == 131072 || bytes == 262144;
                let effective = if ENABLED && small_batch && small_bitmap { 1 } else { request };
                let events = Rc::new(RefCell::new(Vec::new()));
                let mut filter = Filter::<Spy, ENABLED>::from_native(Spy { bytes, events: Rc::clone(&events) });
                assert_eq!(filter.size_in_bytes(), bytes);
                assert_eq!(filter.effective_build_request(n, request), effective);
                assert_eq!(filter.build_workers(n, request), effective + 7);
                assert_eq!(filter.build_scratch_bytes(n, request), n + effective * 11 + bytes);
                filter.insert_hashes(&input[..n]); filter.insert_hashes_parallel(&input[..n], request);
                filter.lookup_hashes(&input[..n], &mut output[..n]);
                if n != 0 { assert_eq!(output[0], 17); }
                filter.lookup_hashes_parallel(&input[..n], &mut output[..n], request);
                if n != 0 { assert_eq!(output[0], 19); }
                let actual = events.borrow(); assert_eq!(actual.len(), 6);
                let names = ["workers", "scratch", "insert", "parallel_insert", "lookup", "parallel_lookup"];
                let requests = [effective, effective, 0, effective, 0, request];
                for i in 0..6 {
                    assert_eq!(actual[i], Event { method: names[i], n, request: requests[i],
                        input: if i >= 2 { input.as_ptr() as usize } else { 0 },
                        output: if i >= 4 { output.as_mut_ptr() as usize } else { 0 } });
                }
                count += 1;
            }
        }
    }
    count
}

#[derive(Clone, Copy)]
struct Case { id: usize, bytes: usize, n: usize, requested: usize, history: usize, hotspot: bool }
fn case(range: bool, id: usize) -> Case {
    let large = if range { 100663296 } else { 67108864 };
    let (bytes, n, requested, history, hotspot) = [
        (262144, 65536, 1, 0, false), (262144, 65537, 4, 0, false),
        (262144, 65536, 4, 131072, true), (if range { 262208 } else { 524288 }, 65536, 8, 0, false),
        (large, 65536, 0, 0, false), (large, 65536, 8, large / 2, true),
    ][id];
    Case { id, bytes, n, requested, history, hotspot }
}

fn guards(out: &[u32], n: usize) {
    assert!(out[..16].iter().all(|&x| x == GUARD));
    assert!(out[n + 16..n + 32].iter().all(|&x| x == GUARD));
}
fn prefill<F: Native, const ENABLED: bool>(filter: &mut Filter<F, ENABLED>, count: usize) {
    let mut hashes = [0; BLOCK];
    for begin in (0..count).step_by(BLOCK) {
        let len = BLOCK.min(count - begin);
        for (j, value) in hashes[..len].iter_mut().enumerate() { *value = hash((begin + j) as u64); }
        filter.insert_hashes(&hashes[..len]);
    }
}
fn check_inserted<F: Native, const ENABLED: bool>(filter: &Filter<F, ENABLED>, c: Case, batch: &[u64]) {
    let mut hashes = [0; BLOCK]; let mut out = [GUARD; BLOCK + 32];
    for begin in (0..c.history).step_by(BLOCK) {
        let len = BLOCK.min(c.history - begin);
        for (j, value) in hashes[..len].iter_mut().enumerate() { *value = hash((begin + j) as u64); }
        out.fill(GUARD); filter.lookup_hashes(&hashes[..len], &mut out[16..16 + len]); guards(&out, len);
        assert!(out[16..16 + len].iter().all(|&x| x == 1), "old inserted key missing");
    }
    for input in batch.chunks(BLOCK) {
        let len = input.len(); out.fill(GUARD);
        filter.lookup_hashes(input, &mut out[16..16 + len]); guards(&out, len);
        assert!(out[16..16 + len].iter().all(|&x| x == 1), "new inserted key missing");
    }
}
fn workers(n: usize, requested: usize, bytes: usize) -> usize {
    if n < 16384 { 1 } else { requested.min(n / 4096).min(bytes / 64).min(1024).max(1) }
}
fn scratch(n: usize, w: usize) -> usize {
    if w == 1 { 0 } else { n * 8 + w * w.div_ceil(8) * 64 + (w + 1) * 8 + w * w * 24 + w * 48 }
}
struct Stats { request: usize, workers: usize, scratch: usize, auto_workers: usize }
fn variant<F: Native, const ENABLED: bool>(make: &impl Fn(usize) -> F, c: Case, batch: &[u64], query: &[u64], expected: &mut Vec<u32>, serial: bool) -> Stats {
    let mut filter = Filter::<F, ENABLED>::from_native(make(c.bytes)); assert_eq!(filter.size_in_bytes(), c.bytes);
    let effective = if ENABLED && c.id < 3 && c.n == 65536 { 1 } else { c.requested };
    let auto_workers = filter.build_workers(c.n, 0);
    let w = if effective == 0 { auto_workers } else { workers(c.n, effective, c.bytes) }; let bytes = scratch(c.n, w);
    assert_eq!(filter.effective_build_request(c.n, c.requested), effective);
    assert_eq!(filter.build_workers(c.n, c.requested), w);
    assert_eq!(filter.build_scratch_bytes(c.n, c.requested), bytes);
    assert_eq!(filter.build_scratch_bytes(c.n, 0), scratch(c.n, auto_workers));
    prefill(&mut filter, c.history);
    if serial { filter.insert_hashes(batch); } else { filter.insert_hashes_parallel(batch, c.requested); }
    check_inserted(&filter, c, batch);
    let mut out = vec![GUARD; query.len() + 32];
    filter.lookup_hashes(query, &mut out[16..16 + query.len()]); guards(&out, query.len());
    if serial { *expected = out[16..16 + query.len()].to_vec(); }
    else { assert_eq!(&out[16..16 + query.len()], expected.as_slice()); }
    assert!(expected.iter().all(|&x| x <= 1));
    out.fill(GUARD); filter.lookup_hashes_parallel(query, &mut out[16..16 + query.len()], c.requested);
    guards(&out, query.len()); assert_eq!(&out[16..16 + query.len()], expected.as_slice());
    Stats { request: effective, workers: w, scratch: bytes, auto_workers }
    // The native bitmap drops before another variant constructs its filter.
}

fn real_cases<F: Native>(family: &str, range: bool, make: impl Fn(usize) -> F) {
    for id in 0..6 {
        let c = case(range, id);
        let batch: Vec<u64> = (0..c.n).map(|i| if c.hotspot { hash(NEW_BASE + i as u64) & 0xffffffff } else { hash(NEW_BASE + i as u64) }).collect();
        let mut query: Vec<u64> = (0..QUERY_COUNT).map(|i| hash(NEGATIVE_BASE + i as u64)).collect();
        for i in (0..query.len()).step_by(3) { query[i] = batch[i % c.n]; }
        if c.history != 0 { for i in (1..query.len()).step_by(3) { query[i] = hash((i % c.history) as u64); } }
        else { for i in (1..query.len()).step_by(3) { query[i] = batch[(i * 17) % c.n]; } }
        let mut expected = Vec::new();
        let reference = variant::<F, false>(&make, c, &batch, &query, &mut expected, true);
        let control = variant::<F, false>(&make, c, &batch, &query, &mut expected, false);
        let candidate = variant::<F, true>(&make, c, &batch, &query, &mut expected, false);
        assert_eq!(control.auto_workers, reference.auto_workers, "original automatic scheduler drift");
        assert_eq!(candidate.auto_workers, if id == 0 || id == 2 { 1 } else { reference.auto_workers });
        let checksum = expected.iter().fold(14695981039346656037u64, |h, &v| (h ^ u64::from(v)).wrapping_mul(1099511628211));
        let positives: u64 = expected.iter().map(|&x| u64::from(x)).sum();
        println!("{{\"language\":\"rust\",\"family\":\"{}\",\"case\":{},\"bytes\":{},\"batch_n\":{},\"requested\":{},\"history_n\":{},\"hotspot\":{},\"query_n\":{},\"control_effective\":{},\"candidate_effective\":{},\"control_workers\":{},\"candidate_workers\":{},\"native_auto_workers\":{},\"candidate_auto_workers\":{},\"control_scratch\":{},\"candidate_scratch\":{},\"checksum\":{},\"positives\":{},\"checked_history_per_variant\":{},\"checked_new_per_variant\":{},\"variants\":3,\"full_mixed_checks_per_variant\":2,\"performance_run\":false}}",
            family, c.id, c.bytes, c.n, c.requested, c.history, c.hotspot, query.len(), control.request, candidate.request,
            control.workers, candidate.workers, reference.auto_workers, candidate.auto_workers, control.scratch, candidate.scratch, checksum, positives, c.history, c.n);
    }
}

fn main() {
    let args: Vec<_> = std::env::args().collect(); assert_eq!(args.len(), 2, "one mode --spy or --real required");
    match args[1].as_str() {
        "--spy" => { let cases = spy_cases::<false>() + spy_cases::<true>(); assert_eq!(cases, 336);
            println!("{{\"language\":\"rust\",\"spy_cases\":{},\"forwarded_calls\":{},\"performance_run\":false}}", cases, cases * 6); }
        "--real" => {
            real_cases("Split64", false, |bytes| Split64BloomFilter::new(bytes / 2, 8).expect("fixed Split allocation"));
            real_cases("Split64Range", true, |bytes| Split64RangeBloomFilter::with_byte_budget(bytes).expect("fixed Range allocation"));
        }
        _ => panic!("unknown mode"),
    }
}
