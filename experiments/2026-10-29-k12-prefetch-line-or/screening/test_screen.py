"""Focused offline guard tests; no compiler, filter or formal input execution."""
import copy,csv,hashlib,io,json,tempfile,unittest
from pathlib import Path
import screen_contract as s
import placement
HERE=Path(__file__).resolve().parent

def fixture(item):
    sample=HERE.parent/'caller/repair-v2/validation-v1/native-case0-latin0.stdout'
    rows=list(csv.DictReader(io.StringIO(sample.read_text())));n,q=item['keys'],1<<item['query_power']
    present=q//100*item['hit_percent']+min(q%100,item['hit_percent']);cal=(1<<item['calibration_power'])if item['calibration_power']else 0
    for row in rows:
        is_range=row['filter']==s.TYPES[2]
        update=dict(keys=n,queries=q,filter_bytes=n*3,present_queries=present,absent_queries=q-present,
            batch=item['query_batch'],repeats=item['query_repeats'],seed=item['seed'],insert_batch=item['insert_batch'],
            harness_hash_scratch_bytes=8*max(item['insert_batch'],item['query_batch']),calibration_absent_queries=cal,
            calibration_false_positives=(200 if is_range else 100)if cal else 0,
            query_repeats=item['query_repeats'],build_repeats=item['build_repeats'],budget_bytes=n*3,logical_bytes=n*3,
            unit_count=n*3//64,constructor_argument=n*3,false_positives=0,fpr=0,result_checksum=19 if is_range else 17)
        row.update({k:str(v)for k,v in update.items()})
        row['query_phase_order']=';'.join('H>P'if(item['seed']+i)&1 else'P>H'for i in range(item['query_repeats']))
        for vector,metric in s.METRICS.items():
            count=item['query_repeats']if'lookup'in vector else item['build_repeats']
            values=[float(i+1+(10 if vector.startswith('allocate_')else 0))for i in range(count)]
            row[vector]=json.dumps(values);row[metric]=str(s.statistics.median(values))
            if'lookup'in vector:
                row[metric.replace('_ns','_min_ns')]=str(min(values));row[metric.replace('_ns','_max_ns')]=str(max(values))
    return sorted(rows,key=lambda r:item['filter_order'].index(r['filter']))

def text(rows):return s.csv_text(rows)
def lease():
    return dict(cpu=2,socket=0,node=0,core=1,affinity=[2],lock_path='/tmp/fastest-bf-socket0.lock',
      inherited_lock_descriptors=[9],environment={k:None for k in placement.FORBIDDEN},memory_policy=placement.DESCRIPTION,
      exclusive_lock_evidence={'9':'lock:\t1: FLOCK  ADVISORY  WRITE 123 00:00:1 0 EOF\n'})

class Guards(unittest.TestCase):
    def setUp(self):self.item=s.plan()[0];self.rows=fixture(self.item)
    def bad(self,change):
        rows=copy.deepcopy(self.rows);change(rows)
        with self.assertRaises(RuntimeError):s.parse(text(rows),self.item)
    def test_fixed_counts_latin_and_command(self):
        rows=[];groups={}
        for item in s.plan():
            parsed=s.parse(text(fixture(item)),item);rows.extend(parsed)
            groups.setdefault((item['keys_power'],item['insert_chunk']),[]).append(item['filter_order'])
            self.assertEqual(s.command('/fixed',item)[-1],f"latin{s.SEEDS.index(item['seed'])}")
            self.assertEqual(s.command('/fixed',item)[-4],'26')
        self.assertEqual(s.complete(rows),s.COUNTS)
        for orders in groups.values():
            for index in range(3):self.assertEqual({order[index]for order in orders},set(s.TYPES))
    def test_old_tiny_fixture(self):
        item=dict(self.item,keys=64,keys_power=6,seed=74381,query_power=12,query_batch=31,query_repeats=2,build_repeats=2,calibration_power=0)
        original=(HERE.parent/'caller/repair-v2/validation-v1/native-case0-latin0.stdout').read_text()
        self.assertEqual(len(s.parse(original,item)),3)
    def test_wrong_order(self):self.bad(lambda r:r.reverse())
    def test_duplicate_type(self):self.bad(lambda r:r[1].update(filter=r[0]['filter']))
    def test_bad_count_and_geometry(self):
        self.bad(lambda r:r[0].update(calibration_absent_queries='16777216'))
        self.bad(lambda r:r[2].update(unit_count='1'))
    def test_bad_trials_and_summary(self):
        self.bad(lambda r:r[0].update(insert_trials_ns='[1]'))
        self.bad(lambda r:r[0].update(insert_ns='999'))
        self.bad(lambda r:r[0].update(lookup_max_ns='999'))
    def test_alias_counts(self):self.bad(lambda r:r[1].update(calibration_false_positives='101'))
    def test_phase_order(self):self.bad(lambda r:r[0].update(query_phase_order='P>H;P>H'))
    def test_source_intervals(self):
        for item in s.plan():
            v=s.intervals(item);self.assertEqual(v['inserted_half_open'][1],v['mixed_absent_superset_half_open'][0])
            self.assertEqual(v['mixed_absent_superset_half_open'][1],v['calibration_half_open'][0])
            self.assertEqual(v['calibration_half_open'][1]-v['calibration_half_open'][0],1<<26)
        self.assertEqual(s.splitmix_first(0),0xe220a8397b1dcdaf)
    def test_cross_chunk_no_pool(self):
        rows=[r for item in s.plan()for r in fixture(item)];s.complete(rows)
        rows[3]['result_checksum']='999'
        with self.assertRaises(RuntimeError):s.complete(rows)
    def test_placement_archive(self):
        placement.validate(lease())
        for key,value in [('cpu',3),('affinity',[2,4]),('environment',{}),('exclusive_lock_evidence',{'9':'FLOCK ADVISORY READ'})]:
            bad=lease();bad[key]=value
            with self.assertRaises(RuntimeError):placement.validate(bad)
    def test_complete_raw_audit_rejects_corruption(self):
        with tempfile.TemporaryDirectory()as tmp:
            directory=Path(tmp);records=[];rows=[];digest=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
            for item in s.plan():
                label=f"case-{item['index']:02d}";a=directory/(label+'.stdout');b=directory/(label+'.stderr')
                f=fixture(item);a.write_text(text(f));b.write_text('');rows.extend(f)
                records.append(dict(case=item,command=s.command('/fixed',item),raw_intervals=s.intervals(item),complete=True,returncode=0,
                    stdout=a.name,stderr=b.name,stdout_sha256=digest(a),stderr_sha256=digest(b)))
            (directory/'rows.json').write_text(json.dumps(rows));(directory/'results.csv').write_text(text(rows))
            meta=dict(complete=True,source_commit='fixed',binary={'path':'/fixed'},plan=s.plan(),lease=lease(),child_prefix=placement.PREFIX,
                compiler_runs=0,query_ranking=False,cases=records,counts=s.COUNTS)
            self.assertEqual(s.audit(directory,meta,Path('/fixed'),'fixed',digest),s.COUNTS)
            meta['cases'][0]['raw_intervals']['key_base']+=1
            with self.assertRaises(RuntimeError):s.audit(directory,meta,Path('/fixed'),'fixed',digest)
if __name__=='__main__':unittest.main()
