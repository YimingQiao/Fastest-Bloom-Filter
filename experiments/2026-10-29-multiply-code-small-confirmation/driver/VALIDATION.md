# Pre-data runner validation

No new filter, compiler, calibration or performance workload has run for this
confirmation. The seven initial files remain unchanged; all subsequent sources
and logs are additive in `driver/`.

`validation-v1` records the initial26 successful offline tests. Adding six
synthetic complete raw/aggregate archive tests exposed a Python import collision
in `validation-v2`: prepending the frozen parent directory to `sys.path` made
`test_contract` resolve to the parent's unrelated executable test script. Its
attempt to execute the nonexistent command `discover` failed before any BF
process started. Both complete error traces are retained. No binary or algorithm
changed. The corrected helper import loads only `order_oracle.py` and
`validate_rows.py` by their explicit immutable file paths, without changing
`sys.path`.

`validation-v3` records all32 offline tests passing, followed by immutable
ancestry verification: own initial7 files at77fd38ef, later committed70-row
evidence at0c8088f, compiled parent archive at9e4362f,325 combined source/evidence
hashes and39 unchanged executable hashes. A source-only review also caught a
temporary pre-test inversion of the initial/evidence Git anchors; it was fixed
before that ancestry validation and no workload saw it.

After the independent FourSector precision results became available, the
coordinator fixed two explicitly named analysis policies before fresh timings:
the main competitive set includes every API passing all six fresh endpoints;
the initially specified restricted set retains its FourSector diagnostic rule.
Neither set pools alias or repeated-batch samples. The separately committed
FourSector evidence is pinned in `policy-context.json`; no old latency or
negative count is imported into the144 matrix.

`validation-v4` records all33 final offline guards passing, including an actual
child-process inherited flock proof and both named eligibility policies. Its
ancestry check passes all336 combined source/evidence hashes and39 unchanged
executables, including the separately committed FourSector precision context.
The synthetic child test uses a temporary lock and mocked CPU affinity, never
the real performance socket lock or benchmark executable. The full source freeze
records final logs and all consumed immutable inputs. Timing remains contingent
on a reviewed commit and explicit real socket lease.
