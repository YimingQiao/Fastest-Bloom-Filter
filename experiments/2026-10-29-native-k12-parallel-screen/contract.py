"""Fixed195 ledger and raw semantic/trial contract; no benchmark invocation."""
import csv,io,json,math,statistics,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PLAN=ROOT/'experiments/2026-10-29-native-k12-parallel-plan'
CALLER=ROOT/'experiments/2026-10-29-native-k12-parallel-caller'
sys.path.insert(0,str(CALLER))
from checks import expected_schedule
CPUS=[2,4,6,8,10,12,14,16];CPU_TEXT=','.join(map(str,CPUS))
PREFIX=['/usr/bin/taskset','-c',CPU_TEXT,'/usr/bin/numactl','--physcpubind='+CPU_TEXT,'--membind=0']
Q=1<<22;CAL=1<<26;MASK=(1<<64)-1
GEOMETRY=['budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes','probe_policy','constructor_argument','page_level','native_constructor_bpk']
IDENTITY=['keys','queries','filter_bytes','present_queries','absent_queries','false_positives','result_checksum','raw_insert_checksum','raw_query_checksum','inserted_hash_checksum','query_hash_checksum']
INPUTS=['raw_insert_checksum','raw_query_checksum','inserted_hash_checksum','query_hash_checksum']
def need(ok,msg):
 if not ok:raise ValueError(msg)
def shuffle(values,seed):
 out=list(values);state=seed
 for n in range(len(out),1,-1):
  state=(state+0x9e3779b97f4a7c15)&MASK;z=state;z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK;z=((z^(z>>27))*0x94d049bb133111eb)&MASK;z^=z>>31
  out[n-1],out[z%n]=out[z%n],out[n-1]
 return out
def plan():
 selection=json.loads((PLAN/'selection.json').read_text());points=selection['query_configurations'];seeds=selection['construction_seeds']
 need(len(points)==49 and len(seeds)==3,'fixed plan changed')
 public=[p for p in points if p['geometry']['configuration_id']in selection['public_api_configuration_ids']]
 need(len(public)==16,'public API panel changed')
 result=[]
 for track,selected,salt in [('shared_query',points,0x6a09e667f3bcc909),('native_public',public,0xbb67ae8584caa73b)]:
  for seed in seeds:
   for point in shuffle(selected,seed^salt):result.append({'index':len(result),'track':track,'seed':seed,'point':point})
 need(len(result)==195,'fixed195 ledger changed');return result
def command(binaries,case):
 p=case['point'];n=p['keys'];power=n.bit_length()-1;need(1<<power==n,'non-power2 workload')
 if case['track']=='shared_query':args=[power,p['geometry']['requested_bpk'],50,22,4096,8,case['seed'],p['filter'],n,26,8,CPU_TEXT];binary=binaries['native-query']['path']
 else:args=[power,p['geometry']['requested_bpk'],22,6,case['seed'],p['filter'],CPU_TEXT];binary=binaries['native-public_api']['path']
 return PREFIX+[binary,*map(str,args)]
def parse(text):
 rows=list(csv.DictReader(io.StringIO(text)));need(len(rows)==1,'successful command must return exactly one row')
 need(None not in rows[0]and all(v is not None for v in rows[0].values()),'malformed CSV row');return rows[0]
def positive_samples(row,median,minimum,maximum,trials,count):
 values=[float(v)for v in row[trials].split('|')];need(len(values)==count and all(math.isfinite(v)and v>0 for v in values),'invalid query/build trial vector')
 need(float(row[median])==statistics.median(values)and float(row[minimum])==min(values)and float(row[maximum])==max(values),'trial summary differs');return values
