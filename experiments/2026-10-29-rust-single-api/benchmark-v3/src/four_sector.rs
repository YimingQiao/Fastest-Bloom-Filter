//! Experimental four-sector filter matching C++ FourSectorBF<8> with 16 patterns.
//! Eight bits are set across four independently selected words in one cache line.

use crate::Filter;
use fastest_bloom_filter::SizeError;

const PATTERNS: [u32; 16] = [
    0x3, 0x5, 0x9, 0x11, 0x21, 0x41, 0x81, 0x101, 0x201, 0x401, 0x801, 0x1001, 0x2001, 0x4001,
    0x8001, 0x10001,
];
const PREFETCH_THRESHOLD: usize = 1 << 21;

#[repr(C, align(64))]
#[derive(Clone, Copy, Default, Debug, PartialEq, Eq)]
struct Line([u32; 16]);

pub(crate) struct FourSector16K8Experimental {
    lines: Vec<Line>,
    word_mask: u32,
    avx512: bool,
}

impl FourSector16K8Experimental {
    fn line_count(n: usize, bpk: u32) -> Result<usize, SizeError> {
        if bpk == 0 {
            return Err(SizeError::InvalidSize);
        }
        let bits = n
            .checked_mul(bpk as usize)
            .ok_or(SizeError::InvalidSize)?
            .max(512);
        if bits >= 1usize << 31 {
            return Err(SizeError::CapacityExceeded);
        }
        let mut words = 32;
        while words <= bits / 32 {
            words *= 2;
        }
        Ok(words / 16)
    }

    #[inline]
    fn probe(&self, hash: u64) -> ([u32; 4], [u32; 4]) {
        let hi = (hash >> 32) as u32;
        let lo = hash as u32;
        let a = hi & self.word_mask;
        let indices = [
            a,
            a ^ 4 ^ ((hi >> 26) & 3),
            a ^ 8 ^ ((hi >> 28) & 3),
            a ^ 12 ^ ((hi >> 30) & 3),
        ];
        let masks = std::array::from_fn(|j| {
            let code = lo.rotate_right(j as u32 * 8);
            PATTERNS[(code & 15) as usize].rotate_left((code >> 4) & 31)
        });
        (indices, masks)
    }

    #[inline]
    fn insert_scalar(&mut self, hash: u64) {
        let (indices, masks) = self.probe(hash);
        for (index, mask) in indices.into_iter().zip(masks) {
            self.lines[index as usize >> 4].0[index as usize & 15] |= mask;
        }
    }

    #[inline]
    fn contains_scalar(&self, hash: u64) -> bool {
        let (indices, masks) = self.probe(hash);
        let mut pass = true;
        for (index, mask) in indices.into_iter().zip(masks) {
            pass &= self.lines[index as usize >> 4].0[index as usize & 15] & mask == mask;
        }
        pass
    }
}

impl Filter for FourSector16K8Experimental {
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let count = Self::line_count(n, bpk)?;
        #[cfg(target_arch = "x86_64")]
        let avx512 =
            std::is_x86_feature_detected!("avx512f") && std::is_x86_feature_detected!("avx2");
        #[cfg(not(target_arch = "x86_64"))]
        let avx512 = false;
        Ok(Self {
            lines: vec![Line::default(); count],
            word_mask: (count * 16 - 1) as u32,
            avx512,
        })
    }

    fn size_in_bytes(&self) -> usize {
        self.lines.len() * 64
    }

    fn insert_hashes(&mut self, hashes: &[u64]) {
        #[cfg(target_arch = "x86_64")]
        if self.avx512 {
            // SAFETY: checked CPU features, bounded loads and masked bitmap indices.
            unsafe {
                if self.size_in_bytes() > PREFETCH_THRESHOLD {
                    self.insert_avx512::<true>(hashes);
                } else {
                    self.insert_avx512::<false>(hashes);
                }
            }
            return;
        }
        for &hash in hashes {
            self.insert_scalar(hash);
        }
    }

    fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
        assert_eq!(hashes.len(), out.len(), "one output is required per input");
        #[cfg(target_arch = "x86_64")]
        if self.avx512 && hashes.len() >= 4 {
            // SAFETY: checked CPU features, equal output length and masked tails.
            unsafe {
                if self.size_in_bytes() > PREFETCH_THRESHOLD {
                    self.lookup_avx512::<true>(hashes, out);
                } else {
                    self.lookup_avx512::<false>(hashes, out);
                }
            }
            return;
        }
        for (&hash, answer) in hashes.iter().zip(out) {
            *answer = self.contains_scalar(hash) as u32;
        }
    }
}

