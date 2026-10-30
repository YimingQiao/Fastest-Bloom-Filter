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
}
