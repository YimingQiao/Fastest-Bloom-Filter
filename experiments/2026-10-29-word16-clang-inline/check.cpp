#include "fast_pattern_BF.h"
#include "adapters.hpp"
#include "inline_query.hpp"
#include <algorithm>
#include <iostream>
#include <stdexcept>
#include <vector>
using namespace bloom_filters;
static void require(bool value, const char *message) {
    if (!value) throw std::runtime_error(message);
}
template <class BF>
void check_filter(const char *name) {
    constexpr size_t n = 1024;
    BF filter(n, 16);
    std::vector<uint64_t> inserted(n);
    for (size_t i = 0; i < n; ++i)
        inserted[i] = InlineRawKeyApi<BF>::value ? i + 731 : MurmurHash64(i + 731);
    filter.Insert(n, inserted.data());
    for (auto h : inserted) require(visible_single(filter, h) == 1, "inserted key missing");
    inline_single_kernel<false, BF, uint64_t>(filter, 0, nullptr, nullptr);
    inline_single_kernel<true, BF, uint64_t>(filter, 0, nullptr, nullptr);
    for (size_t offset = 0; offset < 8; ++offset) {
        std::vector<uint64_t> raw(139), prepared(139);
        for (size_t i = 0; i < raw.size(); ++i) raw[i] = ~uint64_t(i * 65537);
        for (size_t i = 1; i < raw.size(); i += 2) raw[i] = 731 + i;
        for (size_t i = 0; i < raw.size(); ++i)
            prepared[i] = InlineRawKeyApi<BF>::value ? raw[i] : MurmurHash64(raw[i]);
        for (size_t count = 0; count <= 131; ++count) {
            std::vector<uint32_t> expected(count), out(count + 2, 0xdeadbeef);
            filter.Lookup(count, prepared.data() + offset, expected.data());
            auto validate = [&] {
                require(out.front() == 0xdeadbeef && out.back() == 0xdeadbeef, "output guard");
                require(std::equal(expected.begin(), expected.end(), out.begin() + 1), "full output mismatch");
                require(std::all_of(expected.begin(), expected.end(), [](auto x) { return x <= 1; }), "not dense boolean");
            };
            inline_single_kernel<false, BF, uint64_t>(filter, count, prepared.data() + offset, out.data() + 1);
            validate();
            std::fill(out.begin() + 1, out.end() - 1, 0xabcdef);
            inline_single_kernel<true, BF, uint64_t>(filter, count, raw.data() + offset, out.data() + 1);
            validate();
        }
    }
    std::cout << name << ": full scalar/raw/batch equivalence, guards and inserted keys passed\n";
}
struct DirectDispatchProbe {
    uint32_t ScalarContains(uint64_t hash) const { return hash == 731; }
    uint32_t Lookup(uint32_t, const uint64_t *, uint32_t *) const {
        throw std::runtime_error("ScalarContains dispatch was not selected");
    }
};
static_assert(InlineHasScalarContains<Boost192ClassicK11, uint64_t>::value);
static_assert(!InlineHasScalarContains<FastPatternBF, uint64_t>::value);
int main() {
    require(visible_single(DirectDispatchProbe {}, uint64_t {731}) == 1, "direct dispatch hit");
    require(visible_single(DirectDispatchProbe {}, uint64_t {732}) == 0, "direct dispatch miss");
    check_filter<FastPatternBF>("FastPatternBF");
#define CHECK(T, H) check_filter<T>(#T)
    BF_REGISTER_EXTERNAL_FILTERS(CHECK);
#undef CHECK
}
