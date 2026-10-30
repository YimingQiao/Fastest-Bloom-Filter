//! Raw-only reporter core. Reuses the frozen caller's Aligned, Config,
//! SplitMix64/shuffle, median, consume and full output/checksum guards.
//! It has exactly two query contracts and two construction metrics.
use crate::raw_contract::{RawFilter, raw_batched, raw_visible, raw_insert};
use crate::{Aligned, Config, SplitMix64, shuffle, consume, verify_dense_output};
use std::time::Instant;

const OUTPUT_POISON: u32 = 0xffff_fffe;

pub struct Measurements {
    pub raw_batched_trials: Vec<f64>,
    pub raw_visible_trials: Vec<f64>,
    pub raw_insert_trials: Vec<f64>,
    pub allocate_filter_and_scratch_raw_insert_trials: Vec<f64>,
    pub query_phase_order: Vec<[usize; 2]>,
    pub actual_bytes: usize,
    pub insert_batch: usize,
    pub query_batch: usize,
    pub build_scratch_bytes: usize,
    pub query_scratch_bytes: usize,
    pub present: usize,
    pub absent: usize,
    pub false_positives: usize,
    pub checksum: u64,
    pub calibration_absent: usize,
    pub calibration_false_positives: usize,
}

/// A zero requirement allocates nothing (Aligned::new(0) would allocate one byte).
struct Scratch(Option<Aligned<u64>>);
impl Scratch {
    fn new(words: usize) -> Self {
        Self(if words == 0 { None } else { Some(Aligned::<u64>::new(words)) })
    }
    fn as_mut_slice(&mut self) -> &mut [u64] {
        match self.0.as_mut() { Some(buffer) => &mut buffer[..], None => &mut [] }
    }
}

pub fn phase_orders(seed: u64, repeats: usize) -> Vec<[usize; 2]> {
    assert!(repeats > 0 && repeats.is_multiple_of(4));
    let mut labels = [0, 1];
    shuffle(&mut labels, &mut SplitMix64(seed ^ 0x6a09e667f3bcc909));
    (0..repeats).map(|trial| {
        let order = if matches!(trial % 4, 0 | 3) { [0, 1] } else { [1, 0] };
        order.map(|phase| labels[phase])
    }).collect()
}

