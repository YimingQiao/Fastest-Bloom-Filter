"""Fixed40-run four-arm contract; importing executes no filters or compilers."""
import csv,io,json,statistics,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
CALLER=STAGE/'caller'
ROOT=STAGE.parents[1]
sys.path.insert(0,str(CALLER/'preflight'))
import contract as original
from contract import need,parse,plan as PLAN
from source_guard import sha


def command(binary,case,lease):
    cpus=','.join(map(str,lease['child_cpus'][:case['requested']]))
    return ['taskset','-c',cpus,'numactl','--physcpubind='+cpus,'--membind='+str(lease['node']),
            str(binary),case['family'],str(case['scenario']),str(case['requested']),str(case['seed']),cpus,'--measure']


def counts(rows,lease):
    cases=PLAN.ledger();need(len(rows)==len(cases)==40,'Incomplete fixed process ledger')
    semantic={}
    for row,case in zip(rows,cases,strict=True):
        original.validate(row,case,lease['child_cpus'][:case['requested']])
        key=(case['family'],case['scenario'],case['seed']);value=tuple(row[k]for k in original.SEMANTICS)
        need(key not in semantic or semantic[key]==value,'Cross-language bitmap/output/input mismatch')
        semantic[key]=value
    need(len(semantic)==20,'Wrong mapping/geometry record count')
    return dict(PLAN.validate(cases),semantic_geometry_records=20)


def tables(records):
    rows=[]
    for case,row in zip(PLAN.ledger(),records,strict=True):
        for arm in PLAN.ARMS:
            result={key:row[key]for key in ('language','family','scenario','bytes','batch_n','requested','history_n','hotspot','seed','input_base','query_n','checksum','positives','batch_checksum','query_checksum','repeats','cycles','scheduler','time_unit')}
            result.update(case_index=case['case_index'],scenario_name=case['name'],arm=arm)
            samples=row['arms'][arm]
            result.update({key:samples[key]for key in ('effective','workers','scratch_bytes','spawned_per_pass')})
            for metric in ('insert','allocate_insert'):
                values=samples[metric+'_ns'];present=bool(values)
                result[metric+'_available']=present
                for stat,fn in [('median',statistics.median),('min',min),('max',max)]:
                    result[metric+'_'+stat+'_ns']=fn(values)if present else None
                result[metric+'_trials_ns']=json.dumps(values,separators=(',',':'))
            setup=samples['insert_prefill_setup_ns']
            result['insert_prefill_setup_median_ns']=statistics.median(setup)
            result['insert_prefill_setup_trials_ns']=json.dumps(setup,separators=(',',':'))
            rows.append(result)
    need(len(rows)==160,'Wrong arm row count')
    return rows


def csv_text(rows):
    output=io.StringIO(newline='');writer=csv.DictWriter(output,fieldnames=list(rows[0]),lineterminator='\n')
    writer.writeheader();writer.writerows(rows);return output.getvalue()


def audit(output,metadata,binaries,lease):
    cases=PLAN.ledger();need(metadata['complete']is True and metadata['final_frozen_inputs_equal']is True,'Incomplete run')
    need(isinstance(metadata['cases'],list)and len(metadata['cases'])==40,'Incomplete command ledger')
    rows=[]
    for index,(case,saved)in enumerate(zip(cases,metadata['cases'],strict=True)):
        need(saved['case']==case and saved['complete']is True and saved['returncode']==0,'Case outcome/identity changed')
        need(saved['command']==command(binaries[case['language']]['path'],case,lease),'Changed measured command')
        for stream in ('stdout','stderr'):
            need(saved[stream]==f'case-{index:03d}.'+stream,'Changed raw artifact name')
            need(sha(output/saved[stream])==saved[stream+'_sha256'],'Raw output hash changed')
        need(not(output/saved['stderr']).read_bytes(),'Successful process diagnostic changed')
        row=parse((output/saved['stdout']).read_text());original.validate(row,case,lease['child_cpus'][:case['requested']]);rows.append(row)
    observed=counts(rows,lease);need(metadata['counts']==observed,'Run count mismatch')
    need(parse((output/'four-arm-records.json').read_text())==rows,'Raw/aggregate mismatch')
    need((output/'arm-results.csv').read_text()==csv_text(tables(rows)),'Raw/CSV mismatch')
    return rows,observed
