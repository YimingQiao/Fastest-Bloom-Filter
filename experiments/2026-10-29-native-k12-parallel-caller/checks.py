"""Bounded caller semantic checks; incidental smoke timings are never ranked."""
import csv,io,math,statistics
NAMES=['FastPatternBF','FourSectorBloomFilter','Split64BloomFilter','ByteSplitBloomFilter','Split64RangeBloomFilter','FourSectorRange12BloomFilter','FastFilterFixed16','FastFilterFixed16SingleV1','FastFilterFixed32','FastFilterFixed32Bulk','FastFilterFixed64','FastFilterSimdBlock','FastFilterSimdBlockSingleV1','Boost192Multi32K8','Boost192Multi64K8']
SEMANTICS=['keys','queries','filter_bytes','present_queries','absent_queries','false_positives','result_checksum','raw_insert_checksum','raw_query_checksum','inserted_hash_checksum','query_hash_checksum']
def need(ok,msg):
 if not ok:raise ValueError(msg)
def parse(text):return list(csv.DictReader(io.StringIO(text)))
def expected_schedule(seed,repeats):
 state=seed^0x6a09e667f3bcc909;mask=(1<<64)-1;labels=[0,1,2,3]
 for n in range(4,1,-1):
  state=(state+0x9e3779b97f4a7c15)&mask;z=state;z=((z^(z>>30))*0xbf58476d1ce4e5b9)&mask;z=((z^(z>>27))*0x94d049bb133111eb)&mask;z^=z>>31;labels[n-1],labels[z%n]=labels[z%n],labels[n-1]
 pattern=[[0,1,3,2],[1,2,0,3],[2,3,1,0],[3,0,2,1]]
 return ';'.join('|'.join(str(labels[x])for x in pattern[r%4])for r in range(repeats))
def schedule(text,repeats):
 rows=[[int(x)for x in row.split('|')]for row in text.split(';')];need(len(rows)==repeats,'phase count')
 for begin in range(0,repeats,4):
  block=rows[begin:begin+4];need(len(block)==4,'partial phase balance')
  for row in block:need(sorted(row)==[0,1,2,3],'missing phase')
  for col in range(4):need(sorted(row[col]for row in block)==[0,1,2,3],'position imbalance')
  need(sorted((r[i],r[i+1])for r in block for i in range(3))==[(a,b)for a in range(4)for b in range(4)if a!=b],'adjacent pair imbalance')
def samples(row,median,minimum,maximum,trials,count):
 x=[float(v)for v in row[trials].split('|')];need(len(x)==count and all(math.isfinite(v)and v>0 for v in x),'invalid timing sample shape')
 need(float(row[median])==statistics.median(x)and float(row[minimum])==min(x)and float(row[maximum])==max(x),'sample summary mismatch')
def query_rows(rows):
 need(len(rows)==15 and {r['filter']for r in rows}==set(NAMES),'incomplete15 query registry')
 for r in rows:
  for field,value in [('keys',32768),('queries',32768),('requested_bpk',24),('batch',4096),('repeats',4),('seed',101),('threads',8),('spawned_threads',7),('build_repeats',0),('calibration_absent_queries',4096),('insert_batch',32768),('harness_hash_scratch_bytes',32768),('parallel_hash_scratch_bytes',262144)]:need(int(r[field])==value,'wrong '+field)
  need(r['measurement_mode']=='query_only','wrong query-only mode');need(int(r['filter_bytes'])<=98304,'actual budget exceeded')
  need(int(r['present_queries'])==16400 and int(r['absent_queries'])==16368,'mixed query counts')
  for field in ['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:need(math.isnan(float(r[field])),'construction time invented')
  schedule(r['query_phase_order'],4)
  need(r['query_phase_order']==expected_schedule(101,4),'wrong seeded phase schedule')
  for prefix in ['','hash_']:samples(r,prefix+'lookup_ns',prefix+'lookup_min_ns',prefix+'lookup_max_ns',prefix+'lookup_trials_ns',4)
  for phase in ['parallel_lookup','parallel_hash_lookup']:
   for kind in ['end_to_end','gated']:samples(r,phase+'_'+kind+'_ns',phase+'_'+kind+'_min_ns',phase+'_'+kind+'_max_ns',phase+'_'+kind+'_trials',4)
  need(0<=int(r['calibration_false_positives'])<=4096,'invalid calibration count')
 return {r['filter']:r for r in rows}
def public_row(row,reference):
 for field in SEMANTICS:need(row[field]==reference[field],'public/shared output identity mismatch: '+field)
 need(int(row['repeats'])==2 and row['paired_phase_order']=='1|8;8|1','wrong public paired order')
 need(row['measurement_mode']=='prehashed_native_public_api' and row['new_calibration_samples']=='0','wrong native scope')
 for prefix in ['build_workers','query_workers']:
  need(row[prefix+'_t1']=='1' and row[prefix+'_t8']=='8','wrong effective worker count')
 need(row['build_scratch_bytes_t1']=='0'and int(row['build_scratch_bytes_t8'])>32768*8,'wrong partition scratch')
 need(row['public_bitmap_compared']==('0'if row['filter']=='Split64BloomFilter'else'1'),'wrong public bitmap claim')
 need(int(row['validation_bitmap_bytes'])==(0 if row['filter']=='Split64BloomFilter'else int(row['filter_bytes'])),'wrong resident bitmap copy disclosure')
 need(int(row['validation_expected_output_bytes'])==32768*4 and int(row['caller_buffer_bytes'])>=int(row['validation_bitmap_bytes'])+32768*4,'missing auxiliary buffer accounting')
 for metric in ['insert_t1','allocate_insert_t1','insert_t8','allocate_insert_t8','lookup_t1','lookup_t8']:samples(row,metric+'_ns',metric+'_min_ns',metric+'_max_ns',metric+'_trials_ns',2)