#[cfg(target_arch = "x86_64")]
impl FourSector16K8Experimental {
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn insert_avx512<const PREFETCH: bool>(&mut self, hashes: &[u64]) {
        use std::arch::x86_64::*;
        let even = _mm512_setr_epi32(0, 0, 0, 0, 2, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6);
        let odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
        let rotations = _mm512_setr_epi32(0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24);
        let quarters = _mm512_setr_epi32(0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12);
        let offset_shifts = _mm512_setr_epi32(
            26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30,
        );
        let offset_masks = _mm512_setr_epi32(0, 3, 3, 3, 0, 3, 3, 3, 0, 3, 3, 3, 0, 3, 3, 3);
        let table = _mm512_loadu_si512(PATTERNS.as_ptr().cast());
        let words = self.lines.as_mut_ptr().cast::<u32>();
        let mut i = 0;
        while i + 4 <= hashes.len() {
            if PREFETCH && i + 68 <= hashes.len() {
                for j in 0..4 {
                    let index = ((hashes[i + 64 + j] >> 32) as u32 & self.word_mask) as usize;
                    _mm_prefetch::<_MM_HINT_T0>(words.add(index).cast());
                }
            }
            let packed = _mm512_castsi256_si512(_mm256_loadu_si256(hashes.as_ptr().add(i).cast()));
            let lo = _mm512_permutexvar_epi32(even, packed);
            let hi = _mm512_permutexvar_epi32(odd, packed);
            let code = _mm512_rorv_epi32(lo, rotations);
            let masks = _mm512_rolv_epi32(
                _mm512_permutexvar_epi32(code, table),
                _mm512_srli_epi32::<4>(code),
            );
            let offsets = _mm512_and_si512(_mm512_srlv_epi32(hi, offset_shifts), offset_masks);
            let indices = _mm512_xor_si512(
                _mm512_and_si512(hi, _mm512_set1_epi32(self.word_mask as i32)),
                _mm512_xor_si512(quarters, offsets),
            );
            let mut index = [0u32; 16];
            let mut mask = [0u32; 16];
            _mm512_storeu_si512(index.as_mut_ptr().cast(), indices);
            _mm512_storeu_si512(mask.as_mut_ptr().cast(), masks);
            // Sequential ORs retain all bits if different keys select one word.
            for j in 0..16 {
                *words.add(index[j] as usize) |= mask[j];
            }
            i += 4;
        }
        for &hash in &hashes[i..] {
            self.insert_scalar(hash);
        }
    }

