# Cyclic62 offline analysis

This sidecar reads the completed screen prepared at
`33ad882da3f5bff603f4b51559f3cd4833778fee`. It modifies no frozen input,
benchmark, executable or raw measurement. The source/selection was fixed
before timing; these descriptive rankings are postprocessing.

`summarize.py` verifies the committed local archive,214 consumed source pins,
27 binary pins, full62-row/13-case grid, exact commands, raw stdout/stderr
hashes and exact ordered aggregate. `order_oracle.py` expands the four C++
registration macros into75 names, verifies the allocation planner's registry,
filters each case and reproduces the complete SplitMix/Fisher–Yates job order.
The imported producer guard validates actual backing bytes, ownership,
geometry, complete trial vectors, summary medians/min/max, phases and NaNs.

Each primary view independently selects the fastest measured external,
production native, range experiment and cyclic allocation under caps16/32
and FPR limits1%/0.1%/0.01%, separately for pure and common-hash queries.
Actual24-bpk rivals and28-bpk cyclic remain eligible under cap32. All62
allocations and744 detailed alternatives remain visible, including all96
cyclic alternatives and every ineligible/loss row. Raw-only APIs cannot
participate in pure-query rankings.

Known calibration aliases collapse to56 samples without increasing their
individual2^24 denominators. `prior-quality.json` imports only six earlier
FourSector16 quality records, with raw-source hashes; no earlier latency
enters the analysis. A new training pass does not erase the previous small
table's0.1% held-out failure. The report marks that history explicitly.

Reproduce to a new output directory:

```sh
python3 experiments/2026-10-29-cyclic-split64-analysis/summarize.py --output /tmp/cyclic62-reproduced
python3 -m unittest discover -s experiments/2026-10-29-cyclic-split64-analysis -p 'test_*.py' -v
```

No benchmark or compiler runs in either command. The tests cover raw/aggregate
corruption, exact source-derived order, trial/phase metadata, alias mismatch,
actual-capacity eligibility, smaller rival allocations, raw-only contracts,
all failed candidate allocations, historical quality flags and Python `-O`.

This is one seed and one fixed case ordering. Filter order is randomized
within cases but not pair-order balanced, and size/budget cases run in sorted
groups. Alternating query phases do not balance filter/case order. CPU3
affinity does not impose NUMA memory binding. No held-out, whole75-registry,
global-fastest or construction-speed claim follows.
