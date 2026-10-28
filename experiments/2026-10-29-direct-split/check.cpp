#include "direct_split.hpp"
#include <algorithm>
#include <cstring>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>
using namespace direct_split_experiment;
static void require(bool value, const char *message) { if (!value) throw std::runtime_error(message); }

// Independent, byte-addressed reference. Signed high multiplication is computed
// with division rounded toward minus infinity; it does not call candidate masks.
static std::array<uint8_t, 16> byte_mask(uint64_t h) {
	constexpr int32_t salt[] = {18357, 17559, -30685, -23881, 28755, 11761, -24836, 23659};
	constexpr uint8_t shuffle[] = {128, 64, 32, 16, 8, 4, 2, 1, 128, 64, 32, 16, 8, 4, 2, 1};
	std::array<uint8_t, 16> result {};
	for (unsigned lane = 0; lane < 8; ++lane) {
		int32_t value = (h >> (16 * (lane % 2))) & 0xffff;
		if (value >= 32768) value -= 65536;
		const int64_t product = int64_t(value) * salt[lane];
		const int32_t high = product >= 0 ? product / 65536 : -((-product + 65535) / 65536);
		const unsigned encoded = static_cast<uint16_t>(high);
		for (unsigned byte = 0; byte < 2; ++byte) {
			const unsigned index = (encoded >> (byte * 8)) & 255;
			result[lane * 2 + byte] = index < 128 ? shuffle[index % 16] : 0;
		}
	}
	return result;
}
template <bool Byte> struct Oracle {
	std::vector<uint8_t> bitmap;
	explicit Oracle(size_t bytes) : bitmap(bytes) {}
	size_t block(uint64_t h) const { return Byte ? ((h >> 32) & (bitmap.size() / 16 - 1)) * 16 : ((h >> 41) & (bitmap.size() / 32 - 1)) * 32; }
	void add(uint64_t h) {
		const size_t offset = block(h);
		if constexpr (Byte) {
			const auto mask = byte_mask(h);
			for (unsigned j = 0; j < 16; ++j) bitmap[offset + j] |= mask[j];
		} else {
			for (unsigned j = 0; j < 8; ++j) {
				const unsigned bit = (h / (uint64_t {1} << (j * 5))) % 32;
				bitmap[offset + j * 4 + bit / 8] |= 1u << (bit % 8);
			}
		}
	}
	uint32_t query(uint64_t h) const {
		const size_t offset = block(h);
		if constexpr (Byte) {
			const auto mask = byte_mask(h);
			for (unsigned j = 0; j < 16; ++j) if ((bitmap[offset + j] & mask[j]) != mask[j]) return 0;
		} else {
			for (unsigned j = 0; j < 8; ++j) {
				const unsigned bit = (h / (uint64_t {1} << (j * 5))) % 32;
				if (!(bitmap[offset + j * 4 + bit / 8] & (1u << (bit % 8)))) return 0;
			}
		}
		return 1;
	}
};

template <class Filter, bool Byte> static void check() {
	for (size_t n : {size_t(0), size_t(1), size_t(33), size_t(65539)}) {
		for (uint32_t bpk : {4u, 8u, 16u}) {
			std::vector<uint64_t> hashes(n);
			for (size_t i = 0; i < n; ++i) hashes[i] = bloom_filters::MurmurHash64(i + 731);
			// Adversarial low words, including the zero-mask cases in the byte algorithm.
			for (size_t i = 0; i < std::min(n, size_t(16)); ++i) hashes[i] = (i & 1 ? ~uint64_t(0) : 0) ^ (uint64_t(i) << 16);
			for (size_t batch : {size_t(1), size_t(8), size_t(31), size_t(4096)}) {
				Filter filter(n, bpk);
				Oracle<Byte> oracle(filter.LogicalBytes());
				require(filter.SizeInBytes() == filter.LogicalBytes(), "unexpected vector spare allocation");
				require(reinterpret_cast<uintptr_t>(filter.Data()) % (Byte ? 16 : 32) == 0, "alignment");
				filter.Insert(0, nullptr);
				require(filter.Lookup(0, nullptr, nullptr) == 0, "empty lookup");
				for (size_t i = 0; i < n; i += batch) filter.Insert(std::min(batch, n - i), hashes.data() + i);
				for (auto h : hashes) oracle.add(h);
				require(std::memcmp(filter.Data(), oracle.bitmap.data(), oracle.bitmap.size()) == 0, "full bitmap mismatch");
				filter.Insert(n, hashes.data());
				require(std::memcmp(filter.Data(), oracle.bitmap.data(), oracle.bitmap.size()) == 0, "duplicate changed bitmap");
				std::vector<uint32_t> inserted(n);
				require(filter.Lookup(n, hashes.data(), inserted.data()) == n, "inserted return count");
				for (auto x : inserted) require(x == 1, "false negative");
				std::vector<uint64_t> queries(4101);
				for (size_t i = 0; i < queries.size(); ++i) queries[i] = bloom_filters::MurmurHash64(i + n + 1000000007);
				if (n) for (size_t i = 1; i < queries.size(); i += 2) queries[i] = hashes[i % n];
				for (size_t count : {size_t(1), size_t(4097)}) {
					std::vector<uint32_t> out(count + 2, 0xdeadbeef);
					require(filter.Lookup(count, queries.data(), out.data() + 1) == count, "lookup return count");
					require(out.front() == 0xdeadbeef && out.back() == 0xdeadbeef, "output guard");
					for (size_t i = 0; i < count; ++i) require(out[i + 1] == oracle.query(queries[i]), "query reference mismatch");
				}
				for (size_t offset = 0; offset < 4; ++offset) for (size_t count = 0; count <= 131; ++count) {
					std::vector<uint32_t> out(count + 2, 0xdeadbeef);
					filter.Lookup(count, queries.data() + offset, out.data() + 1);
					require(out.front() == 0xdeadbeef && out.back() == 0xdeadbeef, "tail guard");
					for (size_t i = 0; i < count; ++i) require(out[i + 1] == oracle.query(queries[i + offset]), "tail reference mismatch");
				}
			}
		}
	}
	bool threw = false;
	try { Filter invalid(1, 0); } catch (const std::invalid_argument &) { threw = true; }
	require(threw, "zero bpk accepted");
	threw = false;
	try { Filter invalid(std::numeric_limits<size_t>::max(), 8); } catch (const std::invalid_argument &) { threw = true; }
	require(threw, "overflow accepted");
	threw = false;
	try { Filter invalid(size_t(1) << 28, 8); } catch (const std::length_error &) { threw = true; }
	require(threw, "oversize accepted");
}
int main() {
	check<ByteSplit128, true>();
	check<IndependentSplit32, false>();
	check<SingleShortcut<ByteSplit128>, true>();
	check<SingleShortcut<IndependentSplit32>, false>();
	std::cout << "Exact full scalar bitmap/query parity; all inserted keys; duplicate, alignment, length/offset and output-guard checks passed.\n";
}