    #[inline]
    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn query_chunk<const MASKED: bool>(
        &self,
        hashes: *const u64,
        out: *mut u32,
        valid: u16,
        table: std::arch::x86_64::__m512i,
    ) {
        use std::arch::x86_64::*;
        let even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30);
        let odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
        let x = if MASKED {
            _mm512_maskz_loadu_epi64(valid as u8, hashes.cast())
        } else {
            _mm512_loadu_si512(hashes.cast())
        };
        // Forming hashes.add(8) itself requires at least eight input objects.
        let y = if MASKED {
            if valid >> 8 != 0 {
                _mm512_maskz_loadu_epi64((valid >> 8) as u8, hashes.add(8).cast())
            } else {
                _mm512_setzero_si512()
            }
        } else {
            _mm512_loadu_si512(hashes.add(8).cast())
        };
        let lo = _mm512_permutex2var_epi32(x, even, y);
        let hi = _mm512_permutex2var_epi32(x, odd, y);
        let a = _mm512_and_si512(hi, _mm512_set1_epi32(self.word_mask as i32));
        let b = _mm512_xor_si512(
            a,
            _mm512_or_si512(
                _mm512_set1_epi32(4),
                _mm512_and_si512(_mm512_srli_epi32::<26>(hi), _mm512_set1_epi32(3)),
            ),
        );
        let c = _mm512_xor_si512(
            a,
            _mm512_or_si512(
                _mm512_set1_epi32(8),
                _mm512_and_si512(_mm512_srli_epi32::<28>(hi), _mm512_set1_epi32(3)),
            ),
        );
        let d = _mm512_xor_si512(
            a,
            _mm512_or_si512(
                _mm512_set1_epi32(12),
                _mm512_and_si512(_mm512_srli_epi32::<30>(hi), _mm512_set1_epi32(3)),
            ),
        );
        let code2 = _mm512_ror_epi32::<8>(lo);
        let code3 = _mm512_ror_epi32::<16>(lo);
        let code4 = _mm512_ror_epi32::<24>(lo);
        let m1 = _mm512_rolv_epi32(
            _mm512_permutexvar_epi32(lo, table),
            _mm512_srli_epi32::<4>(lo),
        );
        let m2 = _mm512_rolv_epi32(
            _mm512_permutexvar_epi32(code2, table),
            _mm512_srli_epi32::<4>(code2),
        );
        let m3 = _mm512_rolv_epi32(
            _mm512_permutexvar_epi32(code3, table),
            _mm512_srli_epi32::<4>(code3),
        );
        let m4 = _mm512_rolv_epi32(
            _mm512_permutexvar_epi32(code4, table),
            _mm512_srli_epi32::<4>(code4),
        );
        let zero = _mm512_setzero_si512();
        let words = self.lines.as_ptr().cast::<i32>();
        let v1 = _mm512_mask_i32gather_epi32::<4>(zero, valid, a, words);
        let v2 = _mm512_mask_i32gather_epi32::<4>(zero, valid, b, words);
        let v3 = _mm512_mask_i32gather_epi32::<4>(zero, valid, c, words);
        let v4 = _mm512_mask_i32gather_epi32::<4>(zero, valid, d, words);
        let pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(v1, m1), m1)
            & _mm512_cmpeq_epi32_mask(_mm512_and_si512(v2, m2), m2)
            & _mm512_cmpeq_epi32_mask(_mm512_and_si512(v3, m3), m3)
            & _mm512_cmpeq_epi32_mask(_mm512_and_si512(v4, m4), m4);
        let answers = _mm512_maskz_set1_epi32(pass, 1);
        if MASKED {
            _mm512_mask_storeu_epi32(out.cast(), valid, answers);
        } else {
            _mm512_storeu_si512(out.cast(), answers);
        }
    }

    #[target_feature(enable = "avx2,avx512f")]
    unsafe fn lookup_avx512<const PREFETCH: bool>(&self, hashes: &[u64], out: &mut [u32]) {
        use std::arch::x86_64::*;
        let table = _mm512_loadu_si512(PATTERNS.as_ptr().cast());
        let mut i = 0;
        while i + 16 <= hashes.len() {
            if PREFETCH && i + 80 <= hashes.len() {
                for j in 0..16 {
                    let index = ((hashes[i + 64 + j] >> 32) as u32 & self.word_mask) as usize;
                    _mm_prefetch::<_MM_HINT_T0>(
                        self.lines.as_ptr().cast::<u32>().add(index).cast(),
                    );
                }
            }
            self.query_chunk::<false>(
                hashes.as_ptr().add(i),
                out.as_mut_ptr().add(i),
                u16::MAX,
                table,
            );
            i += 16;
        }
        if i < hashes.len() {
            self.query_chunk::<true>(
                hashes.as_ptr().add(i),
                out.as_mut_ptr().add(i),
                ((1u32 << (hashes.len() - i)) - 1) as u16,
                table,
            );
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use fastest_bloom_filter::hash64;

    #[test]
    fn sizing_alignment_and_distinct_sector_words() {
        for (n, bpk, bytes) in [
            (0, 1, 128),
            (64, 8, 128),
            (64, 16, 256),
            (1024, 8, 2048),
            (1024, 16, 4096),
        ] {
            let bf = FourSector16K8Experimental::new(n, bpk).unwrap();
            assert_eq!(bf.size_in_bytes(), bytes);
            assert_eq!(bf.lines.as_ptr() as usize % 64, 0);
            for h in (0..4096).map(hash64) {
                let (indices, masks) = bf.probe(h);
                for j in 0..4 {
                    assert_eq!(masks[j].count_ones(), 2);
                    assert_eq!(indices[j] / 16, indices[0] / 16);
                    for k in 0..j {
                        assert_ne!(indices[j], indices[k]);
                    }
                }
            }
        }
        assert_eq!(
            FourSector16K8Experimental::line_count(1, 0),
            Err(SizeError::InvalidSize)
        );
        assert_eq!(
            FourSector16K8Experimental::line_count(usize::MAX, 2),
            Err(SizeError::InvalidSize)
        );
        assert_eq!(
            FourSector16K8Experimental::line_count(1 << 27, 16),
            Err(SizeError::CapacityExceeded)
        );
    }

    #[test]
    fn scalar_runtime_collision_and_tail_parity() {
        for n in [0, 1, 3, 4, 15, 16, 17, 64, 65, 4099] {
            for hot in [false, true] {
                let inserted: Vec<_> = (0..n)
                    .map(|i| {
                        if hot {
                            hash64(i) & 0xffff_ffff
                        } else {
                            hash64(i)
                        }
                    })
                    .collect();
                let mut scalar = FourSector16K8Experimental::new(n as usize, 8).unwrap();
                scalar.avx512 = false;
                scalar.insert_hashes(&inserted);
                let mut runtime = FourSector16K8Experimental::new(n as usize, 8).unwrap();
                for batch in [1, 3, 4, 7, 16, 17, 65, 4096] {
                    runtime.lines.fill(Line::default());
                    for chunk in inserted.chunks(batch) {
                        runtime.insert_hashes(chunk);
                    }
                    assert_eq!(scalar.lines, runtime.lines);
                    runtime.insert_hashes(&inserted);
                    assert_eq!(scalar.lines, runtime.lines);
                }
                let mut present = vec![0; inserted.len()];
                runtime.lookup_hashes(&inserted, &mut present);
                assert!(present.iter().all(|&x| x == 1));
                let q: Vec<_> = (0..8192).map(hash64).collect();
                for len in 0..=145 {
                    for offset in 0..8 {
                        let mut actual = vec![0xfeed; len + 2];
                        runtime.lookup_hashes(&q[offset..offset + len], &mut actual[1..1 + len]);
                        assert_eq!(actual[0], 0xfeed);
                        assert_eq!(actual[len + 1], 0xfeed);
                        for (&h, &v) in q[offset..offset + len].iter().zip(&actual[1..1 + len]) {
                            assert_eq!(v, scalar.contains_scalar(h) as u32);
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn large_prefetch_path_matches_scalar() {
        let inserted: Vec<_> = (0..8195).map(hash64).collect();
        let mut scalar = FourSector16K8Experimental::new(1 << 20, 16).unwrap();
        scalar.avx512 = false;
        scalar.insert_hashes(&inserted);
        let mut runtime = FourSector16K8Experimental::new(1 << 20, 16).unwrap();
        assert!(runtime.size_in_bytes() > PREFETCH_THRESHOLD);
        runtime.insert_hashes(&inserted);
        assert_eq!(scalar.lines, runtime.lines);
        let q: Vec<_> = (0..16401).map(hash64).collect();
        let mut out = vec![0; q.len()];
        runtime.lookup_hashes(&q, &mut out);
        for (&h, &v) in q.iter().zip(&out) {
            assert_eq!(v, scalar.contains_scalar(h) as u32);
        }
    }

    #[test]
    #[should_panic(expected = "one output is required per input")]
    fn rejects_mismatched_output_before_writing() {
        let bf = FourSector16K8Experimental::new(1, 8).unwrap();
        bf.lookup_hashes(&[hash64(1)], &mut []);
    }
}
