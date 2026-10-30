//! Bounded public semantics: real constructors, only1031 inserted fixture keys.
//! These tests do not represent full32M population or measure an FPR.
use crate::{poppy_geometry, poppy_raw::PoppyRaw, raw_contract::{self, RawFilter}, tests::allocation};
use poppy_filters::v2::BloomFilter;
use std::io::{self, Write};

struct EqualWriter<'a> { expected: &'a [u8], offset: usize }
impl Write for EqualWriter<'_> {
    fn write(&mut self, data: &[u8]) -> io::Result<usize> {
        let end = self.offset.checked_add(data.len()).unwrap();
        assert!(end <= self.expected.len(), "serialization extent changed");
        assert_eq!(data, &self.expected[self.offset..end], "serialized bytes differ at {}", self.offset);
        self.offset = end;
        Ok(data.len())
    }
    fn flush(&mut self) -> io::Result<()> { Ok(()) }
}
fn serialized(filter: &BloomFilter) -> Vec<u8> {
    let mut bytes = Vec::with_capacity(56+filter.size_in_bytes());
    filter.write(&mut bytes).unwrap();
    assert_eq!(bytes.len(), 56+filter.size_in_bytes());
    bytes
}
fn same_bytes(filter: &BloomFilter, expected: &[u8]) {
    let mut out = EqualWriter { expected, offset: 0 };
    filter.write(&mut out).unwrap();
    assert_eq!(out.offset, expected.len());
}
fn semantic<const ID: usize, const TYPED: bool>() {
    let point = poppy_geometry::by_id(ID);
    let expected_bytes = point.bucket_bytes+point.cache_bytes;
    let (mut tested, created) = allocation::measure(|| PoppyRaw::<ID,TYPED>::new(point.n,point.budget_bpk).unwrap());
    assert_eq!(created.bytes-created.freed_bytes, expected_bytes, "actual live constructor heap differs");
    assert_eq!(tested.size_in_bytes(), expected_bytes);
    assert_eq!(PoppyRaw::<ID,TYPED>::scratch_words(usize::MAX), 0);
    let mut reference = poppy_filters::Params::new(point.n,f64::from_bits(point.fpp_bits)).opt(point.policy).try_into_v2().unwrap();
    let mut inserted: Vec<u64> = (0..1031).map(|i| 0xf17e_0000_0000_0000+i).collect();
    inserted[..5].copy_from_slice(&[0,u64::MAX,1<<63,1,u64::MAX]);
    let inserted_before = inserted.clone();
    let (_, operation) = allocation::measure(|| tested.insert_raw(&inserted,&mut []));
    assert_eq!((operation.allocations,operation.deallocations),(0,0), "direct insertion allocated scratch");
    for &raw in &inserted {
        // Type inference keeps the upstream private hasher type opaque.
        let it = if TYPED { BloomFilter::build_index_iter(&raw) }
            else { BloomFilter::build_index_iter(&raw.to_le_bytes().as_slice()) };
        reference.insert_iter(it).unwrap();
    }
    let bytes = serialized(&reference);
    same_bytes(&tested.0,&bytes);
    // Public serialization proves the actual parameter/cache/bucket structure;
    // complete byte equality also checks the counters and all bitmap bytes.
    assert_eq!(u64::from_le_bytes(bytes[24..32].try_into().unwrap()),point.probes as u64);
    assert_eq!(u64::from_le_bytes(bytes[40..48].try_into().unwrap()),(point.cache_bytes*8)as u64);
    let bucket_offset=48+point.cache_bytes;
    assert_eq!(u64::from_le_bytes(bytes[bucket_offset..bucket_offset+8].try_into().unwrap()),(point.bucket_bytes/4096)as u64);
    let queries:Vec<_>=(0..8200).map(|i|if i%2==0 {inserted[(i/2)%inserted.len()]}else{0xe17e_0000_0000_0000+i as u64}).collect();
    let query_before=queries.clone();
    for offset in [0,1,7] {
        for len in [0,1,3,31,4096,8193] {
            let input=&queries[offset..offset+len];
            let expected:Vec<_>=input.iter().map(|&raw|{
                let it = if TYPED { BloomFilter::build_index_iter(&raw) }
                    else { BloomFilter::build_index_iter(&raw.to_le_bytes().as_slice()) };
                reference.contains_iter(it).unwrap()as u32
            }).collect();
            let mut output=vec![0xfeed;len+2];
            for mode in [0,1] {
                output[1..len+1].fill(0xffff_fffe);
                let (_, operation)=allocation::measure(||if mode==0 {
                    raw_contract::raw_batched(&tested,input,&mut output[1..len+1],&mut []);
                }else{
                    raw_contract::raw_visible(&tested,input,&mut output[1..len+1]);
                });
                assert_eq!((operation.allocations,operation.deallocations),(0,0),"direct query allocated scratch");
                assert_eq!(&output[1..len+1],expected);
                assert_eq!((output[0],output[len+1]),(0xfeed,0xfeed));
            }
        }
    }
    assert_eq!(queries,query_before);
    for &raw in &inserted { assert!(tested.contains_raw(raw)); }
    tested.insert_raw(&inserted,&mut []);
    same_bytes(&tested.0,&bytes); // duplicate insertion and queries are immutable
    assert_eq!(inserted,inserted_before);
    let mut wrong=[0xfeed;2];
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(||tested.lookup_raw(&queries[..3],&mut wrong,&mut []))).is_err());
    assert_eq!(wrong,[0xfeed;2]);
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(||raw_contract::raw_visible(&tested,&queries[..3],&mut wrong))).is_err());
    assert_eq!(wrong,[0xfeed;2]);
    let (_, dropped)=allocation::measure(||drop(tested));
    assert_eq!(dropped.freed_bytes,expected_bytes);
    assert_eq!(dropped.allocations,0);
}

#[test]
fn natural_forms_real_geometry_small_load_full_bytes_and_outputs() {
    macro_rules! both { ($($id:literal),+) => { $(semantic::<$id,false>();semantic::<$id,true>();)+ }; }
    both!(20,33,39,40,41,42,43,60,73,79,80,81,82,83);
}

#[test]
fn natural_geometry_registry_and_reject_before_bitmap() {
    assert_eq!(poppy_geometry::POINTS.len(),14);
    assert_eq!(crate::FILTER_NAMES.len(),73);
    for point in poppy_geometry::POINTS {
        for (name,typed) in [(point.byte_name,false),(point.typed_name,true)] {
            let (found,form)=poppy_geometry::by_name(name).unwrap();
            assert_eq!((found.id,form),(point.id,typed));
            assert!(crate::geometry::plan(name,point.n+1,point.budget_bpk).is_err());
            assert!(crate::geometry::plan(name,point.n,point.budget_bpk+1).is_err());
            let plan=crate::geometry::plan(name,point.n,point.budget_bpk).unwrap();
            assert_eq!((plan.allocated_bytes,plan.logical_bytes,plan.effective_probes),(point.bucket_bytes+point.cache_bytes,point.bucket_bytes,point.probes));
        }
    }
    assert!(PoppyRaw::<39,false>::new(128,16).is_err());
    assert!(PoppyRaw::<39,true>::new(65536,24).is_err());
}
