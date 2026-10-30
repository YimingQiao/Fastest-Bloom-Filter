"""Synthetic formal-entry corruption checks only; no compiler or BF execution."""
import copy,json,tempfile,unittest
from pathlib import Path
from screen_contract import PLAN,original,command,counts,tables,csv_text,audit,sha
from freeze import ENVIRONMENT,validate_placement
from run import protocol


def placement_record():
    cpus=list(range(3,18,2))
    lease=dict(cpu=3,socket=1,node=1,lock_path='/tmp/fastest-bf-socket1.lock',inherited_lock_descriptors=[3],
               child_cpus=cpus,topology=[dict(cpu=c,socket=1,core=i,nodes=[1])for i,c in enumerate(cpus)],environment={})
    return dict(lease=lease,affinity=[3],inherited_write_verified=True,host={},environment={key:None for key in ENVIRONMENT})


def mock_row(case):
    row={key:case[key]for key in ('language','family','scenario','bytes','batch_n','requested','history_n','hotspot','seed','input_base','repeats','cycles')}
    sums=original.input_checksums(case['seed'],case['batch_n'],case['history_n'],case['hotspot'])
    row.update(query_n=32771,checksum=case['seed']+case['scenario'],positives=21848,batch_checksum=sums[0],query_checksum=sums[1],
               phase_order='four_arm_williams',time_unit='absolute_ns',executed_order=original.executed_order(case),
               scheduler='caller_worker0'if case['language']=='cpp'else'scoped_workers_plus_caller_or_serial_fallback',
               cpus=list(range(3,3+case['requested']*2,2)))
    row['arms']={arm:dict(original.stats(case,arm),insert_ns=list(range(1,33)),
                         allocate_insert_ns=[]if case['history_n']else list(range(32,0,-1)),
                         insert_prefill_setup_ns=[1 if case['history_n']else 0]*32)for arm in PLAN.ARMS}
    return row


class RunnerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.records=[mock_row(case)for case in PLAN.ledger()]

    def test_fixed_ledger_protocol_and_storage(self):
        protocol();result=counts(self.records,placement_record()['lease'])
        self.assertEqual((result['process_cases'],result['contracts'],result['timed_fresh_bitmap_lifetimes']),(40,72,9216))
        self.assertEqual(result['semantic_geometry_records'],20)
        self.assertEqual(len(tables(self.records)),160)

    def test_wrong_order_and_count(self):
        with self.assertRaises(ValueError):counts(self.records[:-1],placement_record()['lease'])
        rows=copy.deepcopy(self.records);rows[0],rows[1]=rows[1],rows[0]
        with self.assertRaises(ValueError):counts(rows,placement_record()['lease'])

    def test_full_cycles_and_populated_contract(self):
        rows=copy.deepcopy(self.records);rows[0]['arms']['A1']['insert_ns'].pop()
        with self.assertRaises(ValueError):counts(rows,placement_record()['lease'])
        rows=copy.deepcopy(self.records);row=next(r for r in rows if r['history_n']);row['arms']['Policy']['allocate_insert_ns']=[1]*32
        with self.assertRaises(ValueError):counts(rows,placement_record()['lease'])

    def test_shared_mapping_and_actual_worker(self):
        rows=copy.deepcopy(self.records);rows[1]['checksum']^=1
        with self.assertRaises(ValueError):counts(rows,placement_record()['lease'])
        rows=copy.deepcopy(self.records);rows[0]['arms']['Clone']['workers']=1
        with self.assertRaises(ValueError):counts(rows,placement_record()['lease'])

    def test_archived_placement_guards(self):
        record=placement_record();validate_placement(record)
        variants=[]
        for mutate in (lambda r:r.update(affinity=[2]),lambda r:r.update(inherited_write_verified=False),
                       lambda r:r['lease'].update(node=0),lambda r:r['lease'].update(inherited_lock_descriptors=[]),
                       lambda r:r['lease']['topology'][1].update(core=0),lambda r:r['environment'].update(LD_PRELOAD='bad')):
            broken=copy.deepcopy(record);mutate(broken);variants.append(broken)
        for broken in variants:
            with self.assertRaises(ValueError):validate_placement(broken)

    def test_exact_raw_aggregate_and_command(self):
        lease=placement_record()['lease'];binaries={language:dict(path='/not/executed/'+language)for language in ('cpp','rust')}
        with tempfile.TemporaryDirectory()as tmp:
            output=Path(tmp);meta=dict(complete=True,final_frozen_inputs_equal=True,cases=[],counts=counts(self.records,lease))
            for index,(case,row)in enumerate(zip(PLAN.ledger(),self.records,strict=True)):
                saved=dict(case=case,complete=True,returncode=0,command=command(binaries[case['language']]['path'],case,lease))
                for stream,text in [('stdout',json.dumps(row)+'\n'),('stderr','')]:
                    name=f'case-{index:03d}.'+stream;(output/name).write_text(text);saved[stream]=name;saved[stream+'_sha256']=sha(output/name)
                meta['cases'].append(saved)
            (output/'four-arm-records.json').write_text(json.dumps(self.records));(output/'arm-results.csv').write_text(csv_text(tables(self.records)))
            self.assertEqual(audit(output,meta,binaries,lease)[0],self.records)
            broken=copy.deepcopy(meta);broken['cases']=40
            with self.assertRaises(ValueError):audit(output,broken,binaries,lease)
            broken=copy.deepcopy(meta);broken['cases'][0]['command'][-1]='--caller-check'
            with self.assertRaises(ValueError):audit(output,broken,binaries,lease)
            rows=copy.deepcopy(self.records);rows[0]['arms']['A0']['insert_ns'][0]+=1
            (output/'four-arm-records.json').write_text(json.dumps(rows))
            with self.assertRaises(ValueError):audit(output,meta,binaries,lease)


if __name__=='__main__':unittest.main()
