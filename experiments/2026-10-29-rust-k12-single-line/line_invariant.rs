#[test]
fn single_line_probe_physical_owner_invariant() {
    // No bitmap allocation: test the actual probe at the maximum allowed size
    // and nonpower-of-two line counts, independent u128 quotient as oracle.
    for count in [2u32,3,17,3072,32768,32769,1_572_864,1<<22] {
        let denominator=1u128<<24;
        let mut addresses=vec![0u32,1,(1<<24)-2,(1<<24)-1];
        for line in [1u32,count/3,count/2,count-1] {
            let boundary=(line as u128*denominator).div_ceil(count as u128) as u32;
            addresses.extend([boundary.saturating_sub(1),boundary.min((1<<24)-1)]);
        }
        addresses.sort_unstable();addresses.dedup();
        for address in addresses {
            let expected=(address as u128*count as u128/denominator)as u32;
            assert!(expected<count);
            for offsets in 0..256u64 {
                for low in [0u32,1,0x0123_4567,0x89ab_cdef,u32::MAX] {
                    let h=((address as u64)<<40)|(offsets<<32)|low as u64;
                    let(indices,masks)=FourSectorRange12BloomFilter::probe_mask(h,count);
                    for sector in 0..4 {
                        assert_eq!(indices[sector]>>4,expected);
                        assert_eq!((indices[sector]&15)>>2,sector as u32);
                        assert!((indices[sector]&15)<16);
                        assert_eq!(masks[sector].count_ones(),3);
                    }
                }
            }
        }
    }
}
