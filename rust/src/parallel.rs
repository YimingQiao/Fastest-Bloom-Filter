//! Parallel batches partition writes by cache line; the atomic type is for overlapping writers/readers.
#[cfg(target_arch = "x86_64")]
use super::Line;
use super::{patterns, BloomFilter, SizeError};
use std::mem::MaybeUninit;
use std::sync::atomic::{AtomicU32, Ordering};
use std::thread;

const COUNTERS_PER_LINE: usize = 64 / std::mem::size_of::<usize>();
// Align the allocation as well as the row stride to prevent boundary false sharing.
#[repr(C, align(64))]
#[derive(Clone)]
struct HistogramLine([usize; COUNTERS_PER_LINE]);

pub(crate) fn workers(items: usize, requested: usize, limit: usize) -> usize {
    if items < (1 << 14) {
        return 1;
    }
    let requested = if requested == 0 {
        thread::available_parallelism().map_or(1, usize::from)
    } else {
        requested
    };
    requested.min(limit).min(items / 4096).clamp(1, 1024)
}
#[inline]
fn block<const P: bool>(h: u64, mask: u32) -> usize {
    let a = if P {
        (h >> 32) as u32
    } else {
        (h as u32 & ((1 << 17) - 1)) | (((h >> 32) as u32).wrapping_shl(14) & (511 << 17))
    };
    (a & mask) as usize
}
#[inline]
fn probe<const P: bool>(h: u64, mask: u32, table: &[u32; 32]) -> (usize, usize, u32, u32) {
    let a = block::<P>(h, mask);
    let lo = h as u32;
    let hi = (h >> 32) as u32;
    if P {
        (
            a,
            a ^ (8 + ((lo >> 20) & 7) as usize),
            table[(lo & 31) as usize].rotate_left(lo >> 5),
            table[((lo >> 10) & 31) as usize].rotate_left(lo >> 15),
        )
    } else {
        (
            a,
            a ^ (8 + (hi & 7) as usize),
            (1 << ((lo >> 17) & 31)) | (1 << ((lo >> 22) & 31)) | (1 << (lo >> 27)),
            (1 << ((hi >> 12) & 31))
                | (1 << ((hi >> 17) & 31))
                | (1 << ((hi >> 22) & 31))
                | (1 << (hi >> 27)),
        )
    }
}

