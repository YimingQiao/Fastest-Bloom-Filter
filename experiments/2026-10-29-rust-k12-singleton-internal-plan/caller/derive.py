"""Derive a new CLI/bounds/order caller from the proved immutable workspace."""
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SOURCE = '1f409288eb288bae109cd9bcfce99977631efd99'
RECOVERY = '4a31f93725212e08be1bc127e956c53c94f588e9'
BASE = 'experiments/2026-10-29-rust-k12-singleton-vector-plan/caller/'

def blob(commit, path):
    return subprocess.check_output(['git', 'show', commit + ':' + path], cwd=ROOT)

def digest(data):
    return hashlib.sha256(data).hexdigest()

def replace(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old, new)

CONFIG = '''#[derive(Clone)]
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
'''

def derive():
    original = blob(SOURCE, BASE + 'main.rs').decode()
    text = replace(original, '//! Bounded actual public caller; check-only CLI, no formal measurement mode.',
                   '//! Fixed internal caller; explicit bounded proof and immutable formal grid.')
    text = replace(text, 'const N:usize=256;\nconst Q:usize=4096;\n', '')
    text = replace(text, 'const REPEATS:usize=4;\n', '')
    text = replace(text, '    fn new(hit:usize)->Self {\n        let mut state=74381;',
                   '    #[allow(non_snake_case)]\n    fn new(config:&Config)->Self {\n        let N=config.n;let Q=config.q;let hit=config.hit;\n        let mut state=config.seed;')
    text = replace(text, 'fn timed_work<F:PublicFilter>', '#[allow(non_snake_case)]\nfn timed_work<F:PublicFilter>')
    text = replace(text, '    let skip=fault==Some("generic-skip")&&mode==0;',
                   '    let Q=data.raw.len();\n    let skip=fault==Some("generic-skip")&&mode==0;')
    text = replace(text, '#[inline(never)]\nfn run<F:PublicFilter>(data:&Data,batch:usize,hit:usize,fault:Option<&str>)->Result<String,String> {',
                   '#[inline(never)]\n#[allow(non_snake_case)]\nfn run<F:PublicFilter>(data:&Data,config:&Config)->Result<String,String> {\n    let N=config.n;let Q=config.q;let REPEATS=config.repeats;\n    let batch=config.batch;let hit=config.hit;let fault=config.fault.as_deref();')
    text = replace(text, 'FOUR[rep].to_vec()}else{TWO[rep].to_vec()', 'FOUR[rep%4].to_vec()}else{TWO[rep%4].to_vec()')
    text = replace(text, r'\"seed\":74381,\"repeats\":4', r'\"seed\":{},\"repeats\":{}')
    text = replace(text, r'\"calibration_queries\":0', r'\"round\":{},\"stage\":{:?},\"calibration_queries\":0')
    text = replace(text, 'F::NAME,N,Q,batch,hit,filter.bytes()', 'F::NAME,N,Q,batch,hit,config.seed,REPEATS,filter.bytes()')
    text = replace(text, 'scratch.len()*8,order,trials);', 'scratch.len()*8,order,trials,config.round,if config.measure{"measure"}else{"check"});')
    text = text[:text.index('fn parse()->')] + CONFIG
    timed_start = '            out[1..Q+1].fill(POISON);\n            let start=Instant::now();'
    timed_end = '            trials[mode].push(elapsed);'
    def block(s):
        begin=s.index(timed_start);end=s.index(timed_end,begin)+len(timed_end)
        return s[begin:end]
    assert block(original) == block(text)
    before_query = original[original.index('fn timed_work'):original.index('\n#[inline(never)]')]
    after_query = text[text.index('fn timed_work'):text.index('\n#[inline(never)]')]
    assert after_query.replace('    let Q=data.raw.len();\n','') == before_query
    files = {'main.rs': text.encode()}
    record = {'main.rs': dict(commit=SOURCE, path=BASE+'main.rs', original_sha256=digest(original.encode()),
                              sha256=digest(files['main.rs']), change='CLI, runtime bounds, metadata and whole/API order only')}
    names = list(json.loads(blob(SOURCE, BASE+'DERIVED.json'))['files']) + ['Cargo.toml','Cargo.lock','query.rs']
    for name in names:
        files[name] = blob(SOURCE, BASE+name)
        record[name] = dict(commit=SOURCE, path=BASE+name, sha256=digest(files[name]), change='byte-identical')
    for name, commit, path in [('dependencies.py', RECOVERY, BASE+'repair-v2/dependencies.py'),
                               ('lease.py', SOURCE, BASE+'lease.py'), ('asm.py', SOURCE, BASE+'asm.py')]:
        files[name] = blob(commit, path)
        record[name] = dict(commit=commit, path=path, sha256=digest(files[name]), change='byte-identical')
    original_asm = files['asm.py'].decode()
    derived_asm = replace(original_asm,
        "        if role is None or not size:continue",
        "        if role is None and 'PublicFilter' in name and name.endswith('::contains'):role='public_trait_facade'\n        if role is None or not size:continue")
    files['asm.py'] = derived_asm.encode()
    record['asm.py'].update(original_sha256=record['asm.py']['sha256'],sha256=digest(files['asm.py']),
                            change='Add optional actual public trait facade role; ELF address/size mechanism unchanged')
    files['ASM.patch'] = ''.join(difflib.unified_diff(original_asm.splitlines(True), derived_asm.splitlines(True), fromfile='frozen/asm.py', tofile='internal/asm.py')).encode()
    files['MAIN.patch'] = ''.join(difflib.unified_diff(original.splitlines(True), text.splitlines(True), fromfile='frozen/main.rs', tofile='internal/main.rs')).encode()
    description = dict(files=record, timed_block_sha256=digest(block(original).encode()),
                       timed_block_byte_identical=True, query_rs_byte_identical=True,
                       local_runtime_uppercase_bounds='Explicitly allowed to preserve the literal timed block; no unsafe code added.',
                       proposal_commit='9e7fb401ccd6bd55a151eb8cc32395a06375862a')
    files['DERIVED.json'] = (json.dumps(description,indent=2,sort_keys=True)+'\n').encode()
    return files

if __name__ == '__main__':
    files = derive()
    for name, data in files.items():
        path=HERE/name;path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
    print(json.dumps(dict(derived_files=len(files), main_sha256=digest(files['main.rs']))))
