#!/usr/bin/env python3
"""Ranking must reject unequal workloads and must not count duplicate negatives."""
import csv
import subprocess
import sys
import tempfile
from pathlib import Path

script = Path(__file__).resolve().parents[1] / 'scripts/rank_external.py'
fields = ['language','filter','keys','requested_bpk','filter_bytes','input_mode','queries','repeats',
          'hit_percent','batch','insert_batch','seed','false_positives','absent_queries','hash_lookup_ns']
base = dict(zip(fields, ['cpp','A','1024','8','2048','prehashed','1048576','3','0','4096','1024','42','0','1048576','1']))
with tempfile.TemporaryDirectory() as d:
    p = Path(d)/'rows.csv'
    out = Path(d)/'ranking.csv'
    def run(rows):
        with p.open('w', newline='') as f:
            w=csv.DictWriter(f, fields);w.writeheader();w.writerows(rows)
        return subprocess.run([sys.executable,str(script),str(p),'--output',str(out)], capture_output=True)
    assert run([base, dict(base,filter='B',hash_lookup_ns='2')]).returncode == 0
    rows=list(csv.DictReader(out.open()))
    assert len(rows)==6
    assert all(float(r['fpr_upper95'])>0 for r in rows)
    assert run([base,base]).returncode != 0
    assert run([base,dict(base,filter='B',seed='43')]).returncode != 0
    assert run([base,dict(base,hit_percent='50',seed='43')]).returncode != 0
    assert run([base,dict(base,batch='31')]).returncode == 0
    assert all(int(r['negative_samples'])==1048576 for r in csv.DictReader(out.open()))
print('Ranking rejects mismatched/duplicate cases and counts each negative sample set once.')
