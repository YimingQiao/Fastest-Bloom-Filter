//! Public byte/iterator semantics only. No timing or FPR estimate.
use poppy_filters::{v2::BloomFilter, Error, OptLevel, Params};
use std::io::{self, Write};

const INSERTS: usize = 1031;
const QUERIES: usize = 8193;

fn mix(mut x: u64) -> u64 {
    x = (x ^ (x >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    x = (x ^ (x >> 27)).wrapping_mul(0x94d049bb133111eb);
    x ^ (x >> 31)
}

fn policy(name: &str) -> OptLevel {
    match name {
        "none" => OptLevel::None,
        "space" => OptLevel::Space,
        "speed" => OptLevel::Speed,
        "best" => OptLevel::Best,
        _ => panic!("unknown frozen policy"),
    }
}

// Compare every serialized byte while retaining just one reference payload.
// For the same-parameter None/Space alias only byte1 (public policy tag) differs.
struct EqualWriter<'a> {
    expected: &'a [u8],
    offset: usize,
    alias: bool,
}
impl Write for EqualWriter<'_> {
    fn write(&mut self, data: &[u8]) -> io::Result<usize> {
        let end = self
            .offset
            .checked_add(data.len())
            .expect("extent overflow");
        assert!(
            end <= self.expected.len(),
            "unexpected serialization extent"
        );
        for (j, &value) in data.iter().enumerate() {
            let pos = self.offset + j;
            if self.alias && pos == 1 {
                assert_eq!(value, OptLevel::None as u8);
                assert_eq!(self.expected[pos], OptLevel::Space as u8);
            } else {
                assert_eq!(value, self.expected[pos], "full byte mismatch at {pos}");
            }
        }
        self.offset = end;
        Ok(data.len())
    }
    fn flush(&mut self) -> io::Result<()> {
        Ok(())
    }
}

fn serialized(bf: &BloomFilter) -> Vec<u8> {
    let mut bytes = Vec::with_capacity(56 + bf.size_in_bytes());
    bf.write(&mut bytes).expect("public serialization failed");
    assert_eq!(bytes.len(), 56 + bf.size_in_bytes());
    bytes
}

fn equal(bf: &BloomFilter, bytes: &[u8], alias: bool) {
    let mut writer = EqualWriter {
        expected: bytes,
        offset: 0,
        alias,
    };
    bf.write(&mut writer).expect("public serialization failed");
    assert_eq!(writer.offset, bytes.len());
}

fn digest(bytes: &[u8]) -> u64 {
    bytes.iter().fold(14695981039346656037, |h, b| {
        (h ^ u64::from(*b)).wrapping_mul(1099511628211)
    })
}

