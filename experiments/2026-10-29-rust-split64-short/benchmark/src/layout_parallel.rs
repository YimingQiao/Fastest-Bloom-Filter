//! Shared scheduling for layouts whose writes stay within one cache line.
use crate::{parallel::workers, SizeError};
use std::{mem::MaybeUninit, thread};

const COUNTERS_PER_LINE: usize = 64 / std::mem::size_of::<usize>();
#[repr(C, align(64))]
#[derive(Clone)]
struct HistogramLine([usize; COUNTERS_PER_LINE]);

// Equivalent to n * part / parts without overflowing for a large valid slice.
fn split_point(n: usize, part: usize, parts: usize) -> usize {
    (n / parts) * part + (n % parts) * part / parts
}

pub(crate) fn line_count(keys: usize, bits_per_key: u32) -> Result<usize, SizeError> {
    if bits_per_key == 0 {
        return Err(SizeError::InvalidSize);
    }
    let bits = keys
        .checked_mul(bits_per_key as usize)
        .ok_or(SizeError::InvalidSize)?
        .max(512);
    if bits >= 1usize << 31 {
        return Err(SizeError::CapacityExceeded);
    }
    let mut words = 32;
    while words <= bits / 32 {
        words *= 2;
    }
    Ok(words / 16)
}

pub(crate) fn backends() -> (bool, bool) {
    #[cfg(target_arch = "x86_64")]
    {
        let avx2 = std::is_x86_feature_detected!("avx2");
        let avx512 =
            !cfg!(feature = "disable-avx512") && avx2 && std::is_x86_feature_detected!("avx512f");
        (avx512, avx2)
    }
    #[cfg(not(target_arch = "x86_64"))]
    {
        (false, false)
    }
}

pub(crate) fn backend(avx512: bool, avx2: bool) -> &'static str {
    if avx512 {
        "avx512"
    } else if avx2 {
        "avx2"
    } else {
        "scalar"
    }
}

pub(crate) fn build_workers(n: usize, requested: usize, lines: usize) -> usize {
    workers(n, requested, lines)
}

pub(crate) fn scratch_bytes(n: usize, requested: usize, lines: usize) -> usize {
    let w = build_workers(n, requested, lines);
    if w == 1 {
        return 0;
    }
    let row_lines = w.div_ceil(COUNTERS_PER_LINE);
    let bytes = || -> Option<usize> {
        let hashes = n.checked_mul(8)?;
        let counts = w.checked_mul(row_lines)?.checked_mul(64)?;
        let starts = w
            .checked_add(1)?
            .checked_mul(std::mem::size_of::<usize>())?;
        let descriptors =
            std::mem::size_of::<&mut [u64]>().checked_add(std::mem::size_of::<usize>())?;
        let scatter = w.checked_mul(w)?.checked_mul(descriptors)?;
        let vectors = w
            .checked_mul(2)?
            .checked_mul(std::mem::size_of::<Vec<usize>>())?;
        [hashes, counts, starts, scatter, vectors]
            .into_iter()
            .try_fold(0usize, usize::checked_add)
    };
    bytes().expect("build scratch size overflow")
}

// `line_of` must be the global cache-line index of every write performed for h.
// `insert` receives only hashes belonging to its exclusive owned line slice.
// Concrete layout modules keep these closures private; no public unsafe contract.
pub(crate) fn insert<L, Index, Insert>(
    lines: &mut [L],
    hashes: &[u64],
    requested: usize,
    line_of: Index,
    insert: Insert,
) where
    L: Send,
    Index: Fn(u64) -> usize + Sync,
    Insert: Fn(&mut [L], usize, &[u64]) + Sync,
{
    let w = build_workers(hashes.len(), requested, lines.len());
    if w == 1 {
        insert(lines, 0, hashes);
        return;
    }
    let line_count = lines.len();
    debug_assert!(line_count.is_power_of_two());
    let line_shift = line_count.trailing_zeros();
    let shard = |hash| ((line_of(hash) as u64 * w as u64) >> line_shift) as usize;
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

pub(crate) fn lookup<Lookup>(hashes: &[u64], out: &mut [u32], requested: usize, lookup: Lookup)
where
    Lookup: Fn(&[u64], &mut [u32]) + Sync,
{
    assert_eq!(hashes.len(), out.len(), "one output is required per input");
    let w = workers(hashes.len(), requested, usize::MAX);
    if w == 1 {
        lookup(hashes, out);
        return;
    }
    thread::scope(|scope| {
        let mut remaining = out;
        for worker in 0..w {
            let begin = split_point(hashes.len(), worker, w);
            let end = split_point(hashes.len(), worker + 1, w);
            let (owned, rest) = remaining.split_at_mut(end - begin);
            remaining = rest;
            let input = &hashes[begin..end];
            let lookup = &lookup;
            scope.spawn(move || lookup(input, owned));
        }
    });
}
