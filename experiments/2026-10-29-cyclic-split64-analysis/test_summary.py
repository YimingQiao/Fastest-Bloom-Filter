"""Offline corruption/eligibility/order checks; no benchmark is invoked."""
import copy
import csv
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from order_oracle import draw, expected_order, macro, validate_order
from summarize import (BINARY, CYCLIC, available, eligible, fastest, owner, prior_failure,
                       quality, rankings, sha, verify_aggregate, verify_case, wilson)


def row(name=CYCLIC, actual=16, fp=100, pure=2, raw=3, origin="project_experiment"):
    n, q, present = 65536, 1 << 22, 2097154
    size = n * actual // 8
    r = dict(filter=name, keys=str(n), queries=str(q), requested_bpk=str(actual), filter_bytes=str(size), actual_bpk=str(actual),
             hash_bits="64", hit_percent="50", present_queries=str(present), absent_queries=str(q-present), batch="4096", repeats="6",
             query_repeats="6", build_repeats="0", seed="42", insert_batch=str(n), calibration_absent_queries=str(1 << 24),
             calibration_false_positives=str(fp), harness_hash_scratch_bytes="32768", filter_build_scratch_bytes="0",
             language="cpp", measurement_mode="query_only", budget_mode="exact_backing_bytes", input_mode="prehashed",
             false_positives="100", fpr=str(100/(q-present)), result_checksum="1234", query_phase_order="P>H;H>P;P>H;H>P;P>H;H>P",
             budget_bytes=str(size), logical_bytes=str(size), geometry_kind="project_range_buckets", unit_bytes="64",
             unit_count=str(size//64), effective_probes="8", probe_policy="cyclic_low32_6bit_windows_stride4", constructor_argument=str(size),
             page_level="0", native_constructor_bpk="0", implementation_origin=origin,
             configuration_id=name+str(actual), calibration_identity=name+str(actual))
    for key in ("insert_ns", "allocate_insert_ns", "hash_insert_ns", "allocate_hash_insert_ns"):
        r[key] = "nan"
    for metric, value in (("lookup", pure), ("hash_lookup", raw)):
        for suffix in ("_ns", "_min_ns", "_max_ns"):
            r[metric + suffix] = str(value)
        r[metric + "_trials_ns"] = json.dumps([value] * 6)
    return r


class AnalysisTests(unittest.TestCase):
    def test_exact_budget_accepts_smaller24_rival_and28_candidate(self):
        rows = [row(actual=28), row("External", actual=24, pure=1, raw=9, origin="external"),
                row("External", actual=32, pure=9, raw=1, origin="external")]
        ranked, individual = rankings(rows, {"records": []})
        selected = [r for r in ranked if r["cap_bpk"] == 32 and r["fpr_ceiling"] == .0001]
        self.assertEqual([r["external"]["actual_bpk"] for r in selected], [24, 32])
        self.assertTrue(all(r["cyclic"]["actual_bpk"] == 28 for r in selected))
        self.assertTrue(any(r["external_outcome"] == "external_faster" for r in individual if r["owner"] == "cyclic"))

    def test_upper_endpoint_not_point_estimate_and_all_failed_allocations_retained(self):
        rows = [row(actual=b, fp=30000 if b == 16 else 100) for b in (16,24,28,32)]
        ranked, individual = rankings(rows, {"records": []})
        self.assertEqual(len(individual), 4*2*2*3)
        self.assertEqual({r["actual_bpk"] for r in individual}, {16,24,28,32})
        bad = [r for r in individual if r["actual_bpk"] == 16 and r["fpr_ceiling"] == .001]
        self.assertTrue(all(not r["eligible"] and r["external_outcome"] == "no_eligible_pair" for r in bad))
        r = row()
        self.assertFalse(eligible(r,32,100/(1<<24)))
        r["filter_bytes"] = str(65536*4+1)
        self.assertFalse(eligible(r,32,.01))

    def test_alias_dedup_does_not_pool_samples(self):
        a,b = row("ExternalA",origin="external"), row("ExternalB",origin="external")
        b["calibration_identity"] = a["calibration_identity"]
        values = quality([a,b])
        self.assertEqual(len(values),1)
        self.assertEqual(values[0]["count"],1<<24)
        b["calibration_false_positives"] = "101"
        with self.assertRaises(ValueError): quality([a,b])
        b["seed"] = "43"
        self.assertEqual(len(quality([a,b])),2)

    def test_history_failure_visible_even_if_current_training_qualifies(self):
        r = row("FourSectorBloomFilter",fp=10000,origin="production_native")
        history = {"records":[dict(filter=r["filter"],keys=65536,filter_bytes=131072,wilson_upper=.001001112583453033)]}
        self.assertTrue(eligible(r,16,.001))
        ranked,_ = rankings([r],history)
        view = next(x for x in ranked if x["cap_bpk"]==16 and x["metric"]=="lookup_ns" and x["fpr_ceiling"]==.001)
        self.assertTrue(view["production"]["prior_heldout_quality_failure"])
        self.assertFalse(prior_failure(r,history,.01))

    def test_raw_only_pure_unavailable_and_corruption_rejected(self):
        r = row("PageBloom8Compact",origin="external");r["input_mode"]="raw_bytes";r["lookup_ns"]="nan"
        self.assertIsNone(fastest([r],"lookup_ns"))
        self.assertEqual(fastest([r],"hash_lookup_ns"),r)
        r["lookup_ns"]="1"
        with self.assertRaises(ValueError): available(r,"lookup_ns")

    def test_ownership_and_bounds(self):
        r=row();r["implementation_origin"]="external"
        with self.assertRaises(ValueError): owner(r)
        self.assertEqual(wilson(0,100)[0],0);self.assertEqual(wilson(100,100)[1],1)
        for fp,n in ((-1,100),(101,100),(0,0)):
            with self.assertRaises(ValueError): wilson(fp,n)

    def test_aggregate_missing_duplicate_and_reorder_rejected(self):
        a,b = row(actual=16),row(actual=28);expected=[a,b];config={r["configuration_id"]:r for r in expected}
        verify_aggregate(expected,expected,config)
        for bad in ([a],[a,a],[b,a]):
            with self.assertRaises(ValueError):verify_aggregate(bad,expected,config)

    def test_case_command_hash_trial_and_order_corruption(self):
        a,b = row(),row("Split64RangeExperiment")
        b["probe_policy"]="fixed"
        records={r["configuration_id"]:r for r in (a,b)}
        case=dict(key_power=16,budget_bpk=16,filters=[a["filter"],b["filter"]],configuration_ids=list(records))
        registry=list(case["filters"])
        ordered=expected_order(registry,registry,65536,1<<22,42,50)
        source={r["filter"]:r for r in (a,b)}
        raw=[{k:v for k,v in source[name].items() if k not in ("configuration_id","calibration_identity")} for name in ordered]
        with tempfile.TemporaryDirectory() as d:
            directory=Path(d);stdout=directory/'case-00-n16-b16.stdout';stderr=directory/'case-00-n16-b16.stderr';stderr.write_text('')
            def save(rows):
                with stdout.open('w',newline='') as stream:
                    writer=csv.DictWriter(stream,fieldnames=list(rows[0]));writer.writeheader();writer.writerows(rows)
            save(raw)
            entry=dict(case=case,command=[str(BINARY),'16','16','50','22','4096','6','42',','.join(case['filters']),'65536','24','query-only','0'],rows=2,stdout_sha256=sha(stdout),stderr_sha256=sha(stderr))
            verify_case(entry,case,0,directory,records,registry)
            changed=copy.deepcopy(entry);changed['command'][4]='21'
            with self.assertRaises(ValueError):verify_case(changed,case,0,directory,records,registry)
            save(list(reversed(raw)));entry['stdout_sha256']=sha(stdout)
            with self.assertRaisesRegex(ValueError,'order'):verify_case(entry,case,0,directory,records,registry)
            bad=copy.deepcopy(raw);bad[0]['lookup_trials_ns']='[1,2,3,4,5,6]';save(bad);entry['stdout_sha256']=sha(stdout)
            with self.assertRaises(AssertionError):verify_case(entry,case,0,directory,records,registry)
            save(raw);entry['stdout_sha256']=sha(stdout);stderr.write_text('changed')
            with self.assertRaises(ValueError):verify_case(entry,case,0,directory,records,registry)

    def test_optimized_python_fails_before_inputs(self):
        result=subprocess.run([sys.executable,'-O',str(Path(__file__).with_name('summarize.py'))],capture_output=True,text=True)
        self.assertNotEqual(result.returncode,0);self.assertIn('without Python -O',result.stderr)


class OrderTests(unittest.TestCase):
    def test_skip_ahead_matches_literal_state_consumption(self):
        registry=list('abcdef');selected=list('cadf')
        for seed in (0,42,(1<<64)-1):
            for n,q in ((1,1),(17,111),(64,256)):
                for hit in (0,50,100):
                    state=seed
                    def next_draw():
                        nonlocal state
                        state,value=draw(state);return value
                    def shuffle(values):
                        for size in range(len(values),1,-1):
                            pos=next_draw()%size;values[size-1],values[pos]=values[pos],values[size-1]
                    base=next_draw()%((1<<32)-n-q);inserted=list(range(n));shuffle(inserted)
                    query=[base+(next_draw()%n if i%100<hit else n+i) for i in range(q)];shuffle(query)
                    names=[r for r in registry if r in selected];shuffle(names)
                    self.assertEqual(names,expected_order(registry,selected,n,q,seed,hit))

    def test_registration_macro_bounds(self):
        text='#define EXAMPLE(ADD) \\\n ADD(A, uint64_t); \\\n ADD(B, uint64_t)\nnext_line\n'
        self.assertIn('ADD(B, uint64_t)',macro(text,'EXAMPLE'));self.assertNotIn('next_line',macro(text,'EXAMPLE'))
        with self.assertRaises(ValueError):macro(text,'Missing')
        with self.assertRaises(ValueError):expected_order(['A'],['A','A'],1,1,42,50)


if __name__=='__main__':unittest.main()
