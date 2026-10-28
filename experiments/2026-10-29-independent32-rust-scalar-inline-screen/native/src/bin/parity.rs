use independent32_scalar_inline_experiment::Independent32BloomFilter;

fn next(state: &mut u64) -> u64 {
    *state = state.wrapping_add(0x9e3779b97f4a7c15);
    let mut x = *state;
    x = (x ^ (x >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    x = (x ^ (x >> 27)).wrapping_mul(0x94d049bb133111eb);
    x ^ (x >> 31)
}

fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    assert_eq!(args, ["--parity"], "usage: independent32-parity --parity");
    for n in [17, 1000, 4096] {
        for bpk in [1, 8, 16] {
            let mut state = 0x243f6a8885a308d3;
            let inserted: Vec<_> = (0..2048).map(|_| next(&mut state)).collect();
            let mut query: Vec<_> = (0..1024).map(|_| next(&mut state)).collect();
            query.extend_from_slice(&inserted[..128]);
            let mut filter = Independent32BloomFilter::new(n, bpk).unwrap();
            filter.insert_hashes(&inserted);
            let mut output = vec![0; query.len()];
            filter.lookup_hashes(&query, &mut output);
            println!(
                "{{\"n\":{n},\"bpk\":{bpk},\"words\":{:?},\"output\":{:?}}}",
                filter.bitmap_words(),
                output
            );
        }
    }
}
