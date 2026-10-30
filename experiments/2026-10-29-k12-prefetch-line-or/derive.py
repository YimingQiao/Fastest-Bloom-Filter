#!/usr/bin/env python3
"""Single conditional variant from two frozen insertion branches; no BF/build."""
import argparse,ast,difflib,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
ORIGINAL='5cb840406f1b4c48763bd660246e51c03bfe56c2'
RANGE='81f40f16caa44586537d577f998c33fec4c22be8'
OLD_DIR='experiments/2026-10-29-k12-line-or/'
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
def h(data):return hashlib.sha256(data).hexdigest()
def derive():
    values={}
    for node in ast.parse(blob(ORIGINAL,OLD_DIR+'derive.py')).body:
        if isinstance(node,ast.Assign) and len(node.targets)==1 and isinstance(node.targets[0],ast.Name) and node.targets[0].id in ('OLD','NEW'):
            values[node.targets[0].id]=ast.literal_eval(node.value)
    old,new=values['OLD'],values['NEW'];control=blob(ORIGINAL,OLD_DIR+'control.hpp').decode()
    assert control.count(old)==1
    def indent(text):return '\n'.join('\t'+line for line in text.splitlines())
    conditional='\t\t\tif constexpr (Prefetch) {\n'+indent(new)+'\n\t\t\t} else {\n'+indent(old)+'\n\t\t\t}'
    candidate=control.replace(old,conditional).replace('K12ScalarOrControl','K12PrefetchLineOrCandidate')
    assert candidate.replace(conditional,old).replace('K12PrefetchLineOrCandidate','K12ScalarOrControl')==control
    dispatch='''\t\tif (SizeInBytes() > (1u << 21))
\t\t\tInsertVector<true>(n, h);
\t\telse
\t\t\tInsertVector<false>(n, h);'''
    assert dispatch in candidate and dispatch in control
    sizing=blob(ORIGINAL,OLD_DIR+'range_size.hpp');base=blob(ORIGINAL,OLD_DIR+'base.h')
    assert blob(RANGE,'include/split64_range_size.h')==sizing
    assert blob(RANGE,'include/base.h')==base
    range_source=blob(RANGE,'include/split64_range_bloom.h').decode()
    assert range_source.count('#include "split64_range_size.h"')==1
    range_copy=range_source.replace('#include "split64_range_size.h"','#include "range_size.hpp"')
    files={'control.hpp':control.encode(),'conditional.hpp':candidate.encode(),'split64_range_bloom.h':range_copy.encode(),'base.h':base,'range_size.hpp':sizing,
           'CHANGE.patch':''.join(difflib.unified_diff(control.splitlines(True),candidate.splitlines(True),fromfile='control.hpp',tofile='conditional.hpp')).encode(),
           'RANGE.patch':''.join(difflib.unified_diff(range_source.splitlines(True),range_copy.splitlines(True),fromfile='native/include/split64_range_bloom.h',tofile='split64_range_bloom.h')).encode()}
    sources={ORIGINAL+':'+OLD_DIR+n:h(blob(ORIGINAL,OLD_DIR+n)) for n in ('derive.py','control.hpp','candidate.hpp','base.h','range_size.hpp')}
    sources.update({RANGE+':include/'+n:h(blob(RANGE,'include/'+n))for n in ('split64_range_bloom.h','split64_range_size.h','base.h')})
    origin=dict(sources=sources,selection='Exact existing SizeInBytes()>2MiB template dispatch, no threshold change',only_variant='Prefetch=true uses earlier line-OR block; Prefetch=false original word-OR block',range_delta='Include route only; byte-identical common sizing/base')
    return files,origin
def main():
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args();files,origin=derive();descriptor=dict(origin=origin,files={n:h(v)for n,v in files.items()})
    if a.write:
        for name,data in files.items():(HERE/name).write_bytes(data)
        (HERE/'DERIVATION.json').write_text(json.dumps(descriptor,indent=2)+'\n')
    else:
        assert json.loads((HERE/'DERIVATION.json').read_text())==descriptor
        for name,data in files.items():assert(HERE/name).read_bytes()==data,name
    print('PASS exact conditional source; zero compiler/Bloom executions')
if __name__=='__main__':main()
