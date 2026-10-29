"""Derive an isolated four-arm caller and exact native snapshots; never build/run."""
from pathlib import Path
import difflib,hashlib,json,subprocess
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
PARENT='26232ad9b1412e64346e09f40de15f8ef77c52f7'
PREFIX='experiments/2026-10-29-native-build-policy-port/proof/'

def blob(name):return subprocess.check_output(['git','show',PARENT+':'+PREFIX+name],cwd=ROOT)
def change(text,old,new,count=None):
    if count is not None:assert text.count(old)==count,(old,text.count(old),count)
    assert old in text,old
    return text.replace(old,new)
def sources():
    result={};origins={}
    names=subprocess.check_output(['git','ls-tree','-r','--name-only',PARENT,'--',PREFIX],cwd=ROOT,text=True).splitlines()
    for path in names:
        name=path[len(PREFIX):]
        if name.startswith(('cpp/before/','cpp/after/','native/before/rust/','native/after/rust/'))or name=='cpp/placement.hpp':
            data=blob(name);result[name]=data;origins[name]=dict(commit=PARENT,path=path,sha256=hashlib.sha256(data).hexdigest(),change='none')
            if name.startswith('cpp/before/'):
                target=name.replace('cpp/before/','cpp/clone/',1);derived=data.replace(b'native_before',b'native_clone');result[target]=derived;origins[target]=dict(origins[name],change='namespace token native_before -> native_clone')
            elif name.startswith('native/before/rust/'):
                target=name.replace('native/before/rust/','native/clone/rust/',1);derived=data
                if name.endswith('/Cargo.toml'):derived=derived.replace(b'fastest-bloom-filter-before',b'fastest-bloom-filter-clone')
                result[target]=derived;origins[target]=dict(origins[name],change='package identity only for Cargo.toml; all Rust source unchanged')
    cpp=blob('cpp/main.cpp').decode();oldcpp=cpp
    cpp=change(cpp,'constexpr unsigned Schedule[4][3] = {{0,1,2},{2,1,0},{0,2,1},{1,2,0}};','constexpr unsigned Schedule[4][4] = {{0,1,3,2},{1,2,0,3},{2,3,1,0},{3,0,2,1}};',1)
    cpp=change(cpp,'constexpr const char* Arms[3] = {"serial", "control", "candidate"};','constexpr const char* Arms[4] = {"A0", "A1", "Clone", "Policy"};',1)
    cpp=change(cpp,'std::array<std::array<size_t,4>,6>','std::array<std::array<size_t,4>,5>',1)
    cpp=change(cpp,'{large,65536,0,0},{large,65536,large/2,1}','{large,65536,0,0}',1)
    cpp=cpp.replace('bool After','unsigned Variant').replace('bool Range,bool After','bool Range,unsigned Variant').replace('Range,After','Range,Variant').replace('After &&','Variant==2 &&').replace('Observe<After>','Observe<Variant>')
    cpp=change(cpp,'const Case& c,bool serial)', 'const Case& c)',1)
    cpp=change(cpp,'return serial ? Stats{1,1,0} : Stats{e,w,scratch};','return Stats{e,w,scratch};',1)
    cpp=change(cpp,'template<bool Range,unsigned Variant> void Trial','template<bool Range,unsigned Variant> __attribute__((noinline)) void Trial',1)
    cpp=change(cpp,'std::vector<uint32_t>& out,bool serial,bool allocate,Samples& samples)','std::vector<uint32_t>& out,bool allocate,Samples& samples)',1)
    cpp=cpp.replace('Observe<Variant>(filter,c,serial)','Observe<Variant>(filter,c)').replace('if(!serial) Affinity(c.cpus);','Affinity(c.cpus);')
    cpp=change(cpp,'if(serial) filter.Insert(static_cast<uint32_t>(c.n),d.batch.data());\n        else filter.InsertParallel','filter.InsertParallel',2)
    cpp=change(cpp,'std::array<Samples,3> samples','std::array<Samples,4> samples',1).replace('Make<Range,false>','Make<Range,0>')
    cpp=change(cpp,'repeat<4','repeat<32',1).replace('const bool allocation_first=repeat==1 || repeat==2;','const bool allocation_first=(repeat/4+repeat)%2!=0;').replace('Schedule[repeat]','Schedule[repeat%4]')
    cpp=change(cpp,'if(arm==2) Trial<Range,true>(c,d,expected,out,false,allocate,samples[arm]);\n                else Trial<Range,false>(c,d,expected,out,arm==0,allocate,samples[arm]);','if(arm==3) Trial<Range,2>(c,d,expected,out,allocate,samples[arm]);\n                else if(arm==2) Trial<Range,1>(c,d,expected,out,allocate,samples[arm]);\n                else Trial<Range,0>(c,d,expected,out,allocate,samples[arm]);',1)
    cpp=cpp.replace('repeats\\\":4','repeats\\\":32').replace('serial_pair_abba4','four_arm_williams8').replace('arm<3','arm<4')
    cpp=change(cpp,'scenario<6 && (request==4 || request==8) && (seed==74381 || seed==164321)','scenario<5 && request==4 && (seed==2694173 || seed==3819257)',1)
    cpp=change(cpp,'void Run(const Case& c,bool corrupt)','void Run(const Case& c,bool corrupt,size_t repeats)',1)
    cpp=change(cpp,'repeat<32','repeat<repeats',1)
    cpp=change(cpp,r'<<",\"repeats\":32,\"phase_order\":',r'<<",\"repeats\":"<<repeats<<",\"cycles\":"<<repeats/4<<",\"phase_order\":',1)
    cpp=cpp.replace('four_arm_williams8','four_arm_williams')
    cpp=change(cpp,'scenario<5 && request==4 && (seed==2694173 || seed==3819257)','scenario<5 && request==4',1)
    cpp=change(cpp,'Need(mode=="--measure" || mode=="--check-bad-output","unknown mode");','Need(mode=="--measure" || mode=="--caller-check" || mode=="--check-bad-output","unknown mode");\n    const bool measure=mode=="--measure";\n    Need(measure ? (seed==2694173 || seed==3819257) : seed==74381,"wrong stage input seed");',1)
    cpp=cpp.replace('Run<true>(c,mode=="--check-bad-output")','Run<true>(c,mode=="--check-bad-output",measure?32:4)').replace('Run<false>(c,mode=="--check-bad-output")','Run<false>(c,mode=="--check-bad-output",measure?32:4)')
    result['cpp/main.cpp']=cpp.encode()
    bindings='#pragma once\n'
    for side in ['before','clone','after']:
        for header in ['parallel_layout_bloom.h','parallel_split64_range_bloom.h']:bindings+=f'#include "{side}/{header}"\n'
    bindings+='template<bool Range,unsigned Variant> struct NativeBinding;\n'
    for variant,side in enumerate(['before','clone','after']):
        for is_range in [False,True]:
            ty='ParallelSplit64RangeBloomFilter'if is_range else'ParallelSplit64BloomFilter';make=f'Type(native_{side}::RangeBytes{{bytes}})'if is_range else'Type(bytes / 2, 8)'
            bindings+=f'template<> struct NativeBinding<{str(is_range).lower()},{variant}> {{\n    using Type = native_{side}::{ty};\n    static Type Make(size_t bytes) {{ return {make}; }}\n}};\n'
    result['cpp/bindings.hpp']=bindings.encode()
    rust=blob('rust/src/main.rs').decode();oldrust=rust
    rust=change(rust,'const SCHEDULE: [[usize; 3]; 4] = [[0, 1, 2], [2, 1, 0], [0, 2, 1], [1, 2, 0]];','const SCHEDULE: [[usize; 4]; 4] = [[0, 1, 3, 2], [1, 2, 0, 3], [2, 3, 1, 0], [3, 0, 2, 1]];',1)
    rust=change(rust,'const ARMS: [&str; 3] = ["serial", "control", "candidate"];','const ARMS: [&str; 4] = ["A0", "A1", "Clone", "Policy"];',1)
    rust=change(rust,'(large, 65536, 0, false), (large, 65536, large / 2, true)','(large, 65536, 0, false)',1)
    rust=change(rust,'fn observe<F: Native>(filter: &F, c: &Case, serial: bool)','fn observe<F: Native>(filter: &F, c: &Case)',1)
    rust=change(rust,'if serial { Stats { effective: 1, workers: 1, scratch: 0 } }\n    else { Stats { effective, workers: w, scratch } }','Stats { effective, workers: w, scratch }',1)
    rust=change(rust,'fn trial<F: Native>','#[inline(never)]\nfn trial<F: Native>',1)
    rust=change(rust,'serial: bool, allocate: bool, samples: &mut Samples)','allocate: bool, samples: &mut Samples)',1)
    rust=rust.replace('observe(&filter, c, serial)','observe(&filter, c)').replace('if !serial { affinity(&c.cpus); }','affinity(&c.cpus);')
    rust=change(rust,'if serial { filter.insert_hashes(black_box(&d.batch)); }\n        else { filter.insert_hashes_parallel(black_box(&d.batch), c.requested); }','filter.insert_hashes_parallel(black_box(&d.batch), c.requested);',2)
    rust=change(rust,'fn run<Before: Native, After: Native>','fn run<Before: Native, Clone: Native, After: Native>',1).replace('[Samples; 3]','[Samples; 4]')
    rust=change(rust,'for (repeat, schedule) in SCHEDULE.iter().enumerate() {\n        let allocation_first = repeat == 1 || repeat == 2;','for repeat in 0..32 {\n        let schedule = &SCHEDULE[repeat % 4];\n        let allocation_first = (repeat / 4 + repeat) % 2 != 0;',1)
    rust=change(rust,'if arm == 2 { trial::<After>(c, &d, &expected, &mut out, false, allocate, &mut samples[arm]); }\n                else { trial::<Before>(c, &d, &expected, &mut out, arm == 0, allocate, &mut samples[arm]); }','if arm == 3 { trial::<After>(c, &d, &expected, &mut out, allocate, &mut samples[arm]); }\n                else if arm == 2 { trial::<Clone>(c, &d, &expected, &mut out, allocate, &mut samples[arm]); }\n                else { trial::<Before>(c, &d, &expected, &mut out, allocate, &mut samples[arm]); }',1)
    rust=rust.replace('repeats\\\":4','repeats\\\":32').replace('serial_pair_abba4','four_arm_williams8')
    rust=change(rust,'scenario < 6 && [4, 8].contains(&requested) && [74381, 164321].contains(&seed)','scenario < 5 && requested == 8 && [2694173, 3819257].contains(&seed)',1)
    for ty in ['Split64RangeBloomFilter','Split64BloomFilter']:
        rust=rust.replace(f'run::<before_native::{ty}, after_native::{ty}>',f'run::<before_native::{ty}, clone_native::{ty}, after_native::{ty}>')
    rust=change(rust,'(family: &str, c: &Case, corrupt: bool)','(family: &str, c: &Case, corrupt: bool, repeats: usize)',1)
    rust=change(rust,'for repeat in 0..32','for repeat in 0..repeats',1)
    rust=change(rust,'    let d = workload(c); let batch_before','    let cycles = repeats / 4;\n    let d = workload(c); let batch_before',1)
    rust=change(rust,r'\"repeats\":32,',r'\"repeats\":{repeats},\"cycles\":{cycles},',1).replace('four_arm_williams8','four_arm_williams')
    rust=change(rust,'scenario < 5 && requested == 8 && [2694173, 3819257].contains(&seed)','scenario < 5 && requested == 8',1)
    rust=change(rust,'assert!(["--measure", "--check-bad-output"].contains(&args[6].as_str()), "unknown mode");','assert!(["--measure", "--caller-check", "--check-bad-output"].contains(&args[6].as_str()), "unknown mode");\n    let measure = args[6] == "--measure";\n    assert!(if measure { [2694173, 3819257].contains(&seed) } else { seed == 74381 }, "wrong stage input seed");',1)
    rust=rust.replace('&c, args[6] == "--check-bad-output");','&c, args[6] == "--check-bad-output", if measure { 32 } else { 4 });')
    result['rust/src/main.rs']=rust.encode()
    binding=blob('rust/src/bindings.rs').decode()
    for ty in ['Split64BloomFilter','Split64RangeBloomFilter']:
        line=next(x for x in binding.splitlines()if x.startswith('forward_native!(before_native::'+ty+','));binding+='\n'+line.replace('before_native','clone_native')+'\n'
    result['rust/src/bindings.rs']=binding.encode()
    manifest=blob('rust/Cargo.toml').decode().replace('native-build-policy-port-proof','native-build-policy-four-arm')
    manifest=manifest.replace('[profile.release]','clone_native = { package = "fastest-bloom-filter-clone", path = "../native/clone/rust" }\n\n[profile.release]');result['rust/Cargo.toml']=manifest.encode()
    lock=blob('rust/Cargo.lock').decode().replace('native-build-policy-port-proof','native-build-policy-four-arm')
    lock=lock.replace('[[package]]\nname = "native-build-policy-four-arm"','[[package]]\nname = "fastest-bloom-filter-clone"\nversion = "0.1.0"\n\n[[package]]\nname = "native-build-policy-four-arm"').replace(' "fastest-bloom-filter-before",',' "fastest-bloom-filter-before",\n "fastest-bloom-filter-clone",');result['rust/Cargo.lock']=lock.encode()
    cmake=blob('CMakeLists.txt').decode().replace('native_build_policy_port_proof','native_build_policy_four_arm')
    cmake='\n'.join(line for line in cmake.splitlines()if 'policy_boundaries'not in line)+'\n';result['CMakeLists.txt']=cmake.encode()
    for language,old,new in [('cpp',oldcpp,cpp),('rust',oldrust,rust)]:
        result['changes/'+language+'-caller.patch']=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='frozen-parent/'+language,tofile='four-arm/'+language)).encode()
    result['NATIVE_ORIGINS.json']=(json.dumps(origins,indent=2)+'\n').encode()
    return result

def main():
    generated=sources()
    for name,data in generated.items():
        path=HERE/name;path.parent.mkdir(parents=True,exist_ok=True)
        if path.exists():assert path.read_bytes()==data,'Preserve an existing changed derivation: '+name
        else:path.write_bytes(data)
    (HERE/'DERIVATION.json').write_text(json.dumps({'parent_commit':PARENT,'parent_prefix':PREFIX,'compiler_or_filter_executed':False,'files':{name:hashlib.sha256(data).hexdigest()for name,data in generated.items()}},indent=2)+'\n')
    print('Derived',len(generated),'source artifacts only')
if __name__=='__main__':main()
