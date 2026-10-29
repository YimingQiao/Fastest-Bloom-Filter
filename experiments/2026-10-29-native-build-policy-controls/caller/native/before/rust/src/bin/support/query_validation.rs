//! Validation outside the benchmark timers, covering every output position.
fn checksum(output: &[u32]) -> u64 {
    output.iter().fold(14695981039346656037u64, |sum, &answer| {
        assert!(answer <= 1, "invalid timed query output");
        (sum ^ answer as u64).wrapping_mul(1099511628211)
    })
}

pub fn verify_output(output: &[u32], expected: u64, phase: &str) {
    assert_eq!(
        checksum(output),
        expected,
        "{phase} output differs from warmup"
    );
}

#[cfg(test)]
mod tests {
    use super::{checksum, verify_output};

    #[test]
    fn detects_a_changed_tail_beyond_sampled_consumption() {
        let mut output = vec![0; 4096];
        let expected = checksum(&output);
        verify_output(&output, expected, "test query");
        output[4095] = 1;
        assert!(
            std::panic::catch_unwind(|| verify_output(&output, expected, "test query")).is_err()
        );
    }

    #[test]
    fn rejects_non_boolean_results() {
        assert!(std::panic::catch_unwind(|| verify_output(&[2], 0, "test query")).is_err());
    }

    struct CorruptTimedTail<const PASS: usize> {
        hashes: std::collections::HashSet<u64>,
        query_pass: std::cell::Cell<usize>,
    }
    impl<const PASS: usize> crate::Filter for CorruptTimedTail<PASS> {
        fn new(_: usize, _: u32) -> Result<Self, Box<dyn std::error::Error>> {
            Ok(Self {
                hashes: Default::default(),
                query_pass: 0.into(),
            })
        }
        fn size_in_bytes(&self) -> usize {
            128
        }
        fn insert_hashes(&mut self, hashes: &[u64]) {
            self.hashes.extend(hashes.iter().copied());
        }
        fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {
            for (&hash, answer) in hashes.iter().zip(out.iter_mut()) {
                *answer = self.hashes.contains(&hash) as u32;
            }
            // Build checks use 32 inputs. The one full 128-input query batch
            // is warmup, timed prehash, then timed hash+query respectively.
            if hashes.len() == 128 {
                let pass = self.query_pass.get() + 1;
                self.query_pass.set(pass);
                if pass == PASS {
                    out[127] ^= 1;
                }
            }
        }
    }
    fn run_corrupted<const PASS: usize>() {
        let c = crate::Config {
            n: 32,
            q: 128,
            bpk: 8,
            hit: 25,
            batch: 128,
            insert_batch: 32,
            calibration_power: 0,
            repeats: 1,
            seed: 42,
            key_base: 0,
        };
        crate::run::<CorruptTimedTail<PASS>>(
            "corrupted test filter",
            &(0..32).collect::<Vec<_>>(),
            &(0..128).collect::<Vec<_>>(),
            &c,
        );
    }
    #[test]
    #[should_panic(expected = "timed prehashed query output differs from warmup")]
    fn actual_harness_rejects_first_timed_prehash_corruption() {
        run_corrupted::<2>();
    }

    #[test]
    #[should_panic(expected = "timed hash+query output differs from warmup")]
    fn actual_harness_rejects_first_timed_hash_query_corruption() {
        run_corrupted::<3>();
    }
}
