#include "candidate.hpp"
#include "control.hpp"
#include <algorithm>
#include <cstring>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>

using Candidate = bloom_filters::Independent32RangeBloomFilter;
using Control = bloom_filters::Independent32BloomFilter;
using bloom_filters::RangeBytes;
static void Need(bool ok, const char *why) { if (!ok) throw std::runtime_error(why); }
static uint64_t Next(uint64_t &s) {
    uint64_t x = (s += 0x9e3779b97f4a7c15ULL);
    x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9ULL;
    x = (x ^ (x >> 27)) * 0x94d049bb133111ebULL;
    return x ^ (x >> 31);
}
// Division and individual bit extraction, independent of SIMD/range shifts.
static size_t Bucket(uint64_t h, size_t bytes, bool range) {
    if (!range) return (h / (uint64_t{1} << 41)) % (bytes / 32);
    return (static_cast<unsigned __int128>(h / (uint64_t{1} << 40)) * (bytes / 32)) /
           (uint64_t{1} << 24);
}
static unsigned Position(uint64_t h, unsigned lane) {
    unsigned answer = 0;
    for (unsigned bit = 0; bit != 5; ++bit)
        if (h & (uint64_t{1} << (5 * lane + bit))) answer |= 1u << bit;
    return answer;
}
static void Add(std::vector<uint32_t> &words, uint64_t h, bool range) {
    const size_t base = Bucket(h, words.size() * 4, range) * 8;
    for (unsigned lane = 0; lane != 8; ++lane) words[base + lane] |= uint32_t{1} << Position(h, lane);
}
static uint32_t Answer(const std::vector<uint32_t> &words, uint64_t h, bool range) {
    const size_t base = Bucket(h, words.size() * 4, range) * 8;
    for (unsigned lane = 0; lane != 8; ++lane)
        if (!(words[base + lane] & (uint32_t{1} << Position(h, lane)))) return 0;
    return 1;
}
template<class F> static void Serial(F &filter, bool range) {
    const size_t bytes = filter.SizeInBytes();
    Need(bytes == filter.LogicalBytes() && bytes % 64 == 0, "backing/logical bytes");
    Need(reinterpret_cast<uintptr_t>(filter.Data()) % 64 == 0, "base alignment");
    std::vector<uint64_t> input;
    uint64_t state = 0x8e719b45731a5d2fULL;
    for (unsigned i = 0; i != 4096; ++i) input.push_back(Next(state));
    for (unsigned bit = 0; bit != 64; ++bit) {
        input.push_back(uint64_t{1} << bit); input.push_back(~(uint64_t{1} << bit));
    }
    input.push_back(0); input.push_back(UINT64_MAX);
    if (range) {
        const size_t count = bytes / 32;
        for (size_t bucket = 1; bucket < count; ++bucket) {
            const uint64_t edge = (bucket * (uint64_t{1} << 24) + count - 1) / count;
            for (int d : {-1, 0, 1})
                input.push_back(((edge + d) << 40) | (Next(state) & ((uint64_t{1} << 40) - 1)));
        }
    }
    const auto saved = input;
    std::vector<uint32_t> oracle(bytes / 4);
    for (auto h : input) Add(oracle, h, range);
    filter.Insert(0, nullptr);
    Need(filter.Lookup(0, nullptr, nullptr) == 0, "zero null query");
    const size_t half = input.size() / 2;
    filter.Insert(half, input.data()); filter.Insert(input.size() - half, input.data() + half);
    Need(std::memcmp(filter.Data(), oracle.data(), bytes) == 0, "complete incremental bitmap");
    filter.Insert(input.size(), input.data());
    Need(std::memcmp(filter.Data(), oracle.data(), bytes) == 0, "duplicates changed bitmap");
    for (auto h : input) {
        Need(filter.ContainsHash(h), "false negative");
        Need(filter.CacheLineIndex(h) == Bucket(h, bytes, range) / 2, "physical line index");
    }
    std::vector<uint64_t> queries(4104);
    for (auto &h : queries) h = Next(state);
    std::copy_n(input.begin(), 1024, queries.begin());
    const auto saved_queries = queries;
    for (size_t count : {0u,1u,2u,3u,4u,7u,8u,15u,16u,31u,32u,63u,64u,255u,256u,4095u,4096u,4097u}) {
        for (size_t offset : {0u,1u,7u}) {
            std::vector<uint32_t> out(count + 2, 0xdeadbeefU);
            Need(filter.Lookup(count, queries.data() + offset, out.data() + 1) == count, "dense count");
            Need(out.front() == 0xdeadbeefU && out.back() == 0xdeadbeefU, "output guard");
            for (size_t i = 0; i < count; ++i) {
                const auto expected = Answer(oracle, queries[offset + i], range);
                Need(out[i + 1] == expected, "dense output");
                Need(filter.ContainsHash(queries[offset + i]) == bool(expected), "public singleton");
            }
        }
    }
    Need(input == saved && queries == saved_queries, "input mutated");
    Need(std::memcmp(filter.Data(), oracle.data(), bytes) == 0, "query mutated bitmap");
}
static void Essential(size_t bytes) {
    Candidate filter(RangeBytes{bytes});
    auto *words = static_cast<uint32_t *>(const_cast<void *>(filter.Data()));
    for (unsigned lane = 0; lane != 8; ++lane) for (unsigned bit = 0; bit != 32; ++bit) {
        const uint64_t h = (uint64_t{0xa5c391} << 40) | (uint64_t(bit) << (lane * 5));
        const size_t base = Bucket(h, bytes, true) * 8;
        filter.Insert(1, &h);
        Need(filter.ContainsHash(h), "isolated key absent");
        words[base + lane] &= ~(uint32_t{1} << bit);
        uint32_t out[3] = {0xdeadbeefU, 0xdeadbeefU, 0xdeadbeefU};
        Need(!filter.ContainsHash(h), "missing required probe accepted");
        filter.Lookup(1, &h, out + 1);
        Need(out[1] == 0 && out[0] == 0xdeadbeefU && out[2] == 0xdeadbeefU, "required-bit dense guard");
        std::fill_n(words + base, 8, uint32_t{0});
    }
    for (size_t i = 0; i < bytes / 4; ++i) Need(words[i] == 0, "essential test escaped bucket");
}
template<class F> static void Reject(F fn) {
    bool rejected = false;
    try { fn(); } catch (const std::invalid_argument &) { rejected = true; }
    catch (const std::length_error &) { rejected = true; }
    Need(rejected, "invalid sizing accepted");
}
int main() {
    try {
#if defined(__AVX512VBMI__) && defined(__AVX512VL__) && defined(__AVX2__)
        constexpr const char *backend = "avx512vbmi-vl";
#elif defined(__AVX2__)
        constexpr const char *backend = "avx2";
#else
        constexpr const char *backend = "scalar-source";
#endif
        for (size_t lines : {2u,3u,7u,1025u}) {
            Candidate filter(RangeBytes{64 * lines}); Serial(filter, true); Essential(64 * lines);
        }
        for (uint32_t legacy_bpk : {8u,16u}) { Control filter(65536, legacy_bpk); Serial(filter, false); }
        Candidate floor(RangeBytes{255}); Need(floor.SizeInBytes() == 192, "floor complete line");
        for (size_t n : {size_t{1} << 16, size_t{1} << 25}) for (uint32_t bpk : {12u,16u,20u,24u,28u,32u}) {
            const size_t bytes = bloom_filters::range_detail::BudgetBytes(n, bpk);
            Need(bloom_filters::range_detail::LineCount(bytes) * 64 == n * bpk / 8, "pilot geometry");
        }
        Need(bloom_filters::range_detail::LineCount(size_t{1} << 28) == size_t{1} << 22, "inclusive sizing maximum");
        Reject([]{ Candidate f(RangeBytes{127}); });
        Reject([]{ Candidate f(RangeBytes{(size_t{1} << 28) + 1}); });
        Reject([]{ Candidate f(0, 16); }); Reject([]{ Candidate f(65536, 0); });
        Reject([]{ Candidate f(std::numeric_limits<size_t>::max(), 2); });
        std::cout << "PASS backend=" << backend << "; 4 candidate + 2 control constructions; 324 tail/offset calls; 1024 required-bit cases; 5 invalid sizes\n";
    } catch (const std::exception &error) { std::cerr << error.what() << '\n'; return 1; }
}
