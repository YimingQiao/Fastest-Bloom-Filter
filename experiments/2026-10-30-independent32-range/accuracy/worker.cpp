#include "../candidate.hpp"
#include "../control.hpp"
#include "input.hpp"
#include <array>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <limits>
#include <string>

using Candidate = bloom_filters::Independent32RangeBloomFilter;
using Control = bloom_filters::Independent32BloomFilter;
constexpr size_t kBatch = 4096;
constexpr uint32_t kGuard = 0xfeed1234;
static void Need(bool ok, const char* why) { if (!ok) throw std::runtime_error(why); }

struct Dense {
    std::array<uint32_t, kBatch + 32> words{};
    size_t count = 0;
    uint32_t* data() { return words.data() + 16; }
    void Reset(size_t n) {
        Need(n <= kBatch, "oversized dense block"); count = n;
        words.fill(kGuard); std::fill_n(data(), count, uint32_t{2});
    }
    void Guards() const {
        for (size_t i = 0; i < 16; ++i) Need(words[i] == kGuard, "prefix guard changed");
        for (size_t i = count + 16; i < words.size(); ++i)
            Need(words[i] == kGuard, "suffix guard changed");
    }
};
template<class Filter> static void LookupChecked(const Filter& filter, size_t count,
        const uint64_t* hashes, Dense& out, bool inject = false) {
    out.Reset(count);
    Need(filter.Lookup(static_cast<uint32_t>(count), hashes, out.data()) == count,
         "wrong dense output count");
    if (inject && count) out.data()[count - 1] = 2;
    out.Guards();
    for (size_t i = 0; i < count; ++i)
        Need(out.data()[i] <= 1 && out.data()[i] == uint32_t(filter.ContainsHash(hashes[i])),
             "public dense output mismatch");
}
static double WilsonUpper(uint64_t fp, uint64_t count) {
    Need(count && fp <= count, "invalid calibration counts");
    constexpr double z = 1.959963984540054;
    const double n = double(count), p = double(fp) / n, zz = z * z;
    return std::min(1.0, (p + zz / (2 * n) + z * std::sqrt((p * (1 - p) + zz / (4 * n)) / n)) /
                         (1 + zz / n));
}
static const char* Backend() {
#if defined(__AVX512VBMI__) && defined(__AVX512VL__) && defined(__AVX2__)
    return "avx512vbmi-vl";
#elif defined(__AVX2__)
    return "avx2";
#else
    return "scalar-source";
#endif
}
template<class Filter> static void Run(const Input& d, unsigned power, unsigned bpk,
        unsigned constructor_bpk, unsigned cal_power, bool candidate, bool inject) {
    const size_t n = d.inserted.size(), q = d.query.size(), budget = n * bpk / 8;
    Filter filter(n, constructor_bpk); // Exactly one live bitmap in this scope.
    const size_t bytes = filter.SizeInBytes(), logical = filter.LogicalBytes();
    Need(bytes == budget && logical == budget && bytes % 64 == 0, "actual allocation mismatch");
    Need(filter.CacheLineCount() == logical / 64, "physical line count mismatch");
    Need(reinterpret_cast<uintptr_t>(filter.Data()) % 64 == 0, "unaligned bitmap");
    filter.Insert(0, nullptr);
    Need(filter.Lookup(0, nullptr, nullptr) == 0, "zero/null lookup mismatch");
    filter.Insert(static_cast<uint32_t>(n), d.inserted.data());
    Dense out;
    uint64_t owner_digest = 14695981039346656037ULL;
    for (size_t begin = 0; begin < n; begin += kBatch) {
        const size_t count = std::min(kBatch, n - begin);
        LookupChecked(filter, count, d.inserted.data() + begin, out);
        for (size_t i = 0; i < count; ++i) {
            Need(out.data()[i] == 1, "inserted false negative");
            const size_t line = filter.CacheLineIndex(d.inserted[begin + i]);
            Need(line < filter.CacheLineCount(), "physical owner out of bounds");
            owner_digest = (owner_digest ^ line) * 1099511628211ULL;
        }
    }
    const auto* bitmap = static_cast<const uint8_t*>(filter.Data());
    const uint64_t bitmap_digest = Digest(bitmap, bytes);
    LookupChecked(filter, q, d.query.data(), out, inject);
    uint64_t present = 0, absent = 0, mixed_fp = 0;
    for (size_t i = 0; i < q; ++i) {
        if (d.query_raw[i] >= d.key_base && d.query_raw[i] < d.key_base + n) {
            ++present; Need(out.data()[i] == 1, "mixed false negative");
        } else { ++absent; mixed_fp += out.data()[i]; }
    }
    const uint64_t mixed_digest = Digest(out.data(), q);
    const uint64_t negatives = uint64_t{1} << cal_power;
    const uint64_t cal_begin = d.key_base + n + q, cal_end = cal_begin + negatives;
    Need(cal_begin >= d.key_base + n && cal_end > cal_begin, "negative interval overflow");
    for (auto raw : d.query_raw) Need(raw < cal_begin, "query/calibration interval overlap");
    std::array<uint64_t, kBatch> raw{}, hashes{};
    uint64_t fp = 0, calibration_digest = 14695981039346656037ULL;
    for (uint64_t begin = 0; begin < negatives; begin += kBatch) {
        const size_t count = std::min<uint64_t>(kBatch, negatives - begin);
        for (size_t i = 0; i < count; ++i) raw[i] = cal_begin + begin + i;
        bloom_filters::HashVector(count, raw.data(), hashes.data());
        LookupChecked(filter, count, hashes.data(), out);
        for (size_t i = 0; i < count; ++i) {
            fp += out.data()[i];
            calibration_digest = (calibration_digest ^ out.data()[i]) * 1099511628211ULL;
        }
    }
    Need(Digest(bitmap, bytes) == bitmap_digest, "query mutated bitmap");
    Need(Digest(d.inserted_raw.data(), n) == d.inserted_digest &&
         Digest(d.inserted.data(), n) == d.inserted_hash_digest &&
         Digest(d.query_raw.data(), q) == d.query_digest &&
         Digest(d.query.data(), q) == d.query_hash_digest, "input mutated");
    const double upper = WilsonUpper(fp, negatives);
    std::cout << std::setprecision(17) << '{'
        << "\"filter\":\"" << (candidate ? "Independent32RangeBloomFilter" : "Independent32BloomFilter") << '"'
        << ",\"mapping\":\"" << (candidate ? "high24-range/low40-independent8-v1" : "high23-mask/low40-independent8-v1") << '"'
        << ",\"backend\":\"" << Backend() << '"'
        << ",\"key_power\":" << power << ",\"keys\":" << n << ",\"seed\":42"
        << ",\"actual_bpk\":" << bpk << ",\"constructor_bpk\":" << constructor_bpk
        << ",\"budget_bytes\":" << budget << ",\"actual_bytes\":" << bytes
        << ",\"logical_bytes\":" << logical << ",\"physical_line_bytes\":64"
        << ",\"physical_lines\":" << filter.CacheLineCount() << ",\"bucket_bytes\":32"
        << ",\"buckets\":" << logical / 32 << ",\"probes\":8,\"parallel_api\":false"
        << ",\"inserted_checked\":" << n << ",\"physical_owner_digest\":" << owner_digest
        << ",\"key_base\":" << d.key_base << ",\"inserted_digest\":" << d.inserted_digest
        << ",\"inserted_hash_digest\":" << d.inserted_hash_digest
        << ",\"query_digest\":" << d.query_digest << ",\"query_hash_digest\":" << d.query_hash_digest
        << ",\"bitmap_digest\":" << bitmap_digest << ",\"mixed_digest\":" << mixed_digest
        << ",\"queries\":" << q << ",\"requested_hit_percent\":50,\"present\":" << present
        << ",\"absent\":" << absent << ",\"mixed_fp\":" << mixed_fp
        << ",\"calibration_power\":" << cal_power << ",\"calibration_negatives\":" << negatives
        << ",\"calibration_begin\":" << cal_begin << ",\"calibration_end\":" << cal_end
        << ",\"calibration_fp\":" << fp << ",\"calibration_digest\":" << calibration_digest
        << ",\"wilson_upper\":" << upper << ",\"qualifies\":{\"1pct\":" << (upper <= .01 ? "true" : "false")
        << ",\"0.1pct\":" << (upper <= .001 ? "true" : "false")
        << ",\"0.01pct\":" << (upper <= .0001 ? "true" : "false") << '}'
        << ",\"query_repeats\":0,\"build_repeats\":0,\"timing_available\":false}\n" << std::flush;
}
int main(int argc, char** argv) {
    try {
        if (argc != 3) throw std::invalid_argument("expected mode and key power");
        const std::string mode = argv[1], text = argv[2];
        if (text.empty() || text.find_first_not_of("0123456789") != std::string::npos)
            throw std::invalid_argument("unsigned key power required");
        const auto value = std::stoul(text);
        const bool formal = mode == "--accuracy", check = mode == "--check", fault = mode == "--fault";
        if ((!formal && !check && !fault) || (formal ? (value != 16 && value != 25) : value != 12))
            throw std::invalid_argument("fixed accuracy/check grid required");
        const unsigned power = static_cast<unsigned>(value), cal = formal ? 26 : 10;
        const size_t n = size_t{1} << power;
        const Input input = MakeInput(n, kBatch);
        if (!formal) {
            Run<Candidate>(input, power, 12, 12, cal, true, fault);
            Run<Control>(input, power, 16, 8, cal, false, false);
        } else {
            for (unsigned bpk : {12u,16u,20u,24u,28u,32u})
                Run<Candidate>(input, power, bpk, bpk, cal, true, false);
            for (unsigned bpk : {16u,32u}) Run<Control>(input, power, bpk, bpk / 2, cal, false, false);
        }
    } catch (const std::exception& error) { std::cerr << error.what() << '\n'; return 1; }
}
