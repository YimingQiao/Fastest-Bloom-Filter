"""The prespecified eight workloads, exact two-row order and raw accounting."""
import csv,io,json,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;PARENT=HERE.parent
sys.path.insert(0,str(PARENT/'caller'))
from contract import TYPES,SEMANTICS,need,rows,command as binary_command
MASK=(1<<64)-1

def plan():
    result=json.loads((PARENT/'plan.json').read_text())['cases']
    need(len(result)==8 and [r['index']for r in result]==list(range(8)),'Wrong fixed workload ledger')
    return result

def case(item):
    return dict(power=item['keys_power'],bpk=item['actual_bpk'],hit=item['hit_percent'],qp=item['query_power'],
                batch=item['query_batch'],insert_batch=item['insert_batch'],repeats=item['query_repeats'],
                build_repeats=item['build_repeats'],seed=item['seed'])

def order(c):
    n,q=1<<c['power'],1<<c['qp'];present=q//100*c['hit']+min(q%100,c['hit'])
    # One base draw, n-1 insertion shuffle, present mixed-hit draws, q-1
    # query shuffle, then one draw to shuffle exactly two registered jobs.
    z=(c['seed']+0x9e3779b97f4a7c15*(n+present+q))&MASK
    z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK
    z=((z^(z>>27))*0x94d049bb133111eb)&MASK;z^=z>>31
    result=list(TYPES) if z&1 else list(reversed(TYPES))
    return list(reversed(result)) if c['seed']==6011 else result

def flag(item):
    need(item['seed'] in (5011,6011),'Unregistered formal seed')
    return 'reverse' if item['seed']==6011 else 'original'

def command(binary,item):
    return ['/usr/bin/numactl','--physcpubind=3','--membind=1',*binary_command(binary,case(item)),flag(item)]

def parse(text,item):
    parsed=rows(text,case(item))
    need([r['filter']for r in parsed]==order(case(item)),'Source-derived filter order mismatch')
    return parsed

def csv_text(records):
    stream=io.StringIO(newline='');writer=csv.DictWriter(stream,fieldnames=list(records[0]),lineterminator='\n')
    writer.writeheader();writer.writerows(records);return stream.getvalue()

def audit(directory,metadata,binary,source_commit,sha):
    need(metadata['complete'] is True and metadata['source_commit']==source_commit,'Incomplete/wrong screen')
    need(metadata['binary']['path']==str(binary) and metadata['plan']==plan(),'Wrong binary/plan')
    lease=metadata['lease'];need(lease['cpu']==3 and lease['socket']==1 and lease['node']==1 and lease['affinity']==[3]
                              and lease['inherited_lock_descriptors'],'Wrong archived lease')
    need(metadata['memory_binding']=='numactl --physcpubind=3 --membind=1 per child','Wrong child placement')
    need(len(metadata['cases'])==8,'Incomplete command ledger')
    rebuilt=[];semantic={}
    for item,record in zip(plan(),metadata['cases']):
        label=f"case-{item['index']:02d}"
        need(record['case']==item and record['command']==command(binary,item)and record['complete'] is True and record['returncode']==0,'Changed/failed invocation')
        for stream in ('stdout','stderr'):
            need(record[stream]==label+'.'+stream and sha(directory/record[stream])==record[stream+'_sha256'],'Raw stream hash changed')
        need(not(directory/record['stderr']).read_bytes(),'Unexpected stderr')
        parsed=parse((directory/record['stdout']).read_text(),item)
        for row in parsed:
            key=(row['keys'],row['seed']);value=tuple(row[k]for k in SEMANTICS)
            need(semantic.get(key,value)==value,'Cross-chunk/type output or geometry mismatch');semantic[key]=value
        rebuilt.extend(parsed)
    need(rebuilt==json.loads((directory/'rows.json').read_text()),'Raw/JSON aggregate mismatch')
    need(rebuilt==list(csv.DictReader(io.StringIO((directory/'results.csv').read_text()))),'Raw/CSV aggregate mismatch')
    counts=dict(cases=8,rows=16,build_trial_vectors=64,build_metric_samples=320,query_trial_vectors=32,query_metric_samples=64)
    need(metadata['counts']==counts,'Wrong complete cardinalities')
    return counts
