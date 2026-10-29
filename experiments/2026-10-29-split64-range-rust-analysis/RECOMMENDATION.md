# Capacity feature, with a remaining external-configuration gap

Keep the current results as a training baseline. Range24 is useful at an
actual24-bpk/0.01% ceiling that the current power-of-two production geometries
cannot fill: its seed42 Wilson upper endpoints are0.00950860% and0.00920914%.
At equal actual16/32-bpk allocations, however, it loses47/48 query comparisons and
all48 build comparisons against production Split64. Do not promote it as a
universal replacement based on this screen.

The large cap24 ratios have an important configuration limit. The frozen
Fastbloom0.17 baseline uses public `.expected_items(real_n)`, selecting17 probes
at24 bpk and yielding a much lower FPR of about0.001%. Its pinned public builder
also supports `.hashes(k)` (`src/builder.rs:80`), so a configuration that spends
less work while still satisfying the0.01% gate may be substantially faster.
Those public fixed-K configurations are unmeasured here. The current ratios
must not be described as beating the strongest attainable Fastbloom baseline.

The next source-only baseline expansion should retain the default and add fixed
K8/K10/K12/K17 public builder controls at the same actual16/24/32 capacities,
without synthetic item counts or private kernel calls. Preserve real input n,
the same public prehashed queries, dense outputs, four query contracts, build
metrics and independent quality gates. Validate full outputs, constructor/probe
metadata and any provable default/fixed-K aliases before new performance data.
Freeze that protocol and its inputs before a separately authorized run.

After baseline coverage, any Range capacity promotion needs fresh-seed quality
and performance confirmation and the separately planned multithreaded tests.
The small-table allocation-inclusive regressions also deserve an isolated
code-generation/allocation audit; the present measurements do not establish
their cause. Historical and current FourSector gate uncertainty remains visible
without retroactively dropping a currently eligible training row.
