#include "adapters.hpp"
#include <cassert>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <vector>

namespace {
void require(bool value, const char *message) {
	if (!value)
		throw std::runtime_error(message);
}
bool scalar_match(uint64_t hash, const std::vector<char> &bitmap, int probes) {
	const uint64_t product = uint64_t {static_cast<uint32_t>(hash)} * (bitmap.size() / 64);
	const size_t offset = (product >> 32) * 64;
	uint32_t h = static_cast<uint32_t>(hash >> 32);
	for (int i = 0; i < probes; ++i, h *= uint32_t {0x9e3779b9}) {
		const unsigned bit = h >> 23;
		if (!(static_cast<unsigned char>(bitmap[offset + bit / 8]) & (1u << (bit & 7))))
			return false;
	}
	return true;
}
void scalar_add(uint64_t hash, std::vector<char> &bitmap, int probes) {
	const uint64_t product = uint64_t {static_cast<uint32_t>(hash)} * (bitmap.size() / 64);
	const size_t offset = (product >> 32) * 64;
	uint32_t h = static_cast<uint32_t>(hash >> 32);
	for (int i = 0; i < probes; ++i, h *= uint32_t {0x9e3779b9}) {
		const unsigned bit = h >> 23;
		auto &byte = bitmap[offset + bit / 8];
		byte = static_cast<char>(static_cast<unsigned char>(byte) | (1u << (bit & 7)));
	}
}
template <int K>
void check() {
	using Direct = rocksdb_external::FastLocalBloom64<K, false>;
	using Bulk = rocksdb_external::FastLocalBloom64<K, true>;
	using Core = ROCKSDB_NAMESPACE::FastLocalBloomImpl;
	for (size_t n : {size_t {0}, size_t {1}, size_t {33}, size_t {65539}}) {
		for (uint32_t bpk : {4u, 8u, 16u}) {
			Direct direct(n, bpk);
			const size_t bytes = rocksdb_external::PayloadBytes(n, bpk);
			require(direct.SizeInBytes() == bytes, "allocation mismatch");
			require(direct.LogicalBytes() == bytes, "logical length mismatch");
			require(reinterpret_cast<uintptr_t>(direct.Data()) % 64 == 0, "bitmap alignment");
			require(direct.BuildScratchBytes() == 0, "direct scratch");
			if constexpr (K != 0)
				require(direct.NumProbes() == K, "fixed probe count");
			direct.Insert(0, nullptr);
			require(direct.Lookup(0, nullptr, nullptr) == 0, "empty direct lookup");
			std::vector<uint64_t> inserted(n), probes(8192);
			for (size_t i = 0; i < n; ++i) {
				const uint64_t hash = bloom_filters::MurmurHash64(i);
				// Exercise each hash half independently, plus repeated cache-line
				// writes and both endpoints of the unsigned range reduction.
				switch (i % 5) {
				case 0: inserted[i] = hash; break;
				case 1: inserted[i] = hash & 0xffffffff00000000ULL; break;
				case 2: inserted[i] = hash | 0xffffffffULL; break;
				case 3: inserted[i] = static_cast<uint32_t>(hash); break;
				default: inserted[i] = hash | 0xffffffff00000000ULL; break;
				}
			}
			for (size_t i = 0; i < probes.size(); ++i)
				probes[i] = bloom_filters::MurmurHash64(n + i);
			if (n != 0) {
				for (size_t i = 1; i < probes.size(); i += 2)
					probes[i] = inserted[i % n];
			}
			std::vector<char> reference(bytes, 0), scalar_bitmap(bytes, 0);
			for (uint64_t hash : inserted) {
				Core::AddHash(static_cast<uint32_t>(hash), static_cast<uint32_t>(hash >> 32), bytes,
				              direct.NumProbes(), reference.data());
				scalar_add(hash, scalar_bitmap, direct.NumProbes());
			}
			require(reference == scalar_bitmap, "independent scalar bitmap mismatch");
			direct.Insert(n, inserted.data());
			require(std::memcmp(reference.data(), direct.Data(), bytes) == 0, "direct bitmap mismatch");
			std::vector<uint32_t> direct_all(n);
			direct.Lookup(n, inserted.data(), direct_all.data());
			for (uint32_t answer : direct_all)
				require(answer == 1, "direct false negative");
			for (size_t batch : {1, 7, 8, 9, 31, 32, 33, 4096}) {
				Bulk bulk(n, bpk);
				bulk.Insert(0, nullptr);
				require(bulk.Lookup(0, nullptr, nullptr) == 0, "empty bulk lookup");
				require(bulk.BuildScratchBytes() == 0, "bulk heap scratch");
				for (size_t i = 0; i < n; i += batch)
					bulk.Insert(std::min(batch, n - i), inserted.data() + i);
				require(std::memcmp(reference.data(), bulk.Data(), bytes) == 0, "bulk bitmap mismatch");
				bulk.Insert(n, inserted.data());
				require(std::memcmp(reference.data(), bulk.Data(), bytes) == 0, "duplicate insert changed bitmap");
				std::vector<uint32_t> all(n);
				bulk.Lookup(n, inserted.data(), all.data());
				for (uint32_t answer : all)
					require(answer == 1, "false negative");
				std::vector<uint32_t> actual(probes.size() + 2, 0xfeed), direct_actual = actual;
				for (size_t i = 0; i < probes.size(); i += batch) {
					bulk.Lookup(std::min(batch, probes.size() - i), probes.data() + i, actual.data() + 1 + i);
					direct.Lookup(std::min(batch, probes.size() - i), probes.data() + i, direct_actual.data() + 1 + i);
				}
				require(actual == direct_actual, "direct/bulk query mismatch");
				for (size_t i = 0; i < probes.size(); ++i)
					require(actual[i + 1] == scalar_match(probes[i], reference, direct.NumProbes()), "scalar/SIMD mismatch");
				require(actual.front() == 0xfeed && actual.back() == 0xfeed, "output overrun");
			}
			Bulk bulk(n, bpk);
			bulk.Insert(n, inserted.data());
			for (size_t count = 0; count <= 131; ++count) {
				for (size_t offset = 0; offset < 8; ++offset) {
					std::vector<uint64_t> exact(probes.begin() + offset, probes.begin() + offset + count);
					std::vector<uint32_t> actual(count + 2, 0xfeed), direct_actual = actual;
					bulk.Lookup(count, exact.data(), actual.data() + 1);
					direct.Lookup(count, exact.data(), direct_actual.data() + 1);
					require(actual == direct_actual, "direct/bulk tail mismatch");
					for (size_t i = 0; i < count; ++i)
						require(actual[i + 1] == scalar_match(exact[i], reference, direct.NumProbes()), "tail mismatch");
					require(actual.front() == 0xfeed && actual.back() == 0xfeed, "tail overrun");
				}
			}
		}
	}
}
} // namespace

int main() {
	check<0>();
	check<8>();
	check<9>();
	check<14>();
	for (const auto &pair : {std::pair<uint32_t, int> {4, 5}, {8, 9}, {16, 14}})
		require(RocksDBFastLocalBloom64(1024, pair.first).NumProbes() == pair.second, "automatic probe choice");
	for (auto pair : {std::pair<size_t, uint32_t> {1, 0}, {SIZE_MAX, 2}, {size_t {1} << 27, 16}}) {
		bool threw = false;
		try {
			RocksDBFastLocalBloom64 bad(pair.first, pair.second);
		} catch (const std::exception &) {
			threw = true;
		}
		require(threw, "invalid size accepted");
	}
	std::cout << "RocksDB direct/bulk bitmaps, scalar/SIMD outputs, duplicate inserts, no false negatives and tails passed\n";
}
