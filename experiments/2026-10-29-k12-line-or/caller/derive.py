#!/usr/bin/env python3
"""Derive a two-type caller without changing any timer/helper/input logic."""
import argparse
import difflib
import hashlib
import json
import subprocess
from pathlib import Path

if not __debug__:
    raise SystemExit('Python -O is not supported')
HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
COMMIT = '2263cf29ebc87d589b49ca015133312993b7db73'
SOURCE = 'experiments/2026-10-29-four-sector-range12-screen/compare_benchmark.cpp'

def content():
    old = subprocess.check_output(['git', 'show', COMMIT + ':' + SOURCE], cwd=ROOT).decode()
    start = old.index('#include "fast_pattern_BF.h"')
    stop = old.index('using namespace bloom_filters;')
    new = old[:start] + '#include "../control.hpp"\n#include "../candidate.hpp"\n#include "geometry.hpp"\n' + old[stop:]
    start = new.index('#ifdef BF_EXACT_TESTS', new.index('#define ADD'))
    stop = new.index('#undef ADD', start)
    new = new[:start] + '\t\tADD(K12ScalarOrControl, uint64_t);\n\t\tADD(K12LineOrCandidate, uint64_t);\n' + new[stop:]
    anchor = "    exact_budget::PrintGeometry(std::cout, geometry);"
    extra = """    trials(insert_times, false); std::cout << ',';
    trials(build_times, false); std::cout << ',';
    trials(hash_insert_times, false); std::cout << ',';
    trials(hash_build_times, false); std::cout << ',';
"""
    assert new.count(anchor) == 1
    new = new.replace(anchor, extra + anchor)
    # A separate exact literal keeps the output-only delta easy to audit.
    old_header = 'lookup_trials_ns,hash_lookup_trials_ns,query_phase_order,"'
    new_header = 'lookup_trials_ns,hash_lookup_trials_ns,query_phase_order,insert_trials_ns,allocate_insert_trials_ns,hash_insert_trials_ns,allocate_hash_insert_trials_ns,"'
    assert new.count(old_header) == 1
    new = new.replace(old_header, new_header)
    before_begin = old.index('using namespace bloom_filters;')
    before_end = old.index('\tstd::cout << "cpp,"')
    after_begin = new.index('using namespace bloom_filters;')
    after_end = new.index('\tstd::cout << "cpp,"')
    assert old[before_begin:before_end] == new[after_begin:after_end], 'Timed region changed'
    # The producer's argument parser, inputs, shuffle and strict selection stay exact.
    a = old[old.index('int main('):]
    b = new[new.index('int main('):]
    a_start = a.index('#ifdef BF_EXACT_TESTS', a.index('#define ADD'))
    a_stop = a.index('#undef ADD', a_start)
    a = a[:a_start] + '\t\tADD(K12ScalarOrControl, uint64_t);\n\t\tADD(K12LineOrCandidate, uint64_t);\n' + a[a_stop:]
    assert a.replace(old_header, new_header) == b, 'Unexpected main/input/CLI change'
    patch = ''.join(difflib.unified_diff(old.splitlines(True), new.splitlines(True), fromfile='frozen-parent.cpp', tofile='compare_benchmark.cpp'))
    info = dict(commit=COMMIT, source=SOURCE, source_sha256=hashlib.sha256(old.encode()).hexdigest(),
                timed_region_sha256=hashlib.sha256(old[before_begin:before_end].encode()).hexdigest(),
                changes=['local two-header/geometry includes', 'exactly two public type registrations', 'append four build trial vectors after timing'])
    return {'compare_benchmark.cpp': new.encode(), 'CALLER.patch': patch.encode()}, info

def main():
    parser = argparse.ArgumentParser(); parser.add_argument('--write', action='store_true'); args = parser.parse_args()
    files, origin = content()
    descriptor = dict(origin=origin, files={name: hashlib.sha256(data).hexdigest() for name, data in files.items()})
    if args.write:
        for name, data in files.items(): (HERE / name).write_bytes(data)
        (HERE / 'DERIVATION.json').write_text(json.dumps(descriptor, indent=2) + '\n')
    else:
        assert json.loads((HERE / 'DERIVATION.json').read_text()) == descriptor
        for name, data in files.items(): assert (HERE / name).read_bytes() == data, name
    print('PASS unchanged timed region and inputs; no compiler/filter execution')

if __name__ == '__main__':
    main()
