#pragma once
#include "before/parallel_layout_bloom.h"
#include "before/parallel_split64_range_bloom.h"
#include "clone/parallel_layout_bloom.h"
#include "clone/parallel_split64_range_bloom.h"
#include "after/parallel_layout_bloom.h"
#include "after/parallel_split64_range_bloom.h"
template<bool Range,unsigned Variant> struct NativeBinding;
template<> struct NativeBinding<false,0> {
    using Type = native_before::ParallelSplit64BloomFilter;
    static Type Make(size_t bytes) { return Type(bytes / 2, 8); }
};
template<> struct NativeBinding<true,0> {
    using Type = native_before::ParallelSplit64RangeBloomFilter;
    static Type Make(size_t bytes) { return Type(native_before::RangeBytes{bytes}); }
};
template<> struct NativeBinding<false,1> {
    using Type = native_clone::ParallelSplit64BloomFilter;
    static Type Make(size_t bytes) { return Type(bytes / 2, 8); }
};
template<> struct NativeBinding<true,1> {
    using Type = native_clone::ParallelSplit64RangeBloomFilter;
    static Type Make(size_t bytes) { return Type(native_clone::RangeBytes{bytes}); }
};
template<> struct NativeBinding<false,2> {
    using Type = native_after::ParallelSplit64BloomFilter;
    static Type Make(size_t bytes) { return Type(bytes / 2, 8); }
};
template<> struct NativeBinding<true,2> {
    using Type = native_after::ParallelSplit64RangeBloomFilter;
    static Type Make(size_t bytes) { return Type(native_after::RangeBytes{bytes}); }
};
