#pragma once
#include "budget.hpp"
#include <climits>
#include <cstdint>
#include <vector>
#include "bloom/bloom.h"
#include "bloom/simd-block-fixed-fpp.h"
namespace external_bloom {
struct IdentityHash {
	uint64_t operator()(uint64_t hash) const noexcept {
		return hash;
	}
};
// Exact ceiling is independent of the upstream family's allocation granularity.
inline size_t PayloadBytes(size_t keys, uint32_t bits_per_key) {
    return exact_budget::Bytes(keys, bits_per_key);
}
class Fixed16 {
	SimdBlockFilterFixed16<IdentityHash> filter_;

public:
	Fixed16(size_t n, uint32_t bpk) : filter_(exact_budget::FixedArgument(PayloadBytes(n, bpk), 16, 10)) {
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

// Versioned adapter-only control: give the unchanged public upstream API a
// compile-time length of one. Keep the generic row too: the two call shapes can
// trade prehashed throughput against hashing-plus-query throughput.
template <class Base>
class SingleShortcutV1 : public Base {
public:
	using Base::Base;
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		if (n == 1)
			return Base::Lookup(1, hashes, out);
		return Base::Lookup(n, hashes, out);
	}
};
} // namespace external_bloom
using FastFilterFixed16 = external_bloom::Fixed16;
using FastFilterFixed16SingleV1 = external_bloom::SingleShortcutV1<FastFilterFixed16>;
