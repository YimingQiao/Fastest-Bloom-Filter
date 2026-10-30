#!/usr/bin/env python3
"""Pre-data row-order control only: keep workload RNG and timed code exact."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
if not __debug__:raise SystemExit('Python -O unsupported')
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]
PARENT='a029583a66936b1bf061df4ee8699cb3514117ca'
SOURCE='experiments/2026-10-29-k12-line-or/caller/compare_benchmark.cpp'
def expected():
    old=subprocess.check_output(['git','show',PARENT+':'+SOURCE],cwd=ROOT).decode()
    replacements=[
      ('if (argc > 13)','if (argc > 14)'),
      ('\t\tsize_t n = size_t {1} << power, q = size_t {1} << qp;',
       '''        const std::string filter_order = argc > 13 ? argv[13] : "original";
        if (filter_order != "original" && filter_order != "reverse")
            throw std::invalid_argument("filter order must be original or reverse");
\t\tsize_t n = size_t {1} << power, q = size_t {1} << qp;'''),
      ('\t\tshuffle(jobs, rng);','\t\tshuffle(jobs, rng);\n        if (filter_order == "reverse") std::reverse(jobs.begin(), jobs.end());'),
    ]
    new=old
    for before,after in replacements:
        assert new.count(before)==1,before
        new=new.replace(before,after)
    assert new[:new.index('int main(')]==old[:old.index('int main(')],'Public/timed code changed'
    restored=new
    for before,after in reversed(replacements):restored=restored.replace(after,before)
    assert restored==old
    patch=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='frozen-v2/compare_benchmark.cpp',tofile='order-v3/compare_benchmark.cpp'))
    return old,new,patch
def main():
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args();old,new,patch=expected()
    for name,data in [('compare_benchmark.cpp',new),('ORDER.patch',patch)]:
        if a.write:(HERE/name).write_text(data)
        else:assert (HERE/name).read_text()==data,name
    info=dict(parent_commit=PARENT,parent_source=SOURCE,parent_sha256=hashlib.sha256(old.encode()).hexdigest(),
              unchanged_prefix_sha256=hashlib.sha256(old[:old.index('int main(')].encode()).hexdigest(),
              source_sha256=hashlib.sha256(new.encode()).hexdigest(),patch_sha256=hashlib.sha256(patch.encode()).hexdigest())
    if a.write:(HERE/'DERIVATION.json').write_text(json.dumps(info,indent=2)+'\n')
    else:assert json.loads((HERE/'DERIVATION.json').read_text())==info
    print('PASS main-only explicit row reversal; no RNG/timer/kernel change')
if __name__=='__main__':main()
