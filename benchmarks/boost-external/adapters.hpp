#pragma once

#include <boost/bloom.hpp>
#include <algorithm>
#include <cstdint>
#include <memory>
#include <stdexcept>
#include <type_traits>

namespace boost_baseline {

// The benchmark already supplies a uniform 64-bit hash. Marking it avalanching
// prevents Boost from silently adding its default non-avalanching hash remix.
struct IdentityHash {
	using is_avalanching = std::true_type;
	size_t operator()(uint64_t hash) const noexcept {
		return static_cast<size_t>(hash);
	}
};
static_assert(sizeof(size_t) == sizeof(uint64_t), "This prehashed adapter targets 64-bit builds");

// Count the bytes requested from the allocator, including Boost's explicit
// alignment/tail over-allocation, which capacity()/8 alone does not expose.
template <class T>
struct CountingAllocator {
	using value_type = T;
	size_t *bytes;
	explicit CountingAllocator(size_t *value) noexcept : bytes(value) {
	}
	template <class U>
	CountingAllocator(const CountingAllocator<U> &other) noexcept : bytes(other.bytes) {
	}
	T *allocate(size_t n) {
		T *p = std::allocator<T> {}.allocate(n);
		*bytes += n * sizeof(T);
		return p;
	}
	void deallocate(T *p, size_t n) noexcept {
		*bytes -= n * sizeof(T);
		std::allocator<T> {}.deallocate(p, n);
	}
	template <class U>
	bool operator==(const CountingAllocator<U> &other) const noexcept {
		return bytes == other.bytes;
	}
	template <class U>
	bool operator!=(const CountingAllocator<U> &other) const noexcept {
		return !(*this == other);
	}
};

inline size_t requested_bits(size_t n, uint32_t bpk) {
	// Match the native benchmark's legacy strict-next-power-of-two budget.
	const size_t bits = std::max<size_t>(512, n * bpk);
	size_t words = 32;
	while (words <= bits / 32)
		words *= 2;
	return words * 32;
}

template <size_t K, class Subfilter, size_t Stride = 0>
class Adapter {
	size_t allocated_ = 0;
	using Filter = boost::bloom::filter<uint64_t, K, Subfilter, Stride, IdentityHash, CountingAllocator<unsigned char>>;
	Filter filter_;
	static size_t fitting_bits(size_t n, uint32_t bpk) {
		// Exact inverse of pinned Boost 1.92 filter_core::space_for and
		// requested_range. Size the usable bitmap inside the complete budget;
		// do not allocate a trial filter or hide alignment/tail bytes.
		using Block = typename Subfilter::value_type;
		constexpr size_t stride = Filter::stride;
		constexpr size_t used = boost::bloom::detail::used_value_size<Subfilter>::value;
		constexpr size_t alignment = stride % alignof(Block) == 0 ? std::max<size_t>(64, alignof(Block)) : 1;
		constexpr size_t overhead = alignment - 1 + sizeof(Block) - stride;
		const size_t budget = requested_bits(n, bpk) / 8;
		if (budget < overhead + stride)
			throw std::invalid_argument("Boost budget too small");
		const size_t range = (budget - overhead) / stride;
		return (range * stride + used - stride) * 8;
	}

public:
	Adapter(size_t n, uint32_t bpk)
	    : filter_(fitting_bits(n, bpk), IdentityHash {}, CountingAllocator<unsigned char> {&allocated_}) {
		if (allocated_ > requested_bits(n, bpk) / 8)
			throw std::runtime_error("Boost allocation exceeded the common byte budget");
	}
	// The allocator points at this object's counter. C++17 guaranteed elision
	// supports the benchmark factory; copying/moving would require rebinding it.
	Adapter(const Adapter &) = delete;
	Adapter &operator=(const Adapter &) = delete;
	Adapter(Adapter &&) = delete;
	Adapter &operator=(Adapter &&) = delete;
	size_t SizeInBytes() const noexcept {
		return allocated_;
	}
	size_t PayloadBytes() const noexcept {
		return filter_.capacity() / 8;
	}
	void Insert(uint32_t n, const uint64_t *keys) {
		if (n == 1)
			filter_.insert(*keys);
		else if (n)
			filter_.insert(keys, keys + n);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *keys, uint32_t *out) const {
		if (n == 1)
			*out = filter_.may_contain(*keys);
		else if (n)
			filter_.may_contain(keys, keys + n, [out](const uint64_t &, bool present) mutable { *out++ = present; });
		return n;
	}
};
} // namespace boost_baseline

