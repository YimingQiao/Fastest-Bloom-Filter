#!/usr/bin/env python3
import csv
import io
import math
from pathlib import Path
import subprocess
import sys

binary = str(Path(sys.argv[1]).resolve())
cases = 0
for power in (16,20):
    for workers in (1,3,8):
        cmd = ['taskset','-c','3',binary,str(power),'8','12',str(workers),'1','731','50','all']
        rows = list(csv.DictReader(io.StringIO(subprocess.check_output(cmd,text=True))))
        assert len(rows) == 27
        for family in ('FastPattern','FourSector','Split64'):
            group = [r for r in rows if r['filter'].startswith(family)]
            assert len(group) == 9
            for field in ('filter_bytes','false_positives','result_checksum','absent_queries'):
                assert len({r[field] for r in group}) == 1, (family,field)
            for row in group:
                instrumented = 'Instrumented' in row['filter'] or 'Cache' in row['filter'] or 'Buffered' in row['filter']
                if not instrumented:
                    assert math.isnan(float(row['phase_total_ns']))
                    continue
                n,w,p = int(row['keys']),int(row['build_workers']),int(row['partitions'])
                scratch = 0 if p == 1 else 8*n + (w*((p+7)//8*8)+p+1)*8
                if 'Buffered' in row['filter'] and p > 1:
                    padded=int(row['padded_hashes'])
                    fixed=(w*((p+7)//8*8)+p+1)*8 + w*p*64 + w*((p+63)//64*64)
                    assert int(row['build_scratch_bytes']) == padded*8 + fixed
                    assert n <= padded <= n+7*min(n,w*p)
                    assert int(row['scratch_upper_bytes']) == (n+7*min(n,w*p))*8 + fixed
                    assert int(row['padding_hashes']) == padded-n
                else:
                    assert int(row['build_scratch_bytes']) == scratch
                    assert int(row['padded_hashes']) == n
                total = float(row['phase_total_ns'])
                summed = sum(float(row[f'phase_{name}_ns']) for name in ('allocate','count','prefix','scatter','insert','release'))
                assert abs(summed-total) <= max(.001, total*0.00002)
                assert total <= float(row['insert_ns']) + .001
                for name in ('allocate','count','prefix','scatter','insert','release','total'):
                    assert len(row[f'phase_{name}_trials'].split('|')) == 1
        cases += 1
for selection in ('unknown','FastPattern,unknown','FastPattern,FastPattern','FastPattern,',''):
    result = subprocess.run(['taskset','-c','3',binary,'5','8','12','1','1','731','0',selection],capture_output=True,text=True)
    assert result.returncode != 0, selection
print(f'{cases} benchmark scenarios: full family equality, scratch accounting, complete phase sum and strict family names passed.')
