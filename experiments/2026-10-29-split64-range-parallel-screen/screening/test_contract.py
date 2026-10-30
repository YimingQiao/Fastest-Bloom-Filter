"""Offline corruption tests only: no benchmark/compiler execution."""
import copy
import csv
import io
import json
import subprocess
import sys
import unittest
from pathlib import Path
from contract import (STAGE, RAW, GEOMETRY_FIELDS, command, identity, parse_rows,
                      shuffled_order, validate_case, validate_matrix, validate_placement, median)

PROTOCOL=json.loads((Path(__file__).parent/'protocol.json').read_text())
PLAN=json.loads((STAGE/'validation-v3/planned-selection.json').read_text())
TEMPLATES={r['filter']:r for r in csv.DictReader((STAGE/'validation-v3/native-cli-p16-h50-b31-t3.stdout').open())}


def mock_rows():
    rows=[];q=1<<PROTOCOL['query_power'];rep=PROTOCOL['repeats'];hit=PROTOCOL['hit_percent']
    present=q//100*hit+min(q%100,hit)
    for case in PROTOCOL['cases']:
        n=1<<case['key_power']; cap=case['budget_bpk']
        planned={r['filter']:r for r in PLAN['configurations'] if r['key_power']==case['key_power'] and int(r['requested_bpk'])==cap}
        for name in shuffled_order(case['filters'],PROTOCOL['seed'],n,q,hit):
            row=copy.deepcopy(TEMPLATES[name]);g=planned[name];raw=name==RAW
            row.update({f:g[f] for f in GEOMETRY_FIELDS})
            values=dict(keys=n,queries=q,requested_bpk=cap,actual_bpk=8*int(g['filter_bytes'])/n,hit_percent=hit,
               present_queries=present,absent_queries=q-present,batch=4096,repeats=rep,seed=42,insert_batch=n,
               calibration_absent_queries=1<<24,threads=8,spawned_threads=7,parallel_hash_scratch_bytes=8*4096*8,
               harness_hash_scratch_bytes=n*8,false_positives=0,calibration_false_positives=0,fpr=0,result_checksum=1,
               filter_build_scratch_bytes=(1+int(g['filter_bytes'])//32//16384)*(16384*8+4) if name=='FastFilterFixed32Bulk' else 0)
            row.update({k:str(v) for k,v in values.items()})
            for prefix in ('lookup','hash_lookup'):
                missing=raw and prefix=='lookup';trial=[float(i+1) for i in range(rep)]
                row[prefix+'_trials_ns']='|'.join(['nan']*rep) if missing else '|'.join(map(str,trial))
                for field,value in [('_ns',median(trial)),('_min_ns',min(trial)),('_max_ns',max(trial))]:
                    row[prefix+field]='nan' if missing else str(value)
            for prefix in ('parallel_lookup','parallel_hash_lookup'):
                missing=raw and prefix=='parallel_lookup'
                for part,value in [('end_to_end',5),('launch',1),('gated',3),('join',1)]:
                    row[prefix+'_'+part+'_ns']='nan' if missing else str(value)
                    row[prefix+'_'+part+'_trials']='nan' if missing else '|'.join([str(value)]*rep)
                    if part in ('end_to_end','gated'):
                        row[prefix+'_'+part+'_min_ns']=row[prefix+'_'+part+'_max_ns']='nan' if missing else str(value)
            rows.append(row)
    return rows


class Guards(unittest.TestCase):
    def setUp(self):self.rows=mock_rows()
    def bad(self,rows):
        with self.assertRaises((ValueError,KeyError)):validate_matrix(rows,PLAN,PROTOCOL)
    def test_complete_fixed142_and92(self):
        self.assertEqual(validate_matrix(self.rows,PLAN,PROTOCOL),dict(rows=142,cases=13,calibration_records=92,pooled=False))
    def test_empty_partial_duplicate(self):
        for rows in ([],self.rows[:-1],self.rows+[self.rows[-1]],self.rows[:10]+self.rows[11:]+[self.rows[10]]):self.bad(rows)
    def test_source_order(self):
        self.rows[2],self.rows[3]=self.rows[3],self.rows[2];self.bad(self.rows)
    def test_geometry_and_scratch(self):
        for key in ('filter_bytes','unit_count','effective_probes','budget_bytes','harness_hash_scratch_bytes','parallel_hash_scratch_bytes','filter_build_scratch_bytes'):
            rows=copy.deepcopy(self.rows);rows[0][key]=str(int(rows[0][key])+1);self.bad(rows)
    def test_metadata_and_phase(self):
        for key in ('threads','spawned_threads','queries','repeats','calibration_absent_queries','seed'):
            rows=copy.deepcopy(self.rows);rows[0][key]=str(int(rows[0][key])+1);self.bad(rows)
        self.rows[0]['query_phase_order']='balanced';self.bad(self.rows)
    def test_vectors_and_summary(self):
        for key in ('lookup_trials_ns','parallel_lookup_end_to_end_trials','parallel_hash_lookup_gated_trials'):
            rows=copy.deepcopy(self.rows);rows[0][key]='1|2';self.bad(rows)
        self.rows[0]['parallel_lookup_end_to_end_ns']='6';self.bad(self.rows)
    def test_decomposition(self):
        self.rows[0]['parallel_lookup_launch_trials']='2|2|2|2|2|2';self.rows[0]['parallel_lookup_launch_ns']='2';self.bad(self.rows)
    def test_raw_pure_nan(self):
        index=next(i for i,r in enumerate(self.rows) if r['filter']==RAW)
        self.rows[index]['lookup_ns']='1';self.bad(self.rows)
    def test_alias_calibration_not_pooled(self):
        counts={}
        for index,row in enumerate(self.rows):counts.setdefault(identity(row)[1],[]).append(index)
        index=next(ids[1] for ids in counts.values() if len(ids)>1)
        self.rows[index]['calibration_false_positives']='1';self.bad(self.rows)
    def test_parse_rejects_empty_and_bad_schema(self):
        for text in ('','a,a\n1,2\n','a,b\n1\n','a\n1,2\n'):
            with self.assertRaises(ValueError):parse_rows(text)
    def test_affinity_prefix_and_exact_args(self):
        cmd=command('/binary',PROTOCOL['cases'][0],PROTOCOL)
        self.assertEqual(cmd[:7],['taskset','-c','3,5,7,9,11,13,15,17','numactl','--physcpubind=3,5,7,9,11,13,15,17','--membind=1','/binary'])
        self.assertEqual(cmd[-2:],['8','3,5,7,9,11,13,15,17'])
        self.assertEqual(cmd[7:],['16','12','50','22','4096','6','42','FastFilterFixed32','65536','24','8','3,5,7,9,11,13,15,17'])
    def test_recorded_lease_topology_and_environment(self):
        meta=dict(lease=dict(cpu=3,lease='socket1',lock_path='/tmp/fastest-bf-socket1.lock',inherited_lock_descriptors=[3]),
          process_affinity=[3],topology=[dict(cpu=cpu,core=i,socket=1,nodes=[1]) for i,cpu in enumerate(PROTOCOL['cpus'])],
          environment=dict(BF_SOCKET_LEASE='socket1-cpu3'))
        validate_placement(meta,PROTOCOL)
        bad=[]
        for key,value in [('cpu',2),('lease','socket0'),('lock_path','/tmp/other.lock'),('inherited_lock_descriptors',[])]:
            x=copy.deepcopy(meta);x['lease'][key]=value;bad.append(x)
        x=copy.deepcopy(meta);x['process_affinity']=[3,5];bad.append(x)
        for key,value in [('cpu',19),('core',1),('socket',0),('nodes',[0])]:
            x=copy.deepcopy(meta);x['topology'][0][key]=value;bad.append(x)
        for key,value in [('BF_SOCKET_LEASE','socket0-cpu2'),('LD_PRELOAD','evil.so')]:
            x=copy.deepcopy(meta);x['environment'][key]=value;bad.append(x)
        for x in bad:
            with self.assertRaises(ValueError):validate_placement(x,PROTOCOL)
    def test_optimized_python_rejected_before_work(self):
        for name in ('run.py','audit.py'):
            result=subprocess.run([sys.executable,'-O',str(Path(__file__).parent/name),'--help'],capture_output=True,text=True)
            self.assertNotEqual(result.returncode,0);self.assertIn('Python -O is forbidden',result.stderr)

if __name__=='__main__':unittest.main()
