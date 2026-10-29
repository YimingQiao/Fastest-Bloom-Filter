use super::*;

const ORACLE_SALTS: [u64; 8] = [
    0x47b6137b, 0x44974d91, 0x8824ad5b, 0xa2b7289d, 0x705495c7, 0x2df1424b, 0x9efc4947, 0x5c6bfb31,
];
fn next(state: &mut u64) -> u64 {
    *state = state.wrapping_add(0x9e3779b97f4a7c15);
    let mut z = *state;
    z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
    z ^ (z >> 31)
}
fn masks(h: u64) -> [u64; 8] {
    ORACLE_SALTS.map(|salt| 1 << (((h as u32 as u64 * salt) % (1u64 << 32)) / (1 << 26)))
}
fn index(h: u64, lines: usize) -> usize {
    (((h as u128 / (1u128 << 32)) * lines as u128) / (1u128 << 32)) as usize
}
fn bitmap(lines: usize, hashes: &[u64]) -> Vec<Line> {
    let mut result = vec![Line::default(); lines];
    for &h in hashes {
        for (word, mask) in result[index(h, lines)].0.iter_mut().zip(masks(h)) {
            *word |= mask;
        }
    }
    result
}
fn answer(words: &[Line], h: u64) -> u32 {
    words[index(h, words.len())]
        .0
        .iter()
        .zip(masks(h))
        .all(|(&word, mask)| word & mask == mask) as u32
}

#[test]
fn range_sizing_and_actual_allocation() {
    for lines in [2, 3, 5, 7, 31, 257, 4097] {
        let f = Split64RangeBloomFilter::with_byte_budget(lines * 64 + 63).unwrap();
        assert_eq!(f.size_in_bytes(), lines * 64);
        assert_eq!(f.lines.as_ptr() as usize % 64, 0);
    }
    for budget in [0, 1, 127, (1 << 28) + 1, usize::MAX] {
        assert!(Split64RangeBloomFilter::with_byte_budget(budget).is_err());
    }
    for (n, bpk) in [(0, 16), (1, 0), (usize::MAX, 16), (1, 8)] {
        assert!(Split64RangeBloomFilter::new(n, bpk).is_err());
    }
    assert_eq!(
        Split64RangeBloomFilter::new(1024, 24)
            .unwrap()
            .size_in_bytes(),
        3072
    );
    let f = Split64RangeBloomFilter::with_byte_budget(1 << 28).unwrap();
    assert_eq!(f.size_in_bytes(), 1 << 28);
}

#[test]
fn exact_partition_boundaries_and_reduced_domain() {
    for lines in 2..=97usize {
        for workers in 1..=lines.min(16) {
            let partition = range_parallel::Partition::new(lines, workers);
            for x in 0..4096u64 {
                let high = x << 20;
                let line = (high as u128 * lines as u128 / (1u128 << 32)) as usize;
                assert_eq!(partition.owner(high << 32), line * workers / lines);
            }
        }
    }
    for lines in [2usize, 3, 5, 7, 31, 257, 4097, (1 << 22) - 1, 1 << 22] {
        for workers in [1usize, 2, 3, 5, 8, 17, 1024]
            .into_iter()
            .filter(|&w| w <= lines)
        {
            let partition = range_parallel::Partition::new(lines, workers);
            for part in 0..=workers {
                let line = (part * lines).div_ceil(workers);
                let boundary = (line as u128 * (1u128 << 32)).div_ceil(lines as u128);
                for delta in [-1i128, 0, 1] {
                    let high = boundary as i128 + delta;
                    if !(0..=u32::MAX as i128).contains(&high) {
                        continue;
                    }
                    let h = (high as u64) << 32;
                    let physical = index(h, lines);
                    let owner = partition.owner(h);
                    assert_eq!(owner, physical * workers / lines);
                    assert!(physical >= (owner * lines).div_ceil(workers));
                    assert!(physical < ((owner + 1) * lines).div_ceil(workers));
                }
            }
        }
    }
    assert_eq!(range_parallel::Partition::new(3, 2).owner(1 << 63), 0);
}

