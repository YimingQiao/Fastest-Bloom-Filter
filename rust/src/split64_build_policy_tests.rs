use crate::{
    layout_parallel, ByteSplitBloomFilter, FourSectorBloomFilter, Split64BloomFilter,
    Split64RangeBloomFilter,
};

#[test]
fn exact_request_boundaries_and_other_layouts() {
    for n in [0, 1, 16383, 16384, 65535, 65536, 65537, usize::MAX] {
        for bytes in [128, 262143, 262144, 262145, 262208, 524288] {
            for requested in [0, 1, 4, 8] {
                let expected = if n <= 65536 && bytes <= 262144 {
                    1
                } else {
                    requested
                };
                assert_eq!(super::build_request(n, bytes, requested), expected);
            }
        }
    }
    let four = FourSectorBloomFilter::new(131072, 8).unwrap();
    let byte = ByteSplitBloomFilter::new(131072, 8).unwrap();
    assert_eq!(four.size_in_bytes(), 262144);
    assert_eq!(byte.size_in_bytes(), 262144);
    assert_eq!(four.build_workers(65536, 8), 8);
    assert_eq!(byte.build_workers(65536, 8), 8);
}

fn next(state: &mut u64) -> u64 {
    *state = state.wrapping_add(0x9e3779b97f4a7c15);
    let mut z = *state;
    z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
    z ^ (z >> 31)
}

macro_rules! check {
    ($make:expr, $bytes:expr, $n:expr, $requested:expr, $hotspot:expr) => {{
        let (bytes, n, requested, hotspot) = ($bytes, $n, $requested, $hotspot);
        let mut state = 0x243f6a8885a308d3;
        let old: Vec<_> = (0..if hotspot { 4096 } else { 0 })
            .map(|_| next(&mut state))
            .collect();
        let hashes: Vec<_> = (0..n)
            .map(|_| {
                let h = next(&mut state);
                if hotspot {
                    h & 0xffffffff
                } else {
                    h
                }
            })
            .collect();
        let mut queries: Vec<_> = (0..32771).map(|_| next(&mut state)).collect();
        for i in (0..queries.len()).step_by(3) {
            queries[i] = hashes[i % hashes.len()];
        }
        let mut serial = $make;
        let mut parallel = $make;
        assert_eq!(serial.size_in_bytes(), bytes);
        assert_eq!(parallel.size_in_bytes(), bytes);
        let effective = if n <= 65536 && bytes <= 262144 {
            1
        } else {
            requested
        };
        // Observe the unchanged native scheduler under the same actual affinity.
        let workers = layout_parallel::build_workers(n, effective, bytes / 64);
        assert_eq!(parallel.build_workers(n, requested), workers);
        assert_eq!(
            parallel.build_scratch_bytes(n, requested),
            layout_parallel::scratch_bytes(n, effective, bytes / 64)
        );
        serial.insert_hashes(&old);
        parallel.insert_hashes(&old);
        serial.insert_hashes(&hashes);
        parallel.insert_hashes_parallel(&hashes, requested);
        parallel.insert_hashes_parallel(&hashes, requested);
        for input in [&old, &hashes] {
            let mut present = vec![0; input.len()];
            parallel.lookup_hashes(input, &mut present);
            assert!(present.iter().all(|&v| v == 1));
        }
        let mut expected = vec![0; queries.len()];
        let mut out = vec![0xfeed; queries.len() + 2];
        serial.lookup_hashes(&queries, &mut expected);
        parallel.lookup_hashes_parallel(&queries, &mut out[1..queries.len() + 1], requested);
        assert_eq!(out[0], 0xfeed);
        assert_eq!(out[queries.len() + 1], 0xfeed);
        assert_eq!(expected, out[1..queries.len() + 1]);
        parallel.insert_hashes_parallel(&[], requested);
        parallel.lookup_hashes_parallel(&[], &mut [], requested);
    }};
}

#[test]
fn public_incremental_boundaries_and_auto_request() {
    for range in [false, true] {
        for (bytes, n, requested, hotspot) in [
            (262144, 65536, 1, false),
            (262144, 65537, 8, false),
            (262144, 65536, 4, true),
            (if range { 262208 } else { 524288 }, 65536, 8, false),
            (if range { 262208 } else { 524288 }, 65536, 0, true),
            (262144, 65536, 8, true),
        ] {
            if range {
                check!(
                    Split64RangeBloomFilter::with_byte_budget(bytes).unwrap(),
                    bytes,
                    n,
                    requested,
                    hotspot
                );
            } else {
                check!(
                    Split64BloomFilter::new(bytes / 2, 8).unwrap(),
                    bytes,
                    n,
                    requested,
                    hotspot
                );
            }
        }
    }
}
