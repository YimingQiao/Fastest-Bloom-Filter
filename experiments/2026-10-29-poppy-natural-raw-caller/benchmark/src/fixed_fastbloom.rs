// Public constructor controls only; the query/build adapter bodies below match
// the retained Fastbloom017 wrapper. No upstream private kernel is accessed.
struct FastbloomFixed<const K: u32>(fastbloom::BloomFilter);
type Fastbloom017K1 = FastbloomFixed<1>;
type Fastbloom017K2 = FastbloomFixed<2>;
type Fastbloom017K3 = FastbloomFixed<3>;
type Fastbloom017K4 = FastbloomFixed<4>;
type Fastbloom017K5 = FastbloomFixed<5>;
type Fastbloom017K6 = FastbloomFixed<6>;
type Fastbloom017K7 = FastbloomFixed<7>;
type Fastbloom017K8 = FastbloomFixed<8>;
type Fastbloom017K9 = FastbloomFixed<9>;
type Fastbloom017K10 = FastbloomFixed<10>;
type Fastbloom017K11 = FastbloomFixed<11>;
type Fastbloom017K12 = FastbloomFixed<12>;

fn fixed_fastbloom_name(k: u32) -> &'static str {
    match k {
        1 => "Fastbloom017K1",
        2 => "Fastbloom017K2",
        3 => "Fastbloom017K3",
        4 => "Fastbloom017K4",
        5 => "Fastbloom017K5",
        6 => "Fastbloom017K6",
        7 => "Fastbloom017K7",
        8 => "Fastbloom017K8",
        9 => "Fastbloom017K9",
        10 => "Fastbloom017K10",
        11 => "Fastbloom017K11",
        12 => "Fastbloom017K12",
        _ => panic!("only the twelve prespecified public probe counts are supported"),
    }
}

impl<const K: u32> Filter for FastbloomFixed<K> {
    #[inline(always)]
    fn contains_hash(&self, hash: u64) -> bool {
        self.0.contains_hash(hash)
    }
    fn new(n: usize, bpk: u32) -> Result<Self, Box<dyn std::error::Error>> {
        let g = geometry::plan(fixed_fastbloom_name(K), n, bpk)?;
        let filter = fastbloom::BloomFilter::with_num_bits(g.logical_bytes * 8).hashes(K);
        assert_eq!(filter.num_bits() / 8, g.allocated_bytes);
        assert_eq!(filter.num_hashes() as i32, g.effective_probes);
        Ok(Self(filter))
    }
    fn size_in_bytes(&self) -> usize {
        self.0.num_bits() / 8
    }
    fn insert_hashes(&mut self, h: &[u64]) {
        for &hash in h {
            self.0.insert_hash(hash);
        }
    }
    fn lookup_hashes(&self, h: &[u64], out: &mut [u32]) {
        assert_eq!(h.len(), out.len());
        for (&hash, v) in h.iter().zip(out.iter_mut()) {
            *v = self.0.contains_hash(hash) as u32;
        }
    }
}

