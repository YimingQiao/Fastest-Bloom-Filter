"""Focused actual-caller checks; never use tiny timings to select configurations."""
import csv
import io
import json
import re
import sys
from source_guard import ROOT,STAGE,PARENT,OLD,need
sys.path.insert(0,str(OLD))
from validate_rows import validate,GEOMETRY
MASK=(1<<64)-1
SEMANTIC=('language','filter','keys','queries','requested_bpk','filter_bytes','actual_bpk','hash_bits','hit_percent','present_queries','seed','absent_queries','false_positives','fpr','result_checksum','input_mode','insert_batch','filter_build_scratch_bytes','calibration_absent_queries','calibration_false_positives',*GEOMETRY)
def csvrows(text):
    rows=list(csv.DictReader(io.StringIO(text)));need(rows and all(None not in row and None not in row.values()for row in rows),'Invalid dense CSV');return rows
class RNG:
    def __init__(self,seed):self.state=seed
    def next(self):
        self.state=(self.state+0x9e3779b97f4a7c15)&MASK;z=self.state
        z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK;z=((z^(z>>27))*0x94d049bb133111eb)&MASK
        return z^(z>>31)
def ordered(names):
    r=RNG(731);r.next()
    for _ in range(1023):r.next()
    for i in range(4096):
        if i%100<50:r.next()
    for _ in range(4095):r.next()
    out=list(names)
    for i in range(len(out),1,-1):j=r.next()%i;out[i-1],out[j]=out[j],out[i-1]
    return out
def schema():
    text=(STAGE/'compare_benchmark.cpp').read_text();start=text.index('std::cout << std::setprecision(17) << "language,filter,keys')
    end=text.index('exact_budget::GeometryHeader()',start)
    prefix=''.join(re.findall(r'"([^"\n]*)"',text[start:end]))
    geom=re.search(r'GeometryHeader\(\)\s*\{\s*return "([^"]+)";', (STAGE/'geometry.hpp').read_text()).group(1)
    return(prefix+geom).split(',')
def validate_case(rows,plan,cap,names,batch=31):
    need([r['filter']for r in rows]==ordered(names),'Wrong registry-derived job order')
    need(list(rows[0])==schema(),'Changed CSV field schema')
    expected={r['filter']:dict(r,calibration_identity=r['filter'])for r in plan}
    need(set(expected)==set(json.loads((STAGE/'registry.json').read_text())),'Wrong26 geometry planner')
    validate(rows,{name:expected[name]for name in names},power=10,budget=cap,query_power=12,batch=batch,repeats=2,seed=731,calibration_power=12)
    return{row['filter']:row for row in rows}
def same(current,reference):
    need({key:current[key]for key in SEMANTIC}=={key:reference[key]for key in SEMANTIC},'Retained control semantic drift '+current['filter'])
def oracle(row,record):
    for field,value in record.items():need(row[field]==value,'Independent K12 oracle mismatch '+field)
def command(binary,cap=16,selection='',batch=31,repeats=2,mode='query-only',builds=0,cal=12):
    return[str(binary),'10',str(cap),'50','12',str(batch),str(repeats),'731',selection,'1024',str(cal),mode,str(builds)]
