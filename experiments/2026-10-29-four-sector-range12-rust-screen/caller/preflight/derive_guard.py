"""Subset-capable exact derivative of the frozen four-mode validator."""
from pathlib import Path
import subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]
PARENT='experiments/2026-10-29-rust-fastbloom-fixed-probes-screen/guard.py'
COMMIT='571186b420bf7e5fc08269ed4a65feab42ac8400'

def generate():
    s=subprocess.check_output(['git','show',COMMIT+':'+PARENT],cwd=ROOT).decode()
    edits=[("NAMES = NATIVE | EXTERNAL | {RANGE}","K12 = 'FourSectorRange12BloomFilter'\nNAMES = NATIVE | EXTERNAL | {RANGE, K12}"),
      ('len(names) == len(set(names)) == 20','len(names) == len(set(names)) == 21'),
      ("return shuffled(selected_names(case['budget_bpk'], source), state)","return shuffled([name for name in source_registry(source) if name in case['filters']], state)"),
      ("    if name in NATIVE:\n        kind, argument, owner", "    if name == K12:\n        kind, probes, owner = 'top24_range_lines', 12, 'K12_experiment'\n    elif name in NATIVE:\n        kind, argument, owner"),
      ("    require(case['filters'] == selected_names(case['budget_bpk'], source), 'Wrong selected family set')", "    require(case['filters'] and len(case['filters']) == len(set(case['filters'])) and set(case['filters']) <= set(source_registry(source)), 'Wrong selected family set')")]
    for old,new in edits:
        if s.count(old)!=1:raise ValueError('Unexpected parent guard anchor '+old)
        s=s.replace(old,new,1)
    return s
if __name__=='__main__':
    import argparse
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');args=p.parse_args();text=generate();out=HERE/'guard.py'
    if args.write:out.write_text(text)
    elif out.read_text()!=text:raise ValueError('Derived guard drift')
    print('Exact five-edit row-guard derivation verified')
