//! Bounded actual public caller; check-only CLI, no formal measurement mode.
mod query;
use query::PublicFilter;
use std::hint::black_box;
use std::time::Instant;

const N:usize=256;
const Q:usize=4096;
const BPK:u32=24;
const REPEATS:usize=4;
const GUARD:u32=0xdead_beef;
const POISON:u32=0xffff_fffe;
const FOUR:[[usize;4];4]=[[0,1,3,2],[1,2,0,3],[2,3,1,0],[3,0,2,1]];
const TWO:[[usize;2];4]=[[0,1],[1,0],[1,0],[0,1]];

fn mix(state:&mut u64)->u64 {
    *state=state.wrapping_add(0x9e3779b97f4a7c15);
    let mut z=*state;
    z=(z^(z>>30)).wrapping_mul(0xbf58476d1ce4e5b9);
    z=(z^(z>>27)).wrapping_mul(0x94d049bb133111eb);
    z^(z>>31)
}
fn hash(mut x:u64)->u64 {
    x^=x>>32; x=x.wrapping_mul(0xd6e8feb86659fd93);
    x^=x>>32; x=x.wrapping_mul(0xd6e8feb86659fd93); x^(x>>32)
}
fn digest<I:IntoIterator<Item=u64>>(values:I)->u64 {
    values.into_iter().fold(0xcbf29ce484222325,|s,x|(s^x).wrapping_mul(0x100000001b3))
}

// Independent u128 address and explicit bit positions; never a target kernel.
fn probes(h:u64,lines:usize)->[(usize,u32);12] {
    const B:[[u32;3];16]=[[0,1,3],[0,4,9],[0,6,13],[0,8,18],
        [0,1,12],[0,2,15],[0,4,16],[0,3,8],[0,6,15],[0,7,18],
        [0,1,10],[0,2,5],[0,4,10],[0,7,15],[0,1,13],[0,3,14]];
    let hi=h>>32; let lo=h&0xffff_ffff;
    let line=(((hi>>8)as u128*lines as u128)/(1u128<<24))as usize;
    let mut p=[(0,0);12];
    for j in 0..4 {
        let shift=j*8;
        let c=if shift==0 {lo}else{((lo>>shift)|(lo<<(32-shift)))&0xffff_ffff};
        let off=if j==0 {hi&3}else{(hi&3)^((hi>>(j*2))&3)};
        for k in 0..3 {p[j*3+k]=(line*16+j*4+off as usize,1u32<<((B[(c&15)as usize][k]+((c>>4)&31)as u32)%32));}
    }
    p
}

struct Data { raw:Vec<u64>, hashes:Vec<u64>, keys:Vec<u64>, words:Vec<u32>, answers:Vec<u32> }
impl Data {
    fn new(hit:usize)->Self {
        let mut state=74381;
        let base=mix(&mut state)%((1u64<<32)-N as u64-Q as u64);
        let keys:Vec<_>=(0..N).map(|i|hash(base+i as u64)).collect();
        let raw:Vec<_>=(0..Q).map(|i|if i%100<hit {base+mix(&mut state)%N as u64}else{base+N as u64+i as u64}).collect();
        let hashes:Vec<_>=raw.iter().map(|&x|hash(x)).collect();
        for (&r,&h) in raw.iter().zip(&hashes) {assert_eq!(h,control_native::hash64(r));}
        let mut words=vec![0u32;N*BPK as usize/32];
        let lines=words.len()/16;
        for &h in &keys {for (index,bit) in probes(h,lines) {words[index]|=bit;}}
        let answers=hashes.iter().map(|&h|probes(h,lines).iter().all(|&(i,b)|words[i]&b!=0)as u32).collect();
        Self{raw,hashes,keys,words,answers}
    }
}

fn validate(output:&[u32],expected:&[u32])->Result<(),String> {
    if output.len()!=expected.len()+2 || output[0]!=GUARD || output[output.len()-1]!=GUARD {
        return Err("output guard mismatch".into());
    }
    if &output[1..output.len()-1]!=expected {return Err("full output mismatch".into());}
    black_box(digest(output[1..output.len()-1].iter().map(|&x|x as u64)));
    Ok(())
}

// Two finite post-warmup faulty producers; the skipped final output stays poison.
fn timed_work<F:PublicFilter>(filter:&F,mode:usize,data:&Data,out:&mut[u32],scratch:&mut[u64],batch:usize,fault:Option<&str>) {
    let skip=fault==Some("generic-skip")&&mode==0;
    let end=if skip{Q-1}else{Q};
    query::execute(filter,mode,&data.raw[..end],&data.hashes[..end],&mut out[..end],scratch,batch);
    if fault==Some("visible-wrong")&&mode==2 {out[Q-1]=1-data.answers[Q-1];}
}

