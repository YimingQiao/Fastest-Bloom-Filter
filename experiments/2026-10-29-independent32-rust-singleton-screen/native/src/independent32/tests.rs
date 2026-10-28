use super::*;

fn splitmix(state: &mut u64) -> u64 {
    *state = state.wrapping_add(0x9e3779b97f4a7c15);
    let mut x = *state;
    x = (x ^ (x >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    x = (x ^ (x >> 27)).wrapping_mul(0x94d049bb133111eb);
    x ^ (x >> 31)
}

fn hashes(n: usize) -> Vec<u64> {
    let mut state = 0x243f6a8885a308d3;
    (0..n).map(|_| splitmix(&mut state)).collect()
}

fn words(filter: &Independent32BloomFilter) -> Vec<u32> {
    filter
        .lines
        .iter()
        .flat_map(|line| line.0.iter().flatten().copied())
        .collect()
}

// Byte-addressed independent oracle: division/remainders express the fields
// without using any production bucket/mask helper or vector implementation.
fn oracle_insert(bitmap: &mut [u8], hash: u64) {
    let bucket = ((hash / (1u64 << 41)) % (bitmap.len() / 32) as u64) as usize;
    for sector in 0..8 {
        let bit = ((hash / 32u64.pow(sector)) % 32) as usize;
        bitmap[bucket * 32 + sector as usize * 4 + bit / 8] |= 1 << (bit % 8);
    }
}

fn oracle_contains(bitmap: &[u8], hash: u64) -> u32 {
    let bucket = ((hash / (1u64 << 41)) % (bitmap.len() / 32) as u64) as usize;
    (0..8).all(|sector| {
        let bit = ((hash / 32u64.pow(sector)) % 32) as usize;
        bitmap[bucket * 32 + sector as usize * 4 + bit / 8] & (1 << (bit % 8)) != 0
    }) as u32
}

fn backends(filter: &Independent32BloomFilter) -> Vec<(bool, bool)> {
    let mut result = vec![(false, false)];
    if filter.avx2 {
        result.push((true, false));
    }
    if filter.vbmi {
        result.push((true, true));
    }
    result
}

#[test]
fn allocation_and_two_bucket_alignment() {
    for (n, bpk, bytes) in [
        (0, 1, 128),
        (1, 16, 128),
        (64, 8, 128),
        (64, 16, 256),
        (65, 16, 256),
        (1024, 8, 2048),
        (1024, 16, 4096),
    ] {
        let filter = Independent32BloomFilter::new(n, bpk).unwrap();
        assert_eq!(filter.size_in_bytes(), bytes);
        assert_eq!(filter.lines.len(), filter.lines.capacity());
        assert_eq!(std::mem::size_of::<Line>(), 64);
        assert_eq!(filter.lines.as_ptr() as usize % 64, 0);
        assert_eq!(filter.bucket_mask as usize + 1, bytes / 32);
    }
    assert!(matches!(
        Independent32BloomFilter::new(1, 0),
        Err(SizeError::InvalidSize)
    ));
    assert!(matches!(
        Independent32BloomFilter::new(usize::MAX, 2),
        Err(SizeError::InvalidSize)
    ));
    assert!(matches!(
        Independent32BloomFilter::new(1 << 27, 16),
        Err(SizeError::CapacityExceeded)
    ));
    let minimum = Independent32BloomFilter::new(1, 1).unwrap();
    assert_eq!(minimum.build_scratch_bytes(0, 8), 0);
    if cfg!(feature = "disable-avx512") {
        assert!(!minimum.vbmi);
    }
}

#[test]
fn every_probe_field_and_ignored_bit_match_simd() {
    let filter = Independent32BloomFilter::new(65536, 8).unwrap();
    let mut inputs = vec![0, u64::MAX, 1 << 40];
    inputs.extend((0..64).map(|bit| 1u64 << bit));
    for sector in 0..8 {
        inputs.extend((0..32).map(|bit| (bit as u64) << (sector * 5)));
    }
    inputs.extend(hashes(4096));
    for hash in inputs {
        let expected: [u32; 8] = std::array::from_fn(|j| 1 << ((hash >> (j * 5)) & 31));
        for (j, &value) in expected.iter().enumerate() {
            assert_eq!(
                value,
                Independent32BloomFilter::scalar_mask(hash ^ (1 << 40), j)
            );
        }
        assert_eq!(filter.bucket(hash), filter.bucket(hash ^ (1 << 40)));
        #[cfg(target_arch = "x86_64")]
        unsafe {
            use std::arch::x86_64::*;
            let mut actual = [0u32; 8];
            if filter.avx2 {
                _mm256_storeu_si256(
                    actual.as_mut_ptr().cast(),
                    Independent32BloomFilter::mask_avx2(hash),
                );
                assert_eq!(actual, expected);
            }
            if filter.vbmi {
                _mm256_storeu_si256(
                    actual.as_mut_ptr().cast(),
                    Independent32BloomFilter::mask_vbmi(hash),
                );
                assert_eq!(actual, expected);
            }
        }
    }
}

#[test]
fn full_bitmap_oracle_all_backends_tails_and_duplicates() {
    let input = hashes(10240);
    for n in [0, 1, 17, 1000, 4096] {
        for bpk in [1, 8, 16] {
            let empty = Independent32BloomFilter::new(n, bpk).unwrap();
            let mut reference = vec![0u8; empty.size_in_bytes()];
            for &hash in &input[..2048] {
                oracle_insert(&mut reference, hash);
            }
            let expected: Vec<u32> = reference
                .chunks_exact(4)
                .map(|bytes| u32::from_le_bytes(bytes.try_into().unwrap()))
                .collect();
            for (avx2, vbmi) in backends(&empty) {
                let mut filter = empty.clone();
                (filter.avx2, filter.vbmi) = (avx2, vbmi);
                for batch in [1, 7, 31, 4096] {
                    filter.lines.fill(Line::default());
                    for chunk in input[..2048].chunks(batch) {
                        filter.insert_hashes(chunk);
                    }
                    assert_eq!(words(&filter), expected);
                    filter.insert_hashes(&input[..2048]);
                    assert_eq!(words(&filter), expected);
                    assert!(input[..2048].iter().all(|&hash| filter.contains_hash(hash)));
                }
                let expected_query: Vec<_> = input
                    .iter()
                    .map(|&hash| oracle_contains(&reference, hash))
                    .collect();
                for length in (0..=131).chain([4096, 4097, 4103]) {
                    for offset in 0..8 {
                        let query = &input[offset..offset + length];
                        let mut output = vec![0xfeed; length + 2];
                        filter.lookup_hashes(query, &mut output[1..length + 1]);
                        assert_eq!(output[0], 0xfeed);
                        assert_eq!(output[length + 1], 0xfeed);
                        assert_eq!(
                            &output[1..length + 1],
                            &expected_query[offset..offset + length]
                        );
                    }
                }
            }
        }
    }
}

#[test]
fn mismatch_panics_before_any_output_write() {
    let filter = Independent32BloomFilter::new(17, 8).unwrap();
    let mut output = [0xfeed; 2];
    let caught = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        filter.lookup_hashes(&[0], &mut output);
    }));
    assert!(caught.is_err());
    assert_eq!(output, [0xfeed; 2]);
}

