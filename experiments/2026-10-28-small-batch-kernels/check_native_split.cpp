#include "native_split_before.h"
#include "native_split_single.h"
#include "native_split_after.h"
#include <algorithm>
#include <iostream>
#include <stdexcept>
#include <vector>
// Isolated test reader uses the native classes' existing friend-template declaration.
// It does not include/replace the production parallel wrapper in any library target.
namespace bloom_filters {
template <class Filter>
class ParallelLayoutBloomFilter {
public:
	static std::vector<uint64_t> Bitmap(const Filter &filter) {
		std::vector<uint64_t> words;
		for (const auto &line : filter.lines_)
			words.insert(words.end(), line.words, line.words + 8);
		return words;
	}
};
} // namespace bloom_filters
using namespace bloom_filters;
static void require(bool value) {
	if (!value)
		throw std::runtime_error("native split parity mismatch");
}
int main() {
	uint64_t checksum = 0;
	for (size_t capacity : {size_t(0), size_t(1024), size_t(65539), size_t(1u << 20)}) {
		for (unsigned bpk : {4u, 8u, 16u}) {
			NativeSplitBeforeBF a(capacity, bpk);
			NativeSplitSingleBF b(capacity, bpk);
			NativeSplitAfterBF c(capacity, bpk);
			const size_t n = capacity ? 65539 : 0;
			std::vector<uint64_t> keys(n);
			for (size_t i = 0; i < n; ++i)
				keys[i] = i % 3 ? MurmurHash64(i) : (uint64_t(7) << 32) | uint32_t(MurmurHash64(i / 7));
			a.Insert(n, keys.data());
			b.Insert(n, keys.data());
			c.Insert(n, keys.data());
			const auto bitmap = ParallelLayoutBloomFilter<NativeSplitBeforeBF>::Bitmap(a);
			require(bitmap == ParallelLayoutBloomFilter<NativeSplitSingleBF>::Bitmap(b));
			require(bitmap == ParallelLayoutBloomFilter<NativeSplitAfterBF>::Bitmap(c));
			require(a.Lookup(0, nullptr, nullptr) == 0 && b.Lookup(0, nullptr, nullptr) == 0 &&
			        c.Lookup(0, nullptr, nullptr) == 0);
			for (size_t count = 1; count <= 145; ++count) {
				for (size_t offset = 0; offset < 8; ++offset) {
					std::vector<uint64_t> input(count + offset);
					for (size_t i = 0; i < input.size(); ++i)
						input[i] = i % 2 && n ? keys[(i * 71) % n] : MurmurHash64(1000000 + i);
					std::vector<uint32_t> x(count + 2, 0xdeadbeef), y = x, z = x;
					a.Lookup(count, input.data() + offset, x.data() + 1);
					b.Lookup(count, input.data() + offset, y.data() + 1);
					c.Lookup(count, input.data() + offset, z.data() + 1);
					require(x == y && x == z);
					require(z.front() == 0xdeadbeef && z.back() == 0xdeadbeef);
					for (size_t i = 1; i <= count; ++i)
						checksum = checksum * 0x9e3779b97f4a7c15ULL + z[i];
				}
			}
			require(bitmap == ParallelLayoutBloomFilter<NativeSplitAfterBF>::Bitmap(c));
		}
	}
	std::cout << checksum << '\n';
}
