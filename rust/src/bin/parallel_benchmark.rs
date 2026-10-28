use fastest_bloom_filter::{hash64, AtomicFastPatternBloomFilter, FastPatternBloomFilter};
use std::{hint::black_box, time::Instant};
struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9e3779b97f4a7c15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
        z ^ (z >> 31)
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
fn workers(n: usize, t: usize) -> usize {
    if n < 1 << 14 {
        1
    } else {
        let t = if t == 0 {
            std::thread::available_parallelism().map_or(1, usize::from)
        } else {
            t
        };
        t.min(n / 4096).clamp(1, 1024)
    }
}
enum Filter {
    Plain(FastPatternBloomFilter),
    Atomic(AtomicFastPatternBloomFilter),
}
impl Filter {
    fn new(n: usize, bpk: u32, mode: usize) -> Self {
        if mode == 2 {
            Self::Atomic(AtomicFastPatternBloomFilter::new(n, bpk).unwrap())
        } else {
            Self::Plain(FastPatternBloomFilter::new(n, bpk).unwrap())
        }
    }
    fn bytes(&self) -> usize {
        match self {
            Self::Plain(bf) => bf.size_in_bytes(),
            Self::Atomic(bf) => bf.size_in_bytes(),
        }
    }
    fn insert(&mut self, h: &[u64], mode: usize, t: usize) {
        match self {
            Self::Plain(bf) => {
                if mode == 0 {
                    bf.insert_hashes(h)
                } else {
                    bf.insert_hashes_parallel(h, t)
                }
            }
            Self::Atomic(bf) => bf.insert_hashes_parallel(h, t),
        }
    }
    fn lookup(&self, h: &[u64], o: &mut [u32], mode: usize, t: usize) {
        match self {
            Self::Plain(bf) => {
                if mode == 0 {
                    bf.lookup_hashes(h, o)
                } else {
                    bf.lookup_hashes_parallel(h, o, t)
                }
            }
            Self::Atomic(bf) => {
                if mode == 0 {
                    bf.lookup_hashes(h, o)
                } else {
                    bf.lookup_hashes_parallel(h, o, t)
                }
            }
        }
    }
}
struct Config {
    bpk: u32,
    threads: usize,
    reps: usize,
    seed: u64,
    hit: u64,
}
fn run(mode: usize, keys: &[u64], query: &[u64], truth: &[bool], c: &Config) {
    let name = [
        "FastPatternSerial",
        "FastPatternPartitioned",
        "FastPatternAtomic",
    ][mode];
    let mut out = vec![0; query.len()];
    let mut check = vec![0; 4096];
    let mut build = vec![];
    let mut lookup = vec![];
    let (mut checksum, mut fp, mut absent, mut bytes, mut scratch, mut bw, mut qw) =
        (0u64, 0usize, 0usize, 0usize, 0usize, 1usize, 1usize);
    for _ in 0..c.reps {
        let mut bf = Filter::new(keys.len(), c.bpk, mode);
        bytes = bf.bytes();
        if mode == 1 {
            if let Filter::Plain(f) = &bf {
                scratch = f.build_scratch_bytes(keys.len(), c.threads);
                bw = f.build_workers(keys.len(), c.threads);
            }
        }
        if mode != 0 {
            qw = workers(query.len(), c.threads);
            if mode == 2 {
                bw = workers(keys.len(), c.threads);
            }
        }
        let a = Instant::now();
        bf.insert(keys, mode, c.threads);
        build.push(a.elapsed().as_secs_f64() * 1e9 / keys.len() as f64);
        for chunk in keys.chunks(check.len()) {
            bf.lookup(chunk, &mut check[..chunk.len()], 0, 1);
            assert!(
                check[..chunk.len()].iter().all(|&x| x == 1),
                "false negative after parallel build"
            );
        }
        bf.lookup(query, &mut out, mode, c.threads);
        let a = Instant::now();
        bf.lookup(query, &mut out, mode, c.threads);
        lookup.push(a.elapsed().as_secs_f64() * 1e9 / query.len() as f64);
        checksum = 14695981039346656037;
        fp = 0;
        absent = 0;
        for (&result, &present) in out.iter().zip(truth) {
            assert!(result <= 1 && (!present || result == 1));
            if !present {
                absent += 1;
                fp += result as usize;
            }
            checksum = (checksum ^ result as u64).wrapping_mul(1099511628211);
        }
        black_box(checksum);
    }
    let fpr = if absent == 0 {
        "nan".to_owned()
    } else {
        (fp as f64 / absent as f64).to_string()
    };
    println!(
        "rust,{name},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}",
        keys.len(),
        query.len(),
        c.bpk,
        bytes,
        c.threads,
        bw,
        qw,
        scratch,
        c.reps,
        c.seed,
        c.hit,
        median(&build),
        median(&lookup),
        absent,
        fp,
        fpr,
        checksum,
        build.iter().copied().fold(f64::INFINITY, f64::min),
        build.iter().copied().fold(0.0, f64::max),
        lookup.iter().copied().fold(f64::INFINITY, f64::min),
        lookup.iter().copied().fold(0.0, f64::max)
    );
}
fn main() {
    let args: Vec<_> = std::env::args().collect();
    let num = |i: usize, d: u64| {
        if let Some(s) = args.get(i) {
            assert!(!s.is_empty() && s.bytes().all(|b| b.is_ascii_digit()));
            s.parse::<u64>().unwrap()
        } else {
            d
        }
    };
    let kp = num(1, 20);
    let bpk = num(2, 16);
    let qp = num(3, 22);
    let threads = num(4, 4);
    let reps = num(5, 3);
    let seed = num(6, 42);
    let hit = num(7, 0);
    assert!(
        (5..=26).contains(&kp)
            && (12..=27).contains(&qp)
            && (1..=32).contains(&bpk)
            && threads <= 1024
            && reps > 0
            && hit <= 100
            && args.len() <= 8
    );
    let n = 1usize << kp;
    let q = 1usize << qp;
    assert!(n * (bpk as usize) < (1usize << 31));
    let mut rng = Rng(seed);
    let base = rng.next() % ((1u64 << 32) - n as u64 - q as u64);
    let mut keys: Vec<_> = (0..n).map(|i| hash64(base + i as u64)).collect();
    for i in (2..=n).rev() {
        keys.swap(i - 1, (rng.next() % i as u64) as usize);
    }
    let mut truth: Vec<_> = (0..q).map(|i| (i as u64) % 100 < hit).collect();
    let mut query: Vec<_> = (0..q)
        .map(|i| {
            hash64(
                base + if truth[i] {
                    rng.next() % n as u64
                } else {
                    (n + i) as u64
                },
            )
        })
        .collect();
    for i in (2..=q).rev() {
        let j = (rng.next() % i as u64) as usize;
        query.swap(i - 1, j);
        truth.swap(i - 1, j);
    }
    println!("language,filter,keys,queries,requested_bpk,filter_bytes,threads,build_workers,query_workers,build_scratch_bytes,repeats,seed,hit_percent,insert_ns,lookup_ns,absent_queries,false_positives,fpr,result_checksum,insert_min_ns,insert_max_ns,lookup_min_ns,lookup_max_ns");
    let mut order = vec![0, 1, 2];
    for i in (2..=order.len()).rev() {
        order.swap(i - 1, (rng.next() % i as u64) as usize);
    }
    let c = Config {
        bpk: bpk as u32,
        threads: threads as usize,
        reps: reps as usize,
        seed,
        hit,
    };
    for mode in order {
        run(mode, &keys, &query, &truth, &c);
    }
}
