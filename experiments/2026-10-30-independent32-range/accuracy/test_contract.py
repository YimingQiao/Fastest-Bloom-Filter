import copy
import json
import unittest
import contract as c


def row(power, bpk, candidate, cal=26, fp=0):
    n = 1 << power
    base, query = c.query_input(n)
    budget = n*bpk//8
    r = dict(filter=c.CANDIDATE if candidate else c.CONTROL,
        mapping='high24-range/low40-independent8-v1' if candidate else 'high23-mask/low40-independent8-v1',
        backend='avx512vbmi-vl',key_power=power,keys=n,seed=42,actual_bpk=bpk,
        constructor_bpk=bpk if candidate else bpk//2,budget_bytes=budget,actual_bytes=budget,
        logical_bytes=budget,physical_line_bytes=64,physical_lines=budget//64,bucket_bytes=32,
        buckets=budget//32,probes=8,parallel_api=False,inserted_checked=n,key_base=base,
        queries=4096,requested_hit_percent=50,present=2050,absent=2046,mixed_fp=0,
        calibration_power=cal,calibration_negatives=1<<cal,calibration_begin=base+n+4096,
        calibration_end=base+n+4096+(1<<cal),calibration_fp=fp,wilson_upper=c.upper(fp,1<<cal),
        query_repeats=0,build_repeats=0,timing_available=False)
    r.update({k:11 for k in c.DIGESTS})
    r.update(query_digest=c.digest(query),query_hash_digest=c.digest(map(c.common_hash,query)))
    r['qualifies'] = {k:r['wilson_upper'] <= v for k,v in c.GATES.items()}
    return r


def matrix():
    return [row(p,b,kind) for p in (16,25) for kind,b in
            ([(True,b) for b in (12,16,20,24,28,32)]+[(False,b) for b in (16,32)])]


class Guards(unittest.TestCase):
    def test_rng_skip_matches_full_insert_shuffle(self):
        n,q,state = 4096,4096,42
        def next_value():
            nonlocal state
            state = (state+c.INC)&c.MASK
            return c.mix(state)
        base = next_value()%((1<<32)-n-q)
        inserted = list(range(base,base+n))
        for i in range(n,1,-1):
            j=next_value()%i
            inserted[i-1],inserted[j]=inserted[j],inserted[i-1]
        queries = [base+(next_value()%n if i%100<50 else n+i) for i in range(q)]
        for i in range(q,1,-1):
            j=next_value()%i
            queries[i-1],queries[j]=queries[j],queries[i-1]
        self.assertEqual(c.query_input(n),(base,tuple(queries)))
        self.assertEqual(sum(base<=x<base+n for x in queries),2050)
        self.assertTrue(all(x<base+n+q for x in queries))

    def test_exact_ledger_and_no_replacement(self):
        rows=matrix();self.assertTrue(c.decision(rows)['primary_12bpk_both_sizes_pass'])
        failed=matrix();failed[8]=row(25,12,True,fp=1<<26)
        result=c.decision(failed)
        self.assertEqual(result['next_stage'],'stop_before_timing')
        self.assertTrue(result['secondary']['20'])
        for bad in (rows[:-1],list(reversed(rows)),rows[:8]+rows[:8]):
            with self.assertRaises(ValueError):c.decision(bad)

    def test_capacity_identity_and_intervals(self):
        original=row(16,12,True)
        for key in ('actual_bytes','physical_lines','key_base','calibration_begin','present','seed','query_digest'):
            bad=copy.deepcopy(original);bad[key]+=1
            with self.assertRaises(ValueError):c.validate(bad,16,12,True,26)
        bad=copy.deepcopy(original);bad['mapping']='high23-mask/low40-independent8-v1'
        with self.assertRaises(ValueError):c.validate(bad,16,12,True,26)

    def test_quality_endpoint_and_gate_corruption(self):
        r=row(16,12,True);r['wilson_upper']*=2
        with self.assertRaises(ValueError):c.validate(r,16,12,True,26)
        r=row(16,12,True);r['qualifies']['1pct']=False
        with self.assertRaises(ValueError):c.validate(r,16,12,True,26)
        self.assertEqual(c.upper(1<<26,1<<26),1)

    def test_complete_case_and_duplicate_json(self):
        rows=[row(12,12,True,10),row(12,16,False,10)]
        text=lambda rs:('\n'.join(json.dumps(x) for x in rs)+'\n').encode()
        self.assertEqual(len(c.parse(text(rows),12,False)),2)
        for bad in ([],rows[:1],rows+rows,rows[::-1]):
            with self.assertRaises(ValueError):c.parse(text(bad),12,False)
        with self.assertRaises(ValueError):c.read('{"a":1,"a":2}')
        with self.assertRaises(ValueError):c.read('{"a":NaN}')


if __name__=='__main__':unittest.main()
