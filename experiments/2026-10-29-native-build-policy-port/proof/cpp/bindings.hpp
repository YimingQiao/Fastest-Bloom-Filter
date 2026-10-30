#pragma once
#include "before/parallel_layout_bloom.h"
#include "before/parallel_split64_range_bloom.h"
#include "after/parallel_layout_bloom.h"
#include "after/parallel_split64_range_bloom.h"
template<bool Range, bool After> struct NativeBinding;
template<> struct NativeBinding<false,false> {
    using Type = native_before::ParallelSplit64BloomFilter;
    static Type Make(size_t bytes) { return Type(bytes / 2, 8); }
};
template<> struct NativeBinding<false,true> {
    using Type = native_after::ParallelSplit64BloomFilter;
    static Type Make(size_t bytes) { return Type(bytes / 2, 8); }
};
template<> struct NativeBinding<true,false> {
    using Type = native_before::ParallelSplit64RangeBloomFilter;
    static Type Make(size_t bytes) { return Type(native_before::RangeBytes{bytes}); }
};
template<> struct NativeBinding<true,true> {
    using Type = native_after::ParallelSplit64RangeBloomFilter;
    static Type Make(size_t bytes) { return Type(native_after::RangeBytes{bytes}); }
};
