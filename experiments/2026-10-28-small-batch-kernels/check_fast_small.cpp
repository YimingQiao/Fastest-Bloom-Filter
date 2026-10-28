// Test-only access exposes bitmap words after all transitive standard headers.
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>
#include <iostream>
#include "base.h"
#if defined(__AVX2__)
#include <immintrin.h>
#endif
#define private public
#include "fast_pattern_before.h"
#include "fast_pattern_early.h"
#undef private
using namespace bloom_filters;
static void require(bool ok) {
	if (!ok)
		throw std::runtime_error("FastPattern bitmap/answer mismatch");
}
int main() {
	uint64_t checksum = 0;
	for (auto capacity : {size_t(0), size_t(1024), size_t(65539), size_t(1u << 20)}) {
		for (unsigned bpk : {4u, 8u, 16u}) {
			FastPatternBeforeSmallBF before(capacity, bpk);
			FastPatternEarlySmallBF after(capacity, bpk);
			const size_t n = capacity ? 65539 : 0;
			std::vector<uint64_t> input(n);
			for (size_t i = 0; i < n; ++i)
				input[i] = i % 3 ? MurmurHash64(i) : (uint64_t(7) << 32) | uint32_t(MurmurHash64(i / 7));
			before.Insert(n, input.data());
			after.Insert(n, input.data());
			require(before.blocks_ == after.blocks_);
			const auto bitmap = after.blocks_;
			require(before.Lookup(0, nullptr, nullptr) == 0 && after.Lookup(0, nullptr, nullptr) == 0);
			for (size_t count = 1; count <= 145; ++count) {
				std::vector<uint64_t> query(count);
				for (size_t i = 0; i < count; ++i)
					query[i] = i % 2 && n ? input[(i * 71) % n] : MurmurHash64(1000000 + i);
				std::vector<uint32_t> a(count + 2, 0xdeadbeef), b(count + 2, 0xdeadbeef);
				before.Lookup(count, query.data(), a.data() + 1);
				after.Lookup(count, query.data(), b.data() + 1);
				require(a == b);
				require(b.front() == 0xdeadbeef && b.back() == 0xdeadbeef);
				for (size_t i = 1; i <= count; ++i)
					checksum = checksum * 0x9e3779b97f4a7c15ULL + b[i];
			}
			require(after.blocks_ == bitmap && before.blocks_ == bitmap);
		}
	}
	std::cout << checksum << '\n';
}