#[test]
fn oracle_bitmaps_backends_tails_and_required_bits() {
    for count in [2usize, 3, 5, 7, 31, 257, 4097, 32769] {
        let mut state = 0x243f6a8885a308d3;
        let mut hashes: Vec<_> = (0..2048).map(|_| next(&mut state)).collect();
        for line in 0..=count.min(4097) {
            let boundary = ((line as u128) << 32).div_ceil(count as u128);
            for delta in [-1i128, 0, 1] {
                let high = boundary as i128 + delta;
                if (0..=u32::MAX as i128).contains(&high) {
                    hashes.push(((high as u64) << 32) | next(&mut state) as u32 as u64);
                }
            }
        }
        let expected = bitmap(count, &hashes);
        let queries: Vec<_> = (0..4127).map(|_| next(&mut state)).collect();
        for force_scalar in [false, true] {
            let mut f = Split64RangeBloomFilter::with_byte_budget(count * 64 + 31).unwrap();
            if force_scalar {
                f.avx512 = false;
                f.avx2 = false;
            }
            for chunk in hashes.chunks(37) {
                f.insert_hashes(chunk);
            }
            f.insert_hashes(&hashes[..17]);
            assert_eq!(f.lines, expected);
            for &h in &hashes {
                assert!(f.contains_hash(h));
            }
            for length in (0..=131).chain([4096, 4097, 4119]) {
                for offset in [0, 1, 7] {
                    let input = &queries[offset..offset + length];
                    let mut out = vec![0xfeed; length + 2];
                    f.lookup_hashes(input, &mut out[1..1 + length]);
                    assert_eq!(out[0], 0xfeed);
                    assert_eq!(out[length + 1], 0xfeed);
                    for (&h, &v) in input.iter().zip(&out[1..1 + length]) {
                        assert_eq!(v, answer(&expected, h));
                    }
                }
            }
            for h in [0, 1, u64::MAX, 1 << 63, 0xfedcba9876543210] {
                f.lines.fill(Line::default());
                f.insert_hash(h);
                for (sector, mask) in masks(h).into_iter().enumerate() {
                    f.lines[index(h, count)].0[sector] &= !mask;
                    assert!(!f.contains_hash(h));
                    let mut out = [9];
                    f.lookup_hashes(&[h], &mut out);
                    assert_eq!(out, [0]);
                    f.lines[index(h, count)].0[sector] |= mask;
                }
            }
        }
    }
}

#[test]
fn parallel_complete_bitmap_and_output_parity() {
    let mut state = 0x243f6a8885a308d3;
    let hashes: Vec<_> = (0..32768).map(|_| next(&mut state)).collect();
    let queries: Vec<_> = (0..32768).map(|_| next(&mut state)).collect();
    for count in [2usize, 3, 5, 7, 31, 257, 4097] {
        for length in [0usize, 17, 16384, 32768] {
            let input = &hashes[..length];
            let expected = bitmap(count, input);
            let answers: Vec<_> = queries.iter().map(|&h| answer(&expected, h)).collect();
            for workers in [0usize, 1, 2, 3, 5, 8] {
                let mut f = Split64RangeBloomFilter::with_byte_budget(count * 64).unwrap();
                f.insert_hashes_parallel(input, workers);
                f.insert_hashes_parallel(input, workers);
                assert_eq!(f.lines, expected);
                let mut out = vec![9; queries.len()];
                f.lookup_hashes_parallel(&queries, &mut out, workers);
                assert_eq!(out, answers);
            }
        }
    }
}

#[test]
fn output_length_and_scratch_overflow_guards() {
    let f = Split64RangeBloomFilter::with_byte_budget(192).unwrap();
    let mut out = [73, 73];
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(
        || f.lookup_hashes(&[0], &mut out)
    ))
    .is_err());
    assert_eq!(out, [73, 73]);
    assert!(std::panic::catch_unwind(|| f.build_scratch_bytes(usize::MAX, 2)).is_err());
    assert_eq!(f.build_scratch_bytes(usize::MAX, 1), 0);
}
