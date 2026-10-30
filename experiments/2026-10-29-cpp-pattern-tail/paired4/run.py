#!/usr/bin/env python3
"""Reproduce independent FPR or shared-harness speed screens, with metadata."""
import argparse
import csv
import hashlib
import io
import itertools
import json
from pathlib import Path
import random
import subprocess
import time

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
FILTERS = 'FastPatternBeforeTailBF,FastPatternPair4TailBF'
ACCURACY_FIELDS = ['filter', 'keys', 'queries', 'requested_bpk', 'filter_bytes', 'actual_bpk', 'hash_bits',
                   'hit_percent', 'batch', 'insert_batch', 'seed', 'false_positives', 'absent_queries',
                   'result_checksum', 'calibration_absent_queries', 'calibration_false_positives']


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def wilson_upper(positives, count):
    z = 1.959963984540054
    rate = positives / count
    return (rate + z*z/(2*count) + z * (rate*(1-rate)/count + z*z/(4*count*count))**0.5) / (1+z*z/count)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--mode', choices=['accuracy', 'speed'], required=True)
    p.add_argument('--output', type=Path, required=True)
    p.add_argument('--binary', type=Path, default=REPO/'build/cpp-pattern-tail-paired4/compare_benchmark')
    p.add_argument('--cpu', type=int, default=3)
    p.add_argument('--key-powers', default='16')
    p.add_argument('--requested-bpk', default='8,16')
    p.add_argument('--seeds', default='42')
    p.add_argument('--hits', default='0')
    p.add_argument('--batches', default='4096')
    p.add_argument('--query-power', type=int, default=12)
    p.add_argument('--calibration-power', type=int, default=24)
    p.add_argument('--repeats', type=int, default=1)
    p.add_argument('--filters', default=FILTERS)
    args = p.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    binary = args.binary.resolve()
    sources = [f for f in sorted((HERE/'snapshot').rglob('*')) if f.is_file()] + [HERE/'adapters.hpp', HERE/'CMakeLists.txt', HERE/'run.py', HERE/'before.h', HERE/'after_paired4.h', HERE/'snapshot.json']
    before = {str(f.relative_to(REPO)): sha(f) for f in sources}
    meta = {'arguments': {**vars(args), 'output': str(out), 'binary': str(binary)}, 'binary_sha256': sha(binary),
            'sources': before, 'git_head': subprocess.check_output(['git','rev-parse','HEAD'], cwd=REPO, text=True).strip(),
            'compiler': subprocess.check_output(['clang++','--version'], text=True),
            'cpu': subprocess.check_output(['lscpu'], text=True),
            'compile_commands': json.loads((binary.parent/'compile_commands.json').read_text()),
            'runs': [],
            'snapshot': json.loads((HERE/'snapshot.json').read_text()),
            'purpose': 'FPR-only; incidental timing discarded' if args.mode == 'accuracy' else 'Shared-harness speed comparison'}
    grid = list(itertools.product(*(v.split(',') for v in [args.key_powers, args.requested_bpk, args.hits, args.seeds, args.batches])))
    random.Random(20261029).shuffle(grid)
    writer = None
    with (out/('accuracy.csv' if args.mode == 'accuracy' else 'timing.csv')).open('w') as file:
        for power,bpk,hit,seed,batch in grid:
            cmd = ['taskset','-c',str(args.cpu),str(binary),power,bpk,hit,str(args.query_power),batch,str(args.repeats),seed,args.filters,str(1<<int(power)),str(args.calibration_power)]
            started = time.monotonic()
            rows = list(csv.DictReader(io.StringIO(subprocess.check_output(cmd,text=True))))
            assert len(rows) == len(args.filters.split(',')), (len(rows), args.filters)
            assert {r['filter'] for r in rows} == set(args.filters.split(','))
            assert len({r['filter_bytes'] for r in rows}) == 1, 'unequal byte budgets'
            by_name = {r['filter']: r for r in rows}
            for a,b in [('FastPatternBeforeTailBF','FastPatternPair4TailBF')]:
                if a in by_name and b in by_name:
                    for field in ('filter_bytes','result_checksum','false_positives','calibration_false_positives'):
                        assert by_name[a][field] == by_name[b][field], (a,b,field)
            if args.mode == 'accuracy':
                rows = [{k:r[k] for k in ACCURACY_FIELDS} for r in rows]
                for row in rows:
                    n,fp = int(row['calibration_absent_queries']),int(row['calibration_false_positives'])
                    assert n > 0
                    row['calibration_fpr'] = fp/n
                    row['wilson95_upper'] = wilson_upper(fp,n)
            if writer is None:
                writer = csv.DictWriter(file,fieldnames=list(rows[0]),lineterminator='\n')
                writer.writeheader()
            writer.writerows(rows)
            file.flush()
            meta['runs'].append({'command':cmd,'seconds':time.monotonic()-started})
            print(f'completed n=2^{power}, requested_bpk={bpk}, hit={hit}, seed={seed}, batch={batch}',flush=True)
    meta['utc'] = time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())
    meta['sources_changed_during_run'] = [str(f.relative_to(REPO)) for f in sources if sha(f) != before[str(f.relative_to(REPO))]]
    (out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')


if __name__ == '__main__':
    main()
