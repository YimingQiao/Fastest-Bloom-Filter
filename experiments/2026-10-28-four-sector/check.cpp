#define BF_FOUR_EXTERNAL_BASE 1
#define BF_FOUR_SIMD          1
#define MASK_TABLE_ENTRIES    16
#include "four_sector.h"
#include <stdexcept>
#include <vector>
template <unsigned Mode>
void check() {
	using namespace bloom_filters;
	for (const auto parameters :
	     {std::pair<uint32_t, uint32_t> {65539, 4}, {65539, 8}, {65539, 16}, {(1u << 20) + 3, 16}}) {
		const auto [n, bpk] = parameters;
		FourSectorBF<Mode> bf(n, bpk), scalar_build(n, bpk);
		std::vector<uint64_t> hashes(2 * n + 1);
		for (size_t i = 0; i < hashes.size(); ++i)
			hashes[i] = MurmurHash64(i);
		bf.Insert(n, hashes.data());
		scalar_build.InsertScalar(n, hashes.data());
		for (size_t batch : {1, 3, 4, 7, 8, 9, 15, 16, 17, 31, 64, 4096}) {
			std::vector<uint32_t> scalar(batch), vector(batch + 2, 0xdeadbeef);
			for (size_t begin = 0; begin < hashes.size(); begin += batch) {
				const uint32_t len = std::min(batch, hashes.size() - begin);
				std::fill(vector.begin(), vector.end(), 0xdeadbeef);
				scalar_build.LookupScalar(len, hashes.data() + begin, scalar.data());
				bf.Lookup(len, hashes.data() + begin, vector.data() + 1);
				for (unsigned j = 0; j < len; ++j)
					if (scalar[j] != vector[j + 1] || (begin + j < n && !vector[j + 1]))
						throw std::runtime_error("answer mismatch");
				if (vector.front() != 0xdeadbeef || vector[len + 1] != 0xdeadbeef)
					throw std::runtime_error("output overrun");
			}
		}
	}
	// Four distinct masks for one address exercise overlapping in-batch ORs;
	// exact duplicate keys and incomplete preparation groups are included too.
	for (unsigned count : {1, 3, 4, 5, 8, 15, 16, 17, 31, 32, 33, 1024}) {
		FourSectorBF<Mode> bf(1024, 8), scalar_build(1024, 8);
		std::vector<uint64_t> input(count);
		for (size_t i = 0; i < input.size(); ++i)
			input[i] = (uint64_t(0xe5000123) << 32) | uint32_t(bloom_filters::MurmurHash64(i % 7));
		bf.Insert(input.size(), input.data());
		scalar_build.InsertScalar(input.size(), input.data());
		std::vector<uint64_t> probes = input;
		for (size_t i = 0; i < 65536; ++i)
			probes.push_back((uint64_t(0xe5000123) << 32) | uint32_t(bloom_filters::MurmurHash64(i + 1000)));
		std::vector<uint32_t> a(probes.size()), b(probes.size());
		bf.Lookup(probes.size(), probes.data(), a.data());
		scalar_build.LookupScalar(probes.size(), probes.data(), b.data());
		if (a != b)
			throw std::runtime_error("collision-heavy build mismatch");
		for (unsigned i = 0; i < count; ++i)
			if (!a[i])
				throw std::runtime_error("duplicate-key false negative");
	}
}
int main() {
	check<8>();
	check<9>();
	check<10>();
	check<12>();
}
