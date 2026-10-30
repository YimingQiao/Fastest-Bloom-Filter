use fastest_bloom_filter::{
    hash64, BloomFilter, ByteSplitBloomFilter, FourSectorBloomFilter, Split64BloomFilter,
};
mod four_sector;
mod split64;
use std::{
    alloc::{alloc, dealloc, handle_alloc_error, Layout},
    hint::black_box,
    ops::{Deref, DerefMut},
    ptr::NonNull,
    time::Instant,
};

// Optional external baseline: no dependency is added to the native library.
trait Filter: Sized {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>>;
    fn size_in_bytes(&self) -> usize;
    fn insert_hashes(&mut self, hashes: &[u64]);
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]);
}
impl<const P: bool> Filter for BloomFilter<P> {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(BloomFilter::new(n, bpk)?)
    }
    fn size_in_bytes(&self) -> usize {
        BloomFilter::size_in_bytes(self)
    }
    fn insert_hashes(&mut self, h: &[u64]) {
        BloomFilter::insert_hashes(self, h)
    }
    fn lookup_hashes(&self, h: &[u64], out: &mut [u32]) {
        BloomFilter::lookup_hashes(self, h, out)
    }
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
            fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
                <$filter>::lookup_hashes(self, hashes, out)
            }
        }
    };
}
native_filter!(ByteSplitBloomFilter);
native_filter!(FourSectorBloomFilter);
native_filter!(Split64BloomFilter);

type ByteInlineLookupV1 = fastest_bloom_filter_inline::ByteSplitBloomFilter;
type SplitInlineLookupV1 = fastest_bloom_filter_inline::Split64BloomFilter;
native_filter!(ByteInlineLookupV1);
native_filter!(SplitInlineLookupV1);

macro_rules! single_api_filter {
    ($name:ident, $native:ty) => {
        struct $name($native);
        impl Filter for $name {
            fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
                Ok(Self(<$native>::new(n, bpk)?))
            }
            fn size_in_bytes(&self) -> usize {
                self.0.size_in_bytes()
            }
            fn insert_hashes(&mut self, hashes: &[u64]) {
                self.0.insert_hashes(hashes)
            }
            fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
                assert_eq!(hashes.len(), out.len(), "one output is required per input");
                if hashes.len() == 1 {
                    out[0] = self.0.contains_hash(hashes[0]) as u32;
                } else {
                    self.0.lookup_hashes(hashes, out);
                }
            }
        }
    };
}
single_api_filter!(ByteNativeSingleApiV1, ByteSplitBloomFilter);
// Split's public contains_hash uses scalar source; this also changes the
// chosen kernel, not only dispatch/inlining. Byte's public API retains SIMD.
single_api_filter!(SplitNativeSingleApiV1, Split64BloomFilter);

