"""Fixed Poppy486 raw/quality contract; no compiler or filter execution."""
import csv,io,json,sys
from pathlib import Path
from plan import HERE,CALLER,SOURCE,derive,selection,need
sys.path.insert(0,str(CALLER/'preflight'))
from guard import validate_rows,expected_order,raw_intervals,csv_fields
PROTOCOL=json.loads((HERE/'protocol.json').read_text())
PREFIX=['/usr/bin/numactl','--physcpubind=2','--membind=0']
POINTS={p['configuration_id']:p for p in selection()['configurations']}
OBSERVED_EXCLUDE={'batch','calibration_absent_queries','calibration_false_positives'}

def expected_stderr():
    observed=(CALLER/'validation-v1/normal-case-0.stderr').read_bytes()
    need(observed==b'sbbf-rs 0.2.8 backend: Avx2Filter\n','Changed frozen actual backend diagnostic')
    return observed

def plan():
    ledger=json.loads((HERE/'ledger.json').read_text());need(ledger==derive(),'Fixed process ledger changed');return ledger
def row_protocol(case):return dict(query_power=22,hit_percent=50,repeats=8,calibration_power=case['calibration_power'])
def command(binary,case):
    return PREFIX+[str(binary),*map(str,[case['key_power'],case['budget_bpk'],50,22,case['batch'],8,42]),
        ','.join(case['filters']),str(case['keys']),str(case['calibration_power']),case['order']]
def parse(text,case):
    source=SOURCE.read_text();reader=csv.DictReader(io.StringIO(text))
    need(reader.fieldnames==csv_fields(source),'Wrong actual caller columns');rows=list(reader)
    validate_rows(rows,case,row_protocol(case),source)
    points={POINTS[ident]['filter']:POINTS[ident]for ident in case['configuration_ids']}
    for row in rows:
        point=points[row['filter']];need(int(row['filter_bytes'])==point['actual_bytes'],'Changed selected actual bytes')
        need(int(row['filter_bytes'])*8<=case['keys']*case['budget_bpk'],'Backing+cache cap exceeded')
        if point['owner']=='poppy_external':
            prior=point['prior_observation']
            for field,expected in [('filter_bytes',prior['actual_bytes']),('false_positives',prior['mixed_false_positives']),('result_checksum',prior['result_checksum'])]:
                need(int(row[field])==expected,'Poppy public accuracy reproduction differs: '+field)
            if case['calibration_power']:need(int(row['calibration_false_positives'])==prior['false_positives'],'Poppy independent calibration reproduction differs')
    return rows
def semantic(row):
    return {k:v for k,v in row.items()if k not in OBSERVED_EXCLUDE and not(k.endswith('_ns')or k.endswith('_trials'))}
def validate_records(records,complete=True):
    ledger=plan();expected=ledger['cases'];need(len(records)<=36 and(not complete or len(records)==36),'Incomplete/excess process records')
    observations={};quality={};references=[];row_count=0
    for record,case in zip(records,expected):
        need(record['case']==case,'Wrong full process order')
        rows=parse(csv_text(record['rows']),case);need(rows==record['rows'],'Unexpected row representation');row_count+=len(rows)
        ids={POINTS[ident]['filter']:ident for ident in case['configuration_ids']}
        for row in rows:
            ident=ids[row['filter']];observed=semantic(row)
            need(observations.get(ident,observed)==observed,'Cross-batch/round constructor or output fingerprint differs');observations[ident]=observed
            if case['calibration_power']:
                need(ident not in quality and case['index']==ledger['calibration_case_by_geometry'][ident],'Repeated/misplaced calibration')
                quality[ident]=dict(configuration_id=ident,case_index=case['index'],keys=case['keys'],filter=row['filter'],actual_bytes=int(row['filter_bytes']),
                    seed=42,absent=int(row['calibration_absent_queries']),false_positives=int(row['calibration_false_positives']),
                    semantics=observed,intervals=raw_intervals(case,row_protocol(case)))
                need(quality[ident]['absent']==1<<26,'Changed quality denominator')
            need(ident in quality,'Quality reuse before observed calibration')
            references.append(dict(case_index=case['index'],round=case['round'],configuration_id=ident,calibration_case_index=quality[ident]['case_index'],
                new_calibration=bool(case['calibration_power']),absent_reused=quality[ident]['absent']))
    counts=dict(processes=len(records),rows=row_count,unpooled_api_geometry_quality_records=len(quality),calibrated_rows=sum(r['new_calibration']for r in references),
        reuse_rows=sum(not r['new_calibration']for r in references),query_vectors=row_count*4,query_values=row_count*4*8,build_medians=row_count*4)
    if complete:need(counts==dict(processes=36,rows=486,unpooled_api_geometry_quality_records=81,calibrated_rows=81,reuse_rows=405,query_vectors=1944,query_values=15552,build_medians=1944),'Wrong complete coverage')
    return counts,list(quality.values()),references
def csv_text(rows):
    output=io.StringIO(newline='');writer=csv.DictWriter(output,fieldnames=list(rows[0])if rows else csv_fields(SOURCE.read_text()),lineterminator='\n');writer.writeheader();writer.writerows(rows);return output.getvalue()
def aggregate_csv(records):
    rows=[]
    for record in records:
        case=record['case'];ids={POINTS[i]['filter']:i for i in case['configuration_ids']}
        rows.extend(dict(case_index=case['index'],round=case['round'],configuration_id=ids[row['filter']],**row)for row in record['rows'])
    return csv_text(rows)
