#pragma once
#include "base.h"
#include <algorithm>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>
#if defined(__AVX512F__)
#include <immintrin.h>
#endif

// Experimental widened split-block filter: the public Parquet/Impala multiply-
// shift construction, but eight 64-bit sectors instead of eight 32-bit sectors.
// This is not a Parquet-compatible layout or a claim of a new filter family.
namespace bloom_filters {
template <size_t Prefetch>
class Split64Prototype {
	struct alignas(64) Line {
		uint64_t words[8] {};
	};
	std::vector<Line, AlignedAllocator<Line, 64>> lines_;
	uint32_t block_mask_;
	alignas(32) inline static constexpr uint32_t salts_[8] = {0x47b6137bU, 0x44974d91U, 0x8824ad5bU, 0xa2b7289dU,
	                                                          0x705495c7U, 0x2df1424bU, 0x9efc4947U, 0x5c6bfb31U};
	static size_t LineCount(size_t keys, uint32_t bpk) {
		if (!bpk || keys > std::numeric_limits<size_t>::max() / bpk)
			throw std::invalid_argument("invalid size");
		const size_t bits = std::max<size_t>(512, keys * bpk);
		if (bits >= (size_t {1} << 31))
			throw std::length_error("maximum 256 MiB");
		size_t words = 32;
		while (words <= bits / 32)
			words *= 2;
		return words / 16;
	}
	uint32_t Block(uint64_t hash) const {
		return static_cast<uint32_t>(hash >> 32) & block_mask_;
	}
#if defined(__AVX512F__)
	static __m512i Mask(uint64_t hash) {
		const __m256i positions =
		    _mm256_srli_epi32(_mm256_mullo_epi32(_mm256_set1_epi32(static_cast<uint32_t>(hash)),
			                                     _mm256_load_si256(reinterpret_cast<const __m256i *>(salts_))),
			                  26);
		return _mm512_sllv_epi64(_mm512_set1_epi64(1), _mm512_cvtepu32_epi64(positions));
	}
#endif
	void InsertOne(uint64_t hash) {
		auto &line = lines_[Block(hash)];
#if defined(__AVX512F__)
		const __m512i mask = Mask(hash);
		auto *dst = reinterpret_cast<__m512i *>(line.words);
		_mm512_store_si512(dst, _mm512_or_si512(_mm512_load_si512(dst), mask));
#else
		for (size_t j = 0; j < 8; ++j)
			line.words[j] |= uint64_t {1} << ((static_cast<uint32_t>(hash) * salts_[j]) >> 26);
#endif
	}
	uint32_t LookupOne(uint64_t hash) const {
		const auto &line = lines_[Block(hash)];
#if defined(__AVX512F__)
		return _mm512_testn_epi64_mask(_mm512_load_si512(line.words), Mask(hash)) == 0;
#else
		uint64_t missing = 0;
		for (size_t j = 0; j < 8; ++j)
			missing |= ~line.words[j] & (uint64_t {1} << ((static_cast<uint32_t>(hash) * salts_[j]) >> 26));
		return missing == 0;
#endif
	}

public:
	Split64Prototype(size_t n, uint32_t bpk) : lines_(LineCount(n, bpk)), block_mask_(lines_.size() - 1) {
	}
	size_t SizeInBytes() const {
		return lines_.size() * 64;
	}
	void Insert(uint32_t n, const uint64_t *hashes) {
		size_t i = 0;
		if constexpr (Prefetch) {
			for (; i + Prefetch < n; ++i) {
				__builtin_prefetch(&lines_[Block(hashes[i + Prefetch])], 1, 3);
				InsertOne(hashes[i]);
			}
		}
		for (; i < n; ++i)
			InsertOne(hashes[i]);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		size_t i = 0;
		if constexpr (Prefetch) {
			for (; i + Prefetch < n; ++i) {
				__builtin_prefetch(&lines_[Block(hashes[i + Prefetch])], 0, 3);
				out[i] = LookupOne(hashes[i]);
			}
		}
		for (; i < n; ++i)
			out[i] = LookupOne(hashes[i]);
		return n;
	}
};
using Split64P0 = Split64Prototype<0>;
using Split64P16 = Split64Prototype<16>;
using Split64P32 = Split64Prototype<32>;
using Split64P64 = Split64Prototype<64>;
} // namespace bloom_filters
