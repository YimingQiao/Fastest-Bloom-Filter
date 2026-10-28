#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>
#include "base.h"
#if defined(__AVX2__)
#include <immintrin.h>
#endif
#define private public
#include "before.h"
#include "after_paired4.h"
#undef private
using namespace bloom_filters;
static void Require(bool value) {
	if (!value)
		throw std::runtime_error("masked-tail bitmap/output/guard mismatch");
}
struct Reference {
	std::vector<uint32_t> words;
	std::array<uint32_t, 32> table;
	Reference(size_t n, const uint32_t *patterns) : words(n) {
		std::copy(patterns, patterns + 32, table.begin());
	}
	uint32_t Mask(uint32_t code) const {
		const uint32_t word = table[code % 32];
		const unsigned shift = (code / 32) % 32;
		return shift ? (word << shift) | (word >> (32 - shift)) : word;
	}
	std::array<size_t, 2> Index(uint64_t h) const {
		const size_t a = (h >> 32) % words.size();
		return {a, a ^ (8u + ((uint32_t(h) / (1u << 20)) % 8))};
	}
	void Insert(uint64_t h) {
		const auto indexes = Index(h);
		words[indexes[0]] |= Mask(uint32_t(h));
		words[indexes[1]] |= Mask(uint32_t(h) / 1024);
	}
	uint32_t Lookup(uint64_t h) const {
		const auto indexes = Index(h);
		const uint32_t a = Mask(uint32_t(h)), b = Mask(uint32_t(h) / 1024);
		return (words[indexes[0]] & a) == a && (words[indexes[1]] & b) == b;
	}
};
int main() {
	uint64_t checksum = 14695981039346656037ULL;
	for (size_t capacity : {size_t(0), size_t(1024), size_t(65539), size_t(1u << 20)}) {
		for (uint32_t bpk : {4u, 8u, 16u}) {
			FastPatternBeforeTailBF before(capacity, bpk);
			FastPatternPair4TailBF after(capacity, bpk);
			Reference oracle(before.blocks_.size(), before.patterns_);
			const size_t n = capacity ? 65539 : 0;
			std::vector<uint64_t> inserted(n), query(4150);
			for (size_t i = 0; i < n; ++i) {
				inserted[i] = i % 3 ? MurmurHash64(i + 731)
				                     : (uint64_t(7) << 32) | uint32_t(MurmurHash64(i / 7));
				oracle.Insert(inserted[i]);
			}
			before.Insert(n, inserted.data());
			after.Insert(n, inserted.data());
			Require(before.SizeInBytes() == after.SizeInBytes());
			Require(before.blocks_ == after.blocks_);
			Require(std::equal(before.blocks_.begin(), before.blocks_.end(), oracle.words.begin()));
			after.Insert(n, inserted.data());
			Require(before.blocks_ == after.blocks_);
			std::vector<uint32_t> present(n);
			after.Lookup(n, inserted.data(), present.data());
			for (auto value : present)
				Require(value == 1);
			Require(before.Lookup(0, nullptr, nullptr) == 0 && after.Lookup(0, nullptr, nullptr) == 0);
			for (size_t i = 0; i < query.size(); ++i)
				query[i] = MurmurHash64(1000000007 + i);
			if (n) {
				for (size_t i = 1; i < query.size(); i += 2)
					query[i] = inserted[(i * 71) % n];
			}
			std::vector<size_t> lengths;
			for (size_t i = 0; i <= 131; ++i)
				lengths.push_back(i);
			for (size_t i = 0; i < 32; ++i)
				lengths.push_back(4096 + i);
			for (size_t count : lengths) {
				for (size_t offset = 0; offset < 8; ++offset) {
					// Exact input end checks masked loads; guards check masked stores.
					std::vector<uint64_t> tail(query.begin(), query.begin() + count + offset);
					std::vector<uint32_t> a(count + 2, 0xdeadbeef), b = a;
					Require(before.Lookup(count, tail.data() + offset, a.data() + 1) == count);
					Require(after.Lookup(count, tail.data() + offset, b.data() + 1) == count);
					Require(a == b && a.front() == 0xdeadbeef && a.back() == 0xdeadbeef);
					for (size_t i = 0; i < count; ++i) {
						Require(a[i + 1] == oracle.Lookup(tail[i + offset]));
						checksum = (checksum ^ a[i + 1]) * 1099511628211ULL;
					}
				}
			}
			Require(std::equal(before.blocks_.begin(), before.blocks_.end(), oracle.words.begin()));
			Require(before.blocks_ == after.blocks_);
		}
	}
	std::cout << "All paired4-tail scalar and full-bitmap parity checks passed: " << checksum << '\n';
}
