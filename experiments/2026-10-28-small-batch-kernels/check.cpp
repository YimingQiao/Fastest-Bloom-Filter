#include "fast_pattern_before.h"
#include "fast_pattern_early.h"
#include "split64_before.hpp"
#include "split64_wide.hpp"
#include "split64_single.hpp"
#include "split64_hybrid.hpp"
#include <algorithm>
#include <iostream>
#include <stdexcept>
#include <vector>
using namespace bloom_filters;
static void require(bool x) {
	if (!x)
		throw std::runtime_error("candidate parity mismatch");
}
template <class Before, class After>
uint64_t check() {
	uint64_t checksum = 0;
	for (size_t capacity : {size_t(1024), size_t(65539), size_t((1u << 20) + 3)}) {
		std::vector<uint64_t> keys(65539), queries(131139);
		for (size_t i = 0; i < queries.size(); ++i)
			queries[i] = i % 5 ? MurmurHash64(i + 731) : (uint64_t(0xe5000123) << 32) | uint32_t(MurmurHash64(i / 7));
		std::copy_n(queries.data(), keys.size(), keys.data());
		for (unsigned bpk : {4u, 8u, 16u}) {
			Before a(capacity, bpk);
			After b(capacity, bpk);
			require(a.SizeInBytes() == b.SizeInBytes());
			a.Insert(keys.size(), keys.data());
			b.Insert(keys.size(), keys.data());
			a.Insert(keys.size(), keys.data());
			b.Insert(keys.size(), keys.data());
			for (size_t batch : {size_t(1), size_t(2), size_t(3), size_t(4), size_t(7), size_t(8), size_t(15),
			                     size_t(16), size_t(31), size_t(4096)}) {
				std::vector<uint32_t> expected(batch), actual(batch + 2);
				for (size_t begin = 0; begin < queries.size(); begin += batch) {
					const size_t count = std::min(batch, queries.size() - begin);
					std::fill(actual.begin(), actual.end(), 0xdeadbeef);
					a.Lookup(count, queries.data() + begin, expected.data());
					b.Lookup(count, queries.data() + begin, actual.data() + 1);
					require(actual.front() == 0xdeadbeef && actual[count + 1] == 0xdeadbeef);
					for (size_t j = 0; j < count; ++j) {
						require(expected[j] == actual[j + 1]);
						if (begin + j < keys.size())
							require(actual[j + 1] == 1);
						checksum = checksum * 0x9e3779b97f4a7c15ULL + actual[j + 1];
					}
				}
			}
		}
	}
	return checksum;
}
int main() {
	std::cout << check<FastPatternBeforeSmallBF, FastPatternEarlySmallBF>() << '\n';
	std::cout << check<Split64P32, Split64WideP32>() << '\n';
	std::cout << check<Split64P32, Split64SingleP32>() << '\n';
	std::cout << check<Split64P32, Split64ShortHybridP32>() << '\n';
}
