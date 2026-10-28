#include "current.h"
#include "probe_candidate.h"
#include <vector>
#include <stdexcept>
#include <iostream>
using namespace bloom_filters;
int main() {
	for (unsigned bpk : {4, 8, 16})
		for (unsigned n : {0, 1, 7, 8, 15, 16, 31, 255, 4096}) {
			FastPatternBF old(n, bpk);
			ProbeCandidate candidate(n, bpk);
			std::vector<uint64_t> keys(n);
			for (size_t i = 0; i < n; ++i)
				keys[i] = MurmurHash64(i * 177 + 3);
			old.Insert(n, keys.data());
			candidate.Insert(n, keys.data());
			candidate.Insert(n, keys.data());
			for (unsigned offset = 0; offset < 8; ++offset)
				for (unsigned length = 0; length < 132; ++length) {
					std::vector<uint64_t> query(offset + length);
					for (size_t i = 0; i < query.size(); ++i)
						query[i] = MurmurHash64(i * 177 + (i % 2 ? 3 : 4));
					std::vector<uint32_t> expected(length), actual(length + 2, 0xdeadbeef);
					old.Lookup(length, query.data() + offset, expected.data());
					candidate.Lookup(length, query.data() + offset, actual.data() + 1);
					if (actual.front() != 0xdeadbeef || actual.back() != 0xdeadbeef)
						throw std::runtime_error("output canary");
					for (size_t i = 0; i < length; ++i)
						if (actual[i + 1] != expected[i])
							throw std::runtime_error("wrong answer");
				}
		}
	std::cout << "exact-answer, unaligned-input, output-boundary and short-tail checks passed\n";
}
