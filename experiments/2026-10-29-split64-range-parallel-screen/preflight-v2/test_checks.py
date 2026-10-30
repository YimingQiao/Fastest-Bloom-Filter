"""Offline fixtures/corruption checks; no compiler or benchmark execution."""
import copy
import json
from pathlib import Path
import subprocess
import sys
import unittest
from unittest import mock

from checks import (RANGE, RAW, select_grid, source_registry, validate_plan, validate_cli,
                    shuffled_order, validate_dense)
from lease import require_lease
from validate import placement_prefix

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=STAGE.parents[1]
NAMES=json.loads((STAGE/'registry.json').read_text())
PROPOSAL=json.loads((STAGE/'selection-proposal.json').read_text())


def grid():
    old=json.loads((ROOT/'experiments/2026-10-29-exact-budget-range/planned-grid.json').read_text())
    rows=[]
    for power in (16,25):
        for cap in (12,14,16,20,24,28,32):
            for name in NAMES:
                before='Split64RangeExperiment' if name==RANGE else name
                found=[r for r in old['configurations'] if r['filter']==before and r['key_power']==power and cap in r['represented_budget_bpk']]
                assert len(found)==1
                row={k:v for k,v in found[0].items() if k not in ('key_power','represented_budget_bpk','configuration_id','calibration_identity')}
                row.update(filter=name,requested_bpk=str(cap),budget_bytes=str((1<<power)*cap//8))
                rows.append(row)
    return rows


def fake_cli(raw=False):
    source=[r for r in grid() if r['keys']=='65536' and r['requested_bpk']=='16']
    planned={r['filter']:dict(r) for r in source}
    rows=[]
    for name in shuffled_order(NAMES,731,1024,16384,50):
        # Constructor field comparisons use this intentionally synthetic plan;
        # real small plans are obtained only during the leased native preflight.
        row=dict(planned[name]);row.pop('status');row.pop('reason')
        row.update(keys='1024',queries='16384',requested_bpk='16',hash_bits='64',hit_percent='50',present_queries='8200',absent_queries='8184',
                   batch='31',repeats='2',seed='731',insert_batch='1024',calibration_absent_queries='4096',calibration_false_positives='3',
                   threads='3',spawned_threads='2',parallel_hash_scratch_bytes=str(3*31*8),harness_hash_scratch_bytes='8192',
                   result_checksum='789',false_positives='2',fpr=str(2/8184),actual_bpk=str(8*int(row['filter_bytes'])/1024),
                   executor='caller_worker0',size_contract='exact_byte_ceiling_v1',query_phase_order='fixed_serial_pure_serial_hash_parallel_pure_parallel_hash',
                   input_mode='raw_bytes' if name==RAW else 'prehashed')
        for prefix in ('lookup','hash_lookup'):
            missing=prefix=='lookup' and name==RAW
            row.update({prefix+'_trials_ns':'nan|nan' if missing else '1|3',prefix+'_ns':'nan' if missing else '2',prefix+'_min_ns':'nan' if missing else '1',prefix+'_max_ns':'nan' if missing else '3'})
        for prefix in ('parallel_lookup','parallel_hash_lookup'):
            missing=prefix=='parallel_lookup' and name==RAW
            for part,value in (('end_to_end',6),('launch',1),('gated',3),('join',2)):
                row[prefix+'_'+part+'_trials']='nan' if missing else f'{value}|{value}'
                row[prefix+'_'+part+'_ns']='nan' if missing else str(value)
                if part in ('end_to_end','gated'):
                    row[prefix+'_'+part+'_min_ns']=row[prefix+'_'+part+'_max_ns']='nan' if missing else str(value)
        row.update(insert_ns='nan' if name==RAW else '1',allocate_insert_ns='nan' if name==RAW else '2',hash_insert_ns='1',allocate_hash_insert_ns='2')
        rows.append(row)
    return rows,planned


class Tests(unittest.TestCase):
    def test_source_registry(self):
        self.assertEqual(source_registry((STAGE/'adapters.hpp').read_text()),NAMES)

    def test_unchanged_geometry_proposal_142(self):
        plan=select_grid(grid(),PROPOSAL,NAMES)
        self.assertEqual((plan['actual_grid_rows'],plan['rows'],plan['grid_rows'],plan['extra_rows']),(350,142,132,10))
        self.assertEqual(len({r['configuration_id'] for r in plan['configurations']}),142)

    def test_allocation_missing_duplicate_and_overbudget(self):
        original=grid()
        for rows in (original[:-1],original+[original[0]],[original[1]]+original[1:]):
            with self.assertRaises(ValueError):select_grid(rows,PROPOSAL,NAMES)
        original[0]['filter_bytes']=str(1<<50)
        with self.assertRaises(ValueError):select_grid(original,PROPOSAL,NAMES)

    def test_replay_and_alias_identity(self):
        proposal=copy.deepcopy(PROPOSAL)
        proposal['replay_fixed_external_geometries'][0]['configuration_id']='bad'
        with self.assertRaises(ValueError):select_grid(grid(),proposal,NAMES)
        plan=select_grid(grid(),PROPOSAL,NAMES)
        for row in plan['configurations']:
            if row['filter']==RANGE:
                peers=[p for p in plan['configurations'] if p['filter']=='FastFilterFixed64' and p['keys']==row['keys'] and p['filter_bytes']==row['filter_bytes']]
                self.assertEqual(len(peers),1)
                self.assertEqual(row['calibration_identity'],peers[0]['calibration_identity'])
                self.assertNotEqual(row['configuration_id'],peers[0]['configuration_id'])

    def test_cli_vectors_order_raw_and_thread_parts(self):
        rows,plan=fake_cli();validate_cli(rows,NAMES,plan,16,50,31,3)
        for field,value in [('parallel_hash_lookup_join_trials','9|9'),('parallel_hash_lookup_gated_ns','9'),('threads','4'),('query_phase_order','balanced')]:
            changed=copy.deepcopy(rows);changed[0][field]=value
            with self.assertRaises(ValueError):validate_cli(changed,NAMES,plan,16,50,31,3)
        swapped=rows[1:2]+rows[:1]+rows[2:]
        with self.assertRaises(ValueError):validate_cli(swapped,NAMES,plan,16,50,31,3)
        for field,value in [('lookup_trials_ns','1|1'),('parallel_lookup_gated_ns','1'),('parallel_lookup_gated_trials','nan|nan')]:
            changed=copy.deepcopy(rows);next(r for r in changed if r['filter']==RAW)[field]=value
            with self.assertRaises(ValueError):validate_cli(changed,NAMES,plan,16,50,31,3)

    def test_full_dense_outputs(self):
        outputs=[int(i%4==0) for i in range(4097)];cal=[0]*4096
        current=[dict(filter=name,keys=n,budget_bpk=cap,filter_bytes=n*cap//8,inserted_checked=n,outputs=outputs,calibration_outputs=cal)
                 for name in NAMES for n in (64,1024,65536) for cap in (16,24,32)]
        reference=[r for r in current if r['filter']!=RANGE]
        counts=validate_dense(current,reference,NAMES)
        self.assertEqual(counts['compared_answers'],216*(4097+4096))
        changed=list(current);changed[0]=dict(changed[0],outputs=list(outputs));changed[0]['outputs'][1]=1
        with self.assertRaises(ValueError):validate_dense(changed,reference,NAMES)
        with self.assertRaises(ValueError):validate_dense(current[:-1],reference,NAMES)

    def test_child_affinity_expands_before_libnuma(self):
        prefix=placement_prefix([3,5,7])
        self.assertEqual(prefix,['taskset','-c','3,5,7','numactl','--physcpubind=3,5,7','--membind=1'])
        command=prefix+['benchmark','10','16','50','14','31','2','731','FastPatternBF','1024','12','3','3,5,7']
        # Invalid-argument variants use these tail-relative positions.
        self.assertEqual((command[-8],command[-5],command[-2],command[-1]),('31','FastPatternBF','3','3,5,7'))

    def test_lock_is_already_owned(self):
        with mock.patch('lease.os.environ.get',return_value='socket1-cpu3'),mock.patch('lease.os.sched_getaffinity',return_value={3}),mock.patch('lease.os.listdir',return_value=['8']),mock.patch('lease.os.readlink',return_value='/tmp/fastest-bf-socket1.lock'),mock.patch('lease.fcntl.flock') as lock:
            with mock.patch('lease.Path.read_text',return_value=''):
                with self.assertRaises(ValueError):require_lease(3)
            lock.assert_not_called()
            with mock.patch('lease.Path.read_text',return_value='lock: 1: FLOCK ADVISORY WRITE 1 00:00:1 0 EOF'):
                self.assertEqual(require_lease(3)['inherited_lock_descriptors'],[8])

    def test_early_optimized_python_rejection(self):
        run=subprocess.run([sys.executable,'-O',str(HERE/'validate.py'),'--help'],capture_output=True,text=True)
        self.assertNotEqual(run.returncode,0);self.assertFalse(run.stdout);self.assertIn('without Python -O',run.stderr)


if __name__=='__main__':unittest.main()
