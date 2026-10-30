#!/usr/bin/env python3
"""Small correctness/accounting/selection smoke, not a performance result."""
import argparse
import csv
import io
import math
import subprocess

SELECTED = ','.join(('FastPatternBF','FourSectorBloomFilter','Split64BloomFilter','ByteSplitBloomFilter',
    'FastFilterFixed16','FastFilterFixed16SingleV1','FastFilterFixed32Bulk','FastFilterSimdBlock','FastFilterSimdBlockSingleV1',
    'Boost192Multi64K8','Boost192ClassicK11','RocksDBFastLocalBloom64','RocksDBFastLocalBloom64K8Batch32','PageBloom6Default'))

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('binary')
    parser.add_argument('--cpus',default='3,5,7')
    args=parser.parse_args()
    cpus=args.cpus.split(',')
    assert len(cpus)==3
    def command(hit=50,batch=31,workers=3,selection=SELECTED,cpu_text=None):
        return [args.binary,'12','8',str(hit),'14',str(batch),'2','731',selection,'4096','14',str(workers),cpu_text or ','.join(cpus[:workers])]
    previous={}
    for hit,batch in ((0,1),(50,31),(100,4096)):
        by_worker={}
        for workers in (1,3):
            result=subprocess.run(command(hit,batch,workers),text=True,capture_output=True,check=True)
            rows=list(csv.DictReader(io.StringIO(result.stdout)))
            assert len(rows)==14 and len({r['filter'] for r in rows})==14
            by_worker[workers]={r['filter']:r for r in rows}
            for row in rows:
                assert row['threads']==str(workers) and row['spawned_threads']==str(workers-1)
                assert row['executor']=='caller_worker0'
                assert int(row['parallel_hash_scratch_bytes'])==workers*batch*8
                assert int(row['calibration_absent_queries'])==1<<14
                if hit==100: assert int(row['absent_queries'])==0 and math.isnan(float(row['fpr']))
                for phase in ('parallel_lookup','parallel_hash_lookup'):
                    raw=phase=='parallel_lookup' and row['input_mode']=='raw_bytes'
                    lists={field:[float(v) for v in row[f'{phase}_{field}_trials'].split('|')]
                           for field in ('end_to_end','launch','gated','join')}
                    if raw:
                        assert all(len(values)==1 and math.isnan(values[0]) for values in lists.values())
                        assert math.isnan(float(row[f'{phase}_gated_ns']))
                    else:
                        assert all(len(values)==2 and all(math.isfinite(v) and v>=0 for v in values) for values in lists.values())
                        for i in range(2):
                            assert abs(lists['end_to_end'][i]-sum(lists[f][i] for f in ('launch','gated','join')))<1e-6
                old=previous.setdefault(row['filter'],row['calibration_false_positives'])
                assert old==row['calibration_false_positives'],(row['filter'],'calibration depends on hit/batch/T')
        for name,left in by_worker[1].items():
            right=by_worker[3][name]
            for field in ('keys','queries','filter_bytes','result_checksum','false_positives','absent_queries','calibration_false_positives'):
                assert left[field]==right[field],(name,field)
    bad=[command(selection='FastPatternBF,typo'),command(selection='FastPatternBF,FastPatternBF'),
         command(selection='FastPatternBF,'),command(cpu_text=cpus[0]+','+cpus[0]+','+cpus[2]),
         command(cpu_text=','.join(cpus[:2])),command(cpu_text='99999,5,7'),command(batch=16384)]
    for cmd in bad:
        result=subprocess.run(cmd,text=True,capture_output=True)
        assert result.returncode!=0 and not result.stdout,(cmd,result)
    print('Six representative CLI cases (84 rows) passed full-output checks, T parity, raw labels, calibration, phase accounting and strict input rejection.')

if __name__=='__main__':main()
