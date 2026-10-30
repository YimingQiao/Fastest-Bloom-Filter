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
template<> struct Traits<external_bloom::SimdBlock> : ExternalMake<external_bloom::SimdBlock> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk), allocated = FloorPower2(AtLeast(budget, 64));
        Geometry g{budget, allocated, allocated, 32, allocated / 32, 8, "simd_pow2_buckets"};
        g.constructor_argument = external_bloom::LogBytes(allocated);
        return g;
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
template<bool Bulk> struct Traits<external_bloom::Fixed32<Bulk>> : FixedTraits<external_bloom::Fixed32<Bulk>, 32, 24, 8> {};
template<> struct Traits<external_bloom::Fixed64> : FixedTraits<external_bloom::Fixed64, 64, 50, 8> {};
template<class Base> struct Traits<external_bloom::SingleShortcutV1<Base>> : ExternalMake<external_bloom::SingleShortcutV1<Base>> {
    static Geometry Plan(size_t n, uint32_t bpk) { return Traits<Base>::Plan(n, bpk); }
};
template<int K, bool Branchless, bool Bulk> struct Traits<external_bloom::Classical<K, Branchless, Bulk>>
    : ExternalMake<external_bloom::Classical<K, Branchless, Bulk>> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk), allocated = FloorUnits(budget, 8);
        Geometry g{budget, allocated, allocated, 8, allocated / 8, K, "classical_words"};
        g.constructor_argument = allocated;
        return g;
    }
};
template<unsigned K, bool Compact> struct Traits<external_bloom::Page<K, Compact>> : ExternalMake<external_bloom::Page<K, Compact>> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk);
        const unsigned level = PageLevel<K, Compact>(budget);
        const size_t unit = size_t{1} << level, count = budget / unit;
        Geometry g{budget, count * unit, count * unit, unit, count, K, "page_raw_bytes"};
        g.page_level = level;
        g.constructor_argument = count;
        return g;
    }
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
template<int K, bool Bulk> struct Traits<rocksdb_external::FastLocalBloom64<K, Bulk>>
    : ExternalMake<rocksdb_external::FastLocalBloom64<K, Bulk>> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk), allocated = FloorUnits(budget, 64);
        const int probes = K ? K : ROCKSDB_NAMESPACE::FastLocalBloomImpl::ChooseNumProbes(static_cast<int>(
            std::min<uint64_t>(uint64_t{allocated} * 8000 / n, INT_MAX)));
        Geometry g{budget, allocated, allocated, 64, allocated / 64, probes, "rocks_core_lines"};
        g.constructor_argument = allocated;
        return g;
    }
};
template<class BF, size_t Width, int Probes> struct RangeTraits : ExternalMake<BF> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk), allocation = FloorUnits(AtLeast(budget, 128), 64);
        Geometry g{budget, allocation, allocation, Width, allocation / Width, Probes, "project_range_buckets"};
        g.constructor_argument = budget;
        g.origin = "project_experiment";
        if constexpr (Probes == -1) g.probe_policy = "variable_byte_mask_0_16";
        return g;
    }
};
template<> struct Traits<ByteSplitRangeExperiment> : RangeTraits<ByteSplitRangeExperiment, 16, -1> {};
template<> struct Traits<Split64RangeExperiment> : RangeTraits<Split64RangeExperiment, 64, 8> {};
inline const char *GeometryHeader() {
    return "budget_bytes,logical_bytes,geometry_kind,unit_bytes,unit_count,effective_probes,probe_policy,constructor_argument,page_level,native_constructor_bpk,implementation_origin";
}
inline void PrintGeometry(std::ostream &out, const Geometry &g) {
    out << g.budget_bytes << ',' << g.logical_bytes << ',' << g.kind << ',' << g.unit_bytes << ',' << g.units
        << ',' << g.probes << ',' << g.probe_policy << ',' << g.constructor_argument << ',' << g.page_level << ',' << g.native_bpk << ',' << g.origin;
}
} // namespace exact_budget
