//! Public-call code-generation fixture only; no timing or private-kernel access.
use independent32_singleton_experiment::{hash64, Independent32BloomFilter};

#[no_mangle]
#[inline(never)]
pub fn independent32_public_prehashed(
    filter: &Independent32BloomFilter,
    input: &[u64],
    out: &mut [u32],
) {
    assert_eq!(input.len(), out.len());
    for (&hash, answer) in input.iter().zip(out) {
        *answer = filter.contains_hash(hash) as u32;
    }
}

#[no_mangle]
#[inline(never)]
pub fn independent32_public_fused(
    filter: &Independent32BloomFilter,
    input: &[u64],
    out: &mut [u32],
) {
    assert_eq!(input.len(), out.len());
    for (&raw, answer) in input.iter().zip(out) {
        *answer = filter.contains_hash(hash64(raw)) as u32;
    }
}

fn main() {
    let mut filter = Independent32BloomFilter::new(1024, 16).unwrap();
    let raw: Vec<_> = (0..1024).collect();
    let hashes: Vec<_> = raw.iter().copied().map(hash64).collect();
    filter.insert_hashes(&hashes);
    let mut out = vec![0; hashes.len()];
    independent32_public_prehashed(std::hint::black_box(&filter), &hashes, &mut out);
    assert!(out.iter().all(|&answer| answer == 1));
    independent32_public_fused(std::hint::black_box(&filter), &raw, &mut out);
    assert!(out.iter().all(|&answer| answer == 1));
    std::hint::black_box(out);
}