def validate(row,case):
 p=case['point'];n=p['keys'];g=p['geometry'];present=Q//100*50+min(Q%100,50)
 for key,value in [('keys',n),('queries',Q),('seed',case['seed']),('requested_bpk',int(g['requested_bpk'])),('filter_bytes',int(g['filter_bytes'])),('present_queries',present),('absent_queries',Q-present)]:need(int(row[key])==value,'wrong '+key)
 need(row['language']=='cpp'and row['filter']==p['filter'],'wrong actual API')
 need(float(row['actual_bpk'])==int(g['filter_bytes'])*8/n,'wrong actual allocation ratio')
 need(int(row['filter_bytes'])<=n*int(g['requested_bpk'])//8,'actual byte ceiling exceeded')
 need(0<=int(row['false_positives'])<=Q-present,'invalid mixed FP count')
 for key in INPUTS+['result_checksum']:need(0<=int(row[key])<=MASK,'invalid unsigned checksum')
 if case['track']=='shared_query':
  for key in GEOMETRY:need(row[key]==g[key],'changed selected geometry: '+key)
  need(row['implementation_origin']==p['owner'],'changed ownership label')
  need(row['size_contract']=='exact_byte_ceiling_v1'and row['measurement_mode']=='query_only'and row['input_mode']=='prehashed','changed query contract')
  for key,value in [('hash_bits',64),('hit_percent',50),('batch',4096),('repeats',8),('insert_batch',n),('threads',8),('spawned_threads',7),('build_repeats',0),('harness_hash_scratch_bytes',32768),('parallel_hash_scratch_bytes',262144),('calibration_absent_queries',CAL)]:need(int(row[key])==value,'changed query field '+key)
  need(row['executor']=='caller_worker0'and row['query_phase_order']==expected_schedule(case['seed'],8),'changed executor/order')
  scratch=(1+int(g['filter_bytes'])//32//16384)*(16384*8+4)if p['filter']=='FastFilterFixed32Bulk'else 0
  need(int(row['filter_build_scratch_bytes'])==scratch,'changed setup scratch accounting')
  need(float(row['fpr'])==int(row['false_positives'])/(Q-present),'wrong mixed FPR')
  need(0<=int(row['calibration_false_positives'])<=CAL,'invalid independent FP count')
  for key in ['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:need(math.isnan(float(row[key])),'invented query-only construction sample')
  for prefix in ['', 'hash_']:positive_samples(row,prefix+'lookup_ns',prefix+'lookup_min_ns',prefix+'lookup_max_ns',prefix+'lookup_trials_ns',8)
  for phase in ['parallel_lookup','parallel_hash_lookup']:
   vectors={}
   for boundary in ['end_to_end','gated']:vectors[boundary]=positive_samples(row,phase+'_'+boundary+'_ns',phase+'_'+boundary+'_min_ns',phase+'_'+boundary+'_max_ns',phase+'_'+boundary+'_trials',8)
   for boundary in ['launch','join']:
    values=[float(v)for v in row[phase+'_'+boundary+'_trials'].split('|')];need(len(values)==8 and all(math.isfinite(v)and v>=0 for v in values),'invalid overhead samples');need(float(row[phase+'_'+boundary+'_ns'])==statistics.median(values),'wrong overhead median');vectors[boundary]=values
   for values in zip(vectors['end_to_end'],vectors['launch'],vectors['gated'],vectors['join']):need(math.isclose(values[0],sum(values[1:]),rel_tol=1e-12,abs_tol=1e-10),'executor timing decomposition differs')
 else:
  need(row['measurement_mode']=='prehashed_native_public_api'and row['new_calibration_samples']=='0','changed public contract')
  need(row['repeats']=='6'and row['paired_phase_order']==';'.join(['1|8','8|1']*3),'changed public order')
  argument=int(g['native_constructor_bpk'])if p['filter']=='Split64BloomFilter'else int(g['requested_bpk'])
  need(int(row['native_constructor_argument'])==argument,'changed actual native constructor')
  for operation in ['build_workers','query_workers']:need(row[operation+'_t1']=='1'and row[operation+'_t8']=='8','effective worker mismatch')
  need(row['build_scratch_bytes_t1']=='0'and int(row['build_scratch_bytes_t8'])==n*8+584,'native scratch differs')
  copied=p['filter']!='Split64BloomFilter';need(row['public_bitmap_compared']==str(int(copied)),'wrong bitmap proof claim')
  need(int(row['validation_bitmap_bytes'])==(int(g['filter_bytes'])if copied else 0),'wrong resident bitmap copy')
  need(int(row['validation_expected_output_bytes'])==Q*4 and int(row['caller_buffer_bytes'])==16*n+24*Q+128+int(row['validation_bitmap_bytes']),'wrong caller buffer disclosure')
  vectors={metric:positive_samples(row,metric+'_ns',metric+'_min_ns',metric+'_max_ns',metric+'_trials_ns',6)for metric in ['insert_t1','allocate_insert_t1','insert_t8','allocate_insert_t8','lookup_t1','lookup_t8']}
  for suffix in ['t1','t8']:need(all(a>=b for a,b in zip(vectors['allocate_insert_'+suffix],vectors['insert_'+suffix])),'nested allocation interval smaller than insertion')
 return row
def validate_complete(records,complete=True):
 ledger=plan();need(len(records)<=len(ledger),'excess rows')
 if complete:need(len(records)==195,'incomplete195 result')
 inputs={};quality={};query={}
 for expected,record in zip(ledger,records):
  need(record['case']==expected,'fixed case order changed');r=validate(record['row'],expected);p=expected['point'];key=(p['keys'],expected['seed'])
  fingerprints=tuple(r[k]for k in INPUTS);need(inputs.get(key,fingerprints)==fingerprints,'input construction differs across API');inputs[key]=fingerprints
  identity=(p['keys'],p['filter'],int(p['geometry']['filter_bytes']),expected['seed'])
  if expected['track']=='shared_query':
   need(identity not in query,'duplicate shared geometry');query[identity]=r
   mapping=(p['keys'],p['geometry']['calibration_identity'],expected['seed']);observed=tuple(r[k]for k in IDENTITY+['calibration_absent_queries','calibration_false_positives'])
   need(quality.get(mapping,observed)==observed,'known mapping alias disagrees');quality[mapping]=observed
  else:
   need(identity in query,'public quality has no earlier exact shared row')
   need(all(r[k]==query[identity][k]for k in IDENTITY),'public construction/output differs from shared API')
 counts={'rows':len(records),'shared_query_rows':len(query),'native_public_rows':sum(x['case']['track']=='native_public'for x in records),'mapping_quality_records':len(quality),'new_public_calibration_samples':0}
 if complete:need(counts=={'rows':195,'shared_query_rows':147,'native_public_rows':48,'mapping_quality_records':126,'new_public_calibration_samples':0},'wrong complete API/mapping coverage')
 return counts
def csv_text(records,track):
 rows=[r['row']for r in records if r['case']['track']==track];out=io.StringIO(newline='');writer=csv.DictWriter(out,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows);return out.getvalue()
