#pragma once
#include "base_snapshot.h"
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>
namespace bloom_filters {
// Mode 0: 3/3/3 with32-entry dictionaries; 1: 3/3/3 with64; 2: 2/3/4.
template <unsigned Mode>
class ThreeSectorBF {
	static_assert(Mode < 3, "unknown experiment mode");
	inline static constexpr uint32_t patterns2[16] = {
#include "masks2-count16.txt"
	};
	inline static constexpr uint32_t patterns3[32] = {
#include "masks3-count32.txt"
	};
	inline static constexpr uint32_t patterns3wide[64] = {
#include "masks3-count64.txt"
	};
	inline static constexpr uint32_t patterns4[32] = {
#include "masks4-count32.txt"
	};
	std::vector<uint32_t, AlignedAllocator<uint32_t, 64>> words_;
	uint32_t word_mask_;
	static uint32_t ror(uint32_t x, unsigned r) {
		return (x >> (r & 31)) | (x << ((-r) & 31));
	}
	static uint32_t rol(uint32_t x, unsigned r) {
		return (x << (r & 31)) | (x >> ((-r) & 31));
	}
	void probe(uint64_t h, uint32_t *index, uint32_t *masks) const {
		const uint32_t hi = h >> 32, lo = h;
		index[0] = hi & word_mask_;
		index[1] = (index[0] ^ 4) ^ ((hi >> 26) & 3);
		index[2] = (index[0] ^ 8) ^ ((hi >> 28) & 3);
		if constexpr (Mode == 0) {
			for (unsigned j = 0; j < 3; ++j) {
				const uint32_t code = lo >> (j * 10);
				masks[j] = rol(patterns3[code & 31], code >> 5);
			}
		} else if constexpr (Mode == 1) {
			for (unsigned j = 0; j < 3; ++j) {
				const uint32_t code = ror(lo, j * 11);
				masks[j] = rol(patterns3wide[code & 63], code >> 6);
			}
		} else {
			masks[0] = rol(patterns2[lo & 15], lo >> 4);
			masks[1] = rol(patterns3[(lo >> 9) & 31], lo >> 14);
			masks[2] = rol(patterns4[(lo >> 19) & 31], lo >> 24);
		}
	}

public:
	ThreeSectorBF(size_t n, uint32_t bpk) {
		if (!bpk || n > std::numeric_limits<size_t>::max() / bpk)
			throw std::invalid_argument("size");
		const size_t bits = std::max<size_t>(512, n * bpk);
		if (bits >= (size_t {1} << 31))
			throw std::length_error("maximum256MiB");
		size_t words = 32;
		while (words <= bits / 32)
			words *= 2;
		words_.resize(words);
		word_mask_ = words - 1;
	}
	size_t SizeInBytes() const {
		return words_.size() * 4;
	}
	void Insert(uint32_t n, const uint64_t *h) {
		for (size_t i = 0; i < n; ++i) {
			uint32_t index[3], masks[3];
			probe(h[i], index, masks);
			for (unsigned j = 0; j < 3; ++j)
				words_[index[j]] |= masks[j];
		}
	}
	uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i) {
			uint32_t index[3], masks[3];
			probe(h[i], index, masks);
			uint32_t pass = 1;
			for (unsigned j = 0; j < 3; ++j)
				pass &= (words_[index[j]] & masks[j]) == masks[j];
			out[i] = pass;
		}
		return n;
	}
};
} // namespace bloom_filters
