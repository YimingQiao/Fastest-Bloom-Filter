# Pre-data phase-order guard correction

The original preflight archive and seven passing offline guard tests were committed at `9270e294575f01710d4683644d4e5f89efe6d88a`. Before any throughput run, independent review found that the Python guard checked Williams balance but accepted another balanced label permutation. The Rust producer already computed the intended seed-derived order.

The correction adds an independent unsigned-integer SplitMix/shuffle oracle to the Python validator and requires exact equality with the emitted schedule. A new regression rotates all four labels in one row: balance remains valid, but the guard now rejects it. The retained six-workload producer output also passes the new oracle without rerunning the executable. No Rust source, compiled binary, query timings, protocol, or measured data changed. The previous guard log is retained separately, and the original source/freeze/manifest remain in the committed revision above.
