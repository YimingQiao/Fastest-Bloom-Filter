use super::*;
use crate::tests::allocation;
fn positions<const K: u32>(raw:u64,bits:usize)->Vec<usize> {
    let bytes=raw.to_le_bytes();
    let first=xxhash_rust::xxh3::xxh3_64_with_seed(&bytes,0)as u128 % bits as u128;
    let step=xxhash_rust::xxh3::xxh3_64_with_seed(&bytes,32)as u128 % bits as u128;
    (0..K).map(|i|((first+i as u128*step)%bits as u128)as usize).collect()
}
fn check<const K:u32>() {
    for n in [64usize,97] { for cap in [16u32,24,32] {
        let (mut filter,counts)=allocation::measure(||FastbloomRsRaw::<K>::new(n,cap).unwrap());
        let size=filter.size_in_bytes();
        assert_eq!((counts.allocations,counts.bytes,counts.deallocations),(1,size,0));
        assert_eq!(FastbloomRsRaw::<K>::scratch_words(usize::MAX),0);
        let mut expected=vec![0u8;size];
        let inserted:Vec<_>=(0..n as u64).chain([0,0,1,u64::MAX,1<<32,0x0807060504030201]).collect();
        for chunk in inserted.chunks(31) {
            filter.insert_raw(chunk,&mut []);
            for &raw in chunk {for bit in positions::<K>(raw,size*8) {expected[bit/8]|=1<<(bit%8);}}
            assert_eq!(filter.0.get_u8_array(),expected);
        }
        for &raw in &inserted {assert!(filter.contains_raw(raw));}
        let queries:Vec<_>=(0..4104).map(|i|if i%3==0 {inserted[i%inserted.len()]}else{1_000_000+i as u64}).collect();
        for offset in [0,1,3,7] {for len in [0,1,3,7,31,63,129,4096,4097] {
            let input=&queries[offset..offset+len];let input_copy=input.to_vec();
            let oracle:Vec<_>=input.iter().map(|&raw|positions::<K>(raw,size*8).iter().all(|&bit|expected[bit/8]&(1<<(bit%8))!=0)as u32).collect();
            let mut out=vec![0xfeed;len+2];
            filter.lookup_raw(input,&mut out[1..len+1],&mut []);
            assert_eq!(&out[1..len+1],oracle);assert_eq!(out[0],0xfeed);assert_eq!(out[len+1],0xfeed);
            out[1..len+1].fill(2);crate::raw_contract::raw_visible(&filter,input,&mut out[1..len+1]);
            assert_eq!(&out[1..len+1],oracle);assert_eq!(input,input_copy);
            assert_eq!(filter.0.get_u8_array(),expected);
        }}
        let mut bad=[0xfeed;2];
        assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(||filter.lookup_raw(&queries[..3],&mut bad,&mut []))).is_err());
        assert_eq!(bad,[0xfeed;2]);
        let (_,freed)=allocation::measure(||drop(filter));
        assert_eq!((freed.deallocations,freed.freed_bytes),(1,size));
    }}
}
#[test]
fn all24_public_counts_match_independent_full_bitmaps_and_raw_outputs() {
    check::<1>();
    check::<2>();
    check::<3>();
    check::<4>();
    check::<5>();
    check::<6>();
    check::<7>();
    check::<8>();
    check::<9>();
    check::<10>();
    check::<11>();
    check::<12>();
    check::<13>();
    check::<14>();
    check::<15>();
    check::<16>();
    check::<17>();
    check::<18>();
    check::<19>();
    check::<20>();
    check::<21>();
    check::<22>();
    check::<23>();
    check::<24>();
}
#[test]
fn six_formal_sizes_have_exact_empty_backing_at_both_k_endpoints() {
    fn empty<const K:u32>(n:usize,cap:u32) {
        let (filter,counts)=allocation::measure(||FastbloomRsRaw::<K>::new(n,cap).unwrap());
        assert_eq!((counts.allocations,counts.bytes,counts.deallocations),(1,n*cap as usize/8,0));
        assert_eq!(filter.size_in_bytes(),counts.bytes);
        let (_,freed)=allocation::measure(||drop(filter));
        assert_eq!((freed.deallocations,freed.freed_bytes),(1,counts.bytes));
    }
    for n in [1<<16,1<<25] {for cap in [16,24,32] {empty::<1>(n,cap);empty::<24>(n,cap);}}
}
