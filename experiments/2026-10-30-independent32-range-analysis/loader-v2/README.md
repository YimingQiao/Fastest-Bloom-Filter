# Complete-loader V2: proof-bound caller sealer

This sibling repair preserves loaderf692681654ea68c31870d9684c8c90c839a629f6 and its failed execution unchanged. The sole failed V1 attempt is committed00b921170b72e3deef06624f41b5645b1ae6db3f, with the exact launcher, empty stdout, traceback and actual exit1 tool result. It stopped during caller source inventory checking, before raw-anchor loading or calculation. No report was created.

The caller source preparation968361 predates the additive `caller/seal.py`. That script is already an exact committed member of proofaa21a91 and its173-artifact archive, SHA add8f032e280892dcb5268401e7736c5085c2f5f57cd976de8e5cc68445e4959. V1 incorrectly required every top-level caller Python file to appear in the earlier source-only inventory, although no caller Python is imported.

V2 verifies the entire committed proof archive and compiled descriptor before checking the caller source inventory. Only the exact proof-verified top-level Python set `{seal.py}` may supplement that caller inventory. Unknown extra caller Python, a different proof Python set, wrong hashes, wrong Git bytes and symlinks still reject. The supplement applies only to the caller directory and is not added to any imported-source allowlist. Loader, producer and analysis local Python inventories and isolated import checks remain strict.

`derive.py` proves the exact patch from the committed original loader, requires the original live source/binding bytes to match their Git blobs, and copies `binding.json` unchanged. `REPAIR.patch` contains the complete executable delta. No producer, pure calculation/report writer, native binary, raw archive or completed anchor changes. The complete51-member raw replay,25-line launcher and actual exit0 requirements,36 calibration/180 reuse links, proof and placement checks are retained.

Three focused synthetic guards cover the known proof sealer, unknown extras and a wrong sealer hash. They used temporary mock artifacts, not experiment rows or producer imports, and passed in their first execution under the whole socket1/CPU3 lease. Exact stdout/stderr are retained; the lease has been released. Actual data loading remains blocked until the reviewed V2 source is committed and root grants one offline retry.

The retry uses the same completed anchor9cc55171729dd33affb1570a2344e6be851df941 and raw66168c56a24f688f4f700b6cb9eb8a85810abd64, a fresh `report-v2` output directory and separate execution-v2 logs under the whole socket1 lease. There is no filter, compiler, calibration, disassembler or new measurement invocation.

