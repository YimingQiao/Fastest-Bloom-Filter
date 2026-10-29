#include "../control.hpp"
#include "../candidate.hpp"
#include <array>
#include <iostream>
#include <stdexcept>
#include <string>
#if !defined(__AVX512F__)
#error "This focused proof must execute the changed AVX512F insertion path"
#endif

using bloom_filters::K12LineOrCandidate;
using bloom_filters::K12ScalarOrControl;
using bloom_filters::RangeBytes;

namespace {
void Need(bool ok, const char* message) {
    if (!ok) throw std::runtime_error(message);
}
uint64_t Next(uint64_t& state) {
    uint64_t x = (state += 0x9e3779b97f4a7c15ULL);
    x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9ULL;
    x = (x ^ (x >> 27)) * 0x94d049bb133111ebULL;
    return x ^ (x >> 31);
}
// Independent bit-position oracle: no vector operations, word rotation or
// production dictionary is used to construct a mask.
constexpr unsigned positions[16][3] = {
    {0,1,3}, {0,4,9}, {0,6,13}, {0,8,18},
    {0,1,12}, {0,2,15}, {0,4,16}, {0,3,8},
    {0,6,15}, {0,7,18}, {0,1,10}, {0,2,5},
    {0,4,10}, {0,7,15}, {0,1,13}, {0,3,14}
};
unsigned Field(uint32_t x, unsigned start, unsigned width) {
    unsigned result = 0;
    for (unsigned j = 0; j < width; ++j)
        result |= ((x >> ((start + j) % 32)) & 1u) << j;
    return result;
}
std::array<size_t, 4> Indices(uint64_t h, size_t lines) {
    const size_t line = ((h >> 40) * lines) / (uint64_t{1} << 24);
    const unsigned hi = static_cast<uint32_t>(h >> 32);
    std::array<size_t, 4> result{};
    for (unsigned sector = 0; sector < 4; ++sector) {
        const unsigned other = sector ? ((hi >> (2 * sector)) & 3) : 0;
        result[sector] = 16 * line + 4 * sector + ((hi & 3) ^ other);
    }
    return result;
}
std::array<uint32_t, 4> Masks(uint64_t h) {
    std::array<uint32_t, 4> masks{};
    for (unsigned sector = 0; sector < 4; ++sector) {
        const unsigned dict = Field(static_cast<uint32_t>(h), 8 * sector, 4);
        const unsigned shift = Field(static_cast<uint32_t>(h), 8 * sector + 4, 5);
        for (unsigned pos : positions[dict]) masks[sector] |= uint32_t{1} << ((pos + shift) % 32);
    }
    return masks;
}
void OracleInsert(std::vector<uint32_t>& words, size_t n, const uint64_t* h) {
    for (size_t i = 0; i < n; ++i) {
        const auto indices = Indices(h[i], words.size() / 16);
        const auto masks = Masks(h[i]);
        Need(indices[0] < indices[1] && indices[1] < indices[2] && indices[2] < indices[3], "oracle index order");
        Need(indices[3] < words.size() && indices[0] / 16 == indices[3] / 16, "oracle line bounds");
        for (unsigned j = 0; j < 4; ++j) words[indices[j]] |= masks[j];
    }
}
uint32_t OracleContains(const std::vector<uint32_t>& words, uint64_t h) {
    const auto indices = Indices(h, words.size() / 16);
    const auto masks = Masks(h);
    for (unsigned j = 0; j < 4; ++j)
        if ((words[indices[j]] & masks[j]) != masks[j]) return 0;
    return 1;
}
template<class Filter>
void Bitmap(const Filter& filter, const std::vector<uint32_t>& expected) {
    Need(filter.SizeInBytes() == expected.size() * 4, "actual allocation mismatch");
    Need((reinterpret_cast<uintptr_t>(filter.Data()) & 63) == 0, "unaligned bitmap");
    Need(std::equal(expected.begin(), expected.end(), filter.Data()), "complete bitmap mismatch");
}
template<class Filter>
void Queries(const Filter& filter, const std::vector<uint32_t>& expected, const std::vector<uint64_t>& keys) {
    Need(filter.Lookup(0, nullptr, nullptr) == 0, "zero/null lookup");
    for (uint64_t h : keys) Need(filter.ContainsHash(h), "false negative after insertion");
    std::vector<uint64_t> query = keys;
    uint64_t state = 0x082efa98ec4e6c89ULL;
    for (unsigned i = 0; i < 131; ++i) query.push_back(Next(state));
    const auto untouched = query;
    constexpr uint32_t canary = 0x96e15ba7;
    std::vector<uint32_t> out(query.size() + 32, canary);
    auto check_output = [&] {
        for (unsigned i = 0; i < 16; ++i)
            Need(out[i] == canary && out[out.size() - 1 - i] == canary, "output guard changed");
        for (size_t i = 0; i < query.size(); ++i)
            Need(out[i + 16] == OracleContains(expected, query[i]), "dense oracle mismatch");
        Need(query == untouched, "query input changed");
    };
    Need(filter.Lookup(static_cast<uint32_t>(query.size()), query.data(), out.data() + 16) == query.size(), "query count");
    check_output();
    std::fill(out.begin(), out.end(), canary);
    filter.LookupScalar(static_cast<uint32_t>(query.size()), query.data(), out.data() + 16);
    check_output();
}
template<class Filter>
void Variant(size_t bytes, const uint64_t* input, const std::vector<uint64_t>& keys,
             const std::vector<uint32_t>& expected, bool incremental) {
    Filter filter(RangeBytes{bytes});
    filter.Insert(0, nullptr);
    if (!incremental) {
        filter.Insert(static_cast<uint32_t>(keys.size()), input);
    } else {
        std::vector<uint32_t> progress(bytes / 4);
        const size_t n = keys.size();
        const std::array<size_t, 3> ends{n / 3, (n * 2) / 3, n};
        size_t begin = 0;
        for (size_t end : ends) {
            const uint64_t* p = end == begin ? nullptr : input + begin;
            filter.Insert(static_cast<uint32_t>(end - begin), p);
            OracleInsert(progress, end - begin, p);
            Bitmap(filter, progress);
            begin = end;
        }
    }
    Bitmap(filter, expected);
    Queries(filter, expected, keys);
}
uint64_t digest = 0x243f6a8885a308d3ULL;
size_t cases = 0;
void Case(size_t bytes, size_t n, unsigned offset, unsigned pattern) {
    uint64_t state = 0x13198a2e03707344ULL ^ n ^ (uint64_t{bytes} << 17) ^ pattern;
    std::vector<uint64_t> keys(n);
    for (size_t i = 0; i < n; ++i) {
        const uint64_t random = Next(state);
        if (pattern == 0) keys[i] = random;
        else if (pattern == 1) {
            // Every group of four shares the first or final allocated line.
            const uint64_t address = ((i / 4) & 1) ? 0xffffff : 0;
            keys[i] = (address << 40) | (uint64_t{static_cast<uint8_t>(i * 37)} << 32) | static_cast<uint32_t>(random);
        } else {
            keys[i] = ((i / 4) & 1) ? UINT64_MAX : 0x000000a55a5a5a5aULL;
        }
    }
    if (pattern == 0 && n) keys.front() = 0;
    if (pattern == 0 && n > 1) keys.back() = UINT64_MAX;
    constexpr uint64_t canary = 0xa5f03c965aff169bULL;
    std::vector<uint64_t> storage(n + 32, canary);
    std::copy(keys.begin(), keys.end(), storage.begin() + 8 + offset);
    const auto untouched = storage;
    const uint64_t* input = n ? storage.data() + 8 + offset : nullptr;
    std::vector<uint32_t> expected(bytes / 4);
    OracleInsert(expected, n, input);
    for (bool incremental : {false, true}) {
        Variant<K12ScalarOrControl>(bytes, input, keys, expected, incremental);
        Variant<K12LineOrCandidate>(bytes, input, keys, expected, incremental);
    }
    {
        K12ScalarOrControl scalar(RangeBytes{bytes});
        scalar.InsertScalar(static_cast<uint32_t>(n), input);
        Bitmap(scalar, expected);
        Queries(scalar, expected, keys);
    }
    Need(storage == untouched, "insertion input/guard changed");
    for (uint32_t word : expected) digest = (digest ^ word) * 0x100000001b3ULL;
    ++cases;
}
} // namespace

int main() {
    try {
        for (size_t bytes : {size_t{128}, size_t{192}})
            for (size_t n = 0; n <= 67; ++n)
                for (unsigned offset = 0; offset < 4; ++offset)
                    for (unsigned pattern = 0; pattern < 3; ++pattern)
                        Case(bytes, n, offset, pattern);
        for (size_t bytes : {size_t{262144}, size_t{262208}, size_t{2097152}, size_t{2097216}, size_t{100663296}}) {
            Case(bytes, 257, 1, 0);
            Case(bytes, 4097, 1, 1);
        }
        Need(cases == 1642, "case count changed");
        std::cout << "{\"cases\":" << cases << ",\"digest\":" << digest << ",\"complete\":true}\n";
    } catch (const std::exception& error) {
        std::cerr << error.what() << '\n';
        return 1;
    }
}
