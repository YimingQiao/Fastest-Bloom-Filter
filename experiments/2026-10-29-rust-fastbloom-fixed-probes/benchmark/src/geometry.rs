//! Constructor-only capacity policy; no hashing, insertion or query kernels.
use std::error::Error;

pub type Result<T> = std::result::Result<T, Box<dyn Error>>;

pub fn bytes(n: usize, bpk: u32) -> Result<usize> {
    if n == 0 || bpk == 0 {
        return Err("positive real item count and byte budget required".into());
    }
    let budget = n.checked_mul(bpk as usize).ok_or("byte budget overflow")? / 8;
    if !(128..=1 << 28).contains(&budget) {
        return Err("byte budget must be within 128 bytes..256 MiB".into());
    }
    Ok(budget)
}

pub fn native_bytes(n: usize, legacy_bpk: u32) -> Result<usize> {
    if legacy_bpk == 0 {
        return Err("zero native constructor argument".into());
    }
    let bits = n.checked_mul(legacy_bpk as usize).ok_or("native size overflow")?.max(512);
    if bits >= 1usize << 31 {
        return Err("native capacity exceeded".into());
    }
    let mut allocated = 128;
    while allocated <= bits / 8 {
        allocated *= 2;
    }
    Ok(allocated)
}

pub fn native_argument(n: usize, bpk: u32) -> Result<u32> {
    let budget = bytes(n, bpk)?;
    let target = 1usize << (usize::BITS - 1 - budget.leading_zeros());
    let argument = (target * 4).div_ceil(n);
    let argument = u32::try_from(argument).map_err(|_| "native argument overflow")?;
    if native_bytes(n, argument)? != target {
        return Err("no native public constructor fits this ceiling".into());
    }
    Ok(argument)
}

pub fn bloomsday_fpr(n: usize, bpk: u32) -> Result<f64> {
    let budget = bytes(n, bpk)?;
    if !budget.is_multiple_of(32) || !(budget * 8).is_multiple_of(n) {
        return Err("Bloomsday inverse requires an exact integral-bpk block budget".into());
    }
    let bits_per_key = budget * 8 / n;
    let fpr = (-(bits_per_key as f64 - 0.5) * std::f64::consts::LN_2.powi(2)).exp();
    let rounded = (-fpr.ln() / std::f64::consts::LN_2.powi(2)).ceil() as usize;
    if rounded != bits_per_key || (n * rounded).div_ceil(256) * 32 != budget {
        return Err("Bloomsday public constructor inverse did not round exactly".into());
    }
    Ok(fpr)
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Geometry {
    pub budget_bytes: usize,
    pub allocated_bytes: usize,
    pub logical_bytes: usize,
    pub unit_bytes: usize,
    pub effective_probes: i32,
    pub kind: &'static str,
    pub probe_policy: &'static str,
    pub constructor_argument: usize,
    pub origin: &'static str,
}

impl Geometry {
    pub fn csv(&self) -> String {
        format!("{},{},{},{},{},{},{},{},{},exact_byte_ceiling_v1",
            self.budget_bytes, self.logical_bytes, self.kind, self.unit_bytes,
            self.logical_bytes / self.unit_bytes, self.effective_probes,
            self.probe_policy, self.constructor_argument, self.origin)
    }
}

pub fn plan(name: &str, n: usize, bpk: u32) -> Result<Geometry> {
    let budget = bytes(n, bpk)?;
    let mut g = Geometry {
        budget_bytes: budget, allocated_bytes: budget, logical_bytes: budget,
        unit_bytes: 64, effective_probes: 8, kind: "range_lines",
        probe_policy: "fixed", constructor_argument: budget, origin: "external",
    };
    match name {
        "FastPatternBF" | "ByteSplitBloomFilter" | "FourSectorBloomFilter" | "Split64BloomFilter" => {
            let argument = native_argument(n, bpk)?;
            g.allocated_bytes = native_bytes(n, argument)?;
            g.logical_bytes = g.allocated_bytes;
            g.kind = "native_pow2_lines";
            g.constructor_argument = argument as usize;
            g.origin = "production_native";
            if name == "FastPatternBF" && n > g.allocated_bytes * 8 / 12 {
                g.effective_probes = 6;
            } else if name == "ByteSplitBloomFilter" {
                g.effective_probes = -1;
                g.probe_policy = "variable_byte_mask_0_16";
            }
        }
        "Split64RangeBloomFilter" => {
            g.logical_bytes = budget / 64 * 64;
            g.allocated_bytes = g.logical_bytes;
            g.origin = "native_experimental";
        }
        "Fastbloom017" => {
            g.logical_bytes = budget / 8 * 8;
            g.allocated_bytes = g.logical_bytes;
            g.unit_bytes = 8;
            g.kind = "classical_words";
            g.effective_probes = fastbloom::optimal_hashes(g.logical_bytes * 8, n) as i32;
            g.probe_policy = "upstream_expected_items_real_n";
            g.constructor_argument = g.logical_bytes * 8;
        }
        "Fastbloom017K1" | "Fastbloom017K2" | "Fastbloom017K3" | "Fastbloom017K4" | "Fastbloom017K5" | "Fastbloom017K6" | "Fastbloom017K7" | "Fastbloom017K8" | "Fastbloom017K9" | "Fastbloom017K10" | "Fastbloom017K11" | "Fastbloom017K12" => {
            g.logical_bytes = budget / 8 * 8;
            g.allocated_bytes = g.logical_bytes;
            g.unit_bytes = 8;
            g.kind = "classical_words";
            g.effective_probes = match name {
                "Fastbloom017K1" => 1,
                "Fastbloom017K2" => 2,
                "Fastbloom017K3" => 3,
                "Fastbloom017K4" => 4,
                "Fastbloom017K5" => 5,
                "Fastbloom017K6" => 6,
                "Fastbloom017K7" => 7,
                "Fastbloom017K8" => 8,
                "Fastbloom017K9" => 9,
                "Fastbloom017K10" => 10,
                "Fastbloom017K11" => 11,
                "Fastbloom017K12" => 12,
                _ => unreachable!(),
            };
            g.probe_policy = "public_fixed_hash_count";
            g.constructor_argument = g.logical_bytes * 8;
        }
        "BloomsdayPinned" => {
            let _ = bloomsday_fpr(n, bpk)?;
            g.unit_bytes = 32;
            g.kind = "public_split32_range";
            g.constructor_argument = budget * 8 / n;
        }
        "SbbfSafePinned" => {
            g.logical_bytes = budget / 64 * 64;
            g.allocated_bytes = g.logical_bytes;
            g.unit_bytes = 32;
            g.kind = "public_sbbf_range_padded64";
            g.constructor_argument = g.logical_bytes;
        }
        _ => return Err("unknown geometry family".into()),
    }
    if g.allocated_bytes > budget || g.logical_bytes == 0 {
        return Err("invalid or over-budget geometry".into());
    }
    Ok(g)
}
