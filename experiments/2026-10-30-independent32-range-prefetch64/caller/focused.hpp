#pragma once
#include "candidate.hpp"
#include "pipeline.hpp"
#include <algorithm>
#include <array>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <vector>

namespace prefetch64_proof {
using Candidate = bloom_filters::Independent32RangePrefetch64BloomFilter;
using Control = bloom_filters::Independent32RangeBloomFilter;
static void Need(bool ok, const char *why) { if (!ok) throw std::runtime_error(why); }
static uint64_t Next(uint64_t &s) {
    uint64_t x = (s += 0x9e3779b97f4a7c15ULL);
    x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9ULL;
    x = (x ^ (x >> 27)) * 0x94d049bb133111ebULL;
    return x ^ (x >> 31);
}
static size_t Bucket(uint64_t h, size_t bytes) {
    return (static_cast<unsigned __int128>(h / (uint64_t{1} << 40)) * (bytes / 32)) /
           (uint64_t{1} << 24);
}
static unsigned Position(uint64_t h, unsigned lane) {
    unsigned p = 0;
    for (unsigned bit = 0; bit != 5; ++bit)
        if (h & (uint64_t{1} << (5 * lane + bit))) p |= 1u << bit;
    return p;
}
static uint32_t Answer(const std::vector<uint32_t> &words, uint64_t h) {
    const size_t base = Bucket(h, words.size() * 4) * 8;
    for (unsigned lane = 0; lane != 8; ++lane)
        if (!(words[base + lane] & (uint32_t{1} << Position(h, lane)))) return 0;
    return 1;
}
template<class F> static F Make(size_t lines) {
    if (lines == 1536) return F(65536, 12);
    return F(bloom_filters::RangeBytes{lines * 64 + 63});
}
template<class F> static void CheckOutput(const F &filter, const uint64_t *keys, size_t n,
                                         const std::vector<uint32_t> &oracle) {
    std::vector<uint32_t> output(n + 2, 0xdeadbeefU);
    Need(filter.Lookup(static_cast<uint32_t>(n), keys, output.data() + 1) == n, "focused dense count");
    Need(output.front() == 0xdeadbeefU && output.back() == 0xdeadbeefU, "focused output guard");
    for (size_t i = 0; i < n; ++i) {
        const uint32_t expected = Answer(oracle, keys[i]);
        Need(output[i + 1] == expected, "focused full output mismatch");
        Need(filter.ContainsHash(keys[i]) == bool(expected), "focused singleton mismatch");
    }
}
static int Run() {
#if defined(__AVX512VBMI__) && defined(__AVX512VL__) && defined(__AVX2__)
    constexpr const char *backend = "avx512vbmi-vl";
#elif defined(__AVX2__)
    constexpr const char *backend = "avx2";
#else
    throw std::runtime_error("focused proof requires the compiled AVX2 bulk path");
#endif
    constexpr std::array<size_t, 18> lengths{0,1,3,31,63,64,65,127,128,129,191,192,255,256,257,4095,4096,4097};
    size_t calls = 0, bulk = 0;
    for (size_t lines : {2u,3u,5u,1536u}) {
        auto candidate = Make<Candidate>(lines);
        auto control = Make<Control>(lines);
        const size_t bytes = lines * 64;
        Need(candidate.SizeInBytes() == bytes && control.SizeInBytes() == bytes &&
             candidate.LogicalBytes() == bytes && control.LogicalBytes() == bytes, "focused actual bytes");
        Need(reinterpret_cast<uintptr_t>(candidate.Data()) % 64 == 0 &&
             reinterpret_cast<uintptr_t>(control.Data()) % 64 == 0, "focused physical alignment");
        Need(candidate.Lookup(0, nullptr, nullptr) == 0 && control.Lookup(0, nullptr, nullptr) == 0,
             "focused zero null");
        uint64_t state = 74381;
        // Leave the upper address half empty even in the two-line fixture.
        // This guarantees mixed answers instead of relying on random sparsity.
        std::vector<uint64_t> inserted(65);
        for (auto &h : inserted) h = Next(state) & (UINT64_MAX >> 1);
        inserted[0] = 0; inserted[2] = inserted[3];
        const auto saved_inserted = inserted;
        std::vector<uint32_t> oracle(bytes / 4);
        for (auto h : inserted) {
            const size_t base = Bucket(h, bytes) * 8;
            for (unsigned lane = 0; lane != 8; ++lane)
                oracle[base + lane] |= uint32_t{1} << Position(h, lane);
        }
        candidate.Insert(32, inserted.data()); candidate.Insert(33, inserted.data() + 32);
        control.Insert(65, inserted.data());
        candidate.Insert(65, inserted.data()); control.Insert(65, inserted.data());
        Need(std::memcmp(candidate.Data(), oracle.data(), bytes) == 0 &&
             std::memcmp(control.Data(), oracle.data(), bytes) == 0, "focused complete bitmap");
        for (auto h : inserted)
            Need(candidate.ContainsHash(h) && control.ContainsHash(h), "focused inserted false negative");
        Need(Answer(oracle, 0) == 1 && Answer(oracle, UINT64_MAX << 40) == 0,
             "focused first/last buckets must have distinct answers");
        for (unsigned pattern = 0; pattern != 3; ++pattern) {
            std::vector<uint64_t> queries(4104);
            for (size_t i = 0; i < queries.size(); ++i) {
                if (pattern == 0) queries[i] = i % 2 ? (Next(state) | (uint64_t{1} << 63)) : inserted[i % inserted.size()];
                else if (pattern == 1) queries[i] = inserted[0];
                else queries[i] = i % 2 ? (UINT64_MAX << 40) : uint64_t{0};
            }
            if (pattern != 1)
                Need(Answer(oracle, queries[0]) == 1 && Answer(oracle, queries[1]) == 0,
                     "focused mixed pattern lost its present/absent distinction");
            const auto saved_queries = queries;
            for (size_t count : lengths) for (size_t offset : {0u,1u,7u}) {
                CheckOutput(candidate, queries.data() + offset, count, oracle);
                CheckOutput(control, queries.data() + offset, count, oracle);
                ++calls; bulk += count >= 128;
            }
            Need(queries == saved_queries, "focused query input mutated");
        }
        Need(inserted == saved_inserted, "focused insertion input mutated");
        Need(std::memcmp(candidate.Data(), oracle.data(), bytes) == 0 &&
             std::memcmp(control.Data(), oracle.data(), bytes) == 0, "focused query mutated bitmap");
    }
    Need(calls == 648 && bulk == 360, "focused finite coverage mismatch");
    std::cout << "PASS backend=" << backend
              << ";4 geometry pairs;648 calls per arm;360 bulk requests;98304B representative allocation\n";
    return 0;
}
} // namespace prefetch64_proof
