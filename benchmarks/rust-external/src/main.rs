use fastest_bloom_filter::{hash64, BloomFilter};
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
    repeats: usize,
    seed: u64,
    key_base: u64,
}
fn run<F: Filter>(name: &str, raw_insert: &[u64], raw_query: &[u64], c: &Config) {
    let mut inserted = Aligned::<u64>::new(c.n);
    let mut hashes = Aligned::<u64>::new(c.q);
    let mut scratch = Aligned::<u64>::new(c.batch);
    for (h, &x) in inserted.iter_mut().zip(raw_insert) {
        *h = hash64(x);
    }
    for (h, &x) in hashes.iter_mut().zip(raw_query) {
        *h = hash64(x);
    }
    let mut output_storage = Aligned::<u32>::new(c.q.max(c.batch) + 32);
    let output = &mut output_storage[16..16 + c.q.max(c.batch)];
    let mut bf = F::new(c.n, c.bpk).unwrap();
    let mut insert_times = vec![];
    let mut build_times = vec![];
    for _ in 0..c.repeats {
        let a = Instant::now();
        let mut fresh = F::new(c.n, c.bpk).unwrap();
        let ready = Instant::now();
        for chunk in inserted.chunks(c.batch) {
            insert(&mut fresh, chunk);
        }
        let b = Instant::now();
        insert_times.push((b - ready).as_secs_f64() * 1e9 / c.n as f64);
        build_times.push((b - a).as_secs_f64() * 1e9 / c.n as f64);
        let len = c.n.min(c.batch);
        lookup(&fresh, &inserted[..len], &mut output[..len]);
        consume(&output[..len]);
    }
    for chunk in inserted.chunks(c.batch) {
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
    for _ in 0..c.repeats {
        let start = Instant::now();
        for (input, out) in hashes
            .chunks(c.batch)
            .zip(output[..c.q].chunks_mut(c.batch))
        {
            lookup(&bf, input, out);
        }
        times.push(start.elapsed().as_secs_f64() * 1e9 / c.q as f64);
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
        consume(&output[..c.q]);
    }
    let fpr = if absent == 0 {
        "nan".to_owned()
    } else {
        (fp as f64 / absent as f64).to_string()
    };
    println!(
        "rust,{name},{},{},{},{},{},64,{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}",
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
        checksum
    );
}
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
    assert!(
        (5..=26).contains(&power)
            && (12..=27).contains(&qp)
            && (1..=32).contains(&bpk)
            && hit <= 100
            && batch > 0
            && batch <= 1 << qp
            && repeats > 0
            && args.len() <= 9,
        "invalid arguments"
    );
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
        repeats: repeats as usize,
        seed,
        key_base,
    };
    println!("language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,hash_bits,hit_percent,present_queries,batch,repeats,seed,insert_ns,allocate_insert_ns,lookup_ns,hash_lookup_ns,absent_queries,false_positives,fpr,lookup_min_ns,lookup_max_ns,result_checksum");
    let selection = args.get(8).map(String::as_str).unwrap_or("");
    let mut jobs = vec![];
    for (name, pattern) in [("Fastbloom017", false), ("FastPatternBF", true)] {
        if selection.is_empty() || selection.split(',').any(|x| x == name) {
            jobs.push((name, pattern));
        }
    }
    assert!(!jobs.is_empty(), "no matching filters");
    shuffle(&mut jobs, &mut rng);
    for (name, pattern) in jobs {
        if pattern {
            run::<BloomFilter<true>>(name, &inserted, &query, &c);
        } else {
            run::<Fastbloom017>(name, &inserted, &query, &c);
        }
    }
}
