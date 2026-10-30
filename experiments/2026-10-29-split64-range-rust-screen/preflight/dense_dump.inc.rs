// Correctness-only full-output fixture. Both audit executables include these
// exact bytes; construction arguments are the sole old/new sizing difference.
fn fingerprint(values: &[u64]) -> u64 {
    values.iter().fold(14695981039346656037u64, |sum, &x| {
        (sum ^ x).wrapping_mul(1099511628211)
    })
}

fn dump<F: Filter>(name: &str, n: usize, actual_cap: u32, constructor_bpk: u32) {
    let mut filter = F::new(n, constructor_bpk).unwrap();
    let inserted: Vec<_> = (0..n as u64).map(hash64).collect();
    for chunk in inserted.chunks(37) {
        filter.insert_hashes(chunk);
    }
    filter.insert_hashes(&inserted);
    for chunk in inserted.chunks(31) {
        let mut output = vec![0; chunk.len()];
        filter.lookup_hashes(chunk, &mut output);
        assert!(output.iter().all(|&x| x == 1), "full inserted false negative");
        assert!(chunk.iter().all(|&h| filter.contains_hash(h)));
    }
    let queries: Vec<_> = (0..4097usize)
        .map(|i| if i % 4 == 0 { inserted[i % n] } else { hash64(n as u64 + (1 << 20) + i as u64) })
        .collect();
    let expected: Vec<_> = queries.iter().map(|&h| u32::from(filter.contains_hash(h))).collect();
    filter.lookup_hashes(&[], &mut []);
    for batch in [1, 2, 7, 31, 4096] {
        let mut guarded = vec![0xfeed; queries.len() + 2];
        for (input, output) in queries.chunks(batch).zip(guarded[1..queries.len() + 1].chunks_mut(batch)) {
            filter.lookup_hashes(input, output);
        }
        assert_eq!(guarded[0], 0xfeed);
        assert_eq!(guarded[queries.len() + 1], 0xfeed);
        assert_eq!(&guarded[1..queries.len() + 1], expected);
    }
    let calibration: Vec<_> = (0..4096).map(|i| hash64(n as u64 + (1 << 24) + i)).collect();
    let mut calibrated = vec![0; calibration.len()];
    filter.lookup_hashes(&calibration, &mut calibrated);
    assert!(calibrated.iter().all(|&x| x <= 1));
    for (&hash, &answer) in calibration.iter().zip(&calibrated) {
        assert_eq!(answer, u32::from(filter.contains_hash(hash)));
    }
    let mixed_fp: u64 = expected.iter().enumerate().filter(|(i, _)| i % 4 != 0).map(|(_, &v)| v as u64).sum();
    let calibration_fp: u64 = calibrated.iter().map(|&v| v as u64).sum();
    // Full dense outputs, not checksum-only parity. Constructor bpk is omitted
    // deliberately: old requested8/16 and new ceiling16/32 have equal capacity.
    println!("{{\"filter\":\"{name}\",\"keys\":{n},\"budget_bpk\":{actual_cap},\"filter_bytes\":{},\"inserted_checked\":{n},\"insert_fingerprint\":{},\"query_fingerprint\":{},\"calibration_fingerprint\":{},\"mixed_fp\":{mixed_fp},\"calibration_fp\":{calibration_fp},\"outputs\":{:?},\"calibration_outputs\":{:?}}}",
        filter.size_in_bytes(), fingerprint(&inserted), fingerprint(&queries), fingerprint(&calibration), expected, calibrated);
}
