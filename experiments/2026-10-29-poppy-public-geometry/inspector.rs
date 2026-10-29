//! Constructor/allocation proof only. No throughput timer and no key insertion.
use poppy_filters::{v2::BloomFilter, OptLevel, Params};
use std::alloc::{GlobalAlloc, Layout, System};
use std::io::{self, Write};
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering::Relaxed};

struct CountingAllocator;
static LIVE: AtomicUsize = AtomicUsize::new(0);
static PHASE: AtomicBool = AtomicBool::new(false);
static BASE: AtomicUsize = AtomicUsize::new(0);
static PEAK: AtomicUsize = AtomicUsize::new(0);

fn added(bytes: usize) {
    let current = LIVE.fetch_add(bytes, Relaxed) + bytes;
    if PHASE.load(Relaxed) {
        PEAK.fetch_max(current.saturating_sub(BASE.load(Relaxed)), Relaxed);
    }
}

unsafe impl GlobalAlloc for CountingAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let p = unsafe { System.alloc(layout) };
        if !p.is_null() {
            added(layout.size());
        }
        p
    }
    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        let p = unsafe { System.alloc_zeroed(layout) };
        if !p.is_null() {
            added(layout.size());
        }
        p
    }
    unsafe fn dealloc(&self, p: *mut u8, layout: Layout) {
        LIVE.fetch_sub(layout.size(), Relaxed);
        unsafe {
            System.dealloc(p, layout);
        }
    }
    unsafe fn realloc(&self, p: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        let q = unsafe { System.realloc(p, layout, new_size) };
        if !q.is_null() {
            LIVE.fetch_sub(layout.size(), Relaxed);
            added(new_size);
        }
        q
    }
}

#[global_allocator]
static ALLOC: CountingAllocator = CountingAllocator;

fn begin() -> usize {
    assert!(!PHASE.load(Relaxed));
    let before = LIVE.load(Relaxed);
    BASE.store(before, Relaxed);
    PEAK.store(0, Relaxed);
    PHASE.store(true, Relaxed);
    before
}

fn end(before: usize) -> (usize, usize) {
    PHASE.store(false, Relaxed);
    (
        LIVE.load(Relaxed)
            .checked_sub(before)
            .expect("unexpected phase deallocation"),
        PEAK.load(Relaxed),
    )
}

// Keep exactly 56 metadata bytes; the cache body between the two fields is discarded.
struct MetadataSink {
    header: [u8; 48],
    buckets: [u8; 8],
    offset: usize,
    bucket_offset: Option<usize>,
}

impl MetadataSink {
    fn new() -> Self {
        Self {
            header: [0; 48],
            buckets: [0; 8],
            offset: 0,
            bucket_offset: None,
        }
    }
    fn field(&self, start: usize) -> u64 {
        u64::from_le_bytes(self.header[start..start + 8].try_into().unwrap())
    }
    fn bucket_count(&self) -> u64 {
        let start = self.bucket_offset.expect("missing header");
        assert!(self.offset >= start + 8, "truncated bucket count");
        u64::from_le_bytes(self.buckets)
    }
}

impl Write for MetadataSink {
    fn write(&mut self, bytes: &[u8]) -> io::Result<usize> {
        let end = self
            .offset
            .checked_add(bytes.len())
            .ok_or_else(|| io::Error::other("offset overflow"))?;
        if self.offset < 48 {
            let take = bytes.len().min(48 - self.offset);
            self.header[self.offset..self.offset + take].copy_from_slice(&bytes[..take]);
            if end >= 48 {
                let cache_bits = usize::try_from(self.field(40)).map_err(io::Error::other)?;
                let cache_bytes = cache_bits
                    .checked_add(7)
                    .ok_or_else(|| io::Error::other("cache overflow"))?
                    / 8;
                self.bucket_offset = Some(
                    48usize
                        .checked_add(cache_bytes)
                        .ok_or_else(|| io::Error::other("cache offset overflow"))?,
                );
            }
        }
        if let Some(start) = self.bucket_offset {
            let lo = self.offset.max(start);
            let hi = end.min(
                start
                    .checked_add(8)
                    .ok_or_else(|| io::Error::other("bucket offset overflow"))?,
            );
            if lo < hi {
                self.buckets[lo - start..hi - start]
                    .copy_from_slice(&bytes[lo - self.offset..hi - self.offset]);
            }
        }
        self.offset = end;
        Ok(bytes.len())
    }
    fn flush(&mut self) -> io::Result<()> {
        Ok(())
    }
}

fn policy(s: &str) -> OptLevel {
    match s {
        "none" => OptLevel::None,
        "space" => OptLevel::Space,
        "speed" => OptLevel::Speed,
        "best" => OptLevel::Best,
        _ => panic!("unknown fixed public policy"),
    }
}

