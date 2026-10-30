#include "parallel_layout_bloom.h"
#include <array>
#include <iostream>
#include <stdexcept>
#include <vector>
using namespace bloom_filters;
static void Require(bool value) {
	if (!value)
		throw std::runtime_error("native layout correctness failure");
}
static uint32_t Rotate(uint32_t x, unsigned n) {
	return (x << (n & 31)) | (x >> ((-n) & 31));
}
// Independent scalar reference uses a flat bitmap for both physical layouts.
template <bool Split>
struct Reference {
	std::vector<uint64_t> bitmap;
	explicit Reference(size_t bytes) : bitmap(bytes / 8) {
	}
	std::array<size_t, 8> Bits(uint64_t h) const {
		std::array<size_t, 8> result {};
		const uint32_t hi = h >> 32, lo = h;
		if constexpr (Split) {
			constexpr uint32_t salts[] = {0x47b6137b, 0x44974d91, 0x8824ad5b, 0xa2b7289d,
			                              0x705495c7, 0x2df1424b, 0x9efc4947, 0x5c6bfb31};
			const size_t line = hi & (bitmap.size() / 8 - 1);
			for (size_t j = 0; j < 8; ++j)
				result[j] = line * 512 + j * 64 + ((lo * salts[j]) >> 26);
		} else {
			const size_t a = hi & (bitmap.size() * 2 - 1);
			const size_t words[] = {a, (a ^ 4) ^ ((hi >> 26) & 3), (a ^ 8) ^ ((hi >> 28) & 3),
			                        (a ^ 12) ^ ((hi >> 30) & 3)};
			for (size_t j = 0; j < 4; ++j) {
				const uint32_t code = Rotate(lo, 32 - j * 8);
				const unsigned shift = (code >> 4) & 31;
				result[2 * j] = words[j] * 32 + shift;
				result[2 * j + 1] = words[j] * 32 + ((shift + (code & 15) + 1) & 31);
			}
		}
		return result;
	}
	void Insert(uint64_t h) {
		for (auto b : Bits(h))
			bitmap[b / 64] |= uint64_t {1} << (b % 64);
	}
	uint32_t Contains(uint64_t h) const {
		for (auto b : Bits(h))
			if (!(bitmap[b / 64] & (uint64_t {1} << (b % 64))))
				return 0;
		return 1;
	}
};
template <class Filter, bool Split>
void Check() {
	for (size_t capacity : {size_t {0}, size_t {1024}, size_t {1} << 20}) {
		Filter filter(capacity, 16);
		Require(filter.SizeInBytes() >= 128);
		filter.Insert(0, nullptr);
		Require(filter.Lookup(0, nullptr, nullptr) == 0);
		Reference<Split> ref(filter.SizeInBytes());
		std::vector<uint64_t> keys(65539), query(131081);
		for (size_t i = 0; i < keys.size(); ++i) {
			// Include repeated hashes and severe same-line collisions.
			keys[i] = i % 3 ? MurmurHash64(i) : (uint64_t {7} << 32) | uint32_t(MurmurHash64(i / 7));
			ref.Insert(keys[i]);
		}
		for (size_t i = 0; i < keys.size(); i += 31)
			filter.Insert(std::min<size_t>(31, keys.size() - i), keys.data() + i);
		for (size_t i = 0; i < query.size(); ++i)
			query[i] = i < keys.size() ? keys[i] : MurmurHash64(i);
		std::vector<uint32_t> expected(query.size()), got(query.size());
		for (size_t i = 0; i < query.size(); ++i)
			expected[i] = ref.Contains(query[i]);
		filter.Lookup(query.size(), query.data(), got.data());
		Require(got == expected);
		for (size_t i = 0; i < keys.size(); ++i)
			Require(got[i] == 1);
		// Exact allocations catch masked-load overreads under ASan.
		for (size_t offset = 0; offset < 8; ++offset)
			for (size_t n = 0; n <= 145; ++n) {
				std::vector<uint64_t> tail(query.begin() + 65500, query.begin() + 65500 + n + offset);
				std::vector<uint32_t> out(n + offset + 1, 0xdeadbeef);
				filter.Lookup(n, tail.data() + offset, out.data() + offset);
				for (size_t j = 0; j < n; ++j)
					Require(out[j + offset] == expected[65500 + j + offset]);
				Require(out.back() == 0xdeadbeef);
				for (size_t j = 0; j < offset; ++j)
					Require(out[j] == 0xdeadbeef);
			}
		for (size_t threads : {1u, 2u, 3u, 7u}) {
			ParallelLayoutBloomFilter<Filter> parallel(capacity, 16);
			parallel.InsertParallel(0, nullptr, threads);
			parallel.LookupParallel(0, nullptr, nullptr, threads);
			parallel.InsertParallel(keys.size(), keys.data(), threads);
			parallel.LookupParallel(query.size(), query.data(), got.data(), threads);
			Require(got == expected);
			parallel.InsertParallel(keys.size(), keys.data(), threads);
			parallel.Lookup(query.size(), query.data(), got.data());
			Require(got == expected);
		}
	}
	for (unsigned mode = 0; mode < 3; ++mode) {
		bool rejected = false;
		try {
			Filter invalid(mode == 0 ? 1 : mode == 1 ? SIZE_MAX : (size_t {1} << 27), mode == 0 ? 0 : 16);
		} catch (const std::invalid_argument &) {
			rejected = mode < 2;
		} catch (const std::length_error &) {
			rejected = mode == 2;
		}
		Require(rejected);
	}
}
int main() {
	Check<FourSectorBloomFilter, false>();
	Check<Split64BloomFilter, true>();
	std::cout << "Native layout scalar references, tails, collisions and parallel ownership passed\n";
}
