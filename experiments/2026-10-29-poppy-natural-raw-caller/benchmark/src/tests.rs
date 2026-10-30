use super::*;
include!("allocation.rs");

#[derive(Clone, Copy)]
pub(crate) struct Event { pub phase: &'static str, pub live: usize }
impl Event { const EMPTY: Self = Self { phase: "", live: 0 }; }
#[derive(Clone, Copy)]
struct Trace { events: [Event; 128], len: usize }
thread_local! {
    static TRACE: std::cell::Cell<Option<Trace>> = const { std::cell::Cell::new(None) };
    static VISIBLE_FAULT: std::cell::Cell<Option<(bool, u64, usize)>> = const { std::cell::Cell::new(None) };
}
pub(crate) fn lifecycle(phase: &'static str) {
    TRACE.with(|slot| if let Some(mut trace) = slot.get() {
        let counts = allocation::current();
        trace.events[trace.len] = Event { phase, live: counts.bytes - counts.freed_bytes };
        trace.len += 1; slot.set(Some(trace));
    });
}
pub(crate) fn trace<T>(f: impl FnOnce() -> T) -> (T, Vec<Event>) {
    TRACE.with(|slot| { assert!(slot.get().is_none()); slot.set(Some(Trace { events: [Event::EMPTY;128],len:0 })); });
    let (value, _) = allocation::measure(f);
    let trace = TRACE.with(|slot| slot.take().unwrap());
    (value, trace.events[..trace.len].to_vec())
}
pub(crate) fn begin_visible() {
    VISIBLE_FAULT.with(|slot| if let Some((skip,key,calls))=slot.get() {slot.set(Some((skip,key,calls+1)));});
}
pub(crate) fn skip_visible_write(raw: u64) -> bool {
    VISIBLE_FAULT.with(|slot| matches!(slot.get(),Some((true,key,2)) if key==raw))
}
pub(crate) fn corrupt_visible_write(raw: u64, answer: &mut u32) {
    VISIBLE_FAULT.with(|slot| if matches!(slot.get(),Some((false,key,2)) if key==raw) {*answer^=1;});
}
pub(crate) fn visible_fault(skip: bool, key: u64) {
    VISIBLE_FAULT.with(|slot| slot.set(Some((skip,key,0))));
}
pub(crate) fn clear_fault() { VISIBLE_FAULT.with(|slot| slot.set(None)); }

fn public_raw_parity<F: Filter>() {
    let mut direct=F::new(128,24).unwrap();
    let mut wrapped=CommonHash::<F>::new(128,24).unwrap();
    let raw:Vec<_>=(0..128).chain([0,0,u64::MAX,1<<32]).collect();
    let hashes:Vec<_>=raw.iter().copied().map(hash64).collect();
    let mut scratch=vec![0;4097];
    direct.insert_hashes(&hashes);
    wrapped.insert_raw(&raw,&mut scratch);
    assert_eq!(direct.size_in_bytes(),wrapped.size_in_bytes());
    for value in &raw { assert!(wrapped.contains_raw(*value)); }
    let input:Vec<_>=(0..4104).map(|i|if i%3==0 {raw[i%raw.len()]}else{1_000_000+i as u64}).collect();
    for offset in [0,1,3,7] {
        for len in [0,1,3,7,31,63,129,4096,4097] {
            let values=&input[offset..offset+len];let copied=values.to_vec();
            let expected:Vec<_>=values.iter().map(|&raw|direct.contains_hash(hash64(raw))as u32).collect();
            let mut out=vec![0xfeed;len+2];
            raw_contract::raw_batched(&wrapped,values,&mut out[1..len+1],&mut scratch);
            assert_eq!(&out[1..len+1],expected);assert_eq!(out[0],0xfeed);assert_eq!(out[len+1],0xfeed);
            out[1..len+1].fill(2);
            raw_contract::raw_visible(&wrapped,values,&mut out[1..len+1]);
            assert_eq!(&out[1..len+1],expected);assert_eq!(values,copied);assert_eq!(out[0],0xfeed);assert_eq!(out[len+1],0xfeed);
        }
    }
    let mut bad=[0xfeed;2];
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(||wrapped.lookup_raw(&input[..3],&mut bad,&mut scratch))).is_err());
    assert_eq!(bad,[0xfeed;2]);
}
#[test]
fn retained_public_common_hash_adapters_match_all_dense_outputs() {
    public_raw_parity::<BloomFilter<true>>();
    public_raw_parity::<ByteSplitBloomFilter>();
    public_raw_parity::<FourSectorBloomFilter>();
    public_raw_parity::<Split64BloomFilter>();
    public_raw_parity::<Split64RangeBloomFilter>();
    public_raw_parity::<FourSectorRange12BloomFilter>();
    public_raw_parity::<Fastbloom017>();
    public_raw_parity::<BloomsdayPinned>();
    public_raw_parity::<SbbfSafePinned>();
    public_raw_parity::<FastbloomFixed<1>>();
    public_raw_parity::<FastbloomFixed<2>>();
    public_raw_parity::<FastbloomFixed<3>>();
    public_raw_parity::<FastbloomFixed<4>>();
    public_raw_parity::<FastbloomFixed<5>>();
    public_raw_parity::<FastbloomFixed<6>>();
    public_raw_parity::<FastbloomFixed<7>>();
    public_raw_parity::<FastbloomFixed<8>>();
    public_raw_parity::<FastbloomFixed<9>>();
    public_raw_parity::<FastbloomFixed<10>>();
    public_raw_parity::<FastbloomFixed<11>>();
    public_raw_parity::<FastbloomFixed<12>>();
 }
