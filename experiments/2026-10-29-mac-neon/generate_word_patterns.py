#!/usr/bin/env python3
"""Reproduce the fixed training dictionaries (Python 3.10 random.sample)."""
from pathlib import Path
import random

rng = random.Random(382927)
tables = []
for weight in (4, 5):
    masks, seen = [], set()
    while len(masks) < 64:
        mask = sum(1 << bit for bit in rng.sample(range(64), weight))
        canonical = min(((mask << i) | (mask >> (64-i))) & ((1 << 64)-1) for i in range(64))
        if canonical in seen:
            continue
        seen.add(canonical)
        masks.append(mask)
    tables.append(f'inline constexpr uint64_t patterns{weight}[64] = {{\n' +
                  ',\n'.join('    '+', '.join(hex(x)+'ULL' for x in masks[i:i+4])
                              for i in range(0,64,4)) + '\n};')
Path(__file__).with_name('word_patterns.h').write_text(
    '#pragma once\n#include <cstdint>\nnamespace mac_word_pattern {\n' + '\n'.join(tables) + '\n}\n')
