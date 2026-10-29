use four_sector_range12_inline_isolated::FourSectorRange12BloomFilter;
use std::io::{self,Write};
fn hash(mut z:u64)->u64 {z=(z^(z>>30)).wrapping_mul(0xbf58476d1ce4e5b9);z=(z^(z>>27)).wrapping_mul(0x94d049bb133111eb);z^(z>>31)}
fn main(){
    let args:Vec<_>=std::env::args().collect();assert_eq!(args.len(),4);
    let bytes:usize=args[1].parse().unwrap();let workers:usize=args[2].parse().unwrap();let hot:u64=args[3].parse().unwrap();assert!(hot<=1);
    let h:Vec<_>=(0..32771).map(|i|if hot==1{hash(i+731)&0x0000_00ff_ffff_ffff}else{hash(i+731)}).collect();
    let q:Vec<_>=(0..8193).map(|i|if i%2==0{h[i%h.len()]}else{hash(i as u64+100_000)}).collect();
    let h_before=h.clone();let q_before=q.clone();
    let mut filter=FourSectorRange12BloomFilter::with_byte_budget(bytes).unwrap();filter.insert_hashes_parallel(&h,workers);
    let mut answers=vec![0;q.len()];filter.lookup_hashes_parallel(&q,&mut answers,workers);assert!(h.iter().all(|&h|filter.contains_hash(h)));
    assert_eq!(h,h_before);assert_eq!(q,q_before);
    eprintln!("{{\"backend\":\"{}\",\"bytes\":{},\"workers\":{}}}",filter.backend(),filter.size_in_bytes(),filter.build_workers(h.len(),workers));
    let mut out=io::BufWriter::new(io::stdout().lock());
    for word in filter.bitmap_words().iter().chain(&answers){out.write_all(&word.to_le_bytes()).unwrap();}
}
