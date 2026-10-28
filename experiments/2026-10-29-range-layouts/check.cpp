#include "byte_split_bloom.h"
#include "split64_bloom.h"
#include <array>
#include <cstring>
#include <iostream>
#include <numeric>
#include <type_traits>

namespace bloom_filters {
struct RangeLayoutInspector {
    template<class F> static uint8_t *data(F &f) {
        return reinterpret_cast<uint8_t *>(f.lines_.data());
    }
    template<class F> static size_t lines(const F &f) { return f.lines_.size(); }
    template<class F> static size_t owner(const F &f, uint64_t h) { return f.CacheLineIndex(h); }
};
}
using namespace bloom_filters;
static uint64_t digest = 14695981039346656037ULL;
static void require(bool value, const char *message) {
    if (!value) throw std::runtime_error(message);
}
template<class F> void rejects(F call) {
    bool rejected = false;
    try { call(); } catch (const std::exception &) { rejected = true; }
    require(rejected, "invalid size accepted");
}
static uint64_t random_word(uint64_t &state) {
    uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}
template<class F> struct Oracle;
template<> struct Oracle<ByteSplitRange> {
    static constexpr size_t width = 16;
    static std::array<uint8_t, width> mask(uint64_t h) {
        constexpr std::array<unsigned, 8> salts{0x47b5,0x4497,0x8823,0xa2b7,0x7053,0x2df1,0x9efc,0x5c6b};
        std::array<uint8_t, width> result{};
        for (size_t j = 0; j != salts.size(); ++j) {
            const unsigned value = (h >> ((j % 2) * 16)) & 65535;
            const int64_t x = int64_t(value) - (value >= 32768 ? 65536 : 0);
            const int64_t y = int64_t(salts[j]) - (salts[j] >= 32768 ? 65536 : 0);
            // Extract the signed product's high16 via its unsigned two's-complement value.
            const uint64_t high = (uint64_t(x * y) >> 16) & 65535;
            for (size_t b = 0; b != 2; ++b) {
                const unsigned control = (high >> (b * 8)) & 255;
                result[j * 2 + b] = control < 128 ? uint8_t(1u << (7 - control % 8)) : 0;
            }
        }
        return result;
    }
};
template<> struct Oracle<Split64Range> {
    static constexpr size_t width = 64;
    static std::array<uint8_t, width> mask(uint64_t h) {
        constexpr std::array<uint32_t, 8> salts{0x47b6137bU,0x44974d91U,0x8824ad5bU,0xa2b7289dU,
                                               0x705495c7U,0x2df1424bU,0x9efc4947U,0x5c6bfb31U};
        std::array<uint8_t, width> result{};
        for (size_t j = 0; j != salts.size(); ++j) {
            const uint64_t product = (uint64_t(uint32_t(h)) * salts[j]) & 0xffffffffULL;
            const unsigned position = product / (uint64_t{1} << 26);
            result[j * 8 + position / 8] = uint8_t(1u << (position % 8));
        }
        return result;
    }
};
template<class F> size_t offset(uint64_t h, size_t bytes) {
    const uint64_t count = bytes / Oracle<F>::width;
    return (uint64_t(uint32_t(h >> 32)) * count / (uint64_t{1} << 32)) * Oracle<F>::width;
}
template<class F> uint32_t answer(const std::vector<uint8_t> &bitmap, uint64_t h) {
    const auto m = Oracle<F>::mask(h);
    const size_t at = offset<F>(h, bitmap.size());
    for (size_t j = 0; j != m.size(); ++j)
        if ((bitmap[at + j] & m[j]) != m[j]) return 0;
    return 1;
}
template<class F> void check_case(size_t line_count) {
    const size_t bytes = line_count * 64;
    F bf(RangeBytes{bytes + 31});
    require(RangeLayoutInspector::lines(bf) == line_count && bf.SizeInBytes() == bytes,
            "actual byte ceiling mismatch");
    std::vector<uint8_t> bitmap(bytes);
    std::vector<uint64_t> keys;
    uint64_t state = 0xd0dcf97c47f875b1ULL + line_count;
    for (size_t i = 0; i != 2048; ++i) keys.push_back(random_word(state));
    const uint64_t buckets = bytes / Oracle<F>::width;
    for (uint64_t bucket = 0; bucket <= buckets; ++bucket) {
        const uint64_t boundary = ((bucket << 32) + buckets - 1) / buckets;
        for (const int delta : {-1, 0, 1}) {
            const int64_t high = int64_t(boundary) + delta;
            if (high < 0 || high > UINT32_MAX) continue;
            keys.push_back((uint64_t(high) << 32) | uint32_t(random_word(state)));
        }
    }
    for (const uint64_t h : keys) {
        const auto m = Oracle<F>::mask(h);
        const size_t at = offset<F>(h, bytes);
        require(RangeLayoutInspector::owner(bf, h) == at / 64, "physical owner differs");
        for (size_t j = 0; j != m.size(); ++j) bitmap[at + j] |= m[j];
    }
    for (size_t at = 0; at < keys.size(); at += 37)
        bf.Insert(std::min<size_t>(37, keys.size() - at), keys.data() + at);
    bf.Insert(17, keys.data());
    require(std::memcmp(bitmap.data(), RangeLayoutInspector::data(bf), bytes) == 0,
            "complete bitmap differs from independent scalar oracle");
    std::vector<uint32_t> present(keys.size());
    bf.Lookup(keys.size(), keys.data(), present.data());
    require(std::all_of(present.begin(), present.end(), [](uint32_t x) { return x == 1; }), "false negative");
    std::vector<uint64_t> query(4256);
    for (auto &h : query) h = random_word(state);
    for (size_t i = 1; i < query.size(); i += 2) query[i] = keys[i % keys.size()];
    std::vector<uint32_t> expected(query.size()), out(query.size() + 64);
    for (size_t i = 0; i != query.size(); ++i) expected[i] = answer<F>(bitmap, query[i]);
    for (size_t start : {size_t{0},size_t{1},size_t{7}}) {
        for (size_t len = 0; len <= 131; ++len) {
            std::fill(out.begin(), out.end(), 0xdecafbad);
            require(bf.Lookup(len, query.data() + start, out.data() + 16) == len, "return count differs");
            for (size_t i = 0; i != out.size(); ++i)
                require(out[i] == (i >= 16 && i < 16 + len ? expected[start + i - 16] : 0xdecafbad),
                        "short output or guard differs");
        }
    }
    for (size_t len : {size_t{4096},size_t{4097},size_t{4127}}) {
        std::fill(out.begin(), out.end(), 0xdecafbad);
        bf.Lookup(len, query.data() + 3, out.data() + 16);
        for (size_t i = 0; i != out.size(); ++i)
            require(out[i] == (i >= 16 && i < 16 + len ? expected[3 + i - 16] : 0xdecafbad),
                    "long output or guard differs");
    }
    bf.Lookup(0, nullptr, nullptr);
    // Removing each required probe bit must reject that key, even in a saturated bitmap.
    auto *actual = RangeLayoutInspector::data(bf);
    for (size_t k = 0; k != 24; ++k) {
        const uint64_t h = keys[k];
        const auto m = Oracle<F>::mask(h);
        const size_t at = offset<F>(h, bytes);
        for (size_t j = 0; j != m.size(); ++j) for (unsigned bit = 0; bit != 8; ++bit) {
            if (!(m[j] & (1u << bit))) continue;
            const uint8_t saved = actual[at + j];
            actual[at + j] &= uint8_t(~(1u << bit));
            uint32_t result = 2;
            bf.Lookup(1, &h, &result);
            require(result == 0, "required missing probe not detected");
            actual[at + j] = saved;
        }
    }
    for (const auto byte : bitmap) digest = (digest ^ byte) * 1099511628211ULL;
    for (const auto value : expected) digest = (digest ^ value) * 1099511628211ULL;
}
template<class F> void check() {
    for (size_t lines : {2,3,5,7,31,257,1027,4097}) check_case<F>(lines);
    F size_check(65536, 14);
    require(size_check.SizeInBytes() == 114688, "real n/bpk fitting differs");
    rejects([] { F f(RangeBytes{0}); });
    rejects([] { F f(RangeBytes{127}); });
    rejects([] { F f(RangeBytes{(size_t{1} << 28) + 1}); });
    rejects([] { F f(0, 16); });
    rejects([] { F f(65536, 0); });
    rejects([] { F f(SIZE_MAX, 32); });
    require(range_detail::LineCount(size_t{1} << 28) == size_t{1} << 22, "max geometry differs");
}
int main() {
    try {
        check<ByteSplitRange>();
        check<Split64Range>();
        std::cout << "PASS independent range bitmaps, boundaries, no-FN, missing probes, tails and guards; checksum="
                  << digest << '\n';
    } catch (const std::exception &e) { std::cerr << e.what() << '\n'; return 1; }
}