struct Fastbloom017(fastbloom::BloomFilter);
impl Filter for Fastbloom017 {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let mut bytes = 128;
        while bytes <= ((n * bpk as usize).max(512) / 8) {
            bytes *= 2;
        }
        Ok(Self(
            fastbloom::BloomFilter::with_num_bits(bytes * 8).expected_items(n),
        ))
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

struct BloomsdayPinned {
    filter: bloomsday::BlockedBloomFilter,
    bytes: usize,
}
impl Filter for BloomsdayPinned {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let mut bytes = 128;
        while bytes <= ((n * bpk as usize).max(512) / 8) {
            bytes *= 2;
        }
        // The pinned upstream constructor computes ceil(-ln(fpr)/ln(2)^2)
        // bits/key, then ceil(n*bits_per_key/256) 32-byte blocks. Choose the
        // midpoint of the rounding interval, not a claimed target FPR.
        let bits_per_key = bytes * 8 / n;
        let sizing_fpr = (-(bits_per_key as f64 - 0.5) * std::f64::consts::LN_2.powi(2)).exp();
        let rounded_bpk = (-sizing_fpr.ln() / std::f64::consts::LN_2.powi(2)).ceil() as usize;
        assert_eq!(rounded_bpk, bits_per_key);
        assert_eq!((n * rounded_bpk).div_ceil(256) * 32, bytes);
        Ok(Self {
            filter: bloomsday::BlockedBloomFilter::new_with_seed(n, sizing_fpr, 0),
            bytes,
        })
    }
    fn size_in_bytes(&self) -> usize {
        self.bytes
    }
    fn insert_hashes(&mut self, hashes: &[u64]) {
        for &hash in hashes {
            self.filter.insert_hash(hash);
        }
    }
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len());
        for (&hash, result) in hashes.iter().zip(out.iter_mut()) {
            *result = self.filter.may_match_hash(hash) as u32;
        }
    }
}

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
    let output = &mut output_storage[16..16 + c.q.max(c.batch)];
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
    let mut times = vec![];
    let mut total = vec![];
    for trial in 0..c.repeats {
        let start = Instant::now();
        for (input, out) in hashes
            .chunks(c.batch)
            .zip(output[..c.q].chunks_mut(c.batch))
        {
            lookup(&bf, input, out);
        }
        times.push(start.elapsed().as_secs_f64() * 1e9 / c.q as f64);
        if trial == 0 {
            query_validation::verify_output(&output[..c.q], checksum, "timed prehashed query");
        }
        consume(&output[..c.q]);
        let start = Instant::now();
        for (input, out) in raw_query
            .chunks(c.batch)
            .zip(output[..c.q].chunks_mut(c.batch))
        {
            for (h, &x) in scratch.iter_mut().zip(input) {
                *h = hash64(x);
            }
            lookup(&bf, &scratch[..input.len()], out);
        }
        total.push(start.elapsed().as_secs_f64() * 1e9 / c.q as f64);
        if trial == 0 {
            query_validation::verify_output(&output[..c.q], checksum, "timed hash+query");
        }
        consume(&output[..c.q]);
    }
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
        for &answer in &output[..len] {
            assert!(answer <= 1, "invalid calibration output");
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
    println!(
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
        median(&times),
        median(&total),
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
}
mod filter_selection;
mod query_validation;

const FILTER_NAMES: &[&str] = &[
    "Fastbloom017",
    "FastPatternBF",
    "BloomsdayPinned",
    "Split64Experimental",
    "FourSector16K8Experimental",
    "ByteSplitBloomFilter",
    "FourSectorBloomFilter",
    "Split64BloomFilter",
    "ByteNativeSingleApiV1",
    "ByteInlineLookupV1",
    "SplitNativeSingleApiV1",
    "SplitInlineLookupV1",
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
    let batch = number(5, 4096);
    let repeats = number(6, 5);
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
    println!("language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,hash_bits,hit_percent,present_queries,batch,repeats,seed,insert_ns,allocate_insert_ns,lookup_ns,hash_lookup_ns,absent_queries,false_positives,fpr,lookup_min_ns,lookup_max_ns,result_checksum,input_mode,hash_insert_ns,allocate_hash_insert_ns,insert_batch,hash_lookup_min_ns,hash_lookup_max_ns,calibration_absent_queries,calibration_false_positives");
    shuffle(&mut jobs, &mut rng);
    for name in jobs {
        match name {
            "FastPatternBF" => run::<BloomFilter<true>>(name, &inserted, &query, &c),
            "ByteSplitBloomFilter" => run::<ByteSplitBloomFilter>(name, &inserted, &query, &c),
            "FourSectorBloomFilter" => run::<FourSectorBloomFilter>(name, &inserted, &query, &c),
            "Split64BloomFilter" => run::<Split64BloomFilter>(name, &inserted, &query, &c),
            "ByteNativeSingleApiV1" => run::<ByteNativeSingleApiV1>(name, &inserted, &query, &c),
            "ByteInlineLookupV1" => run::<ByteInlineLookupV1>(name, &inserted, &query, &c),
            "SplitNativeSingleApiV1" => run::<SplitNativeSingleApiV1>(name, &inserted, &query, &c),
            "SplitInlineLookupV1" => run::<SplitInlineLookupV1>(name, &inserted, &query, &c),
            "Fastbloom017" => run::<Fastbloom017>(name, &inserted, &query, &c),
            "BloomsdayPinned" => run::<BloomsdayPinned>(name, &inserted, &query, &c),
            "Split64Experimental" => {
                run::<split64::Split64Experimental>(name, &inserted, &query, &c)
            }
            "FourSector16K8Experimental" => {
                run::<four_sector::FourSector16K8Experimental>(name, &inserted, &query, &c)
            }
            _ => unreachable!(),
        }
    }
}

#[cfg(test)]
mod single_api_tests {
    use super::*;

    fn family<B: Filter, S: Filter, I: Filter>() {
        for (n, bpk) in [(0, 8), (65_539, 8), (1 << 20, 16)] {
            let mut base = B::new(n, bpk).unwrap();
            let mut single = S::new(n, bpk).unwrap();
            let mut inline = I::new(n, bpk).unwrap();
            assert_eq!(base.size_in_bytes(), single.size_in_bytes());
            assert_eq!(base.size_in_bytes(), inline.size_in_bytes());
            let mut inserted: Vec<_> = (0..n.min(65_539) as u64).map(hash64).collect();
            if n != 0 {
                inserted.extend((0..1024).map(|i| (7u64 << 32) | (hash64(i) & 0xffff_ffff)));
                inserted.extend([0, u64::MAX]);
            }
            for chunk in inserted.chunks(7) {
                base.insert_hashes(chunk);
                single.insert_hashes(chunk);
                inline.insert_hashes(chunk);
            }
            base.insert_hashes(&inserted);
            single.insert_hashes(&inserted);
            inline.insert_hashes(&inserted);
            for len in (0..=131).chain([4096, 4097]) {
                for offset in 0..8 {
                    let input: Vec<_> = (0..offset + len)
                        .map(|i| {
                            if i % 3 == 0 && !inserted.is_empty() {
                                inserted[i % inserted.len()]
                            } else {
                                hash64(1_000_000 + i as u64)
                            }
                        })
                        .collect();
                    let input = &input[offset..];
                    let mut expected = vec![0xfeed; len + 2];
                    let mut actual_single = expected.clone();
                    let mut actual_inline = expected.clone();
                    base.lookup_hashes(input, &mut expected[1..len + 1]);
                    single.lookup_hashes(input, &mut actual_single[1..len + 1]);
                    inline.lookup_hashes(input, &mut actual_inline[1..len + 1]);
                    assert_eq!(
                        expected, actual_single,
                        "single n={n} len={len} offset={offset}"
                    );
                    assert_eq!(
                        expected, actual_inline,
                        "inline n={n} len={len} offset={offset}"
                    );
                    assert_eq!(expected[0], 0xfeed);
                    assert_eq!(expected[len + 1], 0xfeed);
                }
            }
            for hash in inserted {
                let mut a = [0];
                let mut b = [0];
                let mut c = [0];
                base.lookup_hashes(std::slice::from_ref(&hash), &mut a);
                single.lookup_hashes(std::slice::from_ref(&hash), &mut b);
                inline.lookup_hashes(std::slice::from_ref(&hash), &mut c);
                assert_eq!(a, [1]);
                assert_eq!(b, [1]);
                assert_eq!(c, [1]);
            }
        }
    }

    #[test]
    fn byte_controls_exact_outputs_and_guards() {
        family::<ByteSplitBloomFilter, ByteNativeSingleApiV1, ByteInlineLookupV1>();
    }
    #[test]
    fn split_controls_exact_outputs_and_guards() {
        family::<Split64BloomFilter, SplitNativeSingleApiV1, SplitInlineLookupV1>();
    }
    fn lengths<F: Filter>() {
        let filter = F::new(1, 8).unwrap();
        for (input_len, output_len) in [(0, 1), (1, 0), (1, 2), (3, 2)] {
            let input = vec![0; input_len];
            let mut output = vec![0xfeed; output_len];
            let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                filter.lookup_hashes(&input, &mut output);
            }));
            assert!(result.is_err());
            assert!(output.iter().all(|&value| value == 0xfeed));
        }
    }
    #[test]
    fn controls_reject_mismatched_lengths_before_writing() {
        lengths::<ByteSplitBloomFilter>();
        lengths::<ByteNativeSingleApiV1>();
        lengths::<ByteInlineLookupV1>();
        lengths::<Split64BloomFilter>();
        lengths::<SplitNativeSingleApiV1>();
        lengths::<SplitInlineLookupV1>();
    }
}
