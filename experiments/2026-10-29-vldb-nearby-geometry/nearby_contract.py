"""Offline guards; no compiler, planner or Bloom execution on import."""
import itertools

CONFIGS=['sector32-u1','sector32-u2','sector32-u4','sector64-u1','sector64-u2','sector64-u4','register64-u0']
BACKENDS=['native','avx2','native-asan']
def need(ok,message):
    if not ok:raise ValueError(message)
def cases():
    return [(c,n,b,'nearby_odd')for c,n,b in itertools.product(CONFIGS,[16,25],[12,24])]+[(c,16,24,'original')for c in ['sector32-u1','sector64-u1','register64-u0']]
def validate(row,case):
    name,power,bpk,policy=case;cap=(1<<power)*bpk//8
    word=4 if name.startswith('sector32')else 8;w=1 if name=='register64-u0'else 8;block=word*w
    maximum=cap//64*64//block;lower=max(3,(99*maximum+99)//100)
    need(row['policy']==policy and row['budget_bytes']==cap,'Wrong policy/cap')
    if row['status']=='unsupported':
        need(policy=='nearby_odd'and set(row)=={'status','policy','budget_bytes','block_bytes','maximum_blocks','lower_blocks'},'Malformed unsupported result')
        need((row['block_bytes'],row['maximum_blocks'],row['lower_blocks'])==(block,maximum,lower),'Wrong unsupported window')
        return row
    need(row['status']=='supported'and set(row)=={'status','policy','budget_bytes','constructor_bits','logical_bytes','backing_bytes','block_count','address','digest','bitmap_digest','upstream_metadata'},'Malformed supported geometry')
    count=row['block_count'];need(type(count)is int and 0<count<=maximum,'Invalid block count')
    if policy=='nearby_odd':need(count%2==1 and count>=lower,'Outside fixed odd window')
    logical=count*block;need(row['logical_bytes']==logical and row['constructor_bits']==logical*8,'Logical geometry mismatch')
    need(row['backing_bytes']==(logical+63)//64*64<=cap,'Uncharged backing padding')
    need(row['address']=='magic','Pilot preflight requires MAGIC addressing')
    actual=row['upstream_metadata'];u=int(name.rsplit('u',1)[1])
    need(actual['size']==logical and actual['word_size']==word and actual['w']==w and actual['s']==w and actual['k']==8 and actual['u']==u and actual['addr']=='magic','Actual public metadata mismatch')
    for key in ('digest','bitmap_digest'):need(type(row[key])is int and 0<=row[key]<1<<64,'Missing complete fixture digest')
    return row

def reference_row(row):
    return {k:v for k,v in row.items()if k not in ('status','policy')}
