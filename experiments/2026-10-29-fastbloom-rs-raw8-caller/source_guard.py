#!/usr/bin/env python3
"""Pure source checks; never invoke Rust, instantiate a filter, or read data."""
import hashlib,json,re
from pathlib import Path
import derive
HERE=derive.HERE

def strip_test_hooks(text):
    text=re.sub(r"^.*#\[cfg\(test\)\] crate::tests::.*\n", "", text,flags=re.M)
    text=re.sub(r"^.*#\[cfg\(test\)\] if crate::tests::.*\n", "", text,flags=re.M)
    return text.split("\n#[cfg(test)]\nmod tests",1)[0].rstrip()

def release_identity():
    for name in ["reporter.rs","raw_contract.rs","fastbloom_rs_adapter.rs"]:
        old=derive.blob(derive.PLAN,derive.PLAN_PATH+"/proposed/"+name).decode()
        actual=(HERE/"benchmark/src"/name).read_text()
        assert re.sub(r"\s+","",strip_test_hooks(actual))==re.sub(r"\s+","",old),name
    old=derive.blob(derive.CALLER,derive.CALLER_PATH+"/src/main.rs").decode()
    actual=(HERE/"benchmark/src/main.rs").read_text()
    start="    let mut rng = SplitMix64(seed);";end="    let c = Config {"
    assert actual[actual.index(start):actual.index(end)]==old[old.index(start):old.index(end)]
    assert 'let insert_batch = number(9, 4096);' in actual
    names=re.findall(r'    "([A-Za-z0-9]+)",',actual[actual.index("const FILTER_NAMES:"):actual.index("fn main() {")])
    assert len(names)==len(set(names))==45
    assert {f"FastbloomRsRawK{k}"for k in range(1,25)}<=set(names)
    assert actual.count('=> report::<CommonHash<')==21
    assert actual.count('=> report::<FastbloomRsRaw<')==24

def dependency_identity():
    proof=json.loads((HERE/"dependency-preparation/resolve-v2.json").read_text())
    assert proof['complete'] and proof['compilation_or_BF_requested']is False
    assert hashlib.sha256((HERE/"benchmark/Cargo.toml").read_bytes()).hexdigest()==proof['manifest_sha256']
    assert hashlib.sha256((HERE/"benchmark/Cargo.lock").read_bytes()).hexdigest()==proof['resolved_lock_sha256']
    changes=json.loads((HERE/"dependency-preparation/package-diff-v2.json").read_text())
    assert changes['retained']==13 and changes['retained_records_changed']==[]
    metadata=json.loads((HERE/"dependency-preparation/metadata-v2.stdout").read_text())
    assert len(metadata['packages'])==34
    local={Path(x['manifest_path']).relative_to(HERE).as_posix() for x in metadata['packages']if x['source']is None}
    assert local=={'benchmark/Cargo.toml','native/Cargo.toml','upstream/fastbloom-rs/Cargo.toml'}
    external=json.loads((HERE/"dependency-preparation/external-trees.json").read_text())
    assert external['external_packages']==31 and external['files']==sum(len(p['files'])for p in external['packages'])==1856

def verify():
    for name,data in derive.derived().items():assert (HERE/name).read_bytes()==data,name
    release_identity();dependency_identity()
    return {'raw_apis':45,'common_hash':21,'direct_raw8':24,'upstream_version':'0.5.10','old_common_packages_unchanged':13,'new_external_tree_files':1856,'compiled':False,'BF_executed':False}
if __name__=='__main__':print(json.dumps(verify(),indent=2))
