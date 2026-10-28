use fastest_bloom_filter::Split64RangeBloomFilter;
fn next(state: &mut u64) -> u64 {
    *state = state.wrapping_add(0x9e3779b97f4a7c15);
    let mut z = *state;
    z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
    z ^ (z >> 31)
}
fn main() {
    for lines in [2usize, 3, 5, 31, 257, 4097] {
        for insertions in [31usize, 2048] {
            let mut state = 0x243f6a8885a308d3;
            let hashes: Vec<_> = (0..insertions).map(|_| next(&mut state)).collect();
            let mut queries: Vec<_> = (0..1024).map(|_| next(&mut state)).collect();
            queries.extend_from_slice(&hashes[..31]);
            let mut f = Split64RangeBloomFilter::with_byte_budget(lines * 64 + 31).unwrap();
            f.insert_hashes(&hashes);
            let mut out = vec![0; queries.len()];
            f.lookup_hashes(&queries, &mut out);
            let words = f.validation_words();
            print!("{{\"lines\":{lines},\"insertions\":{insertions},\"words\":[");
            for (i, word) in words.iter().enumerate() {
                if i > 0 {
                    print!(",");
                }
                print!("{word}");
            }
            print!("],\"out\":[");
            for (i, value) in out.iter().enumerate() {
                if i > 0 {
                    print!(",");
                }
                print!("{value}");
            }
            println!("]}}");
        }
    }
}
