#include "fast_pattern_BF.h"
#include <array>
#include <stdexcept>
#include <vector>
int main() {
	for (auto bpk : {4u, 16u}) {
	  for (size_t capacity : {size_t{1000}, size_t{1} << 23}) {
		bloom_filters::FastPatternBF filter(capacity, bpk);
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
		filter.Insert(0, nullptr);
		if (filter.Lookup(0, nullptr, nullptr) != 0)
			throw std::runtime_error("empty lookup");
		for (size_t count = 0; count <= 145; ++count) {
			std::vector<uint64_t> tail(hashes.begin(), hashes.begin() + count);
			std::vector<uint32_t> guarded(count + 2, 0xdeadbeef);
			filter.Insert(count, tail.data());
			filter.Lookup(count, tail.data(), guarded.data() + 1);
			if (guarded.front() != 0xdeadbeef || guarded.back() != 0xdeadbeef)
				throw std::runtime_error("portable tail guard");
			for (size_t i = 1; i <= count; ++i)
				if (guarded[i] != 1) throw std::runtime_error("portable tail false negative");
		}
	  }
	}
}