#[inline(never)]
fn run<F:PublicFilter>(data:&Data,batch:usize,hit:usize,fault:Option<&str>)->Result<String,String> {
    let mut filter=F::new(N,BPK);
    if filter.bytes()!=N*BPK as usize/8 {return Err("allocation mismatch".into());}
    filter.insert(&data.keys);
    if filter.words()!=data.words {return Err("complete bitmap mismatch".into());}
    if !data.keys.iter().all(|&h|filter.contains(h)) {return Err("inserted false negative".into());}
    let input_before=(data.raw.clone(),data.hashes.clone(),data.keys.clone());
    let mut out=vec![POISON;Q+2];out[0]=GUARD;out[Q+1]=GUARD;
    let mut scratch=vec![0u64;batch.min(Q)];
    let modes=if batch==1{4}else{2};
    for mode in 0..modes {
        out[1..Q+1].fill(POISON);
        timed_work(&filter,mode,data,&mut out[1..Q+1],&mut scratch,batch,None);
        validate(&out,&data.answers)?;
    }
    let mut trials=vec![Vec::<f64>::new();modes];
    let mut order=Vec::new();
    for rep in 0..REPEATS {
        let phases:Vec<_>=if batch==1 {FOUR[rep].to_vec()}else{TWO[rep].to_vec()};
        order.push(phases.clone());
        for mode in phases {
            out[1..Q+1].fill(POISON);
            let start=Instant::now();
            timed_work(&filter,mode,data,&mut out[1..Q+1],&mut scratch,batch,if rep==0{fault}else{None});
            let elapsed=start.elapsed().as_nanos()as f64/Q as f64;
            validate(&out,&data.answers)?;
            trials[mode].push(elapsed);
        }
    }
    if data.raw!=input_before.0||data.hashes!=input_before.1||data.keys!=input_before.2 {
        return Err("input mutation".into());
    }
    if filter.words()!=data.words {return Err("query changed bitmap".into());}
    let row=format!("{{\"filter\":{:?},\"keys\":{},\"queries\":{},\"batch\":{},\"hit\":{},\"seed\":74381,\"repeats\":4,\"filter_bytes\":{},\"backend\":{:?},\"input_digest\":{},\"insert_digest\":{},\"bitmap_digest\":{},\"output_digest\":{},\"scratch_bytes\":{},\"phase_order\":{:?},\"trials_ns\":{:?},\"calibration_queries\":0}}",
        F::NAME,N,Q,batch,hit,filter.bytes(),filter.backend(),digest(data.raw.iter().copied()),
        digest(data.keys.iter().copied()),digest(data.words.iter().map(|&x|x as u64)),
        digest(data.answers.iter().map(|&x|x as u64)),scratch.len()*8,order,trials);
    Ok(row)
}

fn parse()->Result<(usize,usize,Option<String>),String> {
    let args:Vec<_>=std::env::args().skip(1).collect();
    if args.len()!=4&&args.len()!=6 {return Err("expected --check HIT BATCH SEED [--fault NAME]".into());}
    if args[0]!="--check"||args[3]!="74381" {return Err("only fixed check seed74381 is permitted".into());}
    let hit=args[1].parse::<usize>().map_err(|_|"invalid hit".to_string())?;
    let batch=args[2].parse::<usize>().map_err(|_|"invalid batch".to_string())?;
    if ![0,50,100].contains(&hit)||![1,3,31,4096].contains(&batch) {return Err("outside fixed check grid".into());}
    let fault=if args.len()==6 {
        if args[4]!="--fault"||!["generic-skip","visible-wrong"].contains(&args[5].as_str())||batch!=1||hit!=50 {
            return Err("invalid fixed fault case".into());
        }
        Some(args[5].clone())
    }else{None};
    Ok((hit,batch,fault))
}
fn main() {
    let result=(||{
        let (hit,batch,fault)=parse()?;
        let data=Data::new(hit);
        let a=run::<control_native::FourSectorRange12BloomFilter>(&data,batch,hit,fault.as_deref())?;
        let b=run::<candidate_native::FourSectorRange12BloomFilter>(&data,batch,hit,fault.as_deref())?;
        // Do not print partial success if either arm or a deliberate fault fails.
        println!("{a}\n{b}");
        Ok::<(),String>(())
    })();
    if let Err(error)=result {eprintln!("{error}");std::process::exit(1);}
}