pub fn run_raw<F: RawFilter>(raw_insert_keys: &[u64], raw_query: &[u64], c: &Config) -> Measurements {
    assert_eq!(raw_insert_keys.len(), c.n);
    assert_eq!(raw_query.len(), c.q);
    assert!(c.n > 0 && c.batch > 0 && c.insert_batch > 0);
    let build_words = F::scratch_words(c.insert_batch.min(c.n));
    let query_words = F::scratch_words(c.batch);
    let build_scratch_bytes = build_words.checked_mul(std::mem::size_of::<u64>()).unwrap();
    let query_scratch_bytes = query_words.checked_mul(std::mem::size_of::<u64>()).unwrap();
    // insert_batch is independent of query batch; its protocol is fixed later.
    let validation_batch = c.batch.min(c.insert_batch).min(c.n);
    let mut output_storage = Aligned::<u32>::new(c.q.max(c.batch) + 32);
    let (before, rest) = output_storage.split_at_mut(16);
    let (output, after) = rest.split_at_mut(c.q.max(c.batch));
    before.fill(0xfeed); after.fill(0xfeed);
    let mut insertion = Vec::new(); let mut construction = Vec::new();
    for _ in 0..c.repeats {
        let a = Instant::now();
        // Both necessary hash workspace and filter allocation/initialization
        // belong to the complete raw-build interval. DirectRaw8 allocates none.
        let mut build_scratch = Scratch::new(build_words);
        let mut fresh = F::new(c.n, c.bpk).unwrap();
        let ready = Instant::now();
        for chunk in raw_insert_keys.chunks(c.insert_batch) { raw_insert(&mut fresh, chunk, build_scratch.as_mut_slice()); }
        let done = Instant::now();
        insertion.push((done-ready).as_secs_f64()*1e9/c.n as f64);
        construction.push((done-a).as_secs_f64()*1e9/c.n as f64);
        // Every inserted raw key is checked after every timed build. No second
        // reference bitmap lives across a timed construction interval.
        for chunk in raw_insert_keys.chunks(validation_batch) {
            output[..chunk.len()].fill(OUTPUT_POISON);
            raw_batched(&fresh, chunk, &mut output[..chunk.len()], build_scratch.as_mut_slice());
            assert!(output[..chunk.len()].iter().all(|&x|x==1));
            consume(&output[..chunk.len()]);
        }
        assert!(before.iter().chain(after.iter()).all(|&x|x==0xfeed));
        // Validation and destruction are outside clocks. No build workspace
        // from this lifetime survives to the next build or query phase.
        drop(fresh);
        drop(build_scratch);
    }
    let mut filter=F::new(c.n,c.bpk).unwrap();
    {
        let mut canonical_build_scratch=Scratch::new(build_words);
        for chunk in raw_insert_keys.chunks(c.insert_batch) { raw_insert(&mut filter,chunk,canonical_build_scratch.as_mut_slice()); }
    }
    // Only API-required batch workspace lives through the query phase.
    let mut query_scratch=Scratch::new(query_words);
    for &raw in raw_insert_keys { assert!(filter.contains_raw(raw), "raw public false negative"); }
    output[..c.q].fill(OUTPUT_POISON);
    for (input,out) in raw_query.chunks(c.batch).zip(output[..c.q].chunks_mut(c.batch)) {
        raw_batched(&filter,input,out,query_scratch.as_mut_slice());
    }
    let (mut present,mut absent,mut fp,mut checksum)=(0usize,0usize,0usize,14695981039346656037u64);
    for (&raw,&answer) in raw_query.iter().zip(output.iter()) {
        assert!(answer<=1); checksum=(checksum^answer as u64).wrapping_mul(1099511628211);
        assert_eq!(answer,filter.contains_raw(raw) as u32);
        if raw>=c.key_base && raw<c.key_base+c.n as u64 {present+=1;assert_eq!(answer,1);} else {absent+=1;fp+=answer as usize;}
    }
    let expected=output[..c.q].to_vec();
    output[..c.q].fill(OUTPUT_POISON);
    raw_visible(&filter,raw_query,&mut output[..c.q]);
    verify_dense_output(&output[..c.q],&expected,before,after,checksum,"raw visible warmup");
    let orders=phase_orders(c.seed,c.repeats);let mut times:[Vec<f64>;2]=std::array::from_fn(|_|Vec::new());
    for order in &orders {
        for &mode in order {
            // Identical untimed poisoning prevents a skipped write or tail
            // from inheriting a previously correct answer.
            output[..c.q].fill(OUTPUT_POISON);
            let start=Instant::now();
            match mode {
                0=>for(input,out)in raw_query.chunks(c.batch).zip(output[..c.q].chunks_mut(c.batch)){raw_batched(&filter,input,out,query_scratch.as_mut_slice());},
                1=>raw_visible(&filter,raw_query,&mut output[..c.q]),
                _=>unreachable!(),
            }
            times[mode].push(start.elapsed().as_secs_f64()*1e9/c.q as f64);
            verify_dense_output(&output[..c.q],&expected,before,after,checksum,if mode==0{"raw batched"}else{"raw visible"});
            consume(&output[..c.q]);
        }
    }
    let count=if c.calibration_power==0{0}else{1usize<<c.calibration_power};
    let mut calibration_raw=Aligned::<u64>::new(c.batch);let mut calibration_fp=0;
    for i in(0..count).step_by(c.batch){
        let len=c.batch.min(count-i);
        for(j,raw)in calibration_raw[..len].iter_mut().enumerate(){*raw=c.key_base+c.n as u64+c.q as u64+(i+j)as u64;}
        output[..len].fill(OUTPUT_POISON);
        raw_batched(&filter,&calibration_raw[..len],&mut output[..len],query_scratch.as_mut_slice());
        for(&raw,&answer)in calibration_raw[..len].iter().zip(output.iter()){
            assert!(answer<=1);assert_eq!(answer,filter.contains_raw(raw)as u32);calibration_fp+=answer as usize;
        }
        assert!(before.iter().chain(after.iter()).all(|&x|x==0xfeed));
    }
    let [batched,visible]=times;
    Measurements{raw_batched_trials:batched,raw_visible_trials:visible,raw_insert_trials:insertion,allocate_filter_and_scratch_raw_insert_trials:construction,query_phase_order:orders,actual_bytes:filter.size_in_bytes(),insert_batch:c.insert_batch,query_batch:c.batch,build_scratch_bytes,query_scratch_bytes,present,absent,false_positives:fp,checksum,calibration_absent:count,calibration_false_positives:calibration_fp}
}
