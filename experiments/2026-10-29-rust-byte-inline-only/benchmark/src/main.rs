use byte_only_native::ByteSplitBloomFilter as ByteOnlyInlineV1;
use fastest_bloom_filter::{hash64, ByteSplitBloomFilter};
use std::{
    alloc::{alloc, dealloc, handle_alloc_error, Layout},
    hint::black_box,
    ops::{Deref, DerefMut},
    ptr::NonNull,
    time::Instant,
};
use triple_hint_native::ByteSplitBloomFilter as ByteTripleHintControl;

// All three types call their unchanged public APIs; only source hints differ.
trait Filter: Sized {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>>;
    fn size_in_bytes(&self) -> usize;
    fn contains_hash(&self, hash: u64) -> bool;
    fn insert_hashes(&mut self, hashes: &[u64]);
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]);
}
macro_rules! native_filter {
    ($filter:ty) => {
        impl Filter for $filter {
            fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
                Ok(<$filter>::new(n, bpk)?)
            }
            fn size_in_bytes(&self) -> usize {
                <$filter>::size_in_bytes(self)
            }
            fn insert_hashes(&mut self, hashes: &[u64]) {
                <$filter>::insert_hashes(self, hashes)
            }
            #[inline(always)]
            fn contains_hash(&self, hash: u64) -> bool {
                <$filter>::contains_hash(self, hash)
            }
            fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
                <$filter>::lookup_hashes(self, hashes, out)
            }
        }
    };
}
native_filter!(ByteSplitBloomFilter);
native_filter!(ByteTripleHintControl);
native_filter!(ByteOnlyInlineV1);

