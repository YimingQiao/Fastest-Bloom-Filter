"""Synthetic protocol/corruption guards; no filter, compiler or measured input."""
import copy
import hashlib
import json
import unittest
from unittest.mock import patch
import screen_contract as c
import pins


def digest(*parts):
    return int.from_bytes(hashlib.sha256(repr(parts).encode()).digest()[:8], 'little')


def fixtures():
    result = []
    for case in c.ledger():
        cc = c.caller_case(case)
        points, base = c.guard.selected(cc)
        rows = []
        for p in points:
            g = p['geometry'];n = int(g['keys']);seed = case['seed'];hit = case['hit']
            q = 1 << 22;present = q//100*hit + min(q%100,hit)
            row = dict(point_id=p['id'],filter=g['filter'],owner=p['owner'],keys=n,
                requested_bpk=int(g['requested_bpk']),actual_bytes=int(g['filter_bytes']),
                budget_bytes=int(g['budget_bytes']),logical_bytes=int(g['logical_bytes']),
                unit_bytes=int(g['unit_bytes']),unit_count=int(g['unit_count']),
                effective_probes=int(g['effective_probes']),constructor_argument=int(g['constructor_argument']),
                native_constructor_bpk=int(g.get('native_constructor_bpk',0)),geometry_kind=g['geometry_kind'],probe_policy=g['probe_policy'],
                queries=q,hit=hit,batch=case['batch'],repeats=8,seed=seed,reverse_jobs=case['reverse_jobs'],
                measure=True,key_base=base,present=present,absent=q-present,false_positives=0,
                inserted_digest=digest(n,seed,'insert'),inserted_hash_digest=digest(n,seed,'hashinsert'),
                query_digest=digest(n,seed,hit,'query'),query_hash_digest=digest(n,seed,hit,'hashquery'),
                result_digest=digest(p['mapping_id'],seed,hit,'result'),
                bitmap_digest=digest(p['mapping_id'],seed,'bitmap') if p['owner'] in ('candidate','old_k12','native_range') else None,
                calibration_negatives=(1<<26) if case['calibration_power'] else 0,
                calibration_fp=123 if case['calibration_power'] else 0,
                calibration_digest=digest(p['mapping_id'],seed,'calibration') if case['calibration_power'] else None,
                query_scratch_bytes=case['batch']*8,
                phase_order=[m for r in range(8) for m in (c.guard.FOUR if case['batch']==1 else c.guard.TWO)[r%4]],
                samples={mode:[1.0+i/10 for i in range(8)] if j<2 or case['batch']==1 else [] for j,mode in enumerate(c.guard.MODES)})
            rows.append(row)
        result.append(dict(case=case,rows=rows))
    return result


class ScreenGuards(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.good = fixtures()

    def test_complete_fixed_counts(self):
        counts,q = c.validate_records(self.good)
        self.assertEqual(counts,dict(processes=48,rows=616,query_vectors=2032,query_samples=16256,
            calibration_rows=128,reuse_rows=488,api_quality_records=128,known_alias_records=108))
        self.assertEqual(sum(len(r['reuse_case_indices']) for r in q['api_records']),488)
        self.assertFalse(q['pooling'])

    def test_full_ledger_and_raw_row_order(self):
        for mutation in ('missing','reverse','duplicate'):
            bad = copy.deepcopy(self.good)
            if mutation=='missing':bad.pop()
            elif mutation=='reverse':bad[0]['rows'].reverse()
            else:bad[0]['rows'].append(bad[0]['rows'][0])
            with self.assertRaises(ValueError):c.validate_records(bad)

    def test_hit_query_difference_is_allowed_construction_difference_is_not(self):
        c.validate_records(self.good)
        bad = copy.deepcopy(self.good)
        record = next(v for v in bad if v['case']['hit']==0)
        for row in record['rows']:row['inserted_digest']^=1
        with self.assertRaisesRegex(ValueError,'construction identity'):c.validate_records(bad)

    def test_same_hit_cross_batch_output_must_match(self):
        bad = copy.deepcopy(self.good)
        record = next(v for v in bad if v['case']['batch']==3)
        for row in record['rows']:row['result_digest']^=1
        with self.assertRaisesRegex(ValueError,'query identity'):c.validate_records(bad)

    def test_no_calibration_in_reuse_and_no_alias_disagreement(self):
        bad = copy.deepcopy(self.good);record = next(v for v in bad if v['case']['calibration_power']==0)
        record['rows'][0]['calibration_fp']=1
        with self.assertRaises(ValueError):c.validate_records(bad)
        bad = copy.deepcopy(self.good);row=next(r for r in bad[0]['rows'] if r['owner']=='candidate');row['calibration_fp']+=1
        with self.assertRaises(ValueError):c.validate_records(bad)

    def test_phase_sample_and_duplicate_fields_reject(self):
        for mutation in ('phase','samples','field'):
            bad = copy.deepcopy(self.good);row=bad[0]['rows'][0]
            if mutation=='phase':row['phase_order'].reverse()
            elif mutation=='samples':row['samples']['generic_pure'].pop()
            else:row['unexpected']=1
            with self.assertRaises(ValueError):c.validate_records(bad)
        row=self.good[0]['rows'][0];text=json.dumps(row)
        text=text[:-1]+',"point_id":"duplicate"}'
        with self.assertRaisesRegex(ValueError,'duplicate JSON'):c.parse(text,self.good[0]['case'])

    def test_incomplete_prefix_can_be_checked_but_not_published(self):
        c.validate_records(self.good[:1],complete=False)
        with self.assertRaises(ValueError):c.validate_records(self.good[:1])
        with patch.object(pins.subprocess,'check_output') as git:
            for ref in ('HEAD','ae6ab194','A'*40):
                with self.assertRaises(ValueError):pins.blob(ref,'unused')
            git.assert_not_called()

    def test_exact_row_guard_derivation(self):
        pins.verify_guard_derivation()


if __name__ == '__main__':
    unittest.main()
