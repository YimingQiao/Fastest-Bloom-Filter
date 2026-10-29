#include "geometry.hpp"
#include <array>
#include <cstdlib>
#include <cstring>
#include <numeric>
#include <vector>
using bloom_filters::FastPatternBF;
static uint64_t digest = 14695981039346656037ULL;
static void require(bool yes, const char *why) { if (!yes) throw std::runtime_error(why); }
template<class F> void rejects(F fn) { bool rejected = false; try { fn(); } catch (const std::exception &) { rejected = true; } require(rejected, "invalid geometry accepted"); }
template<class T, class = void> struct Raw : std::false_type {};
template<class T> struct Raw<T, std::void_t<decltype(T::kRawKeyApi)>> : std::bool_constant<T::kRawKeyApi> {};
template<class BF> void check(const char *name) {
    for (const size_t n : {size_t{513}, size_t{1027}}) {
        for (const uint32_t budget : {8u, 12u, 14u, 16u, 20u, 24u, 28u, 32u}) {
            auto g = exact_budget::Traits<BF>::Plan(n, budget);
            BF bf = exact_budget::Traits<BF>::Make(n, budget);
            require(g.allocated_bytes <= g.budget_bytes, "planner over cap");
            require(bf.SizeInBytes() == g.allocated_bytes, "actual allocation differs from planner");
            std::vector<uint64_t> keys(n), query(4251);
            for (size_t i = 0; i < n; ++i) keys[i] = Raw<BF>::value ? i + 100 : bloom_filters::MurmurHash64(i + 100);
            for (size_t i = 0; i < query.size(); ++i) query[i] = Raw<BF>::value ? i + 20000 : bloom_filters::MurmurHash64(i + 20000);
            for (size_t i = 1; i < query.size(); i += 2) query[i] = keys[i % n];
            for (size_t i = 0; i < n; i += 37) bf.Insert(std::min<size_t>(37, n - i), keys.data() + i);
            // Duplicate insertions exercise idempotence and collision handling.
            bf.Insert(17, keys.data());
            std::vector<uint32_t> inserted(n);
            bf.Lookup(n, keys.data(), inserted.data());
            require(std::all_of(inserted.begin(), inserted.end(), [](uint32_t x) { return x == 1; }), "false negative");
            std::vector<uint32_t> oracle(query.size());
            for (size_t i = 0; i < query.size(); ++i) bf.Lookup(1, query.data() + i, oracle.data() + i);
            std::vector<uint32_t> output(query.size() + 64, 0xfeedbeef);
            for (const size_t offset : {size_t{0}, size_t{1}, size_t{7}}) {
                for (size_t length = 0; length <= 131; ++length) {
                    std::fill(output.begin(), output.end(), 0xfeedbeef);
                    require(bf.Lookup(length, query.data() + offset, output.data() + 16) == length, "Lookup return count");
                    for (size_t i = 0; i < output.size(); ++i) {
                        const uint32_t expected = i >= 16 && i < 16 + length ? oracle[offset + i - 16] : 0xfeedbeef;
                        require(output[i] == expected, "tail output/guard mismatch");
                    }
                }
            }
            for (const size_t length : {size_t{4096}, size_t{4097}, size_t{4127}}) {
                std::fill(output.begin(), output.end(), 0xfeedbeef);
                bf.Lookup(length, query.data() + 3, output.data() + 16);
                for (size_t i = 0; i < output.size(); ++i) require(output[i] ==
                    (i >= 16 && i < 16 + length ? oracle[3 + i - 16] : 0xfeedbeef), "long tail/guard mismatch");
            }
            for (auto answer : oracle) { require(answer <= 1, "answer not dense0/1"); digest = (digest ^ answer) * 1099511628211ULL; }
        }
    }
    rejects([] { exact_budget::Traits<BF>::Plan(0, 16); });
    rejects([] { exact_budget::Traits<BF>::Plan(100, 0); });
    rejects([] { exact_budget::Traits<BF>::Plan(SIZE_MAX, 32); });
    std::cout << name << " passed\n";
}
template<class A, class B> void parity(size_t n, uint32_t bpk) {
    A a = exact_budget::Traits<A>::Make(n, bpk);
    B b = exact_budget::Traits<B>::Make(n, bpk);
    std::vector<uint64_t> keys(n), query(8192);
    for (size_t i = 0; i < n; ++i) keys[i] = bloom_filters::MurmurHash64(i + 775);
    for (size_t i = 0; i < query.size(); ++i) query[i] = bloom_filters::MurmurHash64(i + 9915);
    a.Insert(n, keys.data()); b.Insert(n, keys.data());
    std::vector<uint32_t> ao(query.size()), bo(query.size());
    a.Lookup(query.size(), query.data(), ao.data()); b.Lookup(query.size(), query.data(), bo.data());
    require(a.SizeInBytes() == b.SizeInBytes() && ao == bo, "API control parity mismatch");
}
int main() {
    try {
        // Native fitting keeps the true item count and the 6/8-probe transition.
        const auto low = exact_budget::Traits<FastPatternBF>::Plan(65536, 12);
        const auto high = exact_budget::Traits<FastPatternBF>::Plan(65536, 16);
        require(low.allocated_bytes == 65536 && low.probes == 6 && low.native_bpk == 4, "native8 geometry");
        require(high.allocated_bytes == 131072 && high.probes == 8 && high.native_bpk == 8, "native16 geometry");
        require(exact_budget::Traits<FastFilterFixed64>::Plan(1001, 14).allocated_bytes == 1728, "nonpow Fixed64 boundary");
        require(exact_budget::Traits<Boost192Multi32K4>::Plan(1001, 14).allocated_bytes <= 1751, "Boost explicit padding");
        const std::array<int, 7> rocks{8,8,9,11,12,12,14};
        size_t j = 0; for (uint32_t bpk : {12u,14u,16u,20u,24u,28u,32u})
            require(exact_budget::Traits<RocksDBFastLocalBloom64>::Plan(65536, bpk).probes == rocks[j++], "Rocks Auto K");
#define ADD(T, H) check<T>(#T)
        ADD(FastPatternBF, uint64_t);
        BF_REGISTER_EXTERNAL_FILTERS(ADD);
#undef ADD
        parity<ByteSplitRangeExperiment, FastFilterFixed16>(1027, 14);
        parity<Split64RangeExperiment, FastFilterFixed64>(1027, 14);
        parity<Split64RangeNative, FastFilterFixed64>(1027, 14);
        parity<FastFilterFixed32, FastFilterFixed32Bulk>(1027, 14);
        parity<FastFilterFixed16, FastFilterFixed16SingleV1>(1027, 14);
        parity<FastFilterSimdBlock, FastFilterSimdBlockSingleV1>(1027, 14);
#define CLASSIC(K) parity<FastFilterClassic##K, FastFilterClassic##K##Bulk>(1027, 14); parity<FastFilterClassic##K, FastFilterClassic##K##Branchless>(1027, 14)
        CLASSIC(10); CLASSIC(14); CLASSIC(17); CLASSIC(19);
#undef CLASSIC
        parity<RocksDBFastLocalBloom64K11, RocksDBFastLocalBloom64K11Batch32>(1027, 14);
        parity<RocksDBFastLocalBloom64K12, RocksDBFastLocalBloom64K12Batch32>(1027, 14);
        std::cout << "All geometry/output checks passed; checksum=" << digest << '\n';
    } catch (const std::exception &e) { std::cerr << e.what() << '\n'; return 1; }
}
