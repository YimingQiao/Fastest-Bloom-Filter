use super::*;
fn hash(mut z: u64) -> u64 {
    z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
    z ^ (z >> 31)
}
// Independent address division and individual bit positions: no SIMD or mask table reuse.
fn positions(h: u64, lines: usize) -> [usize;12] {
    const TRIPLES: [[usize;3];16] = [[0,1,3],[0,4,9],[0,6,13],[0,8,18],
        [0,1,12],[0,2,15],[0,4,16],[0,3,8],[0,6,15],[0,7,18],
        [0,1,10],[0,2,5],[0,4,10],[0,7,15],[0,1,13],[0,3,14]];
    let line=((h>>40) as u128 * lines as u128 / 16_777_216) as usize;
    let base=((h>>32)&3) as usize;
    std::array::from_fn(|i| {
        let j=i/3;let code=(h as u32).rotate_right((8*j) as u32);
        let offset=base ^ if j==0 {0}else{((h>>(32+2*j))&3) as usize};
        let word=line*16+j*4+offset;
        word*32+(TRIPLES[(code%16) as usize][i%3]+((code/16)%32) as usize)%32
    })
}
fn oracle(lines:usize, input:&[u64])->Vec<u32> {
    let mut words=vec![0;lines*16];
    for &h in input { for bit in positions(h,lines) {words[bit/32]|=1u32<<(bit%32);} }
    words
}
fn expected(words:&[u32],h:u64)->u32 {
    positions(h,words.len()/16).into_iter().all(|b|words[b/32]&(1u32<<(b%32))!=0) as u32
}
fn configured(bytes:usize, backend:usize)->FourSectorRange12BloomFilter {
    let mut f=FourSectorRange12BloomFilter::with_byte_budget(bytes).unwrap();
    if backend==0 {f.avx512=false;f.avx2=false;}
    if backend==1 {f.avx512=false;}
    f
}
#[test]
fn sizing_dictionary_and_independent_fields() {
    for bytes in [128,129,191,192,193,448,1088,32769*64] {
        let f=configured(bytes,0);assert_eq!(f.size_in_bytes(),bytes/64*64);
        assert_eq!(f.bitmap_words().as_ptr() as usize%64,0);
        for h in [0,1,u64::MAX,hash(7),hash(731)] {
            let(indices,masks)=f.probe(h);let bits=positions(h,f.lines.len());
            for j in 0..4 {
                assert_eq!(masks[j].count_ones(),3);
                assert_eq!(indices[j] as usize/16,f.line_index(h));
                for k in 0..j {assert_ne!(indices[j],indices[k]);}
                for k in 0..3 {assert_ne!(masks[j]&(1<<(bits[j*3+k]%32)),0);}
            }
        }
    }
    for bytes in [0,1,127] {assert_eq!(FourSectorRange12BloomFilter::with_byte_budget(bytes).err(),Some(SizeError::InvalidSize));}
    assert_eq!(FourSectorRange12BloomFilter::with_byte_budget((1<<28)+1).err(),Some(SizeError::CapacityExceeded));
    assert_eq!(FourSectorRange12BloomFilter::new(usize::MAX,2).err(),Some(SizeError::InvalidSize));
    assert_eq!(FourSectorRange12BloomFilter::new(0,24).err(),Some(SizeError::InvalidSize));
}
#[test]
fn complete_bitmap_backend_tail_and_collision_parity() {
    for lines in [3,17,32768,32769] {
        for hot in [false,true] {
            let input:Vec<_>=(0..1031).map(|i|if hot{hash(i)&0x0000_00ff_ffff_ffff}else{hash(i)}).collect();
            let words=oracle(lines,&input);let input_before=input.clone();
            for backend in [0,1,2] {
                let mut f=configured(lines*64,backend);
                for batch in [1,3,4,7,8,15,16,17,31,64,4096] {
                    f.lines.fill(Line::default());for group in input.chunks(batch){f.insert_hashes(group);}
                    assert_eq!(f.bitmap_words(),words);f.insert_hashes(&input);assert_eq!(f.bitmap_words(),words);
                }
                let q:Vec<_>=(0..8193).map(|i|if i%2==0 {input[i%input.len()]}else{hash(i as u64+100_000)}).collect();
                let q_before=q.clone();
                for len in (0..=131).chain([4096]) {
                    for offset in 0..8 {
                        let mut out=vec![0xfeed;len+2];f.lookup_hashes(&q[offset..offset+len],&mut out[1..len+1]);
                        assert_eq!(out[0],0xfeed);assert_eq!(out[len+1],0xfeed);
                        assert!(out[1..len+1].iter().zip(&q[offset..offset+len]).all(|(&a,&h)|a==expected(&words,h)));
                    }
                }
                assert!(input.iter().all(|&h|f.contains_hash(h)));assert_eq!(f.bitmap_words(),words);assert_eq!(input,input_before);assert_eq!(q,q_before);
            }
        }
    }
}
#[test]
fn top24_boundaries_and_exact_nonpower2_owners() {
    for lines in [3usize,7,15,16,17,257,32769,1<<22] {
        for requested in [1usize,3,7,8] {
            let w=requested.min(lines);
            for part in 0..=w {
                let boundary=(part as u64*lines as u64).div_ceil(w as u64) as usize;
                for line in [boundary.saturating_sub(1),boundary.min(lines-1)] {
                    let x=(line as u64*(1<<24)).div_ceil(lines as u64);
                    for address in [x.saturating_sub(1),x,(x+1).min((1<<24)-1)] {
                        for offset in [0u64,1,127,255] {
                            let h=(address<<40)|(offset<<32)|0x10203040;
                            let physical=((address as u128*lines as u128)/(1<<24)) as usize;
                            let owner=layout_parallel::owner(physical,w,lines);
                            let begin=(owner*lines).div_ceil(w);let end=((owner+1)*lines).div_ceil(w);
                            assert!(begin<=physical&&physical<end);
                            assert_eq!(FourSectorRange12BloomFilter::base((h>>32) as u32,lines as u32) as usize>>4,physical);
                        }
                    }
                }
            }
        }
    }
}
#[test]
fn exclusive_build_and_parallel_immutable_lookup() {
    for lines in [17,32769] {
        for hot in [false,true] {
            let old:Vec<_>=(0..513).map(hash).collect();
            let input:Vec<_>=(0..32771).map(|i|if hot{hash(i+9000)&0x0000_00ff_ffff_ffff}else{hash(i+9000)}).collect();
            let mut all=old.clone();all.extend(&input);let words=oracle(lines,&all);let input_before=input.clone();let old_before=old.clone();
            for requested in [3,7] {
                let mut f=configured(lines*64,2);f.insert_hashes(&old);assert_eq!(f.build_workers(input.len(),requested),requested);
                f.insert_hashes_parallel(&input,requested);assert_eq!(f.bitmap_words(),words);
                let q:Vec<_>=(0..32771).map(|i|if i%2==0{all[i%all.len()]}else{hash(i as u64+1_000_000)}).collect();
                let q_before=q.clone();let mut out=vec![0xfeed;q.len()+2];f.lookup_hashes_parallel(&q,&mut out[1..q.len()+1],requested);
                assert_eq!(out[0],0xfeed);assert_eq!(out[q.len()+1],0xfeed);assert!(out[1..q.len()+1].iter().zip(&q).all(|(&a,&h)|a==expected(&words,h)));
                std::thread::scope(|scope|{for _ in 0..3{let filter=&f;let query=&q;let expected_words=&words;scope.spawn(move||{let mut answers=vec![0;query.len()];filter.lookup_hashes(query,&mut answers);assert!(answers.iter().zip(query).all(|(&a,&h)|a==expected(expected_words,h)));});}});
                assert!(all.iter().all(|&h|f.contains_hash(h)));assert_eq!(f.bitmap_words(),words);assert_eq!(input,input_before);assert_eq!(old,old_before);assert_eq!(q,q_before);
            }
        }
    }
}
#[test]
fn length_and_scratch_fail_before_mutation() {
    let f=configured(17*64,0);let mut out=[0xfeed;3];
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(||f.lookup_hashes(&[1,2],&mut out))).is_err());assert_eq!(out,[0xfeed;3]);
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(||f.lookup_hashes_parallel(&[1,2],&mut out,7))).is_err());assert_eq!(out,[0xfeed;3]);
    assert!(std::panic::catch_unwind(||f.build_scratch_bytes(usize::MAX,3)).is_err());
}

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
