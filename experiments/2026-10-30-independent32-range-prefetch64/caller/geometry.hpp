#pragma once
#include "fast_pattern_BF.h"
#include "adapters.hpp"
#include <iostream>
#include <string>

namespace exact_budget {
struct Geometry {
    size_t budget_bytes, allocated_bytes, logical_bytes, unit_bytes, units;
    int probes;
    const char *kind;
    const char *probe_policy = "fixed";
    size_t constructor_argument = 0;
    unsigned page_level = 0;
    uint32_t native_bpk = 0;
    const char *origin = "external";
};
template<class BF> struct Traits;
template<class BF, int Probes> struct NativeTraits {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk);
        const uint32_t arg = NativeArgument(n, budget);
        const size_t allocation = NativeBytes(n, arg);
        Geometry g{budget, allocation, allocation, 64, allocation / 64, Probes, "native_pow2_lines"};
        g.origin = "production_native";
        g.native_bpk = arg;
        g.constructor_argument = arg;
        if constexpr (Probes == 0) g.probes = n > allocation * 8 / 12 ? 6 : 8;
        if constexpr (Probes == -1) g.probe_policy = "variable_byte_mask_0_16";
        return g;
    }
    static BF Make(size_t n, uint32_t bpk) { return BF(n, Plan(n, bpk).native_bpk); }
};
template<> struct Traits<bloom_filters::FastPatternBF> : NativeTraits<bloom_filters::FastPatternBF, 0> {};
template<> struct Traits<FourSectorBloomFilter> : NativeTraits<FourSectorBloomFilter, 8> {};
template<> struct Traits<Split64BloomFilter> : NativeTraits<Split64BloomFilter, 8> {};
template<> struct Traits<ByteSplitBloomFilter> : NativeTraits<ByteSplitBloomFilter, -1> {};

template<class BF> struct ExternalMake {
    static BF Make(size_t n, uint32_t bpk) {
        (void)Traits<BF>::Plan(n, bpk);
        return BF(n, bpk);
    }
};
template<class BF, size_t Width, size_t Scale, int Probes> struct FixedTraits : ExternalMake<BF> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk), allocated = FloorUnits(budget, Width);
        Geometry g{budget, allocated, allocated, Width, allocated / Width, Probes, "fixed_range_buckets"};
        g.constructor_argument = FixedArgument(budget, Width, Scale);
        if constexpr (Probes == -1) g.probe_policy = "variable_byte_mask_0_16";
        return g;
    }
};
template<> struct Traits<external_bloom::Fixed16> : FixedTraits<external_bloom::Fixed16, 16, 10, -1> {};
template<class Base> struct Traits<external_bloom::SingleShortcutV1<Base>> : ExternalMake<external_bloom::SingleShortcutV1<Base>> {
    static Geometry Plan(size_t n, uint32_t bpk) { return Traits<Base>::Plan(n, bpk); }
};
template<size_t K, class Sub, size_t Stride> struct Traits<boost_baseline::Adapter<K, Sub, Stride>>
    : ExternalMake<boost_baseline::Adapter<K, Sub, Stride>> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        using Filter = boost::bloom::filter<uint64_t, K, Sub, Stride, boost_baseline::IdentityHash,
            boost_baseline::CountingAllocator<unsigned char>>;
        using Block = typename Sub::value_type;
        constexpr size_t stride = Filter::stride;
        constexpr size_t used = boost::bloom::detail::used_value_size<Sub>::value;
        constexpr size_t alignment = stride % alignof(Block) == 0 ? std::max<size_t>(64, alignof(Block)) : 1;
        constexpr size_t overhead = alignment - 1 + sizeof(Block) - stride;
        const size_t budget = Bytes(n, bpk);
        AtLeast(budget, overhead + stride);
        const size_t range = (budget - overhead) / stride;
        const size_t logical = range * stride + used - stride;
        Geometry g{budget, range * stride + overhead, logical, stride, range,
                   static_cast<int>(K * Sub::k), "boost_range"};
        g.constructor_argument = logical * 8;
        return g;
    }
};
template<> struct Traits<Independent32BloomFilter> : NativeTraits<Independent32BloomFilter, 8> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        auto g = NativeTraits<Independent32BloomFilter, 8>::Plan(n, bpk);
        g.unit_bytes = 32; g.units = g.allocated_bytes / 32;
        g.kind = "independent32_pow2_buckets"; g.origin = "retained_project";
        return g;
    }
};
template<> struct Traits<Independent32RangeBloomFilter> : ExternalMake<Independent32RangeBloomFilter> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk), allocated = FloorUnits(AtLeast(budget, 128), 64);
        Geometry g{budget, allocated, allocated, 32, allocated / 32, 8, "independent32_range_buckets"};
        g.constructor_argument = bpk; g.origin = "project_experiment";
        return g;
    }
};
template<> struct Traits<Independent32RangePrefetch64BloomFilter>
    : ExternalMake<Independent32RangePrefetch64BloomFilter> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        return Traits<Independent32RangeBloomFilter>::Plan(n, bpk);
    }
};
} // namespace exact_budget