impl<const P: bool> BloomFilter<P> {
    /// Number of workers used for bulk construction. Tiny inputs remain serial.
    pub fn build_workers(&self, n: usize, requested: usize) -> usize {
        workers(n, requested, self.lines.len())
    }
    /// Explicit peak scratch allocation; excludes allocator metadata and OS thread stacks.
    pub fn build_scratch_bytes(&self, n: usize, requested: usize) -> usize {
        let w = self.build_workers(n, requested);
        let row_lines = w.div_ceil(COUNTERS_PER_LINE);
        if w == 1 {
            0
        } else {
            n * 8
                + w * row_lines * 64
                + (w + 1) * std::mem::size_of::<usize>()
                + w * w * (std::mem::size_of::<&mut [u64]>() + std::mem::size_of::<usize>())
                + 2 * w * std::mem::size_of::<Vec<usize>>()
        }
    }
    /// Exclusive bulk insert. Histogram/scatter passes assign complete cache lines
    /// to workers, so the bitmap itself requires no atomic operations. Input order
    /// does not affect membership. Thread creation and partitioning are included.
    pub fn insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize) {
        let w = self.build_workers(hashes.len(), requested);
        if w == 1 {
            self.insert_hashes(hashes);
            return;
        }
        let row_lines = w.div_ceil(COUNTERS_PER_LINE);
        let lines = self.lines.len();
        let line_shift = lines.trailing_zeros();
        let mask = self.block_mask;
        let table = self.patterns;
        #[cfg(target_arch = "x86_64")]
        let use_simd = self.avx512;
        let shard =
            |h: u64| (((block::<P>(h, mask) >> 4) as u64 * w as u64) >> line_shift) as usize;
        let mut counts = vec![HistogramLine([0; COUNTERS_PER_LINE]); w * row_lines];
        thread::scope(|scope| {
            for (worker, row) in counts.chunks_mut(row_lines).enumerate() {
                let input = &hashes[hashes.len() * worker / w..hashes.len() * (worker + 1) / w];
                let shard = &shard;
                scope.spawn(move || {
                    for &h in input {
                        let part = shard(h);
                        row[part / COUNTERS_PER_LINE].0[part % COUNTERS_PER_LINE] += 1;
                    }
                });
            }
        });
        let mut starts = vec![0usize; w + 1];
        for part in 0..w {
            starts[part + 1] = starts[part]
                + (0..w)
                    .map(|worker| {
                        counts[worker * row_lines + part / COUNTERS_PER_LINE].0
                            [part % COUNTERS_PER_LINE]
                    })
                    .sum::<usize>();
        }
        let mut partitioned_storage = Vec::with_capacity(hashes.len());
        partitioned_storage.resize_with(hashes.len(), MaybeUninit::<u64>::uninit);
        // Give each scatter worker disjoint mutable slices, one per destination.
        // Safe split_at_mut establishes non-overlap without shared raw writes.
        let mut segments: Vec<Vec<&mut [MaybeUninit<u64>]>> =
            (0..w).map(|_| Vec::with_capacity(w)).collect();
        let mut remaining = &mut partitioned_storage[..];
        for part in 0..w {
            for worker in 0..w {
                let (piece, rest) = remaining.split_at_mut(
                    counts[worker * row_lines + part / COUNTERS_PER_LINE].0
                        [part % COUNTERS_PER_LINE],
                );
                segments[worker].push(piece);
                remaining = rest;
            }
        }
        thread::scope(|scope| {
            for (worker, mut pieces) in segments.into_iter().enumerate() {
                let input = &hashes[hashes.len() * worker / w..hashes.len() * (worker + 1) / w];
                let shard = &shard;
                scope.spawn(move || {
                    let mut cursor = vec![0usize; w];
                    for &h in input {
                        let part = shard(h);
                        pieces[part][cursor[part]].write(h);
                        cursor[part] += 1;
                    }
                });
            }
        });
        // SAFETY: histogram-derived disjoint slices cover the entire allocation;
        // each worker writes exactly its counted entries. A panic in scatter
        // propagates out of scope before this conversion can run.
        let partitioned = unsafe {
            std::slice::from_raw_parts(partitioned_storage.as_ptr().cast::<u64>(), hashes.len())
        };
        thread::scope(|scope| {
            let mut remaining = &mut self.lines[..];
            for part in 0..w {
                let begin = (part as u64 * lines as u64).div_ceil(w as u64) as usize;
                let end = ((part + 1) as u64 * lines as u64).div_ceil(w as u64) as usize;
                let (owned, rest) = remaining.split_at_mut(end - begin);
                remaining = rest;
                let input = &partitioned[starts[part]..starts[part + 1]];
                scope.spawn(move || {
                    #[cfg(target_arch = "x86_64")]
                    if P && use_simd {
                        // SAFETY: histogram/scatter placed only hashes owned by
                        // this complete cache-line slice into input; slices do
                        // not overlap and AVX-512 was detected at construction.
                        unsafe {
                            if owned.len() * 64 > (1 << 21) {
                                insert_partition_avx512::<true>(
                                    owned,
                                    begin * 16,
                                    mask,
                                    table,
                                    input,
                                );
                            } else {
                                insert_partition_avx512::<false>(
                                    owned,
                                    begin * 16,
                                    mask,
                                    table,
                                    input,
                                );
                            }
                        }
                        return;
                    }
                    for &h in input {
                        let (a, b, m1, m2) = probe::<P>(h, mask, table);
                        owned[a / 16 - begin].0[a % 16] |= m1;
                        owned[b / 16 - begin].0[b % 16] |= m2;
                    }
                });
            }
        });
    }
    /// Parallel read-only batch. Other read-only batches may run concurrently.
    pub fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        assert_eq!(hashes.len(), out.len());
        let w = workers(hashes.len(), requested, usize::MAX);
        if w == 1 {
            self.lookup_hashes(hashes, out);
            return;
        }
        thread::scope(|scope| {
            let mut remaining = out;
            for worker in 0..w {
                let begin = hashes.len() * worker / w;
                let end = hashes.len() * (worker + 1) / w;
                let (output, rest) = remaining.split_at_mut(end - begin);
                remaining = rest;
                let input = &hashes[begin..end];
                scope.spawn(move || self.lookup_hashes(input, output));
            }
        });
    }
}

