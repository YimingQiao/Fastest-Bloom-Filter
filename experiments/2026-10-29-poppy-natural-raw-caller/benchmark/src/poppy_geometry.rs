//! Exact constructors from the completed historical14 union; no future quality claim.
pub struct Point {
    pub id: usize, pub byte_name: &'static str, pub typed_name: &'static str,
    pub configuration: &'static str, pub n: usize, pub budget_bpk: u32,
    pub fpp_bits: u64, pub policy: poppy_filters::OptLevel, pub policy_name: &'static str,
    pub bucket_bytes: usize, pub cache_bytes: usize, pub probes: i32,
}
impl Point {
    pub fn check(&self, n: usize, bpk: u32) -> crate::geometry::Result<()> {
        if n != self.n || bpk != self.budget_bpk {
            return Err("Poppy requires its frozen real n and declared budget".into());
        }
        Ok(())
    }
    pub fn plan(&self, n: usize, bpk: u32) -> crate::geometry::Result<crate::geometry::Geometry> {
        self.check(n, bpk)?;
        let budget_bytes = crate::geometry::bytes(n, bpk)?;
        let allocated_bytes = self.bucket_bytes.checked_add(self.cache_bytes).ok_or("backing overflow")?;
        if allocated_bytes > budget_bytes { return Err("Poppy exceeds actual-byte cap".into()); }
        Ok(crate::geometry::Geometry { budget_bytes, allocated_bytes, logical_bytes: self.bucket_bytes,
            unit_bytes: 4096, effective_probes: self.probes, kind: "poppy_public_buckets_with_cache",
            probe_policy: "frozen_public_params", constructor_argument: self.n, origin: "external_poppy_natural" })
    }
}
pub const POINTS: &[Point] = &[
    Point { id: 20, byte_name: "PoppyRawByte020", typed_name: "PoppyRawTyped020", configuration: "65536:PoppyPublic020:139264", n: 65536, budget_bpk: 24, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::Speed, policy_name: "speed", bucket_bytes: 131072, cache_bytes: 8192, probes: 5 },
    Point { id: 33, byte_name: "PoppyRawByte033", typed_name: "PoppyRawTyped033", configuration: "65536:PoppyPublic033:139264", n: 65536, budget_bpk: 24, fpp_bits: 0x3f855e85064e2ceb, policy: poppy_filters::OptLevel::Speed, policy_name: "speed", bucket_bytes: 131072, cache_bytes: 8192, probes: 4 },
    Point { id: 39, byte_name: "PoppyRawByte039", typed_name: "PoppyRawTyped039", configuration: "65536:PoppyPublic039:90112", n: 65536, budget_bpk: 16, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 81920, cache_bytes: 8192, probes: 5 },
    Point { id: 40, byte_name: "PoppyRawByte040", typed_name: "PoppyRawTyped040", configuration: "65536:PoppyPublic040:126976", n: 65536, budget_bpk: 16, fpp_bits: 0x3f50624dd2f1a9fc, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 118784, cache_bytes: 8192, probes: 7 },
    Point { id: 41, byte_name: "PoppyRawByte041", typed_name: "PoppyRawTyped041", configuration: "65536:PoppyPublic041:167936", n: 65536, budget_bpk: 24, fpp_bits: 0x3f1a36e2eb1c432d, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 159744, cache_bytes: 8192, probes: 9 },
    Point { id: 42, byte_name: "PoppyRawByte042", typed_name: "PoppyRawTyped042", configuration: "65536:PoppyPublic042:98304", n: 65536, budget_bpk: 16, fpp_bits: 0x3f74c6d46ff00d7a, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 90112, cache_bytes: 8192, probes: 5 },
    Point { id: 43, byte_name: "PoppyRawByte043", typed_name: "PoppyRawTyped043", configuration: "65536:PoppyPublic043:131072", n: 65536, budget_bpk: 16, fpp_bits: 0x3f48604346c46ab0, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 122880, cache_bytes: 8192, probes: 7 },
    Point { id: 60, byte_name: "PoppyRawByte060", typed_name: "PoppyRawTyped060", configuration: "33554432:PoppyPublic060:71303168", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::Speed, policy_name: "speed", bucket_bytes: 67108864, cache_bytes: 4194304, probes: 5 },
    Point { id: 73, byte_name: "PoppyRawByte073", typed_name: "PoppyRawTyped073", configuration: "33554432:PoppyPublic073:71303168", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f855e85064e2ceb, policy: poppy_filters::OptLevel::Speed, policy_name: "speed", bucket_bytes: 67108864, cache_bytes: 4194304, probes: 4 },
    Point { id: 79, byte_name: "PoppyRawByte079", typed_name: "PoppyRawTyped079", configuration: "33554432:PoppyPublic079:44404736", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 40210432, cache_bytes: 4194304, probes: 5 },
    Point { id: 80, byte_name: "PoppyRawByte080", typed_name: "PoppyRawTyped080", configuration: "33554432:PoppyPublic080:64503808", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f50624dd2f1a9fc, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 60309504, cache_bytes: 4194304, probes: 7 },
    Point { id: 81, byte_name: "PoppyRawByte081", typed_name: "PoppyRawTyped081", configuration: "33554432:PoppyPublic081:84615168", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f1a36e2eb1c432d, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 80420864, cache_bytes: 4194304, probes: 9 },
    Point { id: 82, byte_name: "PoppyRawByte082", typed_name: "PoppyRawTyped082", configuration: "33554432:PoppyPublic082:50331648", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f74c6d46ff00d7a, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 46137344, cache_bytes: 4194304, probes: 5 },
    Point { id: 83, byte_name: "PoppyRawByte083", typed_name: "PoppyRawTyped083", configuration: "33554432:PoppyPublic083:67096576", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f48604346c46ab0, policy: poppy_filters::OptLevel::Best, policy_name: "best", bucket_bytes: 62902272, cache_bytes: 4194304, probes: 7 },
];
pub fn by_id(id: usize) -> &'static Point {
    POINTS.iter().find(|p| p.id == id).expect("frozen Poppy constructor ID")
}
pub fn by_name(name: &str) -> Option<(&'static Point, bool)> {
    POINTS.iter().find_map(|p| if name == p.byte_name { Some((p, false)) }
        else if name == p.typed_name { Some((p, true)) } else { None })
}
pub fn metadata_csv(name: &str) -> String {
    if let Some((p, _)) = by_name(name) {
        format!("{},{:016x},{},{},{}", p.policy_name, p.fpp_bits, p.bucket_bytes, p.cache_bytes, p.configuration)
    } else { ",,,,".to_string() }
}
