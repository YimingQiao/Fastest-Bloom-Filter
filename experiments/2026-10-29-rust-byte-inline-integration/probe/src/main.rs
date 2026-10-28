use fastest_bloom_filter::{hash64, ByteSplitBloomFilter};
use std::hint::black_box;

#[inline(never)]
pub fn byte_public_contains_loop(filter: &ByteSplitBloomFilter, input: &[u64], out: &mut [u32]) {
    assert_eq!(input.len(), out.len());
    for (&hash, answer) in input.iter().zip(out.iter_mut()) {
        *answer = filter.contains_hash(hash) as u32;
    }
}

fn main() {
    let mut filter = ByteSplitBloomFilter::new(4096, 8).unwrap();
    let inserted: Vec<_> = (0..4096).map(hash64).collect();
    filter.insert_hashes(&inserted);
    let queries: Vec<_> = (0..8192).map(hash64).collect();
    let mut output = vec![0; queries.len()];
    byte_public_contains_loop(
        black_box(&filter),
        black_box(&queries),
        black_box(&mut output),
    );
    let mut expected = vec![0; queries.len()];
    filter.lookup_hashes(&queries, &mut expected);
    assert_eq!(output, expected);
    assert!(output[..inserted.len()].iter().all(|&answer| answer == 1));
    let checksum = output.iter().enumerate().fold(0u64, |sum, (i, &answer)| {
        sum.wrapping_add((i as u64 + 1).wrapping_mul(answer as u64))
    });
    println!(
        "backend={} inserted={} queries={} checksum={checksum}; full outputs match public batch API; no timing",
        filter.backend(),
        inserted.len(),
        queries.len()
    );
}
