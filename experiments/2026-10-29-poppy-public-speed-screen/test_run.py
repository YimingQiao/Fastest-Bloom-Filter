"""Offline archive/placement/pending-proof tests; no benchmark execution."""
import hashlib,json,subprocess,sys,tempfile,unittest
from pathlib import Path
from unittest.mock import patch
import audit,placement,pins
from test_contract import all_records
from screen_contract import plan,command,validate_records,aggregate_csv,csv_text,row_protocol,raw_intervals,PREFIX,expected_stderr
HERE=Path(__file__).resolve().parent
def lease():return dict(cpu=2,socket=0,node=0,core=1,affinity=[2],lock_path='/tmp/fastest-bf-socket0.lock',inherited_lock_descriptors=[9],
  lock_evidence={'9':'lock:\t1: FLOCK ADVISORY WRITE 123 00:00:1 0 EOF\n'},environment={k:None for k in placement.FORBIDDEN},memory_policy=placement.DESCRIPTION)
class Guards(unittest.TestCase):
    def test_pending_proof_rejected(self):
        old=Path.read_text
        def read(path,*args,**kwargs):
            return '{"complete":false}'if path==HERE/'proof-binding.json'else old(path,*args,**kwargs)
        with patch.object(Path,'read_text',read),self.assertRaises(ValueError):pins.verify('0'*40)
    def test_python_optimized_rejected_before_imports(self):
        result=subprocess.run([sys.executable,'-O',str(HERE/'run.py')],capture_output=True,text=True)
        self.assertNotEqual(result.returncode,0);self.assertIn('Python -O unsupported',result.stderr);self.assertEqual(result.stdout,'')
    def test_archived_lease_corruptions(self):
        placement.validate(lease())
        for key,value in [('affinity',[2,4]),('socket',1),('node',1),('lock_evidence',{'9':'FLOCK ADVISORY READ'}),('environment',{})]:
            record=lease();record[key]=value
            with self.assertRaises(ValueError):placement.validate(record)
    def test_full_raw_audit_and_quality_link_corruption(self):
        records=all_records();counts,quality,references=validate_records(records)
        with tempfile.TemporaryDirectory()as tmp:
            output=Path(tmp);commands=[];sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
            for record in records:
                case=record['case'];label=f"case-{case['index']:02d}";out=output/(label+'.stdout');err=output/(label+'.stderr');out.write_text(csv_text(record['rows']));err.write_bytes(expected_stderr())
                commands.append(dict(case=case,command=command('/fixed',case),returncode=0,complete=True,
                  stdout=out.name,stderr=err.name,stdout_sha256=sha(out),stderr_sha256=sha(err),source_derived_intervals=raw_intervals(case,row_protocol(case))))
            for name,value in [('records.json',records),('quality.json',quality),('quality-links.json',references)]:(output/name).write_text(json.dumps(value))
            (output/'results.csv').write_text(aggregate_csv(records))
            meta=dict(complete=True,source_commit='fixed',ledger=plan(),child_prefix=PREFIX,lease=lease(),compiler_runs=0,binary={'path':'/fixed'},cases=commands,counts=counts)
            self.assertEqual(audit.audit(output,meta,Path('/fixed'),'fixed',sha),counts)
            first=output/commands[0]['stderr'];first.write_bytes(expected_stderr()+b'unexpected\n');commands[0]['stderr_sha256']=sha(first)
            with self.assertRaises(ValueError):audit.audit(output,meta,Path('/fixed'),'fixed',sha)
            first.write_bytes(expected_stderr());commands[0]['stderr_sha256']=sha(first)
            references[-1]['absent_reused']*=2;(output/'quality-links.json').write_text(json.dumps(references))
            with self.assertRaises(ValueError):audit.audit(output,meta,Path('/fixed'),'fixed',sha)
    def test_analysis_composites_and_counts(self):
        rules=json.loads((HERE/'ANALYSIS_RULES.json').read_text())
        self.assertIn('all_external_composite',rules['owner_groups']);self.assertIn('all_native_composite',rules['owner_groups'])
        self.assertEqual(rules['analytic_counts']['query_named_contrasts'],432*9)
        self.assertEqual(rules['analytic_counts']['build_named_contrasts'],432*9)
if __name__=='__main__':unittest.main()
