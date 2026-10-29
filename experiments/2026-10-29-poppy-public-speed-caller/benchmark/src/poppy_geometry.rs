//! Generated literal constructors from the committed47-point source selection.
pub struct Point {
    pub id: usize, pub name: &'static str, pub n: usize, pub budget_bpk: u32,
    pub fpp_bits: u64, pub policy: poppy_filters::OptLevel,
    pub bucket_bytes: usize, pub cache_bytes: usize, pub probes: i32,
}
impl Point {
    pub fn check(&self, n: usize, bpk: u32) -> crate::geometry::Result<()> {
        if n != self.n || bpk != self.budget_bpk {
            return Err("Poppy requires its frozen real n and declared budget".into());
        }
        Ok(())
    }
}
pub const POINTS: &[Point] = &[
    Point { id: 0, name: "PoppyPublic000", n: 65536, budget_bpk: 16, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::None, bucket_bytes: 81920, cache_bytes: 0, probes: 7 },
    Point { id: 1, name: "PoppyPublic001", n: 65536, budget_bpk: 16, fpp_bits: 0x3f50624dd2f1a9fc, policy: poppy_filters::OptLevel::None, bucket_bytes: 118784, cache_bytes: 0, probes: 10 },
    Point { id: 2, name: "PoppyPublic002", n: 65536, budget_bpk: 24, fpp_bits: 0x3f1a36e2eb1c432d, policy: poppy_filters::OptLevel::None, bucket_bytes: 159744, cache_bytes: 0, probes: 14 },
    Point { id: 3, name: "PoppyPublic003", n: 65536, budget_bpk: 16, fpp_bits: 0x3f69b81aa8f3efd5, policy: poppy_filters::OptLevel::None, bucket_bytes: 98304, cache_bytes: 0, probes: 9 },
    Point { id: 4, name: "PoppyPublic004", n: 65536, budget_bpk: 16, fpp_bits: 0x3f700af669cc69fd, policy: poppy_filters::OptLevel::None, bucket_bytes: 98304, cache_bytes: 0, probes: 8 },
    Point { id: 5, name: "PoppyPublic005", n: 65536, budget_bpk: 16, fpp_bits: 0x3f3e1d20e3e93528, policy: poppy_filters::OptLevel::None, bucket_bytes: 131072, cache_bytes: 0, probes: 12 },
    Point { id: 6, name: "PoppyPublic006", n: 65536, budget_bpk: 16, fpp_bits: 0x3f400a41f1a6559f, policy: poppy_filters::OptLevel::None, bucket_bytes: 131072, cache_bytes: 0, probes: 11 },
    Point { id: 7, name: "PoppyPublic007", n: 65536, budget_bpk: 24, fpp_bits: 0x3ee4cd62e3cbd8f3, policy: poppy_filters::OptLevel::None, bucket_bytes: 196608, cache_bytes: 0, probes: 17 },
    Point { id: 8, name: "PoppyPublic008", n: 65536, budget_bpk: 32, fpp_bits: 0x3e8c71fb43d9f0bc, policy: poppy_filters::OptLevel::None, bucket_bytes: 262144, cache_bytes: 0, probes: 23 },
    Point { id: 9, name: "PoppyPublic009", n: 65536, budget_bpk: 32, fpp_bits: 0x3e90425550ba0a52, policy: poppy_filters::OptLevel::None, bucket_bytes: 262144, cache_bytes: 0, probes: 22 },
    Point { id: 20, name: "PoppyPublic020", n: 65536, budget_bpk: 24, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 131072, cache_bytes: 8192, probes: 5 },
    Point { id: 21, name: "PoppyPublic021", n: 65536, budget_bpk: 24, fpp_bits: 0x3f50624dd2f1a9fc, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 131072, cache_bytes: 8192, probes: 7 },
    Point { id: 23, name: "PoppyPublic023", n: 65536, budget_bpk: 16, fpp_bits: 0x3f95f0ab915e9aaa, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 65536, cache_bytes: 8192, probes: 4 },
    Point { id: 24, name: "PoppyPublic024", n: 65536, budget_bpk: 16, fpp_bits: 0x3fa68f49ef9dd676, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 65536, cache_bytes: 8192, probes: 3 },
    Point { id: 25, name: "PoppyPublic025", n: 65536, budget_bpk: 16, fpp_bits: 0x3fbd782c420c512a, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 65536, cache_bytes: 8192, probes: 2 },
    Point { id: 29, name: "PoppyPublic029", n: 65536, budget_bpk: 24, fpp_bits: 0x3f3e1d20e3e93528, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 131072, cache_bytes: 8192, probes: 8 },
    Point { id: 31, name: "PoppyPublic031", n: 65536, budget_bpk: 24, fpp_bits: 0x3f590f44ad05b530, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 131072, cache_bytes: 8192, probes: 6 },
    Point { id: 33, name: "PoppyPublic033", n: 65536, budget_bpk: 24, fpp_bits: 0x3f855e85064e2ceb, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 131072, cache_bytes: 8192, probes: 4 },
    Point { id: 39, name: "PoppyPublic039", n: 65536, budget_bpk: 16, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::Best, bucket_bytes: 81920, cache_bytes: 8192, probes: 5 },
    Point { id: 40, name: "PoppyPublic040", n: 65536, budget_bpk: 16, fpp_bits: 0x3f50624dd2f1a9fc, policy: poppy_filters::OptLevel::Best, bucket_bytes: 118784, cache_bytes: 8192, probes: 7 },
    Point { id: 41, name: "PoppyPublic041", n: 65536, budget_bpk: 24, fpp_bits: 0x3f1a36e2eb1c432d, policy: poppy_filters::OptLevel::Best, bucket_bytes: 159744, cache_bytes: 8192, probes: 9 },
    Point { id: 42, name: "PoppyPublic042", n: 65536, budget_bpk: 16, fpp_bits: 0x3f74c6d46ff00d7a, policy: poppy_filters::OptLevel::Best, bucket_bytes: 90112, cache_bytes: 8192, probes: 5 },
    Point { id: 43, name: "PoppyPublic043", n: 65536, budget_bpk: 16, fpp_bits: 0x3f48604346c46ab0, policy: poppy_filters::OptLevel::Best, bucket_bytes: 122880, cache_bytes: 8192, probes: 7 },
    Point { id: 44, name: "PoppyPublic044", n: 65536, budget_bpk: 24, fpp_bits: 0x3ef0c18cafbc307f, policy: poppy_filters::OptLevel::Best, bucket_bytes: 188416, cache_bytes: 8192, probes: 11 },
    Point { id: 45, name: "PoppyPublic045", n: 65536, budget_bpk: 32, fpp_bits: 0x3e974cb1d803a425, policy: poppy_filters::OptLevel::Best, bucket_bytes: 253952, cache_bytes: 8192, probes: 14 },
    Point { id: 46, name: "PoppyPublic046", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::None, bucket_bytes: 40210432, cache_bytes: 0, probes: 7 },
    Point { id: 47, name: "PoppyPublic047", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f50624dd2f1a9fc, policy: poppy_filters::OptLevel::None, bucket_bytes: 60309504, cache_bytes: 0, probes: 10 },
    Point { id: 48, name: "PoppyPublic048", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f1a36e2eb1c432d, policy: poppy_filters::OptLevel::None, bucket_bytes: 80420864, cache_bytes: 0, probes: 14 },
    Point { id: 49, name: "PoppyPublic049", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f69b81aa8f3efd5, policy: poppy_filters::OptLevel::None, bucket_bytes: 50327552, cache_bytes: 0, probes: 9 },
    Point { id: 50, name: "PoppyPublic050", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f3e1d20e3e93528, policy: poppy_filters::OptLevel::None, bucket_bytes: 67108864, cache_bytes: 0, probes: 12 },
    Point { id: 51, name: "PoppyPublic051", n: 33554432, budget_bpk: 24, fpp_bits: 0x3ee4cd62e3cbd8f3, policy: poppy_filters::OptLevel::None, bucket_bytes: 100618240, cache_bytes: 0, probes: 17 },
    Point { id: 52, name: "PoppyPublic052", n: 33554432, budget_bpk: 32, fpp_bits: 0x3e8c71fb43d9f0bc, policy: poppy_filters::OptLevel::None, bucket_bytes: 134217728, cache_bytes: 0, probes: 23 },
    Point { id: 60, name: "PoppyPublic060", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 67108864, cache_bytes: 4194304, probes: 5 },
    Point { id: 61, name: "PoppyPublic061", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f50624dd2f1a9fc, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 67108864, cache_bytes: 4194304, probes: 7 },
    Point { id: 63, name: "PoppyPublic063", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f95f0ab915e9aaa, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 33554432, cache_bytes: 4194304, probes: 4 },
    Point { id: 64, name: "PoppyPublic064", n: 33554432, budget_bpk: 16, fpp_bits: 0x3fa68f49ef9dd676, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 33554432, cache_bytes: 4194304, probes: 3 },
    Point { id: 65, name: "PoppyPublic065", n: 33554432, budget_bpk: 16, fpp_bits: 0x3fbd782c420c512a, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 33554432, cache_bytes: 4194304, probes: 2 },
    Point { id: 69, name: "PoppyPublic069", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f3e1d20e3e93528, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 67108864, cache_bytes: 4194304, probes: 8 },
    Point { id: 71, name: "PoppyPublic071", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f590f44ad05b530, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 67108864, cache_bytes: 4194304, probes: 6 },
    Point { id: 73, name: "PoppyPublic073", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f855e85064e2ceb, policy: poppy_filters::OptLevel::Speed, bucket_bytes: 67108864, cache_bytes: 4194304, probes: 4 },
    Point { id: 79, name: "PoppyPublic079", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f847ae147ae147b, policy: poppy_filters::OptLevel::Best, bucket_bytes: 40210432, cache_bytes: 4194304, probes: 5 },
    Point { id: 80, name: "PoppyPublic080", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f50624dd2f1a9fc, policy: poppy_filters::OptLevel::Best, bucket_bytes: 60309504, cache_bytes: 4194304, probes: 7 },
    Point { id: 81, name: "PoppyPublic081", n: 33554432, budget_bpk: 24, fpp_bits: 0x3f1a36e2eb1c432d, policy: poppy_filters::OptLevel::Best, bucket_bytes: 80420864, cache_bytes: 4194304, probes: 9 },
    Point { id: 82, name: "PoppyPublic082", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f74c6d46ff00d7a, policy: poppy_filters::OptLevel::Best, bucket_bytes: 46137344, cache_bytes: 4194304, probes: 5 },
    Point { id: 83, name: "PoppyPublic083", n: 33554432, budget_bpk: 16, fpp_bits: 0x3f48604346c46ab0, policy: poppy_filters::OptLevel::Best, bucket_bytes: 62902272, cache_bytes: 4194304, probes: 7 },
    Point { id: 84, name: "PoppyPublic084", n: 33554432, budget_bpk: 24, fpp_bits: 0x3ef0c18cafbc307f, policy: poppy_filters::OptLevel::Best, bucket_bytes: 96448512, cache_bytes: 4194304, probes: 11 },
    Point { id: 85, name: "PoppyPublic085", n: 33554432, budget_bpk: 32, fpp_bits: 0x3e974cb1d803a425, policy: poppy_filters::OptLevel::Best, bucket_bytes: 129904640, cache_bytes: 4194304, probes: 14 },
];
pub fn by_name(name: &str) -> crate::geometry::Result<&'static Point> {
    POINTS.iter().find(|p| p.name == name).ok_or_else(|| "unknown Poppy constructor".into())
}
pub fn by_id(id: usize) -> &'static Point {
    POINTS.iter().find(|p| p.id == id).expect("frozen Poppy type ID")
}
