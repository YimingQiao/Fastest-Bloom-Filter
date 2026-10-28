#!/usr/bin/env python3
"""Verify immutable original/triple controls and exactly one candidate source hint."""
import hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
REPO=HERE.parent.parent

def verify():
    p=json.loads((HERE/'copy-source.json').read_text())
    expected=set(p['original_native_sha256'])
    original={}
    for name,want in p['original_native_sha256'].items():
        raw=subprocess.check_output(['git','show',p['source_commit']+':rust/'+name],cwd=REPO)
        assert hashlib.sha256(raw).hexdigest()==want, 'Pinned original differs: '+name
        original[name]=raw.decode()
    for folder,variant in p['variants'].items():
        observed={str(f.relative_to(HERE/folder)) for f in (HERE/folder).rglob('*') if f.is_file() and 'target' not in f.parts}
        assert observed==expected, 'Native copied file set differs: '+folder
        for name,text in original.items():
            if name=='Cargo.toml':
                text=text.replace('name = "fastest-bloom-filter"',f'name = "{variant["package"]}"',1).replace('name = "fastest_bloom_filter"',f'name = "{variant["lib"]}"',1).replace('edition = "2021"','edition = "2021"\nautobins = false\npublish = false',1)
            elif name=='Cargo.lock':
                text=text.replace('name = "fastest-bloom-filter"',f'name = "{variant["package"]}"')
            for c in variant['changes']:
                if c['file']==name:
                    assert text.count(c['old'])==1
                    text=text.replace(c['old'],c['new'],1)
            assert (HERE/folder/name).read_text()==text, 'Unapproved mutation: '+folder+'/'+name
    assert [len(p['variants'][x]['changes']) for x in ['original','byte_only','triple_hint']]==[0,1,3]
    assert p['variants']['byte_only']['changes']==p['variants']['triple_hint']['changes'][:1]
    base=subprocess.check_output(['git','show',p['source_commit']+':'+p['base_harness']+'/src/main.rs'],cwd=REPO).decode()
    current=(HERE/'benchmark/src/main.rs').read_text()
    begin='// Benchmark buffers use the same 4096-byte alignment'
    end='const FILTER_NAMES:'
    assert current[current.index(begin):current.index(end)]==base[base.index(begin):base.index(end)], 'Timing/query/workload helpers changed'
    for name in ['support/filter_selection.rs','support/query_validation.rs']:
        old=subprocess.check_output(['git','show',p['source_commit']+':'+p['base_harness']+'/src/'+name],cwd=REPO)
        assert (HERE/'benchmark/src'/name).read_bytes()==old, 'Shared selection/validation changed'
    # In particular lookup_hashes, lookup_avx2 and all parallel helpers are byte-identical.
    print('PASS: 0/1/3 hints only; all other native source and four-mode timed code unchanged')
if __name__=='__main__':
    if not __debug__:raise SystemExit('Run verifier without Python -O')
    verify()
