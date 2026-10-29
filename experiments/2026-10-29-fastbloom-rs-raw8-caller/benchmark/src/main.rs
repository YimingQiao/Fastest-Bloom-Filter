use fastest_bloom_filter::FourSectorRange12BloomFilter;
use fastest_bloom_filter::{
    hash64, BloomFilter, ByteSplitBloomFilter, FourSectorBloomFilter, Split64BloomFilter, Split64RangeBloomFilter,
};
mod geometry;
mod sbbf;
use sbbf::SbbfSafePinned;
use std::{
    alloc::{alloc, dealloc, handle_alloc_error, Layout},
    hint::black_box,
    ops::{Deref, DerefMut},
    ptr::NonNull,
};

// Optional external baseline: no dependency is added to the native library.
trait Filter: Sized {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>>;
    fn size_in_bytes(&self) -> usize;
    fn contains_hash(&self, hash: u64) -> bool;
    fn insert_hashes(&mut self, hashes: &[u64]);
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]);
}
impl<const P: bool> Filter for BloomFilter<P> {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(BloomFilter::new(n, geometry::native_argument(n, bpk)?)?)
    }
    fn size_in_bytes(&self) -> usize {
        BloomFilter::size_in_bytes(self)
    }
    fn insert_hashes(&mut self, h: &[u64]) {
        BloomFilter::insert_hashes(self, h)
    }
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        BloomFilter::contains_hash(self, hash)
    }
    fn lookup_hashes(&self, h: &[u64], out: &mut [u32]) {
        BloomFilter::lookup_hashes(self, h, out)
    }
}
macro_rules! native_filter {
    ($filter:ty) => {
        impl Filter for $filter {
            fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
                Ok(<$filter>::new(n, geometry::native_argument(n, bpk)?)?)
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
native_filter!(FourSectorBloomFilter);
native_filter!(Split64BloomFilter);

impl Filter for Split64RangeBloomFilter {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        Ok(Self::with_byte_budget(geometry::bytes(n, bpk)?)?)
    }
    fn size_in_bytes(&self) -> usize { Self::size_in_bytes(self) }
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool { Self::contains_hash(self, hash) }
    fn insert_hashes(&mut self, hashes: &[u64]) { Self::insert_hashes(self, hashes) }
    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) { Self::lookup_hashes(self, hashes, out) }
}


include!("k12_adapter.rs");

struct Fastbloom017(fastbloom::BloomFilter);
impl Filter for Fastbloom017 {
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        self.0.contains_hash(hash)
    }
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let g = geometry::plan("Fastbloom017", n, bpk)?;
        let filter = fastbloom::BloomFilter::with_num_bits(g.logical_bytes * 8).expected_items(n);
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

struct BloomsdayPinned {
    filter: bloomsday::BlockedBloomFilter,
    bytes: usize,
}
impl Filter for BloomsdayPinned {
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        self.filter.may_match_hash(hash)
    }
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let bytes = geometry::bytes(n, bpk)?;
        // Sizing-only inverse. This is not a measured/claimed false-positive rate.
        let sizing_fpr = geometry::bloomsday_fpr(n, bpk)?;
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

include!("fixed_fastbloom.rs");

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

mod raw_contract;
mod fastbloom_rs_adapter;
mod reporter;
use raw_contract::{CommonHash, RawFilter};
use fastbloom_rs_adapter::FastbloomRsRaw;
#[path = "support/filter_selection.rs"]
mod filter_selection;
#[path = "support/query_validation.rs"]
mod query_validation;
include!("report.rs");
const FILTER_NAMES: &[&str] = &[
    "SbbfSafePinned",
    "Fastbloom017",
    "FastPatternBF",
    "BloomsdayPinned",
    "ByteSplitBloomFilter",
    "FourSectorBloomFilter",
    "Split64BloomFilter",
    "Split64RangeBloomFilter",
    "Fastbloom017K1",
    "Fastbloom017K2",
    "Fastbloom017K3",
    "Fastbloom017K4",
    "Fastbloom017K5",
    "Fastbloom017K6",
    "Fastbloom017K7",
    "Fastbloom017K8",
    "Fastbloom017K9",
    "Fastbloom017K10",
    "Fastbloom017K11",
    "Fastbloom017K12",
    "FourSectorRange12BloomFilter",
    "FastbloomRsRawK1",
    "FastbloomRsRawK2",
    "FastbloomRsRawK3",
    "FastbloomRsRawK4",
    "FastbloomRsRawK5",
    "FastbloomRsRawK6",
    "FastbloomRsRawK7",
    "FastbloomRsRawK8",
    "FastbloomRsRawK9",
    "FastbloomRsRawK10",
    "FastbloomRsRawK11",
    "FastbloomRsRawK12",
    "FastbloomRsRawK13",
    "FastbloomRsRawK14",
    "FastbloomRsRawK15",
    "FastbloomRsRawK16",
    "FastbloomRsRawK17",
    "FastbloomRsRawK18",
    "FastbloomRsRawK19",
    "FastbloomRsRawK20",
    "FastbloomRsRawK21",
    "FastbloomRsRawK22",
    "FastbloomRsRawK23",
    "FastbloomRsRawK24",
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
    let insert_batch = number(9, 4096); // independent CLI default, formal choice remains unfrozen
    let calibration_power = number(10, 0);
    assert!(
        (5..=26).contains(&power)
            && (12..=27).contains(&qp)
            && [16, 24, 32].contains(&bpk)
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
    for name in &jobs {
        geometry::plan(name, n, bpk as u32).expect("unsupported exact-capacity geometry");
    }
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
    eprintln!(
        "sbbf-rs 0.2.8 backend: {}",
        sbbf_rs::FilterFn::new().which()
    );
    report_header();
    shuffle(&mut jobs, &mut rng);
    for name in jobs {
        match name {
            "FastPatternBF" => report::<CommonHash<BloomFilter<true>>>(name, &inserted, &query, &c),
            "ByteSplitBloomFilter" => report::<CommonHash<ByteSplitBloomFilter>>(name, &inserted, &query, &c),
            "FourSectorBloomFilter" => report::<CommonHash<FourSectorBloomFilter>>(name, &inserted, &query, &c),
            "Split64BloomFilter" => report::<CommonHash<Split64BloomFilter>>(name, &inserted, &query, &c),
            "Split64RangeBloomFilter" => report::<CommonHash<Split64RangeBloomFilter>>(name, &inserted, &query, &c),
            "Fastbloom017" => report::<CommonHash<Fastbloom017>>(name, &inserted, &query, &c),
            "Fastbloom017K1" => report::<CommonHash<Fastbloom017K1>>(name, &inserted, &query, &c),
            "Fastbloom017K2" => report::<CommonHash<Fastbloom017K2>>(name, &inserted, &query, &c),
            "Fastbloom017K3" => report::<CommonHash<Fastbloom017K3>>(name, &inserted, &query, &c),
            "Fastbloom017K4" => report::<CommonHash<Fastbloom017K4>>(name, &inserted, &query, &c),
            "Fastbloom017K5" => report::<CommonHash<Fastbloom017K5>>(name, &inserted, &query, &c),
            "Fastbloom017K6" => report::<CommonHash<Fastbloom017K6>>(name, &inserted, &query, &c),
            "Fastbloom017K7" => report::<CommonHash<Fastbloom017K7>>(name, &inserted, &query, &c),
            "Fastbloom017K8" => report::<CommonHash<Fastbloom017K8>>(name, &inserted, &query, &c),
            "Fastbloom017K9" => report::<CommonHash<Fastbloom017K9>>(name, &inserted, &query, &c),
            "Fastbloom017K10" => report::<CommonHash<Fastbloom017K10>>(name, &inserted, &query, &c),
            "Fastbloom017K11" => report::<CommonHash<Fastbloom017K11>>(name, &inserted, &query, &c),
            "Fastbloom017K12" => report::<CommonHash<Fastbloom017K12>>(name, &inserted, &query, &c),
            "BloomsdayPinned" => report::<CommonHash<BloomsdayPinned>>(name, &inserted, &query, &c),
            "SbbfSafePinned" => report::<CommonHash<SbbfSafePinned>>(name, &inserted, &query, &c),
            "FourSectorRange12BloomFilter" => report::<CommonHash<FourSectorRange12BloomFilter>>(name, &inserted, &query, &c),
            "FastbloomRsRawK1" => report::<FastbloomRsRaw<1>>(name, &inserted, &query, &c),
            "FastbloomRsRawK2" => report::<FastbloomRsRaw<2>>(name, &inserted, &query, &c),
            "FastbloomRsRawK3" => report::<FastbloomRsRaw<3>>(name, &inserted, &query, &c),
            "FastbloomRsRawK4" => report::<FastbloomRsRaw<4>>(name, &inserted, &query, &c),
            "FastbloomRsRawK5" => report::<FastbloomRsRaw<5>>(name, &inserted, &query, &c),
            "FastbloomRsRawK6" => report::<FastbloomRsRaw<6>>(name, &inserted, &query, &c),
            "FastbloomRsRawK7" => report::<FastbloomRsRaw<7>>(name, &inserted, &query, &c),
            "FastbloomRsRawK8" => report::<FastbloomRsRaw<8>>(name, &inserted, &query, &c),
            "FastbloomRsRawK9" => report::<FastbloomRsRaw<9>>(name, &inserted, &query, &c),
            "FastbloomRsRawK10" => report::<FastbloomRsRaw<10>>(name, &inserted, &query, &c),
            "FastbloomRsRawK11" => report::<FastbloomRsRaw<11>>(name, &inserted, &query, &c),
            "FastbloomRsRawK12" => report::<FastbloomRsRaw<12>>(name, &inserted, &query, &c),
            "FastbloomRsRawK13" => report::<FastbloomRsRaw<13>>(name, &inserted, &query, &c),
            "FastbloomRsRawK14" => report::<FastbloomRsRaw<14>>(name, &inserted, &query, &c),
            "FastbloomRsRawK15" => report::<FastbloomRsRaw<15>>(name, &inserted, &query, &c),
            "FastbloomRsRawK16" => report::<FastbloomRsRaw<16>>(name, &inserted, &query, &c),
            "FastbloomRsRawK17" => report::<FastbloomRsRaw<17>>(name, &inserted, &query, &c),
            "FastbloomRsRawK18" => report::<FastbloomRsRaw<18>>(name, &inserted, &query, &c),
            "FastbloomRsRawK19" => report::<FastbloomRsRaw<19>>(name, &inserted, &query, &c),
            "FastbloomRsRawK20" => report::<FastbloomRsRaw<20>>(name, &inserted, &query, &c),
            "FastbloomRsRawK21" => report::<FastbloomRsRaw<21>>(name, &inserted, &query, &c),
            "FastbloomRsRawK22" => report::<FastbloomRsRaw<22>>(name, &inserted, &query, &c),
            "FastbloomRsRawK23" => report::<FastbloomRsRaw<23>>(name, &inserted, &query, &c),
            "FastbloomRsRawK24" => report::<FastbloomRsRaw<24>>(name, &inserted, &query, &c),
            _ => unreachable!(),
        }
    }
}

#[cfg(test)]
mod tests;
