#pragma once

#include <climits>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <memory>
#include <stdexcept>
#include <vector>
#include "bloom/bloom.h"
#include "bloom/simd-block.h"
#include "bloom/simd-block-fixed-fpp.h"
#include "pbf.h"
// Compile the unchanged upstream implementation in the same translation unit,
// allowing the same optimizer visibility as header-only competitors.
#include "pbf.cc"
#include "hash.cc"

namespace external_bloom {
struct IdentityHash {
	uint64_t operator()(uint64_t hash) const noexcept {
		return hash;
	}
};
// Same strict-next-power-of-two payload as the native FastPattern constructor.
inline size_t PayloadBytes(size_t keys, uint32_t bits_per_key) {
	if (!bits_per_key || keys > SIZE_MAX / bits_per_key)
		throw std::invalid_argument("invalid filter size");
	const size_t bits = std::max<size_t>(512, keys * bits_per_key);
	if (bits >= (size_t {1} << 31))
		throw std::length_error("payload exceeds native comparison capacity");
	size_t bytes = 128;
	while (bytes <= bits / 8)
		bytes *= 2;
	return bytes;
}
inline int LogBytes(size_t bytes) {
	int n = 0;
	while (bytes > 1) {
		++n;
		bytes >>= 1;
	}
	return n;
}

class SimdBlock {
	// Never move upstream owning filters: some upstream move/copy operations
	// retain the original owning pointer. C++17 direct construction is enough.
	SimdBlockFilter<IdentityHash> filter_;

public:
	SimdBlock(size_t n, uint32_t bpk) : filter_(LogBytes(PayloadBytes(n, bpk))) {
	}
	SimdBlock(const SimdBlock &) = delete;
	SimdBlock(SimdBlock &&) = delete;
	size_t SizeInBytes() const {
		return filter_.SizeInBytes();
	}
	void Insert(uint32_t n, const uint64_t *h) {
		for (size_t i = 0; i < n; ++i)
			filter_.Add(h[i]);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i)
			out[i] = filter_.Find(h[i]);
		return n;
	}
};

template <bool Bulk>
class Fixed32 {
	SimdBlockFilterFixed<IdentityHash> filter_;

public:
	Fixed32(size_t n, uint32_t bpk) : filter_(static_cast<int>(PayloadBytes(n, bpk) / 32 * 24)) {
	}
	Fixed32(const Fixed32 &) = delete;
	Fixed32(Fixed32 &&) = delete;
	size_t SizeInBytes() const {
		return filter_.SizeInBytes();
	}
	size_t BuildScratchBytes() const {
		if constexpr (Bulk)
			return (1 + SizeInBytes() / 32 / 16384) * (16384 * sizeof(uint64_t) + sizeof(int));
		return 0;
	}
	void Insert(uint32_t n, const uint64_t *h) {
		if constexpr (Bulk)
			filter_.AddAll(h, 0, n);
		else
			for (size_t i = 0; i < n; ++i)
				filter_.Add(h[i]);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i)
			out[i] = filter_.Find(h[i]);
		return n;
	}
};
class Fixed64 {
	SimdBlockFilterFixed64<IdentityHash> filter_;

public:
	Fixed64(size_t n, uint32_t bpk) : filter_(static_cast<int>(PayloadBytes(n, bpk) / 64 * 50)) {
	}
	Fixed64(const Fixed64 &) = delete;
	Fixed64(Fixed64 &&) = delete;
	size_t SizeInBytes() const {
		return filter_.SizeInBytes();
	}
	void Insert(uint32_t n, const uint64_t *h) {
		for (size_t i = 0; i < n; ++i)
			filter_.Add(h[i]);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i)
			out[i] = filter_.Find(h[i]);
		return n;
	}
};

class Fixed16 {
	SimdBlockFilterFixed16<IdentityHash> filter_;

public:
	Fixed16(size_t n, uint32_t bpk) : filter_(static_cast<int>(PayloadBytes(n, bpk) / 16 * 10)) {
	}
	Fixed16(const Fixed16 &) = delete;
	Fixed16(Fixed16 &&) = delete;
	size_t SizeInBytes() const {
		return filter_.SizeInBytes();
	}
	void Insert(uint32_t n, const uint64_t *h) {
		for (size_t i = 0; i < n; ++i)
			filter_.Add(h[i]);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i)
			out[i] = filter_.Find(h[i]);
		return n;
	}
};

template <int K, bool Branchless = false, bool Bulk = false>
class Classical {
	// Explicit K is an upstream public template argument. Constructor capacity
	// is chosen to allocate exact payload bytes; it does not cap inserted keys.
	bloomfilter::BloomFilter<uint64_t, 8, Branchless, IdentityHash, K> filter_;

public:
	Classical(size_t n, uint32_t bpk) : filter_(PayloadBytes(n, bpk)) {
	}
	Classical(const Classical &) = delete;
	Classical(Classical &&) = delete;
	size_t SizeInBytes() const {
		return filter_.SizeInBytes();
	}
	size_t BuildScratchBytes() const {
		if constexpr (Bulk) {
			const size_t words = SizeInBytes() / 8;
			if (words <= 0x3ffffff)
				return (1 + words / 32768) * (32768 * sizeof(uint32_t) + sizeof(int));
		}
		return 0;
	}
	void Insert(uint32_t n, const uint64_t *h) {
		if constexpr (Bulk)
			filter_.AddAll(h, 0, n);
		else
			for (size_t i = 0; i < n; ++i)
				filter_.Add(h[i]);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i)
			out[i] = filter_.Contain(h[i]) == bloomfilter::Ok;
		return n;
	}
};

