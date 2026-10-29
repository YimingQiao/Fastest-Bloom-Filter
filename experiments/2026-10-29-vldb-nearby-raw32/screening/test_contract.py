import copy,json,unittest
from screen_contract import *
from screen_guard import validate_placement,ENVIRONMENT

def fake(item):
    c=item['case'];g=item['geometry'];q=1<<22
    row={k:str(v)for k,v in g.items()};key=f'{geometry_key(c["filter"])}/{c["power"]}/{c["cap"]}'
    old=json.loads((HERE/'semantic-references.json').read_text()).get(key)
    if old:row.update(old)
    else:
        ref=next(v for k,v in json.loads((HERE/'semantic-references.json').read_text()).items()if k.endswith(f'/{c["power"]}/{c["cap"]}'))
        row.update(ref);row.update(false_positives='3',calibration_false_positives='11',result_checksum='99')
    row.update(repeats='6',query_phase_order=original.schedule(42,6),build_repeats='0',
        build_hash_scratch_bytes=str(0 if c['filter']not in NATIVE else 8*(1<<c['power'])),filter_build_scratch_bytes='0',
        adapter_object_bytes=json.loads((HERE/'object-bytes.json').read_text())[c['filter']])
    unit=4 if c['filter']not in NATIVE else 8
    for mode,count in zip(MODES,(0,1,4096)):
        row.update({mode+'_ns':'3.5',mode+'_min_ns':'1',mode+'_max_ns':'6',mode+'_trials_ns':'1|2|3|4|5|6',mode+'_scratch_bytes':str(unit*count)})
    for key in ('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns'):row[key]='nan'
    return {k:row[k]for k in original.FIELDS}

class Tests(unittest.TestCase):
    def test_complete_grid(self):
        grid=plan();self.assertEqual(len(grid),160);self.assertEqual([x['case']for x in grid[80:]],[x['case']for x in reversed(grid[:80])])
        rows=[]
        for item in grid:
            row=fake(item);validate(row,item['case']);compare_old(row);rows.append(dict(round=item['round'],**row))
        self.assertEqual(parity(rows,True),(80,48))
    def test_exact_present(self):
        item=plan()[0];row=fake(item);row['present_queries']=str((1<<22)//2)
        with self.assertRaises(ValueError):validate(row,item['case'])
    def test_phase_balance(self):
        phases=original.schedule(42,6).split('|');self.assertEqual(set(phases),{'012','021','102','120','201','210'})
        item=plan()[0];row=fake(item);row['query_phase_order']='|'.join(phases[:-1]+[phases[0]])
        with self.assertRaises(ValueError):validate(row,item['case'])
    def test_trial_guards(self):
        item=plan()[0]
        for field,value in [('raw_single_trials_ns','1|2|3|4|5|nan'),('raw_single_ns','4'),('raw_batch1_scratch_bytes','8'),('adapter_object_bytes','1')]:
            row=fake(item);row[field]=value
            with self.assertRaises(ValueError):validate(row,item['case'])
    def test_alias_quality_not_pooled(self):
        rows=[dict(round=x['round'],**fake(x))for x in plan()];rows[2]['calibration_false_positives']=str(int(rows[2]['calibration_false_positives'])+1)
        with self.assertRaises(ValueError):parity(rows,True)
    def test_wrong_geometry(self):
        item=plan()[1];row=fake(item);row['unit_count']=str(int(row['unit_count'])+1)
        with self.assertRaises(ValueError):validate(row,item['case'])
    def test_old_semantic_reproduction(self):
        row=fake(plan()[0]);row['result_checksum']='0'
        with self.assertRaises(ValueError):compare_old(row)
    def test_empty_or_extra_rows(self):
        for raw in ('', 'a,b\n1,2\n','a,b\n1,2\n1,2\n'):
            with self.assertRaises(ValueError):original.parse_one(raw)
    def test_placement(self):
        value=dict(lease=dict(cpu=2,lease='socket0',lock_path='/tmp/fastest-bf-socket0.lock',inherited_lock_descriptors=[3],inherited_write_verified=True),affinity=[2],host=dict(system='Linux',node='test',release='x',version='x',machine='x86_64'),environment={k:None for k in ENVIRONMENT})
        validate_placement(value)
        for key,new in [('affinity',[3]),('environment',{}),('host',{})]:
            bad=copy.deepcopy(value);bad[key]=new
            with self.assertRaises(ValueError):validate_placement(bad)
        bad=copy.deepcopy(value);bad['lease']['inherited_write_verified']=False
        with self.assertRaises(ValueError):validate_placement(bad)
    def test_full_audit_and_order(self):
        import csv,io
        grid=plan();records=[];rows=[];raws=[];binary='/fixed/binary'
        for i,item in enumerate(grid):
            row=fake(item);out=io.StringIO();writer=csv.DictWriter(out,fieldnames=original.FIELDS);writer.writeheader();writer.writerow(row)
            label=f'row{i:03d}';records.append(dict(label=label,round=item['round'],case=item['case'],command=command(binary,item['case']),complete=True,returncode=0,stdout=label+'.stdout',stderr=label+'.stderr'))
            rows.append(dict(round=item['round'],**row));raws.append(dict(stdout=out.getvalue(),stderr=''))
        meta=dict(commands=records,rows=rows);self.assertEqual(audit_rows(meta,raws,binary),rows)
        meta['commands'][0]['command'][-1]='12'
        with self.assertRaises(ValueError):audit_rows(meta,raws,binary)

if __name__=='__main__':unittest.main()
