#!/usr/bin/env python3
"""Separate analysis of completed fixed296; never reads an unfinished screen."""
import argparse
import csv
import io
import json
import math
import re
from pathlib import Path
import subprocess
import sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
STAGE=ROOT/'experiments/2026-10-29-four-sector-range12-screen'
SCREEN=STAGE/'screening'
sys.path.insert(0,str(SCREEN))
from contract import audit,need,sha,save,quality
from freeze import verify
SOURCE='a433e307c73b46e0c1e6f011cf6b6e0d8b2c2ef3'
CANDIDATE='FourSectorRange12Experiment'
OWNERS=['production_native','optional_native_range','K12_experiment','external']

def blob(path,commit):return subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
def load(raw_commit):
    need(re.fullmatch(r"[0-9a-f]{40}",raw_commit)is not None,"Use immutable full40 lowercase raw commit")
    descriptor=SCREEN/'RAW_ARCHIVE.json';need(descriptor.read_bytes()==blob(descriptor,raw_commit),'Raw archive is not the exact committed evidence')
    archive=json.loads(descriptor.read_text());need(archive['complete']is True and archive['source_commit']==SOURCE and len(archive['files'])==55,'Wrong complete55-file raw archive')
    for name,item in archive['files'].items():
        path=SCREEN/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,raw_commit),'Changed committed raw '+name)
    binary,proof=verify(SOURCE);output=SCREEN/'results-v1';meta=json.loads((output/'metadata.json').read_text());rows,counts=audit(output,meta,binary,SOURCE);need(counts==archive['counts'],'Raw counts drift')
    rules=SCREEN/'ANALYSIS_RULES.json';need(rules.read_bytes()==blob(rules,SOURCE),'Changed predata analysis rules')
    return rows,json.loads((output/'quality.json').read_text()),json.loads(rules.read_text()),meta

def owner(name,rules):
    for label in OWNERS[:-1]:
        if name in rules['owners'][label]:return label
    return'external'

def finite(value):
    v=float(value);return v if math.isfinite(v)and v>0 else None

def calculate(rows,q,rules):
    need(len(rows)==296 and len(q['mapping_records'])==98,'Require complete296 and98quality')
    quality_map={}
    for record in q['mapping_records']:
        for name in record['apis']:
            identity=(name,record['keys'],record['filter_bytes'])
            need(identity not in quality_map,'Duplicate quality mapping');quality_map[identity]=record
    allocations=[];leaders=[];candidate_rows=[]
    for n in[1<<x for x in rules['workloads']['key_powers']]:
        for batch in rules['workloads']['batches']:
            selected=[r for r in rows if int(r['keys'])==n and int(r['batch'])==batch]
            need(len({(r['filter'],r['filter_bytes'])for r in selected})==len(selected),'Duplicate API/allocation timing')
            for cap in rules['caps_actual_bpk']:
                for ceiling in rules['fpr_ceilings']:
                    for metric in rules['workloads']['query_metrics']:
                        view=[]
                        for row in selected:
                            record=quality_map[(row['filter'],n,int(row['filter_bytes']))];time=finite(row[metric]);fits=int(row['filter_bytes'])*8<=cap*n;passes=record['wilson95_high']<=ceiling
                            valid=time is not None and not(metric=='lookup_ns'and row['input_mode']=='raw_bytes')
                            item=dict(keys=n,batch=batch,cap_bpk=cap,fpr_ceiling=ceiling,metric=metric,filter=row['filter'],owner=owner(row['filter'],rules),requested_bpk=int(row['requested_bpk']),filter_bytes=int(row['filter_bytes']),actual_bpk=float(row['actual_bpk']),latency_ns=time,byte_eligible=fits,quality_eligible=passes,contract_valid=valid,eligible=fits and passes and valid,wilson95_high=record['wilson95_high'],false_positives=record['false_positives'],negatives=record['negatives'],calibration_identity=record['calibration_identity'],filter_build_scratch_bytes=int(row['filter_build_scratch_bytes']),harness_hash_scratch_bytes=int(row['harness_hash_scratch_bytes']))
                            view.append(item);allocations.append(item)
                        winners={}
                        for label in OWNERS:
                            feasible=[r for r in view if r['owner']==label and r['eligible']]
                            if feasible:
                                minimum=min(r['latency_ns']for r in feasible);winners[label]=[r for r in feasible if r['latency_ns']==minimum]
                            else:winners[label]=[]
                        selected_candidate=winners['K12_experiment'];external=winners['external'];retained=[r for label in('production_native','optional_native_range')for r in winners[label]]
                        if retained:
                            minimum=min(r['latency_ns']for r in retained);retained=[r for r in retained if r['latency_ns']==minimum]
                        def compare(candidate,rivals):
                            if not candidate:return dict(outcome='candidate_ineligible',ratio=None)
                            if not rivals:return dict(outcome='no_comparable',ratio=None)
                            a=candidate[0]['latency_ns'];b=rivals[0]['latency_ns'];return dict(outcome='win'if a<b else'loss'if a>b else'tie',ratio=b/a)
                        leaders.append(dict(keys=n,batch=batch,cap_bpk=cap,fpr_ceiling=ceiling,metric=metric,winners=winners,best_retained_projects=retained,K12_vs_external=compare(selected_candidate,external),K12_vs_retained=compare(selected_candidate,retained)))
                        for item in view:
                            if item['filter']==CANDIDATE:candidate_rows.append(dict(**item,vs_external=compare([item]if item['eligible']else[],external),vs_retained=compare([item]if item['eligible']else[],retained)))
    need(len(leaders)==72 and len(allocations)==5328 and len(candidate_rows)==216,'Changed predeclared72/5328/216 counts')
    return leaders,allocations,candidate_rows

def csvwrite(path,rows):
    flat=[{k:json.dumps(v,separators=(',',':'))if isinstance(v,(dict,list))else v for k,v in row.items()}for row in rows]
    with path.open('w',newline='')as file:
        writer=csv.DictWriter(file,fieldnames=list(flat[0]),lineterminator='\n');writer.writeheader();writer.writerows(flat)

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--raw-commit',required=True);args=parser.parse_args()
    rows,q,rules,meta=load(args.raw_commit);leaders,alternatives,candidates=calculate(rows,q,rules);output=HERE/'report';output.mkdir(exist_ok=True)
    save(output/'leaders.json',leaders);csvwrite(output/'allocation-alternatives.csv',alternatives);csvwrite(output/'K12-alternatives.csv',candidates);save(output/'quality.json',q)
    summary={kind:{state:sum(row[kind]['outcome']==state for row in leaders)for state in['win','loss','tie','candidate_ineligible','no_comparable']}for kind in['K12_vs_external','K12_vs_retained']}
    save(output/'metadata.json',dict(source_commit=SOURCE,raw_commit=args.raw_commit,raw_archive_sha256=sha(SCREEN/'RAW_ARCHIVE.json'),analysis_rules_sha256=sha(SCREEN/'ANALYSIS_RULES.json'),views=72,all_allocation_alternatives=5328,K12_allocation_alternatives=216,quality_records=98,summary=summary,execution=json.loads((SCREEN/'RAW_ARCHIVE.json').read_text()).get('execution'),algorithm_runs=0))
    print(json.dumps(summary))
if __name__=='__main__':main()