fn inspect(line: &str) {
    let fields: Vec<_> = line.split('\t').collect();
    assert_eq!(fields.len(), 9);
    let id = fields[0];
    assert!(id.starts_with("poppy-") && id[6..].bytes().all(|b| b.is_ascii_digit()));
    let n: usize = fields[1].parse().unwrap();
    assert!(matches!(n, 65536 | 33554432));
    let opt = policy(fields[2]);
    let fpp_bits = u64::from_str_radix(fields[3], 16).unwrap();
    let fpp = f64::from_bits(fpp_bits);
    let expected_bytes: usize = fields[8].parse().unwrap();
    assert!(expected_bytes <= 256 * 1024 * 1024);
    let params = Params::new(n, fpp).opt(opt);
    let mut bytes_filter = params.try_into_v2().unwrap();
    let mut iter_filter = params.try_into_v2().unwrap();
    assert_eq!(bytes_filter.size_in_bytes(), expected_bytes);
    assert_eq!(iter_filter.size_in_bytes(), expected_bytes);
    assert_eq!(bytes_filter.capacity(), n);
    assert_eq!(bytes_filter.fpp().to_bits(), fpp_bits);

    let mut keys: Vec<_> = (0..INSERTS)
        .map(|i| mix(0xf17e000000000000 + i as u64))
        .collect();
    keys[..5].copy_from_slice(&[0, u64::MAX, 1 << 63, 1, u64::MAX]);
    let keys_before = keys.clone();
    let queries: Vec<_> = (0..QUERIES)
        .map(|i| {
            if i % 2 == 1 {
                keys[(i / 2) % keys.len()]
            } else {
                mix(0xe17e000000000000 + i as u64)
            }
        })
        .collect();
    let queries_before = queries.clone();
    let mut inserted_new = 0;
    for &h in &keys {
        let bytes = h.to_le_bytes();
        // The public byte-slice PoppyHash specialization retains h1 exactly.
        // Mandatory bucket xorshift and lazy secondary hash remain in the API.
        let it = BloomFilter::build_index_iter(&bytes.as_slice());
        let a = bytes_filter
            .insert_bytes(bytes)
            .expect("in-capacity public insert");
        let b = iter_filter
            .insert_iter(it)
            .expect("initialized public iterator insert");
        assert_eq!(a, b);
        inserted_new += usize::from(a);
    }
    assert_eq!(bytes_filter.count_estimate() as usize, inserted_new);
    let reference = serialized(&bytes_filter);
    equal(&iter_filter, &reference, false);
    let mut outputs = Vec::with_capacity(QUERIES * 4);
    for &h in &queries {
        let bytes = h.to_le_bytes();
        let it = BloomFilter::build_index_iter(&bytes.as_slice());
        let a = bytes_filter.contains_bytes(bytes);
        let b = iter_filter
            .contains_iter(it)
            .expect("initialized iterator query");
        assert_eq!(a, b);
        assert_eq!(a, bytes_filter.contains(&bytes.as_slice()));
        // A copied prepared iterator is reusable, and does not mutate the filter.
        assert_eq!(a, bytes_filter.contains_iter(it).unwrap());
        outputs.extend_from_slice(&u32::from(a).to_le_bytes());
    }
    for &h in &keys {
        assert!(
            bytes_filter.contains_bytes(h.to_le_bytes()),
            "false negative"
        );
        assert!(
            !bytes_filter.insert_bytes(h.to_le_bytes()).unwrap(),
            "duplicate changed bits"
        );
    }
    assert!(matches!(
        bytes_filter.contains_iter(Default::default()),
        Err(Error::UninitIter)
    ));
    assert!(matches!(
        bytes_filter.insert_iter(Default::default()),
        Err(Error::UninitIter)
    ));
    equal(&bytes_filter, &reference, false);
    drop(iter_filter);
    // None and Space differ only in their serialized flag for the same Params.
    let alias = opt == OptLevel::Space;
    if alias {
        let mut none = Params::new(n, fpp)
            .opt(OptLevel::None)
            .try_into_v2()
            .unwrap();
        for &h in &keys {
            none.insert_bytes(h.to_le_bytes()).unwrap();
        }
        equal(&none, &reference, true);
        for (i, &h) in queries.iter().enumerate() {
            assert_eq!(none.contains_bytes(h.to_le_bytes()), outputs[i * 4] != 0);
        }
    }
    bytes_filter.clear();
    assert_eq!(bytes_filter.count_estimate(), 0);
    assert_eq!(bytes_filter.count_ones(), 0);
    for &h in &keys {
        assert!(!bytes_filter.contains_bytes(h.to_le_bytes()));
    }
    assert_eq!(keys, keys_before);
    assert_eq!(queries, queries_before);
    println!("{{\"id\":\"{id}\",\"n\":{n},\"policy\":\"{}\",\"fpp_bits\":\"{fpp_bits:016x}\",\"owned_bytes\":{expected_bytes},\"fixture_inserts\":{INSERTS},\"fixture_queries\":{QUERIES},\"inserted_new\":{inserted_new},\"serialized_bytes\":{},\"serialized_fnv64\":{},\"dense_le_u32_fnv64\":{},\"full_byte_iterator_equal\":true,\"full_query_equal\":true,\"duplicate_unchanged\":true,\"uninitialized_rejected_unchanged\":true,\"none_space_alias\":{alias},\"clear_membership_empty\":true,\"timings\":false}}", fields[2], reference.len(), digest(&reference), digest(&outputs));
}

fn errors() {
    for opt in [
        OptLevel::None,
        OptLevel::Space,
        OptLevel::Speed,
        OptLevel::Best,
    ] {
        for fpp in [0.0, -1.0, 1.01, f64::NAN] {
            assert!(matches!(
                Params::new(16, fpp).opt(opt).try_into_v2(),
                Err(Error::WrongFpp(_))
            ));
        }
        let mut empty = Params::new(0, 0.01).opt(opt).try_into_v2().unwrap();
        assert!(!empty.contains_bytes(0u64.to_le_bytes()));
        assert!(matches!(
            empty.insert_bytes(0u64.to_le_bytes()),
            Err(Error::TooManyEntries)
        ));
        let mut one = Params::new(1, 0.01).opt(opt).try_into_v2().unwrap();
        assert!(one.insert_bytes(0u64.to_le_bytes()).unwrap());
        assert!(one.is_full());
        let before = serialized(&one);
        assert!(!one.insert_bytes(0u64.to_le_bytes()).unwrap());
        assert!(matches!(
            one.insert_bytes(1u64.to_le_bytes()),
            Err(Error::TooManyEntries)
        ));
        equal(&one, &before, false);
        assert!(one.contains_bytes(0u64.to_le_bytes()));
    }
    println!("{{\"error_policies\":4,\"invalid_fpp_cases\":16,\"zero_capacity_cases\":4,\"full_capacity_cases\":4,\"timings\":false}}");
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    assert_eq!(args.len(), 2, "one frozen TSV required");
    let input = std::fs::read_to_string(&args[1]).unwrap();
    let mut lines = input.lines();
    assert_eq!(
        lines.next().unwrap(),
        "id\tn\tpolicy\tfpp_bits\tcapacity\tbuckets\tcache_bytes\tprobes\tbacking_bytes"
    );
    let rows: Vec<_> = lines.collect();
    assert_eq!(rows.len(), 86);
    for line in rows {
        inspect(line);
    }
    errors();
}
