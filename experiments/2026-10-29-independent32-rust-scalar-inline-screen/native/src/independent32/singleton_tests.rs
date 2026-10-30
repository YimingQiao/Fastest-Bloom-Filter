#[test]
fn singleton_public_batch_matches_oracle_with_output_offsets() {
    let input = hashes(8192);
    let empty = Independent32BloomFilter::new(65536, 8).unwrap();
    for inserted in [0, 128, 4096] {
        let mut reference = vec![0u8; empty.size_in_bytes()];
        for &hash in &input[..inserted] {
            oracle_insert(&mut reference, hash);
        }
        for (avx2, vbmi) in backends(&empty) {
            let mut filter = empty.clone();
            (filter.avx2, filter.vbmi) = (avx2, vbmi);
            filter.insert_hashes(&input[..inserted]);
            let before = words(&filter);
            for offset in 0..16 {
                for &hash in input[..32].iter().chain(&input[4096..4128]) {
                    let mut answer = [0xfeed; 18];
                    filter.lookup_hashes(
                        std::slice::from_ref(&hash),
                        &mut answer[offset..offset + 1],
                    );
                    assert_eq!(answer[offset], oracle_contains(&reference, hash));
                    assert_eq!(answer[offset], filter.contains_hash(hash) as u32);
                    assert!(answer[..offset]
                        .iter()
                        .chain(&answer[offset + 1..])
                        .all(|&x| x == 0xfeed));
                }
            }
            assert_eq!(words(&filter), before);
        }
    }
}

#[test]
fn singleton_mismatches_panic_before_writing_any_guard() {
    let empty = Independent32BloomFilter::new(17, 8).unwrap();
    for (avx2, vbmi) in backends(&empty) {
        let mut filter = empty.clone();
        (filter.avx2, filter.vbmi) = (avx2, vbmi);
        for (input_len, output_len) in [(0, 1), (1, 0), (1, 2), (2, 1)] {
            let mut answer = [0xfeed; 5];
            let caught = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                filter.lookup_hashes(&[0, u64::MAX][..input_len], &mut answer[1..1 + output_len]);
            }));
            assert!(caught.is_err());
            assert_eq!(answer, [0xfeed; 5]);
        }
    }
}