// Probe counts and layout are explicit in row names. No FPR-target heuristic
// chooses a favorable implementation after seeing a benchmark's timings.
using Boost192Multi32K4 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock32<4>>;
using Boost192Multi32K5 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock32<5>>;
using Boost192Multi32K6 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock32<6>>;
using Boost192Multi32K7 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock32<7>>;
using Boost192Multi32K8 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock32<8>>;
using Boost192Multi32K10 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock32<10>>;
using Boost192Multi32K12 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock32<12>>;
using Boost192Multi32K16 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock32<16>>;
using Boost192Multi64K4 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock64<4>>;
using Boost192Multi64K8 = boost_baseline::Adapter<1, boost::bloom::fast_multiblock64<8>>;
using Boost192Block64K4 = boost_baseline::Adapter<1, boost::bloom::block<uint64_t, 4>>;
using Boost192Block64K6 = boost_baseline::Adapter<1, boost::bloom::block<uint64_t, 6>>;
using Boost192Block64K8 = boost_baseline::Adapter<1, boost::bloom::block<uint64_t, 8>>;
using Boost192Block512K6 = boost_baseline::Adapter<1, boost::bloom::block<uint64_t[8], 6>>;
using Boost192Block512K8 = boost_baseline::Adapter<1, boost::bloom::block<uint64_t[8], 8>>;
using Boost192Block512K10 = boost_baseline::Adapter<1, boost::bloom::block<uint64_t[8], 10>>;
using Boost192ClassicK6 = boost_baseline::Adapter<6, boost::bloom::block<unsigned char, 1>>;
using Boost192ClassicK11 = boost_baseline::Adapter<11, boost::bloom::block<unsigned char, 1>>;
using Boost192ClassicK22 = boost_baseline::Adapter<22, boost::bloom::block<unsigned char, 1>>;

#define BF_REGISTER_BOOST_FILTERS(ADD)                                                                                 \
	ADD(Boost192Multi32K4, uint64_t);                                                                                  \
	ADD(Boost192Multi32K5, uint64_t);                                                                                  \
	ADD(Boost192Multi32K6, uint64_t);                                                                                  \
	ADD(Boost192Multi32K7, uint64_t);                                                                                  \
	ADD(Boost192Multi32K8, uint64_t);                                                                                  \
	ADD(Boost192Multi32K10, uint64_t);                                                                                 \
	ADD(Boost192Multi32K12, uint64_t);                                                                                 \
	ADD(Boost192Multi32K16, uint64_t);                                                                                 \
	ADD(Boost192Multi64K4, uint64_t);                                                                                  \
	ADD(Boost192Multi64K8, uint64_t);                                                                                  \
	ADD(Boost192Block64K4, uint64_t);                                                                                  \
	ADD(Boost192Block64K6, uint64_t);                                                                                  \
	ADD(Boost192Block64K8, uint64_t);                                                                                  \
	ADD(Boost192Block512K6, uint64_t);                                                                                 \
	ADD(Boost192Block512K8, uint64_t);                                                                                 \
	ADD(Boost192Block512K10, uint64_t);                                                                                \
	ADD(Boost192ClassicK6, uint64_t);                                                                                  \
	ADD(Boost192ClassicK11, uint64_t);                                                                                 \
	ADD(Boost192ClassicK22, uint64_t)

#ifndef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) BF_REGISTER_BOOST_FILTERS(ADD)
#endif
