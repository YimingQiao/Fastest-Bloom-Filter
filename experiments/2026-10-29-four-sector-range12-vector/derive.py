#!/usr/bin/env python3
"""Only the already calibrated K12 dictionary and AVX2 table lookup change."""
from pathlib import Path
import argparse
HERE=Path(__file__).resolve().parent
PARENT=HERE.parent/'2026-10-29-four-sector-range24/four_sector_range24.h'
MASKS=HERE.parent/'2026-10-28-four-sector/masks3-count16.txt'
def replace(s,a,b,count=1):
 if s.count(a)!=count:raise ValueError((a,s.count(a),count))
 return s.replace(a,b)
def generate():
 s=PARENT.read_text().replace('FourSectorRange24','FourSectorRange12')
 s=replace(s,'#include "range_size.hpp"','#include "../2026-10-29-four-sector-range24/range_size.hpp"')
 s=replace(s,'two cyclic mask bits per sector.','three cyclic mask bits per sector.')
 start=s.index('\tinline static constexpr uint32_t patterns2[16]');end=s.index('\n',s.index('};',start))
 s=s[:start]+'\tinline static constexpr uint32_t patterns3[16] = {'+MASKS.read_text().strip()+'};'+s[end:]
 s=s.replace('patterns2','patterns3')
 a='''\t\t\t// The dictionary is exactly 1 | (2 << (code & 15)). Forming it
\t\t\t// arithmetically avoids an extra AVX2 gather for this small table.
\t\t\tconst __m256i pattern = _mm256_or_si256(
\t\t\t    ones, _mm256_sllv_epi32(_mm256_set1_epi32(2), _mm256_and_si256(code, _mm256_set1_epi32(15))));'''
 b='''\t\t\t// K12's fixed 16-entry dictionary needs both 8-word register halves.
\t\t\t// Broadcast code bit3 to ALL bytes before the byte-granularity blend.
\t\t\tconst __m256i low = _mm256_permutevar8x32_epi32(table_low, code);
\t\t\tconst __m256i high = _mm256_permutevar8x32_epi32(table_high, code);
\t\t\tconst __m256i select = _mm256_srai_epi32(_mm256_slli_epi32(code, 28), 31);
\t\t\tconst __m256i pattern = _mm256_blendv_epi8(low, high, select);'''
 s=replace(s,a,b)
 s=replace(s,'\t\tconst __m256i ones = _mm256_set1_epi32(1);','''\t\tconst __m256i ones = _mm256_set1_epi32(1);
\t\tconst __m256i table_low = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(patterns3));
\t\tconst __m256i table_high = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(patterns3+8));''')
 return s
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--verify',action='store_true');a=p.parse_args();s=generate();target=HERE/'four_sector_range12.h'
 if a.verify:
  if target.read_text()!=s:raise ValueError('Candidate derivation mismatch')
 else:
  if target.exists():raise ValueError('Refuse to overwrite candidate')
  target.write_text(s)
