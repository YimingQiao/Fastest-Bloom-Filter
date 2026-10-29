use super::*;
#[test]
fn singleton_chain_clone_bitmap_and_public_outputs() {
    for bytes in [128, 192, 196_608, 2_097_216] {
        let mut old = FourSectorRange12BloomFilter::with_byte_budget(bytes).unwrap();
        let mut new = FourSectorRange12InlineV1::with_byte_budget(bytes).unwrap();
        assert_eq!(old.backend(), new.backend());
        assert_eq!(old.size_in_bytes(), new.size_in_bytes());
        let input:Vec<_>=(0..8197).map(|i| if i%3==0 {hash64(i)&0x0000_00ff_ffff_ffff} else {hash64(i)}).collect();
        let original=input.clone();
        for chunk in input.chunks(31) {old.insert_hashes(chunk);new.insert_hashes(chunk);}
        old.insert_hashes(&input[..257]);new.insert_hashes(&input[..257]);
        assert_eq!(old.bitmap_words(),new.bitmap_words());
        let bitmap=old.bitmap_words().to_vec();
        for &h in &input {assert!(old.contains_hash(h));assert!(new.contains_hash(h));}
        for count in (0..=131).chain([4096]) {
            for offset in [0,3] {
                let query:Vec<_>=(0..count+offset).map(|i|if i%2==0 {input[i%input.len()]}else {hash64(100_000+i as u64)}).collect();
                let saved=query.clone();let hashes=&query[offset..];
                let expected:Vec<_>=hashes.iter().map(|&h|old.contains_hash(h)as u32).collect();
                assert_eq!(hashes.iter().map(|&h|new.contains_hash(h)as u32).collect::<Vec<_>>(),expected);
                let mut before=vec![0xdead_beefu32;count+16];let mut after=before.clone();
                old.lookup_hashes(hashes,&mut before[8..8+count]);new.lookup_hashes(hashes,&mut after[8..8+count]);
                assert_eq!(before,after);assert_eq!(&after[8..8+count],expected);
                assert!(after[..8].iter().chain(&after[8+count..]).all(|&x|x==0xdead_beef));assert_eq!(query,saved);
            }
        }
        assert_eq!(input,original);assert_eq!(old.bitmap_words(),bitmap);assert_eq!(new.bitmap_words(),bitmap);
        let mut guard=[0xdead_beefu32;2];
        assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(||new.lookup_hashes(&[1],&mut guard))).is_err());
        assert_eq!(guard,[0xdead_beef;2]);
    }
    // Warm runtime feature detection before observing each public constructor.
    drop(FourSectorRange12BloomFilter::with_byte_budget(3072).unwrap());
    drop(FourSectorRange12InlineV1::with_byte_budget(3072).unwrap());
    let (old,a)=tests::allocation::measure(||FourSectorRange12BloomFilter::with_byte_budget(3072).unwrap());
    let (new,b)=tests::allocation::measure(||FourSectorRange12InlineV1::with_byte_budget(3072).unwrap());
    assert_eq!((a.allocations,a.bytes,a.max_alignment),(1,3072,64));
    assert_eq!((b.allocations,b.bytes,b.max_alignment),(1,3072,64));
    assert_eq!(old.bitmap_words(),new.bitmap_words());
}
