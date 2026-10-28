#include "base.h"
#include "layout_detail.h"
#include <algorithm>
#include <array>
#include <cstring>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <thread>
#include <vector>
#if defined(__SSSE3__) && defined(__SSE4_1__)
#include <immintrin.h>
#endif
// Inspect the complete bitmap only in this standalone test translation unit.
#define private public
#include "byte_split_bloom.h"
#undef private
#include "parallel_layout_bloom.h"
#include "../experiments/2026-10-29-direct-split/direct_split.hpp"

using bloom_filters::ByteSplitBloomFilter;
using bloom_filters::MurmurHash64;
using bloom_filters::ParallelByteSplitBloomFilter;
using Frozen = direct_split_experiment::SingleShortcut<direct_split_experiment::ByteSplit128>;
static void Require(bool value, const char *message) {
	if (!value)
		throw std::runtime_error(message);
}
// Independent signed-high oracle uses division rounded toward minus infinity,
// then a literal byte-shuffle table, rather than candidate arithmetic/intrinsics.
static std::array<uint8_t, 16> ReferenceMask(uint64_t h) {
	constexpr int32_t salts[] = {18357, 17559, -30685, -23881, 28755, 11761, -24836, 23659};
	constexpr uint8_t table[] = {128, 64, 32, 16, 8, 4, 2, 1, 128, 64, 32, 16, 8, 4, 2, 1};
	std::array<uint8_t, 16> result {};
	for (unsigned lane = 0; lane < 8; ++lane) {
		int32_t value = (h >> (16 * (lane % 2))) & 65535;
		if (value >= 32768)
			value -= 65536;
		const int64_t product = int64_t(value) * salts[lane];
		const int32_t high = product >= 0 ? product / 65536 : -((-product + 65535) / 65536);
		for (unsigned byte = 0; byte < 2; ++byte) {
			const unsigned control = (static_cast<uint16_t>(high) >> (8 * byte)) & 255;
			result[lane * 2 + byte] = control < 128 ? table[control % 16] : 0;
		}
	}
	return result;
}
struct Reference {
	std::vector<uint8_t> bitmap;
	explicit Reference(size_t bytes) : bitmap(bytes) {
	}
	size_t Offset(uint64_t h) const {
		return ((h >> 32) % (bitmap.size() / 16)) * 16;
	}
	void Insert(uint64_t h) {
		const auto mask = ReferenceMask(h);
		for (size_t j = 0; j < 16; ++j)
			bitmap[Offset(h) + j] |= mask[j];
	}
	uint32_t Lookup(uint64_t h) const {
		const auto mask = ReferenceMask(h);
		for (size_t j = 0; j < 16; ++j)
			if ((bitmap[Offset(h) + j] & mask[j]) != mask[j])
				return 0;
		return 1;
	}
};
static void CheckMasks() {
	// Each signed16 lane depends on only one of the two low hash halfwords.
	// Exhausting each halfword therefore covers every possible lane control.
	for (uint64_t word = 0; word <= 65535; ++word) {
		for (uint64_t hash : {word, word << 16}) {
			const auto expected = ReferenceMask(hash);
			Require(expected == ByteSplitBloomFilter::ScalarMask(hash), "signed mask oracle mismatch");
#if defined(__SSSE3__) && defined(__SSE4_1__)
			std::array<uint8_t, 16> simd;
			_mm_storeu_si128(reinterpret_cast<__m128i *>(simd.data()), ByteSplitBloomFilter::Mask(hash));
			Require(expected == simd, "SIMD mask mismatch");
#endif
		}
	}
}
int main() {
	CheckMasks();
	uint64_t checksum = 14695981039346656037ULL;
	for (size_t capacity : {size_t {0}, size_t {1}, size_t {33}, size_t {65539}, size_t {1} << 20}) {
		for (uint32_t bpk : {4u, 8u, 16u}) {
			const size_t n = capacity ? std::min(capacity, size_t {65539}) : 0;
			std::vector<uint64_t> keys(n), queries(32771);
			for (size_t i = 0; i < n; ++i) {
				keys[i] = i % 3 ? MurmurHash64(i + 731)
				                 : (uint64_t((i / 3) % 4) << 32) | uint32_t(MurmurHash64(i / 7));
			}
			constexpr uint32_t edges[] = {0, 0x7fff, 0x8000, 0xffff, 0x80008000, 0x7fff7fff, 0xffffffff};
			for (size_t i = 0; i < std::min(n, size_t {7}); ++i)
				keys[i] = (uint64_t(UINT32_MAX) << 32) | edges[i];
			for (size_t i = 0; i < queries.size(); ++i)
				queries[i] = MurmurHash64(i + 1000000007);
			if (n) {
				for (size_t i = 1; i < queries.size(); i += 2)
					queries[i] = keys[i % n];
			}
			for (size_t batch : {1u, 8u, 31u, 4096u}) {
				ByteSplitBloomFilter filter(capacity, bpk);
				Frozen frozen(capacity, bpk);
				Reference reference(filter.SizeInBytes());
				Require(filter.SizeInBytes() == frozen.SizeInBytes(), "prototype allocation mismatch");
				Require(filter.SizeInBytes() == filter.lines_.size() * 64, "unexpected spare allocation");
				Require(reinterpret_cast<uintptr_t>(filter.lines_.data()) % 64 == 0, "line alignment");
				filter.Insert(0, nullptr);
				Require(filter.Lookup(0, nullptr, nullptr) == 0, "empty lookup");
				for (size_t i = 0; i < n; i += batch) {
					const size_t count = std::min(batch, n - i);
					filter.Insert(count, keys.data() + i);
					frozen.Insert(count, keys.data() + i);
				}
				for (uint64_t key : keys) {
					reference.Insert(key);
					Require(filter.CacheLineIndex(key) == reference.Offset(key) / 64, "physical line ownership");
				}
				Require(std::memcmp(filter.lines_.data(), reference.bitmap.data(), reference.bitmap.size()) == 0,
				        "complete scalar bitmap mismatch");
				Require(std::memcmp(filter.lines_.data(), frozen.Data(), frozen.LogicalBytes()) == 0,
				        "complete frozen bitmap mismatch");
				filter.Insert(n, keys.data());
				Require(std::memcmp(filter.lines_.data(), frozen.Data(), frozen.LogicalBytes()) == 0,
				        "duplicate changed bitmap");
				std::vector<uint32_t> inserted(n);
				filter.Lookup(n, keys.data(), inserted.data());
				for (auto answer : inserted)
					Require(answer == 1, "false negative");
				std::vector<uint32_t> expected(queries.size()), actual(queries.size()), previous(queries.size());
				for (size_t i = 0; i < queries.size(); ++i)
					expected[i] = reference.Lookup(queries[i]);
				for (size_t i = 0; i < queries.size(); i += batch) {
					const size_t count = std::min(batch, queries.size() - i);
					Require(filter.Lookup(count, queries.data() + i, actual.data() + i) == count, "query count");
					frozen.Lookup(count, queries.data() + i, previous.data() + i);
				}
				Require(actual == expected && actual == previous, "complete query parity mismatch");
				for (auto answer : actual)
					checksum = (checksum ^ answer) * 1099511628211ULL;
				if (batch != 31)
					continue;
				ByteSplitBloomFilter copy = filter;
				Require(copy.lines_.data() != filter.lines_.data(), "copy shares owned bitmap");
				Require(std::memcmp(copy.lines_.data(), frozen.Data(), frozen.LogicalBytes()) == 0, "copy bitmap");
				for (size_t offset = 0; offset < 8; ++offset) {
					for (size_t count = 0; count <= 131; ++count) {
						std::vector<uint64_t> tail(queries.begin(), queries.begin() + count + offset);
						std::vector<uint32_t> out(count + 2, 0xdeadbeef);
						filter.Lookup(count, tail.data() + offset, out.data() + 1);
						Require(out.front() == 0xdeadbeef && out.back() == 0xdeadbeef, "tail guard");
						for (size_t i = 0; i < count; ++i)
							Require(out[i + 1] == expected[i + offset], "tail output mismatch");
					}
				}
				for (size_t workers : {1u, 2u, 3u, 7u}) {
					ParallelByteSplitBloomFilter parallel(capacity, bpk);
					Require(parallel.BuildWorkers(n, workers) <= filter.CacheLineCount(), "worker line bound");
					parallel.InsertParallel(0, nullptr, workers);
					parallel.LookupParallel(0, nullptr, nullptr, workers);
					parallel.InsertParallel(n, keys.data(), workers);
					parallel.LookupParallel(queries.size(), queries.data(), actual.data(), workers);
					Require(actual == expected, "parallel construction/query mismatch");
					parallel.InsertParallel(n, keys.data(), workers);
					parallel.Lookup(queries.size(), queries.data(), actual.data());
					Require(actual == expected, "parallel duplicate mismatch");
				}
				// Concurrent immutable readers share the completed bitmap safely.
				std::thread reader([&] { filter.Lookup(queries.size(), queries.data(), previous.data()); });
				filter.Lookup(queries.size(), queries.data(), actual.data());
				reader.join();
				Require(actual == expected && previous == expected, "overlapping reader mismatch");
				Require(std::memcmp(filter.lines_.data(), frozen.Data(), frozen.LogicalBytes()) == 0, "query mutated bitmap");
			}
		}
	}
	for (const auto invalid : {std::pair<size_t, uint32_t> {1, 0}, {SIZE_MAX, 8}, {size_t {1} << 28, 8}}) {
		bool threw = false;
		try {
			ByteSplitBloomFilter filter(invalid.first, invalid.second);
		} catch (const std::exception &) {
			threw = true;
		}
		Require(threw, "invalid capacity accepted");
	}
	std::cout << "ByteSplit exact frozen/scalar bitmap and output parity, exhaustive signed masks, tails, copies and parallel ownership passed: "
	          << checksum << '\n';
}
