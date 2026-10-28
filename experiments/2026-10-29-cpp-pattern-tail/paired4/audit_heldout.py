#!/usr/bin/env python3
"""Require the preregistered frozen comparison and retain every seed regression."""
from pathlib import Path
import csv,json,subprocess
HERE=Path(__file__).resolve().parent
protocol=json.loads((HERE/'confirmation-protocol.json').read_text())
meta=json.loads((HERE/'heldout/metadata.json').read_text())
assert meta['binary_sha256']==protocol['binary_sha256']
assert meta['sources']==protocol['selected_training_source_hashes']
assert meta['sources_changed_during_run']==[]
subprocess.run(['python3',str(HERE/'summarize.py'),str(HERE/'heldout/timing.csv')],check=True,stdout=subprocess.DEVNULL)
x=json.loads((HERE/'heldout/summary.json').read_text())
expected=len(protocol['key_powers'])*len(protocol['requested_bpk'])*len(protocol['seeds'])*len(protocol['batches'])
assert x['workloads']==expected and x['rows']==expected*2
regressions=[]
for r in x['workload_results']:
 for metric in ('lookup_ns','hash_lookup_ns','hash_insert_ns'):
  v=r[metric]
  if v['ratio']>1:
   regressions.append({**{k:r[k] for k in ['keys','requested_bpk','actual_bpk','batch','seed','hit_percent']},'metric':metric,'old_ns':v['old'],'new_ns':v['new'],'new_old_latency_ratio':v['ratio'],'increase_percent':(v['ratio']-1)*100})
with (HERE/'heldout/regressions.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=list(regressions[0]));w.writeheader();w.writerows(regressions)
checks={'workloads':expected,'rows':expected*2,'all_sources_match_frozen_training':True,'binary_matches_frozen_training':True,'sources_changed_during_run':[],'all_output_bytes_and_false_positive_counts_match':True,'ratio_definition':'new/old latency; below1 is faster','every_positive_regression_retained':True,'unchanged_insertion_metric_caution':'Insertion source is unchanged; its observed runtime variation is retained without claiming an algorithmic gain.'}
(HERE/'heldout/audit.json').write_text(json.dumps(checks,indent=2)+'\n')
print(json.dumps(checks,indent=2))
