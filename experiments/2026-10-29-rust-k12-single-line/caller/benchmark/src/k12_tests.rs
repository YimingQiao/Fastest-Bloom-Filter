use super::*;
#[test]
fn k12_actual_public_adapter_allocation_and_dense_output() {
    for (n,bpk) in [(64,16),(65,24),(1024,24),(1024,32)] {
        let geometry=geometry::plan("FourSectorRange12BloomFilter",n,bpk).unwrap();
        // Resolve one-time CPU detection before observed bitmap allocation.
        drop(<FourSectorRange12BloomFilter as Filter>::new(n,bpk).unwrap());
        let (mut filter,allocated)=tests::allocation::measure(|| <FourSectorRange12BloomFilter as Filter>::new(n,bpk).unwrap());
        assert_eq!(allocated.allocations,1); assert_eq!(allocated.deallocations,0);
        assert_eq!(allocated.bytes,geometry.allocated_bytes);assert_eq!(allocated.max_alignment,64);
        assert_eq!(Filter::size_in_bytes(&filter),geometry.allocated_bytes);
        assert_eq!(geometry.effective_probes,12);
        let inserted:Vec<_>=(0..257).map(hash64).collect();let before=inserted.clone();
        Filter::insert_hashes(&mut filter,&inserted[..129]);Filter::insert_hashes(&mut filter,&inserted[129..]);Filter::insert_hashes(&mut filter,&inserted);
        for &h in &inserted {assert!(Filter::contains_hash(&filter,h));}
        for count in [0,1,3,4,7,8,15,16,31,32,63,64,131,4097] {
            let input:Vec<_>=(0..count).map(|i| if i%2==0 { inserted[i%inserted.len()] } else { hash64((10000+i) as u64) }).collect();let original=input.clone();
            let expected:Vec<_>=input.iter().map(|&h|Filter::contains_hash(&filter,h)as u32).collect();
            let mut output=vec![0xdeadbeefu32;count+16];Filter::lookup_hashes(&filter,&input,&mut output[8..8+count]);
            assert_eq!(&output[8..8+count],expected);assert!(output[..8].iter().chain(&output[8+count..]).all(|&x|x==0xdeadbeef));assert_eq!(input,original);
        }
        assert_eq!(inserted,before);
        let (_,freed)=tests::allocation::measure(||drop(filter));assert_eq!(freed.deallocations,1);assert_eq!(freed.freed_bytes,allocated.bytes);
    }
}
