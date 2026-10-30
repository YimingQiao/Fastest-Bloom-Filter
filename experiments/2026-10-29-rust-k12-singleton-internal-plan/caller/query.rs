//! Real public APIs; ordinary wrapper inlining, whole-loop boundaries explicit.
pub trait PublicFilter: Sized {
    const NAME: &'static str;
    fn new(n: usize, bpk: u32) -> Self;
    fn insert(&mut self, hashes: &[u64]);
    fn contains(&self, hash: u64) -> bool;
    fn lookup(&self, hashes: &[u64], out: &mut [u32]);
    fn words(&self) -> &[u32];
    fn bytes(&self) -> usize;
    fn backend(&self) -> &'static str;
}

macro_rules! bind {
    ($native:ty,$name:literal) => {
        impl PublicFilter for $native {
            const NAME: &'static str = $name;
            fn new(n:usize,bpk:u32)->Self { <$native>::new(n,bpk).unwrap() }
            fn insert(&mut self,h:&[u64]) { self.insert_hashes(h); }
            #[inline]
            fn contains(&self,h:u64)->bool { self.contains_hash(h) }
            #[inline]
            fn lookup(&self,h:&[u64],o:&mut[u32]) { self.lookup_hashes(h,o); }
            fn words(&self)->&[u32] { self.bitmap_words() }
            fn bytes(&self)->usize { self.size_in_bytes() }
            fn backend(&self)->&'static str { <$native>::backend(self) }
        }
    }
}
bind!(control_native::FourSectorRange12BloomFilter,"Control");
bind!(candidate_native::FourSectorRange12BloomFilter,"Candidate");

#[inline(never)]
pub fn lookup_kernel<F:PublicFilter>(filter:&F, hashes:&[u64], out:&mut[u32]) {
    filter.lookup(hashes,out);
}

#[inline(never)]
pub fn visible_pure<F:PublicFilter>(filter:&F, hashes:&[u64], out:&mut[u32]) {
    assert_eq!(hashes.len(),out.len());
    for (&h,answer) in hashes.iter().zip(out) { *answer=filter.contains(h) as u32; }
}

#[inline(never)]
pub fn visible_fused<F:PublicFilter>(filter:&F, raw:&[u64], out:&mut[u32]) {
    assert_eq!(raw.len(),out.len());
    for (&value,answer) in raw.iter().zip(out) {
        *answer=filter.contains(control_native::hash64(value)) as u32;
    }
}

#[inline(never)]
pub fn execute<F:PublicFilter>(filter:&F, mode:usize, raw:&[u64], hashes:&[u64],
                             out:&mut[u32], scratch:&mut[u64], batch:usize) {
    assert_eq!(raw.len(),hashes.len());
    assert_eq!(raw.len(),out.len());
    match mode {
        0 => for (input,output) in hashes.chunks(batch).zip(out.chunks_mut(batch)) {
            lookup_kernel(filter,input,output);
        },
        1 => for (input,output) in raw.chunks(batch).zip(out.chunks_mut(batch)) {
            let prepared=&mut scratch[..input.len()];
            for (h,&value) in prepared.iter_mut().zip(input) { *h=control_native::hash64(value); }
            lookup_kernel(filter,prepared,output);
        },
        2 => visible_pure(filter,hashes,out),
        3 => visible_fused(filter,raw,out),
        _ => unreachable!(),
    }
}