// Benchmark buffers use the same 4096-byte alignment and 64-byte output offset
// as C++. This allocator is private to the benchmark, not part of the library.
struct Aligned<T: Copy + Default> {
    ptr: NonNull<T>,
    len: usize,
    layout: Layout,
}
impl<T: Copy + Default> Aligned<T> {
    fn new(len: usize) -> Self {
        let layout = Layout::from_size_align(
            len.checked_mul(std::mem::size_of::<T>()).unwrap().max(1),
            4096.max(std::mem::align_of::<T>()),
        )
        .unwrap();
        let p = unsafe { alloc(layout) };
        let ptr = NonNull::new(p.cast::<T>()).unwrap_or_else(|| handle_alloc_error(layout));
        for i in 0..len {
            unsafe {
                ptr.as_ptr().add(i).write(T::default());
            }
        }
        Self { ptr, len, layout }
    }
}
impl<T: Copy + Default> Deref for Aligned<T> {
    type Target = [T];
    fn deref(&self) -> &[T] {
        unsafe { std::slice::from_raw_parts(self.ptr.as_ptr(), self.len) }
    }
}
impl<T: Copy + Default> DerefMut for Aligned<T> {
    fn deref_mut(&mut self) -> &mut [T] {
        unsafe { std::slice::from_raw_parts_mut(self.ptr.as_ptr(), self.len) }
    }
}
impl<T: Copy + Default> Drop for Aligned<T> {
    fn drop(&mut self) {
        unsafe {
            dealloc(self.ptr.as_ptr().cast(), self.layout);
        }
    }
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
fn median(v: &[f64]) -> f64 {
    let mut v = v.to_vec();
    v.sort_by(f64::total_cmp);
    if v.len() % 2 == 1 {
        v[v.len() / 2]
    } else {
        (v[v.len() / 2 - 1] + v[v.len() / 2]) / 2.0
    }
}
#[inline(never)]
fn lookup<F: Filter>(bf: &F, hashes: &[u64], out: &mut [u32]) {
    bf.lookup_hashes(hashes, out);
}
// One non-inlined whole-array boundary. Each actual public singleton method
// is visible within this monomorphized loop; cross-key optimization is allowed.
#[inline(never)]
fn visible_lookup<F: Filter, const HASH_RAW: bool>(bf: &F, input: &[u64], out: &mut [u32]) {
    assert_eq!(input.len(), out.len(), "one output is required per input");
    for (&value, answer) in input.iter().zip(out.iter_mut()) {
        let hash = if HASH_RAW { hash64(value) } else { value };
        *answer = bf.contains_hash(hash) as u32;
    }
}

const PHASE_NAMES: [&str; 4] = [
    "timed prehashed query",
    "timed hash+query",
    "timed visible prehashed query",
    "timed visible hash+query",
];
fn phase_orders(seed: u64, repeats: usize) -> Vec<[usize; 4]> {
    assert!(repeats > 0 && repeats.is_multiple_of(4));
    let schedule = [[0, 1, 3, 2], [1, 2, 0, 3], [2, 3, 1, 0], [3, 0, 2, 1]];
    let mut labels = [0, 1, 2, 3];
    shuffle(&mut labels, &mut SplitMix64(seed ^ 0x6a09e667f3bcc909));
    (0..repeats)
        .map(|trial| schedule[trial % 4].map(|phase| labels[phase]))
        .collect()
}
fn verify_dense_output(
    output: &[u32],
    expected: &[u32],
    before: &[u32],
    after: &[u32],
    checksum: u64,
    phase: &str,
) {
    query_validation::verify_output(output, checksum, phase);
    assert_eq!(output, expected, "{phase} dense output mismatch");
    assert!(
        before.iter().chain(after).all(|&x| x == 0xfeed),
        "query output guard modified"
    );
}
fn trial_string(samples: &[f64]) -> String {
    samples
        .iter()
        .map(ToString::to_string)
        .collect::<Vec<_>>()
        .join("|")
}

#[inline(never)]
fn insert<F: Filter>(bf: &mut F, hashes: &[u64]) {
    bf.insert_hashes(hashes);
}
fn consume(out: &[u32]) {
    black_box(out.iter().map(|&x| x as u64).sum::<u64>());
}
struct Config {
    n: usize,
    q: usize,
    bpk: u32,
    hit: u64,
    batch: usize,
    insert_batch: usize,
    calibration_power: u32,
    repeats: usize,
    seed: u64,
    key_base: u64,
}
fn run<F: Filter>(name: &str, raw_insert: &[u64], raw_query: &[u64], c: &Config) {
    let mut inserted = Aligned::<u64>::new(c.n);
    let mut hashes = Aligned::<u64>::new(c.q);
    let mut scratch = Aligned::<u64>::new(c.batch.max(c.insert_batch));
    for (h, &x) in inserted.iter_mut().zip(raw_insert) {
        *h = hash64(x);
    }
    for (h, &x) in hashes.iter_mut().zip(raw_query) {
        *h = hash64(x);
    }
    let mut output_storage = Aligned::<u32>::new(c.q.max(c.batch) + 32);
    let (guard_before, rest) = output_storage.split_at_mut(16);
    let (output, guard_after) = rest.split_at_mut(c.q.max(c.batch));
    guard_before.fill(0xfeed);
    guard_after.fill(0xfeed);
    // One bitmap per phase, with destruction and validation outside timing.
    let validate_build = |filter: &F, output: &mut [u32], full: bool| {
        let count = if full { c.n } else { c.n.min(c.batch) };
        for chunk in inserted[..count].chunks(c.batch) {
            lookup(filter, chunk, &mut output[..chunk.len()]);
            assert!(
                output[..chunk.len()].iter().all(|&x| x == 1),
                "false negative in timed build"
            );
            consume(&output[..chunk.len()]);
        }
    };
    let mut insert_times = vec![];
    let mut build_times = vec![];
    let mut hash_insert_times = vec![];
    let mut hash_build_times = vec![];
    for trial in 0..c.repeats {
        {
            let a = Instant::now();
            let mut fresh = F::new(c.n, c.bpk).unwrap();
            let ready = Instant::now();
            for chunk in inserted.chunks(c.insert_batch) {
                insert(&mut fresh, chunk);
            }
            let b = Instant::now();
            insert_times.push((b - ready).as_secs_f64() * 1e9 / c.n as f64);
            build_times.push((b - a).as_secs_f64() * 1e9 / c.n as f64);
            validate_build(&fresh, output, trial == 0);
        }
        {
            let a = Instant::now();
            let mut fresh = F::new(c.n, c.bpk).unwrap();
            let ready = Instant::now();
            for chunk in raw_insert.chunks(c.insert_batch) {
                for (h, &raw) in scratch.iter_mut().zip(chunk) {
                    *h = hash64(raw);
                }
                insert(&mut fresh, &scratch[..chunk.len()]);
            }
            let b = Instant::now();
            hash_insert_times.push((b - ready).as_secs_f64() * 1e9 / c.n as f64);
            hash_build_times.push((b - a).as_secs_f64() * 1e9 / c.n as f64);
            validate_build(&fresh, output, trial == 0);
        }
    }
    let mut bf = F::new(c.n, c.bpk).unwrap();
    for chunk in inserted.chunks(c.insert_batch) {
        insert(&mut bf, chunk);
    }
    for chunk in inserted.chunks(c.batch) {
        lookup(&bf, chunk, &mut output[..chunk.len()]);
        assert!(
            output[..chunk.len()].iter().all(|&x| x == 1),
            "false negative"
        );
    }
    for (input, out) in hashes
        .chunks(c.batch)
        .zip(output[..c.q].chunks_mut(c.batch))
    {
        lookup(&bf, input, out);
    }
    let (mut absent, mut present, mut fp, mut checksum) =
        (0usize, 0usize, 0usize, 14695981039346656037u64);
    for (&key, &result) in raw_query.iter().zip(output.iter()) {
        assert!(result <= 1);
        checksum = (checksum ^ result as u64).wrapping_mul(1099511628211);
        if key >= c.key_base && key < c.key_base + c.n as u64 {
            present += 1;
            assert_eq!(result, 1);
        } else {
            absent += 1;
            fp += result as usize;
        }
    }
    let expected = output[..c.q].to_vec();
    // Verify both public scalar paths before timing; keep one live bitmap.
    for &hash in inserted.iter() {
        assert!(bf.contains_hash(hash), "visible false negative");
    }
    visible_lookup::<F, false>(&bf, &hashes, &mut output[..c.q]);
    verify_dense_output(
        &output[..c.q],
        &expected,
        guard_before,
        guard_after,
        checksum,
        "visible prehashed warmup",
    );
    visible_lookup::<F, true>(&bf, raw_query, &mut output[..c.q]);
    verify_dense_output(
        &output[..c.q],
        &expected,
        guard_before,
        guard_after,
        checksum,
        "visible raw warmup",
    );
    let orders = phase_orders(c.seed, c.repeats);
    let mut samples: [Vec<f64>; 4] = std::array::from_fn(|_| Vec::new());
    for order in &orders {
        for &mode in order {
            let start = Instant::now();
            match mode {
                0 => {
                    for (input, out) in hashes
                        .chunks(c.batch)
                        .zip(output[..c.q].chunks_mut(c.batch))
                    {
                        lookup(&bf, input, out);
                    }
                }
                1 => {
                    for (input, out) in raw_query
                        .chunks(c.batch)
                        .zip(output[..c.q].chunks_mut(c.batch))
                    {
                        for (hash, &raw) in scratch.iter_mut().zip(input) {
                            *hash = hash64(raw);
                        }
                        lookup(&bf, &scratch[..input.len()], out);
                    }
                }
                2 => visible_lookup::<F, false>(&bf, &hashes, &mut output[..c.q]),
                3 => visible_lookup::<F, true>(&bf, raw_query, &mut output[..c.q]),
                _ => unreachable!(),
            }
            samples[mode].push(start.elapsed().as_secs_f64() * 1e9 / c.q as f64);
            #[cfg(test)]
            tests::maybe_corrupt_timed_tail(mode, &mut output[..c.q]);
            verify_dense_output(
                &output[..c.q],
                &expected,
                guard_before,
                guard_after,
                checksum,
                PHASE_NAMES[mode],
            );
            consume(&output[..c.q]);
        }
    }
    let times = &samples[0];
    let total = &samples[1];
    // Separate negative calibration runs after all timing, reusing only one
    // query batch of scratch. Its raw-key range is disjoint from both insertion
    // keys and timed queries, without changing the timed query working set.
    let calibration_queries = if c.calibration_power == 0 {
        0
    } else {
        1usize << c.calibration_power
    };
    let mut calibration_fp = 0usize;
    for i in (0..calibration_queries).step_by(c.batch) {
        let len = c.batch.min(calibration_queries - i);
        for (j, hash) in scratch[..len].iter_mut().enumerate() {
            let raw = c.key_base + c.n as u64 + c.q as u64 + (i + j) as u64;
            *hash = hash64(raw);
        }
        lookup(&bf, &scratch[..len], &mut output[..len]);
        for (&hash, &answer) in scratch[..len].iter().zip(&output[..len]) {
            assert!(answer <= 1, "invalid calibration output");
            assert_eq!(
                answer,
                bf.contains_hash(hash) as u32,
                "visible calibration mismatch"
            );
            calibration_fp += answer as usize;
        }
    }
    let hash_lookup_min = total.iter().copied().fold(f64::INFINITY, f64::min);
    let hash_lookup_max = total.iter().copied().fold(0.0, f64::max);
    let fpr = if absent == 0 {
        "nan".to_owned()
    } else {
        (fp as f64 / absent as f64).to_string()
    };
    print!(
        "rust,{name},{},{},{},{},{},64,{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},prehashed,{},{},{},{hash_lookup_min},{hash_lookup_max},{calibration_queries},{calibration_fp}",
        c.n,
        c.q,
        c.bpk,
        bf.size_in_bytes(),
        8.0 * bf.size_in_bytes() as f64 / c.n as f64,
        c.hit,
        present,
        c.batch,
        c.repeats,
        c.seed,
        median(&insert_times),
        median(&build_times),
        median(times),
        median(total),
        absent,
        fp,
        fpr,
        times.iter().copied().fold(f64::INFINITY, f64::min),
        times.iter().copied().fold(0.0, f64::max),
        checksum,
        median(&hash_insert_times),
        median(&hash_build_times),
        c.insert_batch
    );
    print!(
        ",optimizer_visible_public_single,{},{},{},{},{},{}",
        median(&samples[2]),
        median(&samples[3]),
        samples[2].iter().copied().fold(f64::INFINITY, f64::min),
        samples[2].iter().copied().fold(0.0, f64::max),
        samples[3].iter().copied().fold(f64::INFINITY, f64::min),
        samples[3].iter().copied().fold(0.0, f64::max)
    );
    for values in &samples {
        print!(",{}", trial_string(values));
    }
    println!(
        ",{}",
        orders
            .iter()
            .map(|order| order
                .iter()
                .map(ToString::to_string)
                .collect::<Vec<_>>()
                .join("|"))
            .collect::<Vec<_>>()
            .join(";")
    );
}
#[path = "support/filter_selection.rs"]
mod filter_selection;
#[path = "support/query_validation.rs"]
mod query_validation;

const FILTER_NAMES: &[&str] = &[
    "ByteSplitBloomFilter",
    "ByteTripleHintControl",
    "ByteOnlyInlineV1",
];

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let number = |i: usize, default: u64| -> u64 {
        if let Some(s) = args.get(i) {
            assert!(
                !s.is_empty() && s.bytes().all(|c| c.is_ascii_digit()),
                "unsigned integers required"
            );
            s.parse().expect("integer overflow")
        } else {
            default
        }
    };
    let power = number(1, 16);
    let bpk = number(2, 16);
    let hit = number(3, 0);
    let qp = number(4, 22);
    let batch = number(5, 1);
    let repeats = number(6, 8);
    let seed = number(7, 42);
    let insert_batch = number(9, batch);
    let calibration_power = number(10, 0);
    assert!(
        (5..=26).contains(&power)
            && (12..=27).contains(&qp)
            && (1..=32).contains(&bpk)
            && hit <= 100
            && batch > 0
            && batch <= 1 << qp
            && repeats > 0
            && repeats.is_multiple_of(4)
            && insert_batch > 0
            && insert_batch <= (1 << 26)
            && (calibration_power == 0 || (12..=27).contains(&calibration_power))
            && args.len() <= 11,
        "invalid arguments"
    );
    let mut jobs = filter_selection::select_filters(
        args.get(8).map(String::as_str).unwrap_or(""),
        FILTER_NAMES,
    )
    .unwrap_or_else(|error| {
        eprintln!("{error}");
        std::process::exit(2);
    });
    let n = 1usize << power;
    let q = 1usize << qp;
    assert!(n * (bpk as usize) < (1usize << 31), "size overflow");
    let mut rng = SplitMix64(seed);
    let key_base = rng.next() % ((1u64 << 32) - n as u64 - q as u64);
    let mut inserted: Vec<_> = (key_base..key_base + n as u64).collect();
    shuffle(&mut inserted, &mut rng);
    let mut query: Vec<_> = (0..q as u64)
        .map(|i| {
            key_base
                + if i % 100 < hit {
                    rng.next() % n as u64
                } else {
                    n as u64 + i
                }
        })
        .collect();
    shuffle(&mut query, &mut rng);
    let c = Config {
        n,
        q,
        bpk: bpk as u32,
        hit,
        batch: batch as usize,
        insert_batch: insert_batch as usize,
        calibration_power: calibration_power as u32,
        repeats: repeats as usize,
        seed,
        key_base,
    };
    println!("language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,hash_bits,hit_percent,present_queries,batch,repeats,seed,insert_ns,allocate_insert_ns,lookup_ns,hash_lookup_ns,absent_queries,false_positives,fpr,lookup_min_ns,lookup_max_ns,result_checksum,input_mode,hash_insert_ns,allocate_hash_insert_ns,insert_batch,hash_lookup_min_ns,hash_lookup_max_ns,calibration_absent_queries,calibration_false_positives,scalar_track,inline_lookup_ns,inline_hash_lookup_ns,inline_lookup_min_ns,inline_lookup_max_ns,inline_hash_lookup_min_ns,inline_hash_lookup_max_ns,lookup_trials,hash_lookup_trials,inline_lookup_trials,inline_hash_lookup_trials,query_phase_order");
    shuffle(&mut jobs, &mut rng);
    for name in jobs {
        match name {
            "ByteSplitBloomFilter" => run::<ByteSplitBloomFilter>(name, &inserted, &query, &c),
            "ByteTripleHintControl" => run::<ByteTripleHintControl>(name, &inserted, &query, &c),
            "ByteOnlyInlineV1" => run::<ByteOnlyInlineV1>(name, &inserted, &query, &c),
            _ => unreachable!(),
        }
    }
}

#[cfg(test)]
mod tests;