// All hash addresses must belong to `lines` after subtracting `word_base`.
#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx512f")]
unsafe fn insert_partition_avx512<const PREFETCH: bool>(
    lines: &mut [Line],
    word_base: usize,
    block_mask: u32,
    table: &[u32; 32],
    hashes: &[u64],
) {
    use std::arch::x86_64::*;
    let table0 = _mm512_loadu_si512(table.as_ptr().cast());
    let table1 = _mm512_loadu_si512(table.as_ptr().add(16).cast());
    let base = lines.as_mut_ptr().cast::<u32>();
    let words = lines.len() * 16;
    let mut i = 0;
    while i + 8 <= hashes.len() {
        if PREFETCH && i + 72 <= hashes.len() {
            for j in 0..8 {
                let address = ((hashes[i + 64 + j] >> 32) as u32 & block_mask) as usize - word_base;
                debug_assert!(address < words);
                _mm_prefetch::<_MM_HINT_T2>(base.add(address).cast());
            }
        }
        let h = _mm512_loadu_si512(hashes.as_ptr().add(i).cast());
        let a = _mm512_and_si512(
            _mm512_shuffle_epi32::<0xf5>(h),
            _mm512_set1_epi32(block_mask as i32),
        );
        let delta = _mm512_or_si512(
            _mm512_set1_epi64(8i64 << 32),
            _mm512_and_si512(_mm512_slli_epi64::<12>(h), _mm512_set1_epi64(7i64 << 32)),
        );
        let index = _mm512_sub_epi32(
            _mm512_xor_si512(a, delta),
            _mm512_set1_epi32(word_base as i32),
        );
        let code = _mm512_srlv_epi32(
            _mm512_shuffle_epi32::<0xa0>(h),
            _mm512_set1_epi64(10i64 << 32),
        );
        let mask = _mm512_rolv_epi32(
            _mm512_permutex2var_epi32(table0, code, table1),
            _mm512_srli_epi32::<5>(code),
        );
        let indexes: [u32; 16] = std::mem::transmute(index);
        let masks: [u32; 16] = std::mem::transmute(mask);
        for j in 0..16 {
            debug_assert!((indexes[j] as usize) < words);
            *base.add(indexes[j] as usize) |= masks[j];
        }
        i += 8;
    }
    for &h in &hashes[i..] {
        let (a, b, m1, m2) = probe::<true>(h, block_mask, table);
        debug_assert!(
            a >= word_base && b >= word_base && a - word_base < words && b - word_base < words
        );
        *base.add(a - word_base) |= m1;
        *base.add(b - word_base) |= m2;
    }
}

