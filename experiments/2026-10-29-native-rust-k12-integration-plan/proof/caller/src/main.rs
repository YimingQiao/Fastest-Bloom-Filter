use native::{hash64, FourSectorRange12BloomFilter as Native};
use reference::FourSectorRange12BloomFilter as Reference;


#[no_mangle]
#[inline(never)]
pub fn native_visible_pure(filter: &Native, hashes: &[u64], out: &mut [u32]) {
    assert_eq!(hashes.len(), out.len());
    for (&hash, answer) in hashes.iter().zip(out) {
        *answer = filter.contains_hash(hash) as u32;
    }
}
#[no_mangle]
#[inline(never)]
pub fn native_visible_fused(filter: &Native, keys: &[u64], out: &mut [u32]) {
    assert_eq!(keys.len(), out.len());
    for (&key, answer) in keys.iter().zip(out) {
        *answer = filter.contains_hash(hash64(key)) as u32;
    }
}
#[no_mangle]
#[inline(never)]
pub fn native_public_batch(filter: &Native, hashes: &[u64], out: &mut [u32]) {
    filter.lookup_hashes(hashes, out);
}

fn main() {
    assert_eq!(std::env::args().len(), 1, "proof has no workload options");
    let mut checksum = 0u64;
    let mut cases = 0;
    for bytes in [192usize, 17 * 64, 32769 * 64] {
        for workers in [3usize, 7] {
            for hotspot in [false, true] {
                let old: Vec<_> = (0..513).map(hash64).collect();
                let input: Vec<_> = (0..32771).map(|i| {
                    let h = hash64(i + 10000);
                    if hotspot { h & 0x0000_00ff_ffff_ffff } else { h }
                }).collect();
                let old_before = old.clone();
                let input_before = input.clone();
                let mut expected = Reference::with_byte_budget(bytes).unwrap();
                expected.insert_hashes(&old);
                expected.insert_hashes(&input);
                let mut actual = Native::with_byte_budget(bytes).unwrap();
                assert_eq!(actual.backend(), expected.backend());
                assert_eq!(actual.size_in_bytes(), expected.size_in_bytes());
                assert_eq!(actual.size_in_bytes(), bytes);
                assert_eq!(actual.bitmap_words().as_ptr() as usize % 64, 0);
                // Three-line filters legitimately cap the request at three;
                // non-power-of-two17/32769-line filters must really use T3/T7.
                let observed = actual.build_workers(input.len(), workers);
                assert_eq!(observed, workers.min(bytes / 64));
                assert_eq!(actual.build_scratch_bytes(input.len(), workers), expected.build_scratch_bytes(input.len(), workers));
                actual.insert_hashes(&old);
                actual.insert_hashes_parallel(&input, workers);
                assert_eq!(actual.bitmap_words(), expected.bitmap_words());
                assert!(old.iter().chain(&input).all(|&h| actual.contains_hash(h)));
                let raw: Vec<_> = (0..32771u64).map(|i| if i % 2 == 0 { 10000 + i % input.len() as u64 } else { 1_000_000 + i }).collect();
                let hashes: Vec<_> = raw.iter().map(|&h| hash64(h)).collect();
                let raw_before = raw.clone();
                let hashes_before = hashes.clone();
                let want: Vec<_> = hashes.iter().map(|&h| expected.contains_hash(h) as u32).collect();
                for len in [0usize, 1, 3, 7, 31, 4096, 8193, 32771] {
                    let mut output = vec![0xdead_beef; len + 2];
                    let out = &mut output[1..len + 1];
                    native_visible_pure(std::hint::black_box(&actual), &hashes[..len], out);
                    assert_eq!(out, &want[..len]);
                    native_visible_fused(std::hint::black_box(&actual), &raw[..len], out);
                    assert_eq!(out, &want[..len]);
                    native_public_batch(std::hint::black_box(&actual), &hashes[..len], out);
                    assert_eq!(out, &want[..len]);
                    actual.lookup_hashes_parallel(&hashes[..len], out, workers);
                    assert_eq!(out, &want[..len]);
                    assert_eq!(output[0], 0xdead_beef);
                    assert_eq!(output[len + 1], 0xdead_beef);
                    for &value in &output[1..len + 1] { checksum = checksum.wrapping_mul(31).wrapping_add(value as u64); }
                }
                let mut guarded = [0xdead_beef; 3];
                for parallel in [false, true] {
                    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                        if parallel { actual.lookup_hashes_parallel(&[1, 2], &mut guarded, workers); }
                        else { actual.lookup_hashes(&[1, 2], &mut guarded); }
                    }));
                    assert!(result.is_err());
                    assert_eq!(guarded, [0xdead_beef; 3]);
                }
                assert_eq!(actual.bitmap_words(), expected.bitmap_words());
                assert_eq!(old, old_before); assert_eq!(input, input_before);
                assert_eq!(raw, raw_before); assert_eq!(hashes, hashes_before);
                cases += 1;
                println!("case={cases},bytes={bytes},workers_requested={workers},workers_actual={observed},hotspot={hotspot},backend={},words={}", actual.backend(), actual.bitmap_words().len());
            }
        }
    }
    assert_eq!(cases, 12);
    println!("complete=true,cases={cases},checksum={checksum},timing=false,calibration=0");
}