fn inspect(line: &str) {
    let fields: Vec<_> = line.split('\t').collect();
    assert_eq!(fields.len(), 9);
    let id = fields[0];
    assert!(id.starts_with("poppy-") && id[6..].bytes().all(|b| b.is_ascii_digit()));
    let n: usize = fields[1].parse().unwrap();
    assert!(matches!(n, 65536 | 33554432));
    let opt = policy(fields[2]);
    let fpp_bits = u64::from_str_radix(fields[3], 16).unwrap();
    let fpp = f64::from_bits(fpp_bits);
    let expected_c: usize = fields[4].parse().unwrap();
    let expected_buckets: usize = fields[5].parse().unwrap();
    let expected_cache: usize = fields[6].parse().unwrap();
    let expected_k: u64 = fields[7].parse().unwrap();
    let expected_bytes: usize = fields[8].parse().unwrap();
    assert!(fpp.is_finite() && fpp > 0.0 && fpp < 1.0);
    assert!(expected_bytes > 0 && expected_bytes <= 256 * 1024 * 1024);
    assert_eq!(expected_bytes, expected_buckets * 4096 + expected_cache);
    // Independently evaluate the public argument-derived capacity using Rust's f64 path.
    let derived_c = (32768.0 * 2.0f64.ln().powf(2.0) / fpp.ln()).abs() as usize;
    assert_eq!(derived_c, expected_c);
    let before = begin();
    let bf = Params::new(n, fpp)
        .opt(opt)
        .try_into_v2()
        .expect("public constructor rejected frozen Params");
    let (owned, constructor_peak) = end(before);
    assert_eq!(
        owned, expected_bytes,
        "constructor-owned live allocation must charge cache and buckets"
    );
    assert_eq!(bf.size_in_bytes(), owned);
    assert_eq!(bf.capacity(), n, "real n changed in public constructor");
    assert_eq!(bf.fpp().to_bits(), fpp_bits);
    assert!(bf.data.is_empty());
    assert_eq!(bf.count_estimate(), 0);
    assert_eq!(bf.count_ones(), 0);
    let mut sink = MetadataSink::new();
    let inspect_before = begin();
    bf.write(&mut sink)
        .expect("public streaming serializer failed");
    let (inspection_live, inspection_peak) = end(inspect_before);
    assert_eq!(inspection_live, 0, "serializer scratch must be temporary");
    assert_eq!(sink.header[0], 2);
    assert_eq!(sink.header[1], opt as u8);
    assert_eq!(&sink.header[2..8], &[0u8; 6]);
    assert_eq!(sink.field(8), n as u64);
    assert_eq!(sink.field(16), fpp_bits);
    assert_eq!(sink.field(24), expected_k);
    assert_eq!(sink.field(32), 0);
    assert_eq!(sink.field(40), (expected_cache * 8) as u64);
    assert_eq!(sink.bucket_count(), expected_buckets as u64);
    assert_eq!(sink.offset, 56 + owned);
    drop(bf);
    assert_eq!(
        LIVE.load(Relaxed),
        before,
        "constructor-owned allocation leaked"
    );
    println!("{{\"id\":\"{id}\",\"n\":{n},\"policy\":\"{}\",\"fpp_bits\":\"{:016x}\",\"capacity\":{derived_c},\"buckets\":{expected_buckets},\"cache_bytes\":{expected_cache},\"probes\":{expected_k},\"owned_bytes\":{owned},\"constructor_peak_bytes\":{constructor_peak},\"inspection_peak_bytes\":{inspection_peak},\"inline_object_bytes\":{},\"retained_metadata_bytes\":56,\"serialized_bytes\":{},\"allocator_bookkeeping_bytes\":\"not included in requested allocation size\",\"filter_inserts\":0,\"timings\":false}}", fields[2], fpp_bits, std::mem::size_of::<BloomFilter>(), sink.offset);
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    assert_eq!(args.len(), 2, "requires one frozen constructor TSV");
    let input = std::fs::read_to_string(&args[1]).expect("cannot read constructor ledger");
    let mut lines = input.lines();
    assert_eq!(
        lines.next(),
        Some("id\tn\tpolicy\tfpp_bits\tcapacity\tbuckets\tcache_bytes\tprobes\tbacking_bytes")
    );
    for line in lines {
        inspect(line);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn metadata_skips_cache_across_arbitrary_write_boundaries() {
        for cache in [0usize, 1, 8192, 4 * 1024 * 1024] {
            let mut stream = vec![0xa5; 56 + cache + 4096 * 3];
            stream[..48].fill(0);
            stream[40..48].copy_from_slice(&((cache * 8) as u64).to_le_bytes());
            stream[48 + cache..56 + cache].copy_from_slice(&3u64.to_le_bytes());
            for chunk in [1, 7, 47, 48, 49, 8191, 8192, 65536] {
                let mut sink = MetadataSink::new();
                for part in stream.chunks(chunk) {
                    sink.write_all(part).unwrap();
                }
                assert_eq!(sink.field(40), (cache * 8) as u64);
                assert_eq!(sink.bucket_count(), 3);
                assert_eq!(sink.offset, stream.len());
            }
        }
    }
    #[test]
    #[should_panic(expected = "truncated bucket count")]
    fn truncated_metadata_rejected() {
        let mut sink = MetadataSink::new();
        sink.write_all(&[0; 55]).unwrap();
        sink.bucket_count();
    }
}
