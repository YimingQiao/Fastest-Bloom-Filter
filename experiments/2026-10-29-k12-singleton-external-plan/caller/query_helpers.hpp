#pragma once
#include "base.h"
#include <type_traits>
#include <utility>
template <class BF> struct InlineRawKeyApi : std::false_type {};
template <class BF, class Hash>
__attribute__((noinline)) void lookup_kernel(BF &bf, size_t n, const Hash *hashes, uint32_t *out) {
	// Legacy signatures omit const; every adapter treats inputs as read-only.
	bf.Lookup(static_cast<uint32_t>(n), const_cast<Hash *>(hashes), out);
}
template <class BF, class Hash, class = void> struct HasContainsHash : std::false_type {};
template <class BF, class Hash> struct HasContainsHash<BF, Hash,
    std::void_t<decltype(std::declval<const BF&>().ContainsHash(std::declval<Hash>()))>> : std::true_type {};
template <class BF, class Hash, class = void> struct HasScalarContains : std::false_type {};
template <class BF, class Hash> struct HasScalarContains<BF, Hash,
    std::void_t<decltype(std::declval<const BF&>().ScalarContains(std::declval<Hash>()))>> : std::true_type {};
template <class BF, class Hash>
__attribute__((always_inline)) inline uint32_t visible_single(const BF &bf, Hash hash) {
    if constexpr (HasContainsHash<BF, Hash>::value) return static_cast<uint32_t>(bf.ContainsHash(hash));
    else if constexpr (HasScalarContains<BF, Hash>::value) return static_cast<uint32_t>(bf.ScalarContains(hash));
    else { uint32_t answer; bf.Lookup(1, &hash, &answer); return answer; }
}
template <bool Raw, class BF, class Hash>
__attribute__((noinline)) void inline_single_kernel(const BF &bf, size_t count,
                                                    const uint64_t *input, uint32_t *out) {
    static_assert(std::is_same<Hash, uint64_t>::value, "this external track uses u64 inputs");
    for (size_t i = 0; i < count; ++i) {
        Hash hash = input[i];
        if constexpr (Raw && !InlineRawKeyApi<BF>::value)
            bloom_filters::HashVector(1, input + i, &hash);
        out[i] = visible_single(bf, hash);
    }
}
