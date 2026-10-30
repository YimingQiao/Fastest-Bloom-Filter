//! Shared scheduling for layouts whose writes stay within one cache line.
use crate::layout_parallel::build_workers;
use std::{mem::MaybeUninit, thread};

const COUNTERS_PER_LINE: usize = 64 / std::mem::size_of::<usize>();
#[repr(C, align(64))]
#[derive(Clone)]
struct HistogramLine([usize; COUNTERS_PER_LINE]);

// Equivalent to n * part / parts without overflowing for a large valid slice.
fn split_point(n: usize, part: usize, parts: usize) -> usize {
    (n / parts) * part + (n % parts) * part / parts
}

// Only for layouts whose cache line is high32(hash) * lines >> 32.
// `insert` receives only hashes belonging to its exclusive owned line slice.
// Concrete layout modules keep these closures private; no public unsafe contract.
pub(crate) fn insert<L, Insert>(lines: &mut [L], hashes: &[u64], requested: usize, insert: Insert)
where
    L: Send,
    Insert: Fn(&mut [L], usize, &[u64]) + Sync,
{
    let w = build_workers(hashes.len(), requested, lines.len());
    if w == 1 {
        insert(lines, 0, hashes);
        return;
    }
    let line_count = lines.len();
    let partition = Partition::new(line_count, w);
    let shard = |hash| partition.owner(hash);
    let row_lines = w.div_ceil(COUNTERS_PER_LINE);
    let mut counts = vec![HistogramLine([0; COUNTERS_PER_LINE]); w * row_lines];
    thread::scope(|scope| {
        for (worker, row) in counts.chunks_mut(row_lines).enumerate() {
            let input = &hashes
                [split_point(hashes.len(), worker, w)..split_point(hashes.len(), worker + 1, w)];
            let shard = &shard;
            scope.spawn(move || {
                for &hash in input {
                    let part = shard(hash);
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
    let mut storage = Vec::with_capacity(hashes.len());
    storage.resize_with(hashes.len(), MaybeUninit::<u64>::uninit);
    let mut segments: Vec<Vec<&mut [MaybeUninit<u64>]>> =
        (0..w).map(|_| Vec::with_capacity(w)).collect();
    let mut remaining = &mut storage[..];
    for part in 0..w {
        for worker in 0..w {
            let count =
                counts[worker * row_lines + part / COUNTERS_PER_LINE].0[part % COUNTERS_PER_LINE];
            let (owned, rest) = remaining.split_at_mut(count);
            segments[worker].push(owned);
            remaining = rest;
        }
    }
    thread::scope(|scope| {
        for (worker, mut pieces) in segments.into_iter().enumerate() {
            let input = &hashes
                [split_point(hashes.len(), worker, w)..split_point(hashes.len(), worker + 1, w)];
            let shard = &shard;
            scope.spawn(move || {
                let mut cursor = vec![0usize; w];
                for &hash in input {
                    let part = shard(hash);
                    pieces[part][cursor[part]].write(hash);
                    cursor[part] += 1;
                }
            });
        }
    });
    // SAFETY: histogram-derived disjoint slices cover storage exactly, and scatter
    // wrote every counted element. A worker panic exits scope before conversion.
    let partitioned =
        unsafe { std::slice::from_raw_parts(storage.as_ptr().cast::<u64>(), hashes.len()) };
    thread::scope(|scope| {
        let mut remaining = lines;
        for part in 0..w {
            let begin = (part as u64 * line_count as u64).div_ceil(w as u64) as usize;
            let end = ((part + 1) as u64 * line_count as u64).div_ceil(w as u64) as usize;
            let (owned, rest) = remaining.split_at_mut(end - begin);
            remaining = rest;
            let input = &partitioned[starts[part]..starts[part + 1]];
            let insert = &insert;
            scope.spawn(move || insert(owned, begin, input));
        }
    });
}

// Divisible line counts have exact equal-sized shards. In that case nested
// floors simplify to a single multiply-high; see OWNERSHIP.md for the proof.
#[derive(Clone, Copy)]
pub(crate) struct Partition {
    lines: u64,
    workers: u64,
    divisible: bool,
}
impl Partition {
    pub(crate) fn new(lines: usize, workers: usize) -> Self {
        assert!(lines > 0 && lines <= 1 << 22 && workers > 0 && workers <= lines);
        Self {
            lines: lines as u64,
            workers: workers as u64,
            divisible: lines.is_multiple_of(workers),
        }
    }
    #[inline]
    pub(crate) fn owner(self, hash: u64) -> usize {
        let high = hash >> 32;
        if self.divisible {
            ((high * self.workers) >> 32) as usize
        } else {
            ((((high * self.lines) >> 32) * self.workers) / self.lines) as usize
        }
    }
}
