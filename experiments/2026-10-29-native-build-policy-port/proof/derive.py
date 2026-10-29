#!/usr/bin/env python3
"""Derive source snapshots only; never invoke a compiler, filter or benchmark."""
import argparse, difflib, hashlib, json, re, subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
BEFORE='e8b89cd3c7c090287d1d4222db981ec7f8fb86ab'
AFTER='2b3469f02c8dafc2219a132c681c14529e79995d'
HARNESS='b09b326127792882202f5c3cda8e3d927454aa1e'
OLD='experiments/2026-10-29-native-build-policy/confirmation'

def blob(commit,path):
    return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
def sha(b):return hashlib.sha256(b).hexdigest()
def tree(commit,prefix):
    return subprocess.check_output(['git','ls-tree','-r','--name-only',commit,'--',prefix],cwd=ROOT,text=True).splitlines()
def replace_once(text,old,new):
    if text.count(old)!=1:raise ValueError('nonunique derivation: '+old[:100])
    return text.replace(old,new,1)
def sources():
    out={};origins={}
    def put(path,data,commit=None,source=None,rule='byte-identical'):
        data=data.encode()if isinstance(data,str)else data;out[path]=data
        origins[path]={'sha256':sha(data),'bytes':len(data),'rule':rule}
        if commit is not None:
            original=blob(commit,source);origins[path].update(commit=commit,source=source,source_sha256=sha(original))
    for label,commit in [('before',BEFORE),('after',AFTER)]:
        pending=['include/parallel_layout_bloom.h','include/parallel_split64_range_bloom.h'];seen=set()
        while pending:
            path=pending.pop()
            if path in seen:continue
            seen.add(path);data=blob(commit,path)
            put('native/'+label+'/'+path,data,commit,path)
            text=data.decode()
            put('cpp/'+label+'/'+Path(path).name,re.sub(r'\bbloom_filters\b','native_'+label,text),commit,path,
                'bloom_filters namespace token -> native_'+label)
            for inc in re.findall(r'^\s*#\s*include\s*"([^"\n]+)"',text,re.M):
                pending.append(str(Path(path).parent/inc))
        for path in tree(commit,'rust'):
            data=blob(commit,path)
            if path in ['rust/Cargo.toml','rust/Cargo.lock']:
                data=data.replace(b'name = "fastest-bloom-filter"',('name = "fastest-bloom-filter-'+label+'"').encode())
                rule='package identity only; library name and flags unchanged'
            else:rule='byte-identical'
            put('native/'+label+'/'+path,data,commit,path,rule)
    put('native/after/tests/test_split64_build_policy.cpp',blob(AFTER,'tests/test_split64_build_policy.cpp'),AFTER,'tests/test_split64_build_policy.cpp')
    cpp=blob(HARNESS,OLD+'/cpp/main.cpp').decode()
    cpp=replace_once(cpp,'#include "../../cpp/bindings.hpp"','#include "bindings.hpp"')
    cpp=replace_once(cpp,'#include "../../../2026-10-29-split64-range-native-scaling/cpp/placement.hpp"','#include "placement.hpp"')
    start=cpp.index('template<bool Range, bool Enabled> using Filter')
    end=cpp.index('\nstruct Data',start)
    cpp=cpp[:start]+'''template<bool Range, bool After> using Filter = typename NativeBinding<Range,After>::Type;
template<bool Range, bool After> Filter<Range,After> Make(const Case& c) {
    return NativeBinding<Range,After>::Make(c.bytes);
}'''+cpp[end:]
    cpp=replace_once(cpp,'f.EffectiveBuildRequest(c.n,c.requested)==e && f.BuildWorkers(c.n,c.requested)==w &&','f.BuildWorkers(c.n,c.requested)==w &&')
    cpp=cpp.replace('Enabled','After')
    put('cpp/main.cpp',cpp,HARNESS,OLD+'/cpp/main.cpp','direct native type binding; metadata removes experiment-only request getter; no timer/data/schedule change')
    put('cpp/placement.hpp',blob('5fd487fe3381ce05be2ba823a6137107f4108854','experiments/2026-10-29-split64-range-native-scaling/cpp/placement.hpp'),'5fd487fe3381ce05be2ba823a6137107f4108854','experiments/2026-10-29-split64-range-native-scaling/cpp/placement.hpp')
    bindings=['#pragma once','#include "before/parallel_layout_bloom.h"','#include "before/parallel_split64_range_bloom.h"','#include "after/parallel_layout_bloom.h"','#include "after/parallel_split64_range_bloom.h"','template<bool Range, bool After> struct NativeBinding;']
    for is_range in [False,True]:
        for after in [False,True]:
            ns='native_after'if after else'native_before';name='ParallelSplit64RangeBloomFilter'if is_range else'ParallelSplit64BloomFilter'
            constructor=ns+'::RangeBytes{bytes}'if is_range else'bytes / 2, 8'
            bindings.append(f'template<> struct NativeBinding<{str(is_range).lower()},{str(after).lower()}> {{\n    using Type = {ns}::{name};\n    static Type Make(size_t bytes) {{ return Type({constructor}); }}\n}};')
    put('cpp/bindings.hpp','\n'.join(bindings)+'\n')
    rust=blob(HARNESS,OLD+'/rust/src/main.rs').decode()
    rust=replace_once(rust,'use fastest_bloom_filter::{Split64BloomFilter, Split64RangeBloomFilter};\nuse native_build_policy_experiment::{Filter, Native};','mod bindings;\nuse bindings::Native;')
    start=rust.index('trait Make:');end=rust.index('\nstruct Data',start)
    rust=rust[:start]+'''fn make<F: Native>(c: &Case) -> F { F::make(c.bytes) }'''+rust[end:]
    rust=rust.replace('Filter<F, ENABLED>','F')
    rust=rust.replace('<F: Native, const ENABLED: bool>','<F: Native>')
    rust=rust.replace('<F: Make, const ENABLED: bool>','<F: Native>')
    rust=rust.replace('if ENABLED &&','if F::BOUNDED &&')
    rust=replace_once(rust,'    assert_eq!(filter.effective_build_request(c.n, c.requested), effective);\n','')
    rust=rust.replace('make::<F, ENABLED>(c)','make::<F>(c)')
    rust=replace_once(rust,'fn run<F: Make>','fn run<Before: Native, After: Native>')
    rust=rust.replace('make::<F, false>(c)','make::<Before>(c)').replace('trial::<F, true>','trial::<After>').replace('trial::<F, false>','trial::<Before>')
    rust=rust.replace('run::<Split64RangeBloomFilter>','run::<before_native::Split64RangeBloomFilter, after_native::Split64RangeBloomFilter>')
    rust=rust.replace('run::<Split64BloomFilter>','run::<before_native::Split64BloomFilter, after_native::Split64BloomFilter>')
    if any(token in rust for token in ['Filter<','ENABLED','F: Make','native_build_policy_experiment']):raise ValueError('wrapper remnant')
    put('rust/src/main.rs',rust,HARNESS,OLD+'/rust/src/main.rs','direct before/after native generic types; metadata-only trait constant; no timer/data/schedule change')
    forward=blob('07746e17f82e3fa48adf3bbd1f6fed00daf71514','experiments/2026-10-29-native-build-policy/rust/src/lib.rs').decode()
    begin=forward.index('pub trait Native {');end=forward.index('forward_native!(Split64BloomFilter);')
    forward=forward[begin:end]
    forward=forward.replace('pub trait Native {','pub trait Native {\n    const BOUNDED: bool;\n    fn make(bytes: usize) -> Self;')
    forward=forward.replace('($native:ty) => {','($native:ty, $bounded:expr, $make:expr) => {')
    forward=forward.replace('impl Native for $native {','impl Native for $native {\n            const BOUNDED: bool = $bounded;\n            fn make(bytes: usize) -> Self { ($make)(bytes) }')
    for label in ['before','after']:
        for family in ['Split64BloomFilter','Split64RangeBloomFilter']:
            ty=label+'_native::'+family;ctor='with_byte_budget(bytes)'if'Range'in family else'new(bytes / 2, 8)'
            forward+=f'forward_native!({ty}, {str(label=="after").lower()}, |bytes| {ty}::{ctor}.unwrap());\n'
    put('rust/src/bindings.rs','//! Static forwarding to actual public native methods; no policy here.\n'+forward)
    cargo='''[package]
name = "native-build-policy-port-proof"
version = "0.0.0"
edition = "2021"
publish = false

[dependencies]
before_native = { package = "fastest-bloom-filter-before", path = "../native/before/rust" }
after_native = { package = "fastest-bloom-filter-after", path = "../native/after/rust" }

[profile.release]
lto = "thin"
codegen-units = 1

[[bin]]
name = "policy_confirmation"
path = "src/main.rs"
'''
    put('rust/Cargo.toml',cargo)
    lock='''# This file is automatically @generated by Cargo.
# It is not intended for manual editing.
version = 4

[[package]]
name = "fastest-bloom-filter-after"
version = "0.1.0"

[[package]]
name = "fastest-bloom-filter-before"
version = "0.1.0"

[[package]]
name = "native-build-policy-port-proof"
version = "0.0.0"
dependencies = [
 "fastest-bloom-filter-after",
 "fastest-bloom-filter-before",
]
'''
    put('rust/Cargo.lock',lock)
    cmake=blob(HARNESS,OLD+'/CMakeLists.txt').decode()
    cmake=replace_once(cmake,'project(native_build_policy_confirmation LANGUAGES CXX)','project(native_build_policy_port_proof LANGUAGES CXX)')
    cmake=replace_once(cmake,'target_include_directories(policy_confirmation PRIVATE ../../2026-10-29-split64-range-native-scaling/cpp/native)','''add_executable(policy_boundaries native/after/tests/test_split64_build_policy.cpp)
target_compile_features(policy_boundaries PRIVATE cxx_std_17)
target_include_directories(policy_boundaries PRIVATE native/after/include)
target_compile_options(policy_boundaries PRIVATE -O3 -march=native -fno-strict-aliasing)
target_link_libraries(policy_boundaries PRIVATE Threads::Threads)''')
    cmake=replace_once(cmake,'  target_link_options(policy_confirmation PRIVATE -fsanitize=address,undefined)','''  target_link_options(policy_confirmation PRIVATE -fsanitize=address,undefined)
  target_compile_options(policy_boundaries PRIVATE -fsanitize=address,undefined -fno-omit-frame-pointer -g)
  target_link_options(policy_boundaries PRIVATE -fsanitize=address,undefined)''')
    put('CMakeLists.txt',cmake,HARNESS,OLD+'/CMakeLists.txt','same shared flags plus native boundary-test target')
    for language,path in [('cpp','cpp/main.cpp'),('rust','rust/src/main.rs')]:
        old=blob(HARNESS,OLD+'/'+path).decode();new=out[path].decode()
        put('changes/'+language+'-caller.patch',''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='frozen-wrapper/'+path,tofile='actual-native/'+path)))
    put('DERIVATION.json',json.dumps({'before_commit':BEFORE,'after_commit':AFTER,'harness_commit':HARNESS,'outputs':origins},indent=2)+'\n')
    return out

def main():
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args()
    out=sources()
    for rel,data in out.items():
        path=HERE/rel
        if a.write:
            path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
        elif not path.is_file()or path.read_bytes()!=data:raise ValueError('derived source drift: '+rel)
    print(('WROTE'if a.write else'PASS'),len(out),'exact derived sources; no compiler or Bloom execution')
if __name__=='__main__':main()
