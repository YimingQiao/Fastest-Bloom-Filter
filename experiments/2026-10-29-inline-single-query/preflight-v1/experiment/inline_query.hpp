#pragma once
#include "base.h"
#include <type_traits>
template <class BF, class = void> struct InlineRawKeyApi : std::false_type {};
template <class BF> struct InlineRawKeyApi<BF, std::void_t<decltype(BF::kRawKeyApi)>>
    : std::integral_constant<bool, BF::kRawKeyApi> {};
// This separate track exposes a constant-one public call to the optimizer.
// Only the wrapper is forced inline; assembly must verify nested public methods.
template <class BF, class Hash>
__attribute__((always_inline)) inline uint32_t visible_single(const BF &bf, Hash hash) {
    uint32_t answer;
    bf.Lookup(1, &hash, &answer);
    return answer;
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