#[repr(C, align(64))]
struct AtomicLine([AtomicU32; 16]);
impl Default for AtomicLine {
    fn default() -> Self {
        Self(std::array::from_fn(|_| AtomicU32::new(0)))
    }
}
/// Concurrent append-only filter with the same layout as FastPatternBloomFilter.
/// Queries overlapping unfinished inserts may miss those keys. Once completed
/// writers are synchronized (for example joined), queries have no false negatives.
/// Atomic loads/stores use Relaxed ordering; this type does not publish unrelated data.
pub struct AtomicFastPatternBloomFilter {
    lines: Vec<AtomicLine>,
    mask: u32,
    patterns: &'static [u32; 32],
}
impl AtomicFastPatternBloomFilter {
    pub fn new(keys: usize, bpk: u32) -> Result<Self, SizeError> {
        let words = BloomFilter::<true>::word_count(keys, bpk)?;
        Ok(Self {
            lines: (0..words / 16).map(|_| AtomicLine::default()).collect(),
            mask: (words - 1) as u32,
            patterns: if keys > words * 32 / 12 {
                &patterns::SPARSE
            } else {
                &patterns::DENSE
            },
        })
    }
    pub fn size_in_bytes(&self) -> usize {
        self.lines.len() * 64
    }
    #[inline]
    pub fn insert_hash(&self, h: u64) {
        let (a, b, m1, m2) = probe::<true>(h, self.mask, self.patterns);
        for (index, mask) in [(a, m1), (b, m2)] {
            let word = &self.lines[index / 16].0[index % 16];
            if word.load(Ordering::Relaxed) & mask != mask {
                word.fetch_or(mask, Ordering::Relaxed);
            }
        }
    }
    pub fn insert_hashes(&self, hashes: &[u64]) {
        for &h in hashes {
            self.insert_hash(h);
        }
    }
    #[inline]
    pub fn contains_hash(&self, h: u64) -> bool {
        let (a, b, m1, m2) = probe::<true>(h, self.mask, self.patterns);
        (self.lines[a / 16].0[a % 16].load(Ordering::Relaxed) & m1 == m1)
            & (self.lines[b / 16].0[b % 16].load(Ordering::Relaxed) & m2 == m2)
    }
    pub fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len());
        for (&h, v) in hashes.iter().zip(out.iter_mut()) {
            *v = self.contains_hash(h) as u32;
        }
    }
    pub fn insert_hashes_parallel(&self, hashes: &[u64], requested: usize) {
        let w = workers(hashes.len(), requested, usize::MAX);
        if w == 1 {
            self.insert_hashes(hashes);
            return;
        }
        thread::scope(|scope| {
            for worker in 0..w {
                let input = &hashes[hashes.len() * worker / w..hashes.len() * (worker + 1) / w];
                scope.spawn(move || self.insert_hashes(input));
            }
        });
    }
    pub fn lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize) {
        assert_eq!(hashes.len(), out.len());
        let w = workers(hashes.len(), requested, usize::MAX);
        if w == 1 {
            self.lookup_hashes(hashes, out);
            return;
        }
        thread::scope(|scope| {
            let mut remaining = out;
            for worker in 0..w {
                let begin = hashes.len() * worker / w;
                let end = hashes.len() * (worker + 1) / w;
                let (output, rest) = remaining.split_at_mut(end - begin);
                remaining = rest;
                let input = &hashes[begin..end];
                scope.spawn(move || self.lookup_hashes(input, output));
            }
        });
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{hash64, FastPatternBloomFilter};
    #[test]
    fn parallel_matches_serial() {
        for bpk in [4, 16] {
            for requested in [1, 2, 3, 7, 8] {
                let n = 65539;
                let hashes: Vec<_> = (0..n).map(|i| hash64(i as u64)).collect();
                let query: Vec<_> = (0..n * 2).map(|i| hash64(i as u64)).collect();
                let mut serial = FastPatternBloomFilter::new(n, bpk).unwrap();
                serial.insert_hashes(&hashes);
                let mut parallel = FastPatternBloomFilter::new(n, bpk).unwrap();
                parallel.insert_hashes_parallel(&hashes, requested);
                let atomic = AtomicFastPatternBloomFilter::new(n, bpk).unwrap();
                atomic.insert_hashes_parallel(&hashes, requested);
                let mut expected = vec![0; query.len()];
                let mut got = expected.clone();
                serial.lookup_hashes(&query, &mut expected);
                parallel.lookup_hashes_parallel(&query, &mut got, requested);
                assert_eq!(got, expected);
                atomic.lookup_hashes_parallel(&query, &mut got, requested);
                assert_eq!(got, expected);
            }
        }
    }
    #[test]
    fn overlapping_writers_and_readers() {
        use std::sync::atomic::{AtomicBool, Ordering};
        let bf = AtomicFastPatternBloomFilter::new(65536, 16).unwrap();
        let done = AtomicBool::new(false);
        let hashes: Vec<_> = (0..65536)
            .map(|i| (7u64 << 32) | (hash64(i) & 0xffff_ffff))
            .collect();
        let mut partitioned = FastPatternBloomFilter::new(hashes.len(), 16).unwrap();
        partitioned.insert_hashes_parallel(&hashes, 7);
        for &h in &hashes {
            assert!(partitioned.contains_hash(h));
        }
        let first = &hashes[..1024];
        bf.insert_hashes(first);
        thread::scope(|scope| {
            scope.spawn(|| {
                while !done.load(Ordering::Acquire) {
                    for &h in first {
                        assert!(bf.contains_hash(h));
                    }
                }
            });
            thread::scope(|writers| {
                for chunk in hashes.chunks(8192) {
                    writers.spawn(|| bf.insert_hashes(chunk));
                }
            });
            done.store(true, Ordering::Release);
        });
        for h in hashes {
            assert!(bf.contains_hash(h));
        }
    }
    #[test]
    fn empty_parallel() {
        let mut bf = FastPatternBloomFilter::new(0, 16).unwrap();
        bf.insert_hashes_parallel(&[], 8);
        bf.lookup_hashes_parallel(&[], &mut [], 8);
        let atomic = AtomicFastPatternBloomFilter::new(0, 16).unwrap();
        atomic.insert_hashes_parallel(&[], 8);
        atomic.lookup_hashes_parallel(&[], &mut [], 8);
    }
}
