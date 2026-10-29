#!/usr/bin/env python3
"""Actual three-type caller, unchanged timers, finite reused independent checker."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
CALLER_COMMIT='7546719bf38b77b4d12ca8d9cc829a09a96e459b'
CHECK_COMMIT='dd13d1e829d4482d70093497b8d470bd09be22ac'
CALLER_PATH='experiments/2026-10-29-k12-line-or/caller/order-v3/compare_benchmark.cpp'
CHECK_PATH='experiments/2026-10-29-k12-line-or/caller/check.cpp'
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT).decode()
def outputs():
 old=blob(CALLER_COMMIT,CALLER_PATH);new=old
 replacements=[
 ('if (filter_order != "original" && filter_order != "reverse")\n            throw std::invalid_argument("filter order must be original or reverse");', 'if (filter_order != "latin0" && filter_order != "latin1" && filter_order != "latin2")\n            throw std::invalid_argument("filter order must be latin0, latin1 or latin2");'),
 ('argc > 13 ? argv[13] : "original"','argc > 13 ? argv[13] : "latin0"'),
 ('\t\tADD(K12LineOrCandidate, uint64_t);','\t\tADD(K12PrefetchLineOrCandidate, uint64_t);\n\t\tADD(Split64RangeBloomFilter, uint64_t);'),
 ('\t\tif (jobs.empty())','        if (jobs.size() != 3) throw std::invalid_argument("Latin caller requires all three registered filters");\n\t\tif (jobs.empty())'),
 ('\t\tshuffle(jobs, rng);\n        if (filter_order == "reverse") std::reverse(jobs.begin(), jobs.end());','''        const auto registration_order = jobs;
\t\tshuffle(jobs, rng); // Keep the ordinary three-job shuffle after workload generation.
        const size_t rotation = static_cast<size_t>(filter_order.back() - '0');
        for (size_t i = 0; i < jobs.size(); ++i)
            jobs[i] = registration_order[(i + rotation) % jobs.size()];''')]
 for before,after in replacements:assert new.count(before)==1,before;new=new.replace(before,after)
 assert new[:new.index('int main(')]==old[:old.index('int main(')]
 original_check=blob(CHECK_COMMIT,CHECK_PATH)
 check=original_check.replace('#include "../candidate.hpp"','#include "../conditional.hpp"').replace('K12LineOrCandidate','K12PrefetchLineOrCandidate')
 begin=check.index('        for (size_t bytes : {size_t{128}, size_t{192}})');end=check.index('        std::cout <<',begin)
 check=check[:begin]+'''        for (size_t bytes : {size_t{2097088}, size_t{2097152}, size_t{2097216}}) {
            Case(bytes, 0, 0, 0);
            Case(bytes, 4, 1, 2);
            Case(bytes, 7, 2, 1);
            Case(bytes, 68, 3, 0);
            Case(bytes, 257, 1, 0);
            Case(bytes, 4097, 1, 1);
        }
        Need(cases == 18, "focused boundary case count changed");
'''+check[end:]
 files={'compare_benchmark.cpp':new,'check.cpp':check,'CALLER.patch':''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='order-v3/compare_benchmark.cpp',tofile='conditional/compare_benchmark.cpp')),'CHECK.patch':''.join(difflib.unified_diff(original_check.splitlines(True),check.splitlines(True),fromfile='old1642/check.cpp',tofile='focused18/check.cpp'))}
 info=dict(caller_commit=CALLER_COMMIT,caller_path=CALLER_PATH,caller_sha256=hashlib.sha256(old.encode()).hexdigest(),check_commit=CHECK_COMMIT,check_path=CHECK_PATH,check_sha256=hashlib.sha256(original_check.encode()).hexdigest(),unchanged_timed_prefix_sha256=hashlib.sha256(new[:new.index('int main(')].encode()).hexdigest(),files={n:hashlib.sha256(v.encode()).hexdigest()for n,v in files.items()})
 return files,info
def main():
 p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args();files,info=outputs()
 for n,v in files.items():
  if a.write:(HERE/n).write_text(v)
  else:assert(HERE/n).read_text()==v,n
 if a.write:(HERE/'DERIVATION.json').write_text(json.dumps(info,indent=2)+'\n')
 else:assert json.loads((HERE/'DERIVATION.json').read_text())==info
 print('PASS unchanged timers,Latin3 caller,focused18 boundary checker; no BF/build')
if __name__=='__main__':main()
