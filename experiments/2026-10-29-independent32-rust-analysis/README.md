# Rust Independent32 analysis

This directory contains postprocessing only. The measured harness and its
eleven libraries are frozen separately in
`../2026-10-29-independent32-rust-screen/` at commit
`db966496072e3ec4af5d98afe39697d90ec10835`.

`summarize.py` validates the complete original archive, including per-workload
versus aggregate equality, source commit, executable hashes and all frozen row
guards, before calculating results. It keeps all four query contracts and all
three batch sizes separate. Original native, experimental native and external
ownership remain distinct. Independent32 and ByteLeaf are also selected
individually under each actual-memory/FPR cap, so the experimental-family
winner cannot conceal a losing candidate.

All feasible tested allocations compete under each cap; in particular, the
32-bpk view includes 16-bpk rivals. The quality gate uses each public family's own
pointwise Wilson 95% upper endpoint. Repeated batch/mode streams and aliases
of the same bitmap mapping never add calibration negatives. The initial
seed42 screen has 32 family/size/seed calibration records. Separate public API
families can implement the same bit mapping; those records remain separate and
are never pooled.

Every native configuration at both tested allocations is retained, including
quality failures and speed losses. Exact ties stay separate from wins.
Reported trial min/max are observed ranges, not speed confidence intervals;
nested cap/FPR views are not independent experiments. No held-out or global
leadership claim is supported by this initial screen.

Run `python3 test_summary.py` for offline selection/quality regression tests.
After the authorized matrix completes, run `python3 summarize.py` to create
`report/`; the command never launches a benchmark and refuses to overwrite an
existing report directory.