#[test]
fn parallel_complete_line_ownership_and_readers() {
    fn send_sync<T: Send + Sync>() {}
    send_sync::<Independent32BloomFilter>();
    let input = hashes(65536);
    for shape in 0..3 {
        let input: Vec<_> = input
            .iter()
            .enumerate()
            .map(|(i, &hash)| match shape {
                1 => (hash & ((1 << 40) - 1)) | (((i & 1) as u64) << 41),
                2 => (hash & ((1 << 40) - 1)) | (((4095 - (i % 4)) as u64) << 41),
                _ => hash,
            })
            .collect();
        let empty = Independent32BloomFilter::new(65536, 8).unwrap();
        let mut reference = vec![0u8; empty.size_in_bytes()];
        for &hash in &input {
            oracle_insert(&mut reference, hash);
        }
        let expected: Vec<_> = reference
            .chunks_exact(4)
            .map(|bytes| u32::from_le_bytes(bytes.try_into().unwrap()))
            .collect();
        for (avx2, vbmi) in backends(&empty) {
            for workers in [1, 2, 3, 7] {
                let mut filter = empty.clone();
                (filter.avx2, filter.vbmi) = (avx2, vbmi);
                filter.insert_hashes_parallel(&input, workers);
                assert_eq!(words(&filter), expected);
                let mut output = vec![0; input.len()];
                filter.lookup_hashes_parallel(&input, &mut output, workers);
                assert!(output.iter().all(|&answer| answer == 1));
                let queries = hashes(65536);
                filter.lookup_hashes_parallel(&queries, &mut output, workers);
                assert!(queries
                    .iter()
                    .zip(&output)
                    .all(|(&hash, &answer)| answer == oracle_contains(&reference, hash)));
                std::thread::scope(|scope| {
                    for part in queries.chunks(16384) {
                        let filter = &filter;
                        let reference = &reference;
                        scope.spawn(move || {
                            assert!(part.iter().all(|&hash| filter.contains_hash(hash) as u32
                                == oracle_contains(reference, hash)));
                        });
                    }
                });
            }
        }
    }
}

include!("singleton_tests.rs");