template <unsigned K, bool Compact>
class Page {
	static unsigned Level(size_t bytes) {
		unsigned level = 8 - 8 / K;
		if constexpr (!Compact) {
			level = 12;
			for (unsigned i = 6; i < 12; ++i) {
				if (bytes < (size_t {1} << (i + 4))) {
					level = std::max(i, 8 - 8 / K);
					break;
				}
			}
		}
		while ((bytes >> level) >= pbf::kMaxPageNum)
			++level;
		return level;
	}
	pbf::PageBloomFilter<K> filter_;

public:
	static constexpr bool kRawKeyApi = true;
	Page(size_t n, uint32_t bpk)
	    : filter_(Level(PayloadBytes(n, bpk)),
		          static_cast<unsigned>(PayloadBytes(n, bpk) >> Level(PayloadBytes(n, bpk)))) {
		if (!filter_)
			throw std::invalid_argument("unsupported PageBloom capacity");
		if (filter_.data_size() != PayloadBytes(n, bpk))
			throw std::runtime_error("PageBloom payload mismatch");
	}
	size_t SizeInBytes() const {
		return filter_.data_size();
	}
	void Insert(uint32_t n, const uint64_t *raw) {
		for (size_t i = 0; i < n; ++i)
			filter_.set(reinterpret_cast<const uint8_t *>(raw + i), sizeof(uint64_t));
	}
	uint32_t Lookup(uint32_t n, const uint64_t *raw, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i)
			out[i] = filter_.test(reinterpret_cast<const uint8_t *>(raw + i), sizeof(uint64_t));
		return n;
	}
};
} // namespace external_bloom

using FastFilterSimdBlock = external_bloom::SimdBlock;
using FastFilterFixed32 = external_bloom::Fixed32<false>;
using FastFilterFixed32Bulk = external_bloom::Fixed32<true>;
using FastFilterFixed64 = external_bloom::Fixed64;
using FastFilterFixed16 = external_bloom::Fixed16;
using FastFilterClassic4 = external_bloom::Classical<4>;
using FastFilterClassic6 = external_bloom::Classical<6>;
using FastFilterClassic8 = external_bloom::Classical<8>;
using FastFilterClassic11 = external_bloom::Classical<11>;
using FastFilterClassic16 = external_bloom::Classical<16>;
using FastFilterClassic22 = external_bloom::Classical<22>;
using FastFilterClassic6Branchless = external_bloom::Classical<6, true>;
using FastFilterClassic11Branchless = external_bloom::Classical<11, true>;
using FastFilterClassic22Branchless = external_bloom::Classical<22, true>;
using FastFilterClassic6Bulk = external_bloom::Classical<6, false, true>;
using FastFilterClassic11Bulk = external_bloom::Classical<11, false, true>;
using FastFilterClassic22Bulk = external_bloom::Classical<22, false, true>;
using PageBloom4Default = external_bloom::Page<4, false>;
using PageBloom6Default = external_bloom::Page<6, false>;
using PageBloom8Default = external_bloom::Page<8, false>;
using PageBloom4Compact = external_bloom::Page<4, true>;
using PageBloom6Compact = external_bloom::Page<6, true>;
using PageBloom8Compact = external_bloom::Page<8, true>;

#define BF_REGISTER_FASTFILTER_FILTERS(ADD)                                                                            \
	ADD(FastFilterSimdBlock, uint64_t);                                                                                \
	ADD(FastFilterFixed32, uint64_t);                                                                                  \
	ADD(FastFilterFixed32Bulk, uint64_t);                                                                              \
	ADD(FastFilterFixed64, uint64_t);                                                                                  \
	ADD(FastFilterFixed16, uint64_t);                                                                                  \
	ADD(FastFilterClassic4, uint64_t);                                                                                 \
	ADD(FastFilterClassic6, uint64_t);                                                                                 \
	ADD(FastFilterClassic8, uint64_t);                                                                                 \
	ADD(FastFilterClassic11, uint64_t);                                                                                \
	ADD(FastFilterClassic16, uint64_t);                                                                                \
	ADD(FastFilterClassic22, uint64_t);                                                                                \
	ADD(FastFilterClassic6Branchless, uint64_t);                                                                       \
	ADD(FastFilterClassic11Branchless, uint64_t);                                                                      \
	ADD(FastFilterClassic22Branchless, uint64_t);                                                                      \
	ADD(FastFilterClassic6Bulk, uint64_t);                                                                             \
	ADD(FastFilterClassic11Bulk, uint64_t);                                                                            \
	ADD(FastFilterClassic22Bulk, uint64_t);                                                                            \
	ADD(PageBloom4Default, uint64_t);                                                                                  \
	ADD(PageBloom6Default, uint64_t);                                                                                  \
	ADD(PageBloom8Default, uint64_t);                                                                                  \
	ADD(PageBloom4Compact, uint64_t);                                                                                  \
	ADD(PageBloom6Compact, uint64_t);                                                                                  \
	ADD(PageBloom8Compact, uint64_t)

#ifndef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) BF_REGISTER_FASTFILTER_FILTERS(ADD)
#endif
