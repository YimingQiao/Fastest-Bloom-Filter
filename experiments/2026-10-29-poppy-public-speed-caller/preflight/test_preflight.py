import copy,json,unittest
from bindings import CALLER,SELECTION,TARGET,generated_inputs
from contract import TINY,P,cases,argv,invalid,semantic
from guard import expected_order,expected_phases,expected_geometry,csv_fields,source_registry,validate_rows
SOURCE=(CALLER/'benchmark/src/main.rs').read_text()
def fixture(case):
    rows=[];n=1<<case['key_power'];q=1<<TINY['query_power'];present=q//100*50+min(q%100,50)
    for name in expected_order(case,TINY,SOURCE):
        r={k:'0'for k in csv_fields(SOURCE)}
        r.update(language='rust',filter=name,keys=str(n),queries=str(q),requested_bpk='24',hash_bits='64',hit_percent='50',present_queries=str(present),absent_queries=str(q-present),batch=str(case['batch']),repeats='4',seed='42',result_checksum='123',input_mode='prehashed',insert_batch=str(n),calibration_absent_queries='0',calibration_false_positives='0',scalar_track='optimizer_visible_public_single',query_phase_order=expected_phases(42,4))
        r.update({k:str(v)for k,v in expected_geometry(name,n,24).items()})
        for k in r:
            if k.endswith('_ns'):r[k]='1'
            if k.endswith('_trials'):r[k]='1|1|1|1'
        rows.append(r)
    return rows
class Checks(unittest.TestCase):
    def test_registry_geometry(self):
        self.assertEqual(len(source_registry(SOURCE)),68)
        points=[p for p in json.loads(SELECTION.read_text())['configurations']if p['owner']=='poppy_external']
        self.assertEqual(len(points),47)
        for p in points:
            g=expected_geometry(p['filter'],p['keys'],p['run_budget_bpk']);c=p['canonical_constructor']
            self.assertEqual(g['filter_bytes'],c['buckets']*4096+c['cache_bytes'])
            self.assertEqual(g['constructor_argument'],int(c['fpp_bits'],16))
            with self.assertRaises(ValueError):expected_geometry(p['filter'],p['keys']-1,p['run_budget_bpk'])
    def test_finite_case_order(self):
        all_cases=cases(SOURCE);self.assertEqual(len(all_cases),4)
        for a,b in zip(all_cases[::2],all_cases[1::2]):
            self.assertEqual(expected_order(a,TINY,SOURCE)[::-1],expected_order(b,TINY,SOURCE))
            self.assertEqual(len(argv('/binary',a)),12);self.assertEqual(len(argv('/original',a,True)),11)
            self.assertNotIn(P,argv('/original',a,True)[8])
        self.assertEqual(len(invalid('/binary',SOURCE)),6)
    def test_output_guards(self):
        case=cases(SOURCE)[0];rows=fixture(case);validate_rows(rows,case,TINY,SOURCE)
        for field,value in [('keys','1024'),('calibration_absent_queries','1'),('present_queries','2048'),('filter_bytes','1'),('query_phase_order','0|1|2|3')]:
            bad=copy.deepcopy(rows);bad[0][field]=value
            with self.assertRaises(ValueError,msg=field):validate_rows(bad,case,TINY,SOURCE)
        with self.assertRaises(ValueError):validate_rows([],case,TINY,SOURCE)
    def test_generated_inputs_require_structured_owner(self):
        target=TARGET/'normal';path=str(target/'out/generated.rs');digest='a'*64;inventory={'input_sha256':{}}
        with self.assertRaises(ValueError):generated_inputs([],target,{}, {path:digest},inventory)
        event={'reason':'build-script-executed','package_id':'fixed-package','out_dir':str(target/'out')}
        result=generated_inputs([json.dumps(event)],target,{'fixed-package':{}},{path:digest},inventory)
        self.assertEqual(result[path]['build_script_event'],event)
        with self.assertRaises(ValueError):generated_inputs([json.dumps(event)],target,{}, {path:digest},inventory)
        event['out_dir']='/tmp/other'
        with self.assertRaises(ValueError):generated_inputs([json.dumps(event)],target,{'fixed-package':{}},{path:digest},inventory)
if __name__=='__main__':unittest.main()
