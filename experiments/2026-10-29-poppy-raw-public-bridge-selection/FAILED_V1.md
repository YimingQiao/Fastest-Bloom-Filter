# Preserved offline selector failure

Source 228cf5fb2d0dfc39d748c33617cd53e6b748f869, session73941, terminal exit1. The immutable source/raw/complete producer replay passed; the first construction projection failed before historical view selection or output creation. No filter/compiler/calibration/throughput run occurred. The socket1 lease was released immediately.

The old source catalog stores `source_mapping = [n, buckets, cache_bytes, probes]`. V1 incorrectly compared its third component with `cache_bits`. Thirty cached constructors expose the difference (for example8192bytes versus65536bits); zero-cache synthetic fixtures did not. The intended repair changes only this field in the consistency assertion and adds a nonzero-cache regression. The selected panel remains unknown and no criterion changes. V1 source/logs remain immutable.
