//! Focused private fixtures, compiled only with cfg(test) in each exact arm.
use super::{FourSectorRange12BloomFilter as Filter, Line};

// Independent literal bit positions, not the production dictionary or rotate.
const BITS: [[u32; 3]; 16] = [
    [0,1,3], [0,4,9], [0,6,13], [0,8,18],
    [0,1,12], [0,2,15], [0,4,16], [0,3,8],
    [0,6,15], [0,7,18], [0,1,10], [0,2,5],
    [0,4,10], [0,7,15], [0,1,13], [0,3,14],
];

fn probes(hash: u64, count: usize) -> (usize, [(usize, u32); 12]) {
    let hi = hash >> 32;
    let lo = hash & 0xffff_ffff;
    let line = (((hi >> 8) as u128 * count as u128) / (1u128 << 24)) as usize;
    let mut result = [(0, 0); 12];
    for sector in 0..4 {
        let shift = sector * 8;
        // u64 arithmetic explicitly wraps only the low32 bits, including shift0.
        let code = if shift == 0 { lo } else { ((lo >> shift) | (lo << (32-shift))) & 0xffff_ffff };
        let offset = if sector == 0 { hi & 3 } else { (hi & 3) ^ ((hi >> (sector*2)) & 3) };
        let word = sector*4 + offset as usize;
        for bit in 0..3 {
            let position = (BITS[(code & 15) as usize][bit] + ((code >> 4) & 31) as u32) % 32;
            result[sector*3+bit] = (word, 1u32 << position);
        }
    }
    (line, result)
}

fn answer(words: &[u32], hash: u64) -> u32 {
    let (line, probes) = probes(hash, words.len()/16);
    probes.iter().all(|&(w, b)| words[line*16+w] & b != 0) as u32
}

fn hash(mut x: u64) -> u64 {
    x ^= x >> 32;
    x = x.wrapping_mul(0xd6e8feb86659fd93);
    x ^= x >> 32;
    x = x.wrapping_mul(0xd6e8feb86659fd93);
    x ^ (x >> 32)
}

#[test]
fn simd_singleton_focused_required_bits() {
    let mut fields = Vec::new();
    for offset in 0..256u64 {
        fields.push((((0x8abcdeu64 << 8) | offset) << 32) | 0xfedc_ba98);
    }
    for sector in 0..4u32 {
        for rotation in 0..32u32 {
            for dictionary in 0..16u32 {
                let code = (0xa5c3_0000u32 | (rotation << 4) | dictionary).rotate_left(sector*8);
                let hi = 0xd135_7900u64 | ((rotation as u64*7 + dictionary as u64) & 255);
                fields.push((hi << 32) | code as u64);
            }
        }
    }
    fields.extend([0, u64::MAX]);
    assert_eq!(fields.len(), 2306);
    let mut cases = 0;
    for count in [2usize, 3, 17, 32769] {
        let mut bf = Filter::with_byte_budget(count*64).unwrap();
        assert_eq!(bf.size_in_bytes(), count*64);
        for &h in &fields {
            let (line, points) = probes(h, count);
            let mut original = [0u32; 16];
            for &(word, bit) in &points { original[word] |= bit; }
            bf.lines[line] = Line(original);
            assert!(bf.contains_hash(h));
            for len in 1..=3 {
                let mut out = [0xfeed_face; 5];
                bf.lookup_hashes(&[h; 3][..len], &mut out[1..len+1]);
                assert_eq!(&out[1..len+1], vec![1; len]);
                assert_eq!(out[0], 0xfeed_face);
                assert_eq!(out[len+1], 0xfeed_face);
            }
            for &(word, bit) in &points {
                bf.lines[line].0[word] &= !bit;
                assert!(!bf.contains_hash(h));
                let mut out = [0xfeed_face; 5];
                bf.lookup_hashes(&[h; 3], &mut out[1..4]);
                assert_eq!(&out[1..4], &[0, 0, 0]);
                assert_eq!((out[0], out[4]), (0xfeed_face, 0xfeed_face));
                bf.lines[line].0[word] |= bit;
            }
            assert_eq!(bf.lines[line].0, original);
            bf.lines[line] = Line::default();
            cases += 1;
        }
        // One complete check per allocation, never per field combination.
        assert!(bf.bitmap_words().iter().all(|&w| w == 0));
    }
    assert_eq!(cases, 9224);
}

#[test]
fn simd_singleton_focused_bitmap_and_tails() {
    let keys: Vec<_> = (0..1031).map(hash).collect();
    let mut queries: Vec<_> = (0..4103).map(|x| hash(x+9000)).collect();
    for i in (1..queries.len()).step_by(2) { queries[i] = keys[i%keys.len()]; }
    let saved_input = queries.clone();
    let mut cases = 0;
    for count in [2usize, 3, 17, 32769] {
        let mut bf = Filter::with_byte_budget(count*64).unwrap();
        let mut expected = vec![0u32; count*16];
        for &h in &keys {
            let (line, points) = probes(h, count);
            for (word, bit) in points { expected[line*16+word] |= bit; }
        }
        for chunk in keys.chunks(31) { bf.insert_hashes(chunk); }
        bf.insert_hashes(&keys); // duplicate/colliding append, unchanged insertion.
        assert_eq!(bf.bitmap_words(), expected);
        for &h in &keys { assert!(bf.contains_hash(h)); }
        for offset in [0usize,1,3,7] {
            for len in (0..=131).chain(std::iter::once(4096)) {
                let input = &queries[offset..offset+len];
                let expected_answers: Vec<_> = input.iter().map(|&h| answer(&expected,h)).collect();
                let mut output = vec![0xfeed_face; len+2];
                bf.lookup_hashes(input, &mut output[1..len+1]);
                assert_eq!(&output[1..len+1], expected_answers);
                assert_eq!((output[0],output[len+1]),(0xfeed_face,0xfeed_face));
                for (&h,&v) in input.iter().zip(&expected_answers) { assert_eq!(bf.contains_hash(h) as u32,v); }
                cases += 1;
            }
        }
        assert_eq!(bf.bitmap_words(), expected);
        assert_eq!(queries,saved_input);
        for len in [0usize,1,2,3,4,31] {
            let mut output=vec![0xfeed_face;len+1];
            let failure=std::panic::catch_unwind(std::panic::AssertUnwindSafe(||bf.lookup_hashes(&queries[..len],&mut output)));
            assert!(failure.is_err());
            assert!(output.iter().all(|&x|x==0xfeed_face));
        }
    }
    assert_eq!(cases,2128);
}
