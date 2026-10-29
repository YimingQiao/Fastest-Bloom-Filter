//! Fixed internal caller; explicit bounded proof and immutable formal grid.
mod query;
use query::PublicFilter;
use std::hint::black_box;
use std::time::Instant;

const BPK:u32=24;
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
    #[allow(non_snake_case)]
    fn new(config:&Config)->Self {
        let N=config.n;let Q=config.q;let hit=config.hit;
        let mut state=config.seed;
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
#[allow(non_snake_case)]
fn timed_work<F:PublicFilter>(filter:&F,mode:usize,data:&Data,out:&mut[u32],scratch:&mut[u64],batch:usize,fault:Option<&str>) {
    let Q=data.raw.len();
    let skip=fault==Some("generic-skip")&&mode==0;
    let end=if skip{Q-1}else{Q};
    query::execute(filter,mode,&data.raw[..end],&data.hashes[..end],&mut out[..end],scratch,batch);
    if fault==Some("visible-wrong")&&mode==2 {out[Q-1]=1-data.answers[Q-1];}
}

#[inline(never)]
#[allow(non_snake_case)]
fn run<F:PublicFilter>(data:&Data,config:&Config)->Result<String,String> {
    let N=config.n;let Q=config.q;let REPEATS=config.repeats;
    let batch=config.batch;let hit=config.hit;let fault=config.fault.as_deref();
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
        let phases:Vec<_>=if batch==1 {FOUR[rep%4].to_vec()}else{TWO[rep%4].to_vec()};
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
    let row=format!("{{\"filter\":{:?},\"keys\":{},\"queries\":{},\"batch\":{},\"hit\":{},\"seed\":{},\"repeats\":{},\"filter_bytes\":{},\"backend\":{:?},\"input_digest\":{},\"insert_digest\":{},\"bitmap_digest\":{},\"output_digest\":{},\"scratch_bytes\":{},\"phase_order\":{:?},\"trials_ns\":{:?},\"round\":{},\"stage\":{:?},\"calibration_queries\":0}}",
        F::NAME,N,Q,batch,hit,config.seed,REPEATS,filter.bytes(),filter.backend(),digest(data.raw.iter().copied()),
        digest(data.keys.iter().copied()),digest(data.words.iter().map(|&x|x as u64)),
        digest(data.answers.iter().map(|&x|x as u64)),scratch.len()*8,order,trials,config.round,if config.measure{"measure"}else{"check"});
    Ok(row)
}

#[derive(Clone)]
struct Config { n:usize, q:usize, hit:usize, batch:usize, seed:u64, repeats:usize,
                round:usize, measure:bool, fault:Option<String> }

fn parse()->Result<Config,String> {
    let args:Vec<_>=std::env::args().skip(1).collect();
    if args.is_empty() {return Err("expected explicit --check or --measure".into());}
    let number=|i:usize|->Result<u64,String> {
        args.get(i).ok_or_else(||"missing argument".to_string())?
            .parse::<u64>().map_err(|_|"invalid integer".to_string())
    };
    if args[0]=="--check" {
        if ![4,5,6].contains(&args.len()) {return Err("invalid check arguments".into());}
        let hit=number(1)?;let batch=number(2)?;let seed=number(3)?;
        if hit!=50||![1,3,31,4096].contains(&batch)||seed!=74381 {
            return Err("outside fixed check grid".into());
        }
        let mut round=1;let mut fault=None;
        if args.len()==5 {
            if args[4]!="--reverse"||batch!=1 {return Err("invalid check reverse".into());}
            round=2;
        }
        if args.len()==6 {
            if args[4]!="--fault"||!["generic-skip","visible-wrong"].contains(&args[5].as_str())||batch!=1 {
                return Err("invalid fixed fault case".into());
            }
            fault=Some(args[5].clone());
        }
        return Ok(Config{n:256,q:4096,hit:50,batch:batch as usize,seed,repeats:4,round,measure:false,fault});
    }
    if args[0]!="--measure"||args.len()!=6 {return Err("invalid formal arguments".into());}
    let power=number(1)?;let hit=number(2)?;let batch=number(3)?;let seed=number(4)?;let round=number(5)?;
    if ![16,25].contains(&power)||![6812364731,9517218469].contains(&seed)||![1,2].contains(&round)
        ||!((hit==50&&[1,3,31,4096].contains(&batch))||([0,100].contains(&hit)&&batch==1)) {
        return Err("outside fixed formal grid".into());
    }
    Ok(Config{n:1usize<<(power as u32),q:1usize<<22,hit:hit as usize,batch:batch as usize,
              seed,repeats:8,round:round as usize,measure:true,fault:None})
}

fn main() {
    let result=(||{
        let config=parse()?;
        let data=Data::new(&config);
        let rows=if config.round==1 {
            vec![run::<control_native::FourSectorRange12BloomFilter>(&data,&config)?,
                 run::<candidate_native::FourSectorRange12BloomFilter>(&data,&config)?]
        }else{
            vec![run::<candidate_native::FourSectorRange12BloomFilter>(&data,&config)?,
                 run::<control_native::FourSectorRange12BloomFilter>(&data,&config)?]
        };
        // Both complete before any stdout, including reverse/fault checks.
        for row in rows {println!("{row}");}
        Ok::<(),String>(())
    })();
    if let Err(error)=result {eprintln!("{error}");std::process::exit(1);}
}
