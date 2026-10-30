#!/usr/bin/env python3
"""Archive already-completed V2 correctness; does not run timing or mutate parent72."""
import hashlib,json,re,shlex,shutil,subprocess,time
from pathlib import Path
from make_plan import generate
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert not (HERE/'freeze.json').exists(), 'Refuse to rewrite a frozen preflight'
checks={};oracles={}
for mode in ('native','avx2','asan'):
    build=ROOT/f'build/exact-budget-range-{mode}'
    original=HERE/'validation'/f'{mode}-full-test.log'
    assert original.exists()
    text=original.read_text()
    checks[mode]=int(re.search(r'All geometry/output checks passed; checksum=(\d+)',text).group(1))
    oracles[mode]=int(re.search(r'PASS independent range bitmaps[^\n]*checksum=(\d+)',text).group(1))
    assert '100% tests passed, 0 tests failed out of 4' in (HERE/'validation'/f'{mode}-ctest.log').read_text()
    assert '100% tests passed, 0 tests failed out of 1' in (HERE/'validation'/f'{mode}-strict-regression.log').read_text()
    shutil.copy2(build/'compile_commands.json',HERE/'validation'/f'{mode}-compile-commands.json')
assert len(set(checks.values()))==len(set(oracles.values()))==1
assert next(iter(oracles.values()))==12991785245891427605
for name,digest in json.loads((HERE/'v2-provenance.json').read_text())['range_source_sha256'].items():
    assert sha(HERE/'range-layouts'/name)==digest
plan=generate(ROOT/'build/exact-budget-range-native/plan',[16,25],[12,14,16,20,24,28,32])
assert len(plan['configurations'])==988 and len(plan['cases'])==14 and not plan['unsupported']
(HERE/'planned-grid.json').write_text(json.dumps(plan,indent=2)+'\n')
origins={}
for row in plan['configurations']:
    assert row['filter'] not in origins or origins[row['filter']]==row['implementation_origin']
    origins[row['filter']]=row['implementation_origin']
assert list(origins.values()).count('production_native')==4
assert list(origins.values()).count('external')==68
assert list(origins.values()).count('project_experiment')==2
(HERE/'registry.json').write_text(json.dumps(dict(count=74,filters=plan['registry'],implementation_origin=origins),indent=2)+'\n')
compiler=subprocess.check_output(['clang++','--version'],text=True)
validation=dict(scope='Full74 correctness preflight only; no throughput or calibrated performance claim',
    cpu=2,compiler=compiler,modes=['native','AVX2-no-AVX512','native-ASan-UBSan'],
    all_four_tests_passed_each_mode=True,strict_present_count_and_python_optimization_regression_passed=True,
    all_output_checksums=checks,all_full_bitmap_oracle_checksums=oracles,
    geometry_cases_per_mode=74*2*8,retained72_parent_cases=504,all_original72_parity=True,
    query_only_one_complete_build=True,every_phase_full_output_guard_and_trial_checks=True,
    project_experiments_have_equivalent_FastFilter_calibration_ids=True,
    exact_commit_blob_and_inherited_lease_guards=True,
    source_review='Parent72 adapter geometry reviewed independently by baseline_survey and optimize_probe; range masks/dispatch are byte-identical to root frozen0a25fe8 preflight')
(HERE/'validation.json').write_text(json.dumps(validation,indent=2)+'\n')
inputs=set()
for p in HERE.rglob('*'):
    if p.is_file() and 'validation' not in p.relative_to(HERE).parts and '__pycache__' not in p.parts and p not in (HERE/'freeze.json',HERE/'manifest.json'):
        inputs.add(p)
for dep in (ROOT/'build/exact-budget-range-native/CMakeFiles').rglob('*.o.d'):
    text=dep.read_text().replace('\\\n',' ')
    for name in shlex.split(text.split(':',1)[1]):
        p=Path(name)
        if p.is_file() and p.is_relative_to(ROOT):inputs.add(p)
for name in ('benchmarks/cpp-external/dependencies.cmake','benchmarks/cpp-external/upstreams.json',
             'benchmarks/boost-external/BoostHeaders.cmake','benchmarks/boost-external/upstream.json',
             'benchmarks/rocksdb-external/dependencies.cmake','benchmarks/rocksdb-external/vendor.py','benchmarks/rocksdb-external/manifest.json'):
    inputs.add(ROOT/name)
freeze=dict(schema=2,utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),compiler=compiler,
    purpose='V2 exact-budget74 correctness preflight; no timing',
    source_sha256={str(p.relative_to(ROOT)):sha(p) for p in sorted(inputs)},
    binary_sha256={f'build/exact-budget-range-{m}/{n}':sha(ROOT/f'build/exact-budget-range-{m}/{n}')
                  for m in ('native','avx2','asan') for n in ('benchmark','plan','check','fixtures','range_oracle')})
(HERE/'freeze.json').write_text(json.dumps(freeze,indent=2)+'\n')
manifest={str(p.relative_to(HERE)):sha(p) for p in sorted(HERE.rglob('*'))
          if p.is_file() and '__pycache__' not in p.parts and p != HERE/'manifest.json'}
(HERE/'manifest.json').write_text(json.dumps(dict(files_sha256=manifest),indent=2)+'\n')
print('Frozen',len(freeze['source_sha256']),'source/dependency inputs,15 binaries,',len(manifest),'archive files;988 unique configurations')
