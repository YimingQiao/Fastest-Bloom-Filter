# Completed fixed78 subset preflight

Source `a620b721e92b8706c42aa25fd4be762724bc0107` completed on CPU3 under the actual inherited socket1 flock. All six valid commands passed:16 rows,8 API/geometry combinations, exact native/ASan semantic equality. UINT64_MAX was accepted; overflow and negative seed inputs were rejected before CSV output. Existing dense-output, quality-count, phase/trial and allocation guards all passed. The entire frozen compiler-input/source/binary closure was reverified at the end.

No compiler ran, no held-out seed ran, and tiny timings are not performance evidence. The native `9aceea39...` and ASan `062802b2...` binaries remain unchanged. The raw8-command ledger, stdout/stderr, full semantic records and exact source/host/environment/lease identities are retained in `validation-v1`; its archive is additive to the previously committed caller proof. The initial unavailable-Python source-preparation attempt remains in `preflight/offline-v1.txt`, followed by six passing offline guards using Python3.

The fixed78 plan remains unchanged at `9c9cd9a32a3fbd6dd025f62e1055084312a0ae4b`. Formal measurements require the separate reviewed and committed runner; this preflight does not authorize changing its seeds, uniform calibration26, selected union or quality gates.
