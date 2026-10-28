#include "baseline_snapshot.h"
#include "wide_pattern.h"
#include <vector>
#include <stdexcept>
#include <iostream>
#define MASK_COUNT (1 << DICT_BITS)
#if DICT_BITS == 6
#define BF_DENSE_DICTIONARY "masks4-count64.txt"
#else
#define BF_DENSE_DICTIONARY "masks4-count128.txt"
#endif
namespace reference {
#include "../2026-10-28-mask-sweep/entropy_filter.h"
}
int main() {
	for (unsigned bpk : {8, 16})
		for (unsigned n : {0, 1, 7, 8, 15, 16, 31, 255, 4096, 65539}) {
			reference::bloom_filters::FastPatternBF scalar(n, bpk);
			wide_pattern::Filter<DICT_BITS, USE_GATHER> vector(n, bpk);
			std::vector<uint64_t> keys(n);
			for (size_t i = 0; i < n; ++i)
				keys[i] = bloom_filters::MurmurHash64(i * 177 + 3);
			scalar.Insert(n, keys.data());
			vector.Insert(n, keys.data());
			vector.Insert(n, keys.data());
			for (unsigned offset = 0; offset < 8; ++offset)
				for (unsigned length = 0; length < 132; ++length) {
					std::vector<uint64_t> query(offset + length);
					for (size_t i = 0; i < query.size(); ++i)
						query[i] = bloom_filters::MurmurHash64(i * 177 + (i % 2 ? 3 : 4));
					std::vector<uint32_t> expected(length), actual(length + 2, 0xdeadbeef);
					scalar.Lookup(length, query.data() + offset, expected.data());
					vector.Lookup(length, query.data() + offset, actual.data() + 1);
					if (actual.front() != 0xdeadbeef || actual.back() != 0xdeadbeef)
						throw std::runtime_error("output canary");
					for (size_t i = 0; i < length; ++i)
						if (actual[i + 1] != expected[i])
							throw std::runtime_error("reference mismatch");
				}
		}
	std::cout << "independent scalar reference, unaligned-input, boundary and tail checks passed\n";
}
