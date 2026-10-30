# Reproduction of the diagnostic originally executed through stdin; no baseline edits.
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import bridge, oracle
import numpy as np
from blowchoc.hashfunctions import compile_get_bucket
name = "linear2808315403"
for m in [25, 511, 510, 512]:
    f = compile_get_bucket(name, 4**32, m)
    for h in [0, 1, 2, 2**63 - 1, 2**63, 2**64 - 1]:
        x = (int(name[6:]) * (((h << 32) ^ (h >> 32)) & oracle.MASK)) & oracle.MASK
        if m % 2 == 0 and m & (m - 1):
            x ^= x >> 32
        signed = x if x < 2**63 else x - 2**64
        expected_unsigned = (x >> (64 - (m.bit_length() - 1))) & (m - 1) if m & (m - 1) == 0 else x % m
        print(m, h, f(np.uint64(h)), expected_unsigned, "signedmod", signed % m)
    llvm = f.inspect_llvm(f.signatures[0])
    for line in llvm.splitlines():
        if any(k in line for k in ("srem ", "urem ", "sdiv ", "udiv ", "frem", "sitofp", "uitofp", "lshr", "ashr")):
            print(line)
