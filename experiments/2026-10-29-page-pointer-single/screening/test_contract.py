"""Synthetic-only exact ledger and semantic guards; no executable invocation."""
import copy,csv,io,json,unittest
import screen_contract as s
from test_checks import fixture

def row(case):
    r=fixture(case);r['repeats']='6';r['query_phase_order']=s.original.schedule(42,6)
    for mode in s.original.MODES:
        for suffix in ('_ns','_min_ns','_max_ns'):r[mode+suffix]='1'
        r[mode+'_trials_ns']='1|1|1|1|1|1'
    return r

def evidence():
    metadata=dict(commands=[],rows=[]);raws=[];baseline=[]
    for i,item in enumerate(s.plan()):
        r=row(item['case']);label=f'row{i:03d}'
        stream=io.StringIO();writer=csv.DictWriter(stream,fieldnames=s.original.FIELDS);writer.writeheader();writer.writerow(r)
        raws.append(dict(stdout=stream.getvalue(),stderr=''))
        metadata['commands'].append(dict(label=label,round=item['round'],case=item['case'],command=s.command('/frozen/worker',item['case']),stdout=label+'.stdout',stderr=label+'.stderr',complete=True,returncode=0))
        metadata['rows'].append(dict(round=item['round'],**r))
        from checks import canonical_row
        baseline.append(canonical_row(r))
    return metadata,raws,baseline

class Contract(unittest.TestCase):
    def test_grid_geometry_order(self):
        plans=[s.panel(0),s.panel(1)];self.assertEqual([len(x)for x in plans],[120,120])
        signature=lambda g:(g['filter'],g['keys'],g['filter_bytes'],g['constructor_argument'])
        self.assertEqual({signature(x)for x in plans[0]},{signature(x)for x in plans[1]})
        self.assertEqual([x['filter']for x in plans[0][:16]],s.NAMES)
        self.assertEqual([x['filter']for x in plans[1][:16]],list(reversed(s.NAMES)))
        self.assertEqual(s.plan(),json.loads((s.HERE/'planned-grid.json').read_text()))
    def test_complete_ledger(self):
        metadata,raws,old=evidence();self.assertEqual(len(s.audit(metadata,raws,old,'/frozen/worker')),240)
    def test_incomplete_reorder_and_wrong_command(self):
        metadata,raws,old=evidence()
        with self.assertRaises(ValueError):s.audit(metadata,raws[:-1],old,'/frozen/worker')
        bad=copy.deepcopy(metadata);bad['commands'][0],bad['commands'][1]=bad['commands'][1],bad['commands'][0]
        with self.assertRaises(ValueError):s.audit(bad,raws,old,'/frozen/worker')
        bad=copy.deepcopy(metadata);bad['commands'][0]['command'][-1]='0'
        with self.assertRaises(ValueError):s.audit(bad,raws,old,'/frozen/worker')
    def test_bad_raw_phase_and_empty_success(self):
        metadata,raws,old=evidence();bad=copy.deepcopy(raws);bad[0]['stdout']=''
        with self.assertRaises(ValueError):s.audit(metadata,bad,old,'/frozen/worker')
        bad=copy.deepcopy(raws);bad[0]['stdout']=bad[0]['stdout'].replace(s.original.schedule(42,6),'000|000|000|000|000|000')
        with self.assertRaises(ValueError):s.audit(metadata,bad,old,'/frozen/worker')
    def test_old_latency_not_used(self):
        metadata,raws,old=evidence()
        for r in old:
            for mode in s.original.MODES:r[mode+'_ns']='9999'
        self.assertEqual(len(s.audit(metadata,raws,old,'/frozen/worker')),240)
        old[0]['filter_bytes']='1'
        # All duplicate references for this identity must be changed to test the lookup.
        for r in old:
            if r['filter']==old[0]['filter']and r['keys']==old[0]['keys']and r['requested_bpk']==old[0]['requested_bpk']:r['filter_bytes']='1'
        with self.assertRaises(ValueError):s.audit(metadata,raws,old,'/frozen/worker')
    def test_alias_counts_are_not_pooled(self):
        metadata,raws,old=evidence();self.assertEqual(s.parity(metadata['rows']),72)
        bad=copy.deepcopy(metadata['rows']);next(r for r in bad if r['filter']in s.ALIASES)['calibration_false_positives']='1'
        with self.assertRaises(ValueError):s.parity(bad)
    def test_recorded_placement(self):
        from screen_guard import validate_placement,ENVIRONMENT
        value=dict(affinity=[2],lease=dict(cpu=2,lease='socket0',lock_path='/tmp/fastest-bf-socket0.lock',
          inherited_write_verified=True,inherited_lock_descriptors=[3]),environment={k:None for k in ENVIRONMENT})
        validate_placement(value)
        for key,changed in [('affinity',[3]),('environment',{**value['environment'],'LD_PRELOAD':'override.so'}),
                            ('lease',{**value['lease'],'inherited_write_verified':False})]:
            with self.assertRaises(ValueError):validate_placement({**value,key:changed})

if __name__=='__main__':unittest.main()
