use super::*;
use crate::tests;
struct PreparedSpy(Box<u8>);
impl crate::Filter for PreparedSpy {
    fn new(_:usize,_:u32)->Result<Self,Box<dyn std::error::Error>> {Ok(Self(Box::new(1)))}
    fn size_in_bytes(&self)->usize {1}
    fn contains_hash(&self,_:u64)->bool {*self.0!=0}
    fn insert_hashes(&mut self,_:&[u64]) {}
    fn lookup_hashes(&self,input:&[u64],out:&mut[u32]) {assert_eq!(input.len(),out.len());out.fill(1);}
}
struct DirectSpy(Box<u8>);
impl RawFilter for DirectSpy {
    fn new(_:usize,_:u32)->Result<Self,Box<dyn std::error::Error>> {Ok(Self(Box::new(1)))}
    fn size_in_bytes(&self)->usize {1}
    fn scratch_words(_:usize)->usize {0}
    fn contains_raw(&self,_:u64)->bool {*self.0!=0}
    fn insert_raw(&mut self,_:&[u64],scratch:&mut[u64]) {assert!(scratch.is_empty());}
    fn lookup_raw(&self,input:&[u64],out:&mut[u32],scratch:&mut[u64]) {assert!(scratch.is_empty());assert_eq!(input.len(),out.len());out.fill(1);}
}
fn config(insert_batch:usize,batch:usize)->Config {Config{n:64,q:4096,bpk:16,hit:0,batch,insert_batch,calibration_power:0,repeats:4,seed:42,key_base:0}}
fn trace_check<F:RawFilter>(insertion:usize,query:usize) {
    let c=config(insertion,query);let input:Vec<_>=(0..64).collect();let queries:Vec<_>=(1_000_000..1_004_096).collect();
    let (measurements,events)=tests::trace(||run_raw::<F>(&input,&queries,&c));
    let build=F::scratch_words(insertion.min(c.n))*8;let query=F::scratch_words(query)*8;
    assert_eq!((measurements.build_scratch_bytes,measurements.query_scratch_bytes),(build,query));
    let timed=&events[..24];
    for group in timed.chunks_exact(6) {
        assert_eq!(group.iter().map(|x|x.phase).collect::<Vec<_>>(),["complete_start","scratch_ready","filter_ready","insert_done","validated","build_dropped"]);
        assert_eq!(group[1].live-group[0].live,build);
        assert_eq!(group[2].live-group[1].live,1);
        assert_eq!(group[2].live,group[3].live);
        assert_eq!(group[4].live-group[5].live,build+1);
    }
    assert_eq!(events.len(),28);
    assert_eq!(events[24].phase,"canonical_before_scratch");
    assert_eq!(events[25].phase,"canonical_scratch_ready");
    assert_eq!(events[26].phase,"canonical_scratch_dropped");
    assert_eq!(events[27].phase,"query_scratch_ready");
    assert_eq!(events[25].live-events[24].live,build);
    assert_eq!(events[26].live,events[24].live);
    assert_eq!(events[27].live-events[26].live,query);
}
#[test]
fn actual_scratch_allocations_clock_boundaries_and_lifetimes() {
    let (empty,counts)=tests::allocation::measure(||Scratch::new(0));
    assert_eq!((counts.allocations,counts.bytes),(0,0));drop(empty);
    for (insertion,query) in [(1,31),(31,1),(31,31),(4096,4096),(1,4096)] {
        trace_check::<crate::raw_contract::CommonHash<PreparedSpy>>(insertion,query);
        trace_check::<DirectSpy>(insertion,query);
    }
}
thread_local! {static BATCH_FAULT:std::cell::Cell<Option<(bool,usize)>>=const{std::cell::Cell::new(None)};}
struct BatchFault(DirectSpy);
impl RawFilter for BatchFault {
    fn new(n:usize,b:u32)->Result<Self,Box<dyn std::error::Error>>{Ok(Self(DirectSpy::new(n,b)?))}
    fn size_in_bytes(&self)->usize {1}
    fn scratch_words(_:usize)->usize {0}
    fn contains_raw(&self,raw:u64)->bool {self.0.contains_raw(raw)}
    fn insert_raw(&mut self,raw:&[u64],scratch:&mut[u64]) {self.0.insert_raw(raw,scratch)}
    fn lookup_raw(&self,input:&[u64],out:&mut[u32],scratch:&mut[u64]) {
        let failure=BATCH_FAULT.with(|slot| {let Some((skip,count))=slot.get()else{return None};slot.set(Some((skip,count+1)));(count==277).then_some(skip)});
        if failure==Some(true) {let last=out.len()-1;self.0.lookup_raw(&input[..last],&mut out[..last],scratch);}
        else {self.0.lookup_raw(input,out,scratch);if failure==Some(false){*out.last_mut().unwrap()=0;}}
    }
}
#[test]
fn skip_last_and_wrong_value_faults_fail_after_valid_warmups_in_both_modes() {
    let c=config(31,31);let inserted:Vec<_>=(0..64).collect();let queries:Vec<_>=(1_000_000..1_004_096).collect();
    //12 build-validation batches +133 warmup batches +133 timed batches.
    for skip in [false,true] {
        BATCH_FAULT.with(|slot|slot.set(Some((skip,0))));
        assert!(std::panic::catch_unwind(||run_raw::<BatchFault>(&inserted,&queries,&c)).is_err());
        BATCH_FAULT.with(|slot|slot.set(None));
        tests::visible_fault(skip,*queries.last().unwrap());
        assert!(std::panic::catch_unwind(||run_raw::<DirectSpy>(&inserted,&queries,&c)).is_err());
        tests::clear_fault();
    }
}
#[test]
fn two_phase_schedule_balances_every_position() {
    for seed in [0,42,u64::MAX] {
        let orders=phase_orders(seed,8);let mut positions=[[0;2];2];
        for order in orders {assert_ne!(order[0],order[1]);for (position,mode)in order.into_iter().enumerate(){positions[mode][position]+=1;}}
        assert_eq!(positions,[[4,4],[4,4]]);
    }
}
