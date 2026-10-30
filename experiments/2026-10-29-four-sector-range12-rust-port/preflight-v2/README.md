# V2 include-root binding correction

V1 failed closed after successful C++ compilation: its -I selected a byte-identical base.h at the mutable root path, outside the old compiled dependency closure. validation-v1 preserves all logs, the original complete=false metadata, actual depfile and diagnosis. No BF executed.

This additive driver keeps the committed core, C++ fixture and original guard/affinity modules exact. Its only behavioral correction is -I to the frozen original snapshot/include plus an exact actual-path assertion; V2 uses fresh /tmp/fastest-bf-k12-rust-port-v2-cpu3 and validation-v2. Both original preparation descriptors remain unchanged and are checked alongside this descriptor. The original nine offline guards are reused. Whole socket1 flock and actual seven-core child execution remain mandatory. No performance/FPR.

Run after exact source commit with the same whole-flock command, replacing preflight/validate.py with preflight-v2/validate.py.
