#include "fast_pattern_BF.h"
#include <array>
#include <stdexcept>
int main() {
	for (auto bpk : {4u, 16u}) {
		bloom_filters::FastPatternBF filter(1000, bpk);
		std::array<uint64_t, 1000> hashes;
		for (size_t i = 0; i < hashes.size(); ++i)
			hashes[i] = bloom_filters::MurmurHash64(i);
		filter.Insert(hashes.size(), hashes.data());
		std::array<uint32_t, 1000> out;
		const auto copy = filter;
		copy.Lookup(hashes.size(), hashes.data(), out.data());
		for (auto x : out)
			if (x != 1)
				throw std::runtime_error("portable false negative");
	}
}
