//! Exact benchmark filter selection, shared by the native and external harnesses.
// Empty selection means all; invalid subsets must fail before benchmark jobs run.
pub fn select_filters<'a>(selection: &str, available: &[&'a str]) -> Result<Vec<&'a str>, String> {
    if selection.is_empty() {
        return Ok(available.to_vec());
    }
    let mut requested = Vec::new();
    for name in selection.split(',') {
        if name.is_empty() {
            return Err("filter selection contains an empty name".into());
        }
        if !available.contains(&name) {
            return Err(format!(
                "unknown filter '{name}'; available: {}",
                available.join(",")
            ));
        }
        if requested.contains(&name) {
            return Err(format!("duplicate filter '{name}'"));
        }
        requested.push(name);
    }
    // Preserve registration order before seeded shuffling, independent of list order.
    Ok(available
        .iter()
        .copied()
        .filter(|name| requested.contains(name))
        .collect())
}

#[cfg(test)]
mod tests {
    use super::select_filters;
    const AVAILABLE: &[&str] = &["FastPatternBF", "Split64BloomFilter", "External"];

    #[test]
    fn empty_selects_all_and_subsets_preserve_registration_order() {
        assert_eq!(select_filters("", AVAILABLE).unwrap(), AVAILABLE);
        assert_eq!(select_filters("External", AVAILABLE).unwrap(), ["External"]);
        assert_eq!(
            select_filters("External,FastPatternBF", AVAILABLE).unwrap(),
            ["FastPatternBF", "External"]
        );
    }

    #[test]
    fn invalid_subsets_are_rejected_in_full() {
        for selection in [
            "FastPatternBloomFilter",
            "FastPatternBF,FastPatternBloomFilter",
            "FastPatternBloomFilter,FastPatternBF",
            "FastPatternBF,",
            ",FastPatternBF",
            "FastPatternBF,,External",
            ",",
            ",,",
            "FastPatternBF,FastPatternBF",
            "External,FastPatternBF,External",
            "fastpatternbf",
            " FastPatternBF",
            "FastPatternBF ",
        ] {
            assert!(
                select_filters(selection, AVAILABLE).is_err(),
                "accepted {selection:?}"
            );
        }
    }
}
