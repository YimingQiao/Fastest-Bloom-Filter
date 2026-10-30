#!/usr/bin/env python3
"""Source-only derivation from immutable native modules; no compiler/filter."""
from pathlib import Path
import subprocess,json,hashlib,difflib
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PARENT='79351bc33a256b79dc9cd71e7ac1aebfac37f8c5'
def blob(name):return subprocess.check_output(['git','show',PARENT+':'+name],cwd=ROOT)
def replace(text,old,new,count=1):
    assert text.count(old)==count,(old,text.count(old),count)
    return text.replace(old,new)

def sources():
    originals={name:blob(name)for name in ['rust/src/four_sector.rs','rust/src/layout_parallel.rs','rust/src/parallel.rs','rust/src/lib.rs','LICENSE']}
    text=originals['rust/src/four_sector.rs'].decode().split('#[cfg(test)]\nmod tests {')[0]
    text=replace(text,'//! Eight bits are set across four independently selected words in one cache line.','//! Twelve bits across four words; top24 address and eight offset bits are disjoint.')
    start=text.index('const PATTERNS:');end=text.index('const PREFETCH_THRESHOLD:',start)
    text=text[:start]+'''const PATTERNS: [u32; 16] = [
    0xb, 0x211, 0x2041, 0x40101, 0x1003, 0x8005, 0x10011, 0x109,
    0x8041, 0x40081, 0x403, 0x25, 0x411, 0x8081, 0x2003, 0x4009,
];
'''+text[end:]
    text=text.replace('FourSectorBloomFilter','FourSectorRange12BloomFilter').replace('word_mask','line_count')
    text=text.replace('setting two bits in each','setting three bits in each')
    old='''    fn line_count(n: usize, bpk: u32) -> Result<usize, SizeError> {
        layout_parallel::line_count(n, bpk)
    }
'''
    new='''    #[inline]
    fn base(hi: u32, count: u32) -> u32 {
        ((((hi >> 8) as u64 * count as u64) >> 24) as u32 * 16) | (hi & 3)
    }
    /// Physical cache line. Address bits40..63 never overlap offset/mask bits.
    #[inline]
    pub fn line_index(&self, hash: u64) -> usize {
        Self::base((hash >> 32) as u32, self.line_count) as usize >> 4
    }
'''
    text=replace(text,old,new)
    text=replace(text,'let a = hi & line_count;','let a = Self::base(hi, line_count);')
    for old,new in [('hi >> 26','hi >> 2'),('hi >> 28','hi >> 4'),('hi >> 30','hi >> 6')]:text=replace(text,old,new)
    text=replace(text,'|h| (((h >> 32) as u32 & mask) >> 4) as usize,','|h| (Self::base((h >> 32) as u32, mask) >> 4) as usize,')
    start=text.index('    /// Requests a bitmap');end=text.index('    fn insert_into(',start)
    text=text[:start]+'''    /// Complete64-byte lines within128bytes..256MiB inclusive; no pow2 rounding.
    pub fn with_byte_budget(bytes: usize) -> Result<Self, SizeError> {
        if bytes < 128 { return Err(SizeError::InvalidSize); }
        if bytes > 1 << 28 { return Err(SizeError::CapacityExceeded); }
        let count = bytes / 64;
        let lines = vec![Line::default(); count];
        if lines.capacity().checked_mul(64).ok_or(SizeError::CapacityExceeded)? > bytes {
            return Err(SizeError::CapacityExceeded);
        }
        let (avx512, avx2) = layout_parallel::backends();
        Ok(Self { lines, line_count: count as u32, avx512, avx2 })
    }
    /// floor(n*bpk/8) byte ceiling; real n, no synthetic sizing value.
    pub fn new(n: usize, bpk: u32) -> Result<Self, SizeError> {
        if n == 0 || bpk == 0 { return Err(SizeError::InvalidSize); }
        let bits = n.checked_mul(bpk as usize).ok_or(SizeError::InvalidSize)?;
        Self::with_byte_budget(bits / 8)
    }
    /// Actual bitmap backing allocation, excluding allocator metadata.
    pub fn size_in_bytes(&self) -> usize { self.lines.capacity() * 64 }
    /// Read-only logical bitmap words for exact cross-language fixture validation.
    pub fn bitmap_words(&self) -> &[u32] {
        // SAFETY: Line is repr(C,align64), exactly16 contiguous initialized u32s.
        unsafe { std::slice::from_raw_parts(self.lines.as_ptr().cast(), self.lines.len()*16) }
    }

'''+text[end:]
    text=replace(text,'((hash >> 32) as u32 & self.line_count) as usize','Self::base((hash >> 32) as u32, self.line_count) as usize')
    text=replace(text,'((hashes[i + 64 + j] >> 32) as u32 & line_count) as usize - begin * 16','Self::base((hashes[i + 64 + j] >> 32) as u32, line_count) as usize - begin * 16',2)
    text=replace(text,'((hashes[i + 64 + j] >> 32) as u32 & self.line_count) as usize','Self::base((hashes[i + 64 + j] >> 32) as u32, self.line_count) as usize',2)
    text=replace(text,'26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30,','2, 2, 4, 6, 2, 2, 4, 6, 2, 2, 4, 6, 2, 2, 4, 6,')
    text=replace(text,'28, 28, 28, 28, 28, 28, 28, 28, 30, 30, 30, 30, 30, 30, 30, 30,','4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6,')
    text=replace(text,'_mm256_setr_epi32(26, 26, 28, 30, 26, 26, 28, 30)','_mm256_setr_epi32(2, 2, 4, 6, 2, 2, 4, 6)')
    for width in(256,512):
        for shift,new in[(26,2),(28,4),(30,6)]:
            old=f'_mm{width}_srli_epi32::<{shift}>(hi)';text=text.replace(old,f'_mm{width}_srli_epi32::<{new}>(hi)')
        text=replace(text,f'_mm{width}_and_si{width}(hi, _mm{width}_set1_epi32(line_count as i32))',f'Self::base{width}(hi, line_count)')
        text=replace(text,f'_mm{width}_and_si{width}(hi, _mm{width}_set1_epi32(self.line_count as i32))',f'Self::base{width}(hi, self.line_count)',2 if width==512 else 1)
    marker='#[cfg(target_arch = "x86_64")]\nimpl FourSectorRange12BloomFilter {'
    helpers=''
    for width,features in[(512,'avx2,avx512f'),(256,'avx2')]:
        helpers+=f'''    #[inline]
    #[target_feature(enable = "{features}")]
    unsafe fn base{width}(hi: std::arch::x86_64::__m{width}i, count: u32) -> std::arch::x86_64::__m{width}i {{
        use std::arch::x86_64::*;
        let address = _mm{width}_srli_epi32::<8>(hi);
        let counts = _mm{width}_set1_epi32(count as i32);
        let even = _mm{width}_srli_epi64::<24>(_mm{width}_mul_epu32(address, counts));
        let odd = _mm{width}_srli_epi64::<24>(_mm{width}_mul_epu32(_mm{width}_srli_epi64::<32>(address), counts));
        let blocks = _mm{width}_or_si{width}(even, _mm{width}_slli_epi64::<32>(odd));
        _mm{width}_or_si{width}(_mm{width}_slli_epi32::<4>(blocks), _mm{width}_and_si{width}(hi, _mm{width}_set1_epi32(3)))
    }}
'''
    text=text.replace(marker,marker+'\n'+helpers,1)
    text+='\n#[cfg(test)]\n#[path = "tests.rs"]\nmod tests;\n'
    assert 'word_mask'not in text and '>> 26'not in text
    helper=originals['rust/src/layout_parallel.rs'].decode().split('#[cfg(test)]\nmod tests {')[0]
    helper=replace(helper,'use crate::{parallel::workers, BloomFilter, SizeError};','use crate::parallel::workers;')
    begin=helper.index('pub(crate) fn line_count(');end=helper.index('pub(crate) fn backends()',begin);helper=helper[:begin]+helper[end:]
    helper=replace(helper,'    debug_assert!(line_count.is_power_of_two());\n    let line_shift = line_count.trailing_zeros();\n    let shard = |hash| ((line_of(hash) as u64 * w as u64) >> line_shift) as usize;','''    // Exact physical ownership for arbitrary line counts. No high32 shortcut.
    let shard = |hash| owner(line_of(hash), w, line_count);''')
    helper+='''
// Shard p owns [ceil(p*L/W),ceil((p+1)*L/W)). For integer line i,
// floor(i*W/L)=p iff p*L <= i*W < (p+1)*L; these bounds agree exactly.
#[inline]
pub(crate) fn owner(line: usize, workers: usize, lines: usize) -> usize {
    debug_assert!(line < lines && workers > 0 && workers <= lines && lines <= 1 << 22);
    ((line as u64 * workers as u64) / lines as u64) as usize
}
'''
    parallel=originals['rust/src/parallel.rs'].decode();start=parallel.index('pub(crate) fn workers(');end=parallel.index('\n#[inline]',start);parallel='use std::thread;\n\n'+parallel[start:end]+'\n'
    return originals,{'native/src/four_sector_range12.rs':text.encode(),'native/src/layout_parallel.rs':helper.encode(),'native/src/parallel.rs':parallel.encode(),'native/LICENSE-MIT':originals['LICENSE']}

def main():
    import argparse
    parser=argparse.ArgumentParser();parser.add_argument('--write',action='store_true');args=parser.parse_args();originals,derived=sources()
    for name,data in derived.items():
        path=HERE/name
        if args.write:assert not path.exists(),name;path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
        else:assert path.read_bytes()==data,name
    pins={name:hashlib.sha256(data).hexdigest()for name,data in originals.items()};print(json.dumps({'parent_commit':PARENT,'originals_sha256':pins,'derived_files':{n:hashlib.sha256(v).hexdigest()for n,v in derived.items()},'compiler_or_BF_runs':0},indent=2))
if __name__=='__main__':main()
