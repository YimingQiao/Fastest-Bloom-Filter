#include <algorithm>
#include <chrono>
#include <functional>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <limits>
#include <type_traits>
#include <random>
#include <sstream>
#include <string>
#include <vector>
#include "fast_pattern_BF.h"
#ifdef BF_EXPERIMENTS
#include "direct_split_BF.h"
#include "pattern_sectorized_BF.h"
#include "pattern32_BF.h"
#include "pipelined_sectorized_BF.h"
#endif
#include "cache_sectorized_BF_32bit.h"
#include "new_cache_sectorized_BF_32bit.h"
#include "register_blocked_BF_32bit.h"
#include "register_blocked_BF_32bit_Masks.h"
#include "register_blocked_BF_64bit.h"
#include "register_blocked_BF_64bit_Masks.h"
#include "register_blocked_BF_2x32bit.h"
#include "impala_blocked_BF_64bit.h"
#ifdef __AVX512F__
#include "impala_blocked_BF_64bit_avx512.h"
#endif

#ifdef BF_EXTERNAL_HEADER
#include BF_EXTERNAL_HEADER
#endif

using namespace bloom_filters;
template <class BF, class = void>
struct RawKeyApi : std::false_type {};
template <class BF>
struct RawKeyApi<BF, std::void_t<decltype(BF::kRawKeyApi)>> : std::integral_constant<bool, BF::kRawKeyApi> {};
using Clock = std::chrono::steady_clock;
static volatile uint64_t sink;
static double ns(Clock::time_point a, Clock::time_point b) {
	return std::chrono::duration<double, std::nano>(b - a).count();
}
static double median(std::vector<double> v) {
	std::sort(v.begin(), v.end());
	return v.size() % 2 ? v[v.size() / 2] : (v[v.size() / 2 - 1] + v[v.size() / 2]) / 2;
}
// Defined modulo 2^64, shared verbatim with the native Rust benchmark.
struct SplitMix64 {
	uint64_t state;
	uint64_t operator()() {
		uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
		z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
		z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
		return z ^ (z >> 31);
	}
};
template <class T>
void shuffle(std::vector<T> &v, SplitMix64 &rng) {
	for (size_t i = v.size(); i > 1; --i)
		std::swap(v[i - 1], v[rng() % i]);
}
template <class BF>
BF make_filter(size_t n, uint32_t bpk) {
	std::ostringstream ignored;
	struct Restore {
		std::streambuf *buffer;
		~Restore() {
			std::cout.rdbuf(buffer);
		}
	} restore {std::cout.rdbuf(ignored.rdbuf())};
	return BF(n, bpk);
}
// One compiled query kernel per implementation, shared by pure and hash+query
// timing. Avoid call-site-specific vectorization changing the operation measured.
template <class BF, class Hash>
__attribute__((noinline)) void lookup_kernel(BF &bf, size_t n, const Hash *hashes, uint32_t *out) {
	// Legacy signatures omit const; every adapter treats inputs as read-only.
	bf.Lookup(static_cast<uint32_t>(n), const_cast<Hash *>(hashes), out);
}
template <class BF, class Hash>
__attribute__((noinline)) void insert(BF &bf, size_t n, const Hash *hashes) {
	bf.Insert(static_cast<uint32_t>(n), const_cast<Hash *>(hashes));
}
template <class BF, class Hash>
void run(const char *name, const std::vector<uint64_t> &raw_insert, const std::vector<uint64_t> &raw_query,
         uint32_t bpk, unsigned hit, size_t batch, unsigned repeats, uint64_t seed, uint64_t key_base,
         size_t insert_batch) {
	const size_t n = raw_insert.size(), q = raw_query.size();
	std::vector<Hash, AlignedAllocator<Hash, 4096>> inserted(n), hashes(q), scratch(std::max(batch, insert_batch));
	std::vector<uint32_t, AlignedAllocator<uint32_t, 4096>> output_storage(std::max(q, batch) + 32);
	uint32_t *output = output_storage.data() + 16;
	if constexpr (RawKeyApi<BF>::value) {
		static_assert(std::is_same<Hash, uint64_t>::value, "raw-key adapter requires uint64_t keys");
		std::copy(raw_insert.begin(), raw_insert.end(), inserted.begin());
		std::copy(raw_query.begin(), raw_query.end(), hashes.begin());
	} else {
		HashVector(n, raw_insert.data(), inserted.data());
		HashVector(q, raw_query.data(), hashes.data());
	}
	BF bf = make_filter<BF>(n, bpk);
	std::vector<double> insert_times, build_times, hash_insert_times, hash_build_times;
	for (unsigned trial = 0; trial < repeats; ++trial) {
		auto a = Clock::now();
		BF fresh = make_filter<BF>(n, bpk);
		auto ready = Clock::now();
		for (size_t i = 0; i < n; i += insert_batch)
			insert(fresh, std::min(insert_batch, n - i), inserted.data() + i);
		auto b = Clock::now();
		insert_times.push_back(ns(ready, b) / n);
		build_times.push_back(ns(a, b) / n);
		lookup_kernel(fresh, std::min(n, batch), inserted.data(), output);
		sink = std::accumulate(output, output + std::min(n, batch), uint64_t {0});
		if constexpr (RawKeyApi<BF>::value) {
			hash_insert_times.push_back(insert_times.back());
			hash_build_times.push_back(build_times.back());
		} else {
			a = Clock::now();
			BF hashed = make_filter<BF>(n, bpk);
			ready = Clock::now();
			for (size_t i = 0; i < n; i += insert_batch) {
				const size_t len = std::min(insert_batch, n - i);
				HashVector(len, raw_insert.data() + i, scratch.data());
				insert(hashed, len, scratch.data());
			}
			b = Clock::now();
			hash_insert_times.push_back(ns(ready, b) / n);
			hash_build_times.push_back(ns(a, b) / n);
			lookup_kernel(hashed, std::min(n, batch), inserted.data(), output);
			for (size_t j = 0; j < std::min(n, batch); ++j)
				if (output[j] != 1)
					throw std::runtime_error("false negative in hashed build");
			sink = std::accumulate(output, output + std::min(n, batch), uint64_t {0});
		}
	}
	for (size_t i = 0; i < n; i += insert_batch)
		insert(bf, std::min(insert_batch, n - i), inserted.data() + i);
	for (size_t i = 0; i < n; i += batch) {
		size_t len = std::min(batch, n - i);
		lookup_kernel(bf, len, inserted.data() + i, output);
		for (size_t j = 0; j < len; ++j)
			if (output[j] != 1)
				throw std::runtime_error("false negative");
	}
	// Warm-up and validate output before measuring. Query arrays are disjoint for misses.
	for (size_t i = 0; i < q; i += batch)
		lookup_kernel(bf, std::min(batch, q - i), hashes.data() + i, output + i);
	uint64_t false_positives = 0, absent = 0, present = 0, result_checksum = 14695981039346656037ULL;
	for (size_t i = 0; i < q; ++i) {
		result_checksum = (result_checksum ^ output[i]) * 1099511628211ULL;
		if (output[i] > 1)
			throw std::runtime_error("output must be 0 or 1");
		if (raw_query[i] >= key_base && raw_query[i] < key_base + n) {
			++present;
			if (!output[i])
				throw std::runtime_error("false negative in mixed workload");
		} else {
			++absent;
			false_positives += output[i];
		}
	}
	std::vector<double> lookup, total;
	for (unsigned r = 0; r < repeats; ++r) {
		auto start = Clock::now();
		for (size_t i = 0; i < q; i += batch)
			lookup_kernel(bf, std::min(batch, q - i), hashes.data() + i, output + i);
		auto end = Clock::now();
		lookup.push_back(ns(start, end) / q);
		sink = std::accumulate(output, output + q, uint64_t {0});
		start = Clock::now();
		for (size_t i = 0; i < q; i += batch) {
			size_t len = std::min(batch, q - i);
			if constexpr (RawKeyApi<BF>::value) {
				lookup_kernel(bf, len, raw_query.data() + i, output + i);
			} else {
				HashVector(len, raw_query.data() + i, scratch.data());
				lookup_kernel(bf, len, scratch.data(), output + i);
			}
		}
		end = Clock::now();
		total.push_back(ns(start, end) / q);
		sink = std::accumulate(output, output + q, uint64_t {0});
	}
	std::cout << "cpp," << name << ',' << n << ',' << q << ',' << bpk << ',' << bf.SizeInBytes() << ','
	          << 8.0 * bf.SizeInBytes() / n << ',' << sizeof(Hash) * 8 << ',' << hit << ',' << present << ',' << batch
	          << ',' << repeats << ',' << seed << ','
	          << (RawKeyApi<BF>::value ? std::numeric_limits<double>::quiet_NaN() : median(insert_times)) << ','
	          << (RawKeyApi<BF>::value ? std::numeric_limits<double>::quiet_NaN() : median(build_times)) << ','
	          << (RawKeyApi<BF>::value ? std::numeric_limits<double>::quiet_NaN() : median(lookup)) << ','
	          << median(total) << ',' << absent << ',' << false_positives << ',';
	if (absent)
		std::cout << double(false_positives) / absent;
	else
		std::cout << "nan";
	std::cout << ',' << *std::min_element(lookup.begin(), lookup.end()) << ','
	          << *std::max_element(lookup.begin(), lookup.end()) << ',' << result_checksum << ','
	          << (RawKeyApi<BF>::value ? "raw_bytes" : "prehashed") << ',' << median(hash_insert_times) << ','
	          << median(hash_build_times) << ',' << insert_batch << '\n';
}
int main(int argc, char **argv) {
	try {
		if (argc > 10)
			throw std::invalid_argument("too many arguments");
		auto number = [&](int i, uint64_t fallback) {
			if (argc <= i)
				return fallback;
			std::string str = argv[i];
			if (str.empty() || str.find_first_not_of("0123456789") != std::string::npos)
				throw std::invalid_argument("arguments must be unsigned integers");
			uint64_t value = std::stoull(str);
			if (i != 7 && value > UINT32_MAX)
				throw std::invalid_argument("argument too large");
			return value;
		};
		unsigned power = number(1, 16);
		uint32_t bpk = number(2, 16);
		unsigned hit = number(3, 0);
		unsigned qp = number(4, 22);
		size_t batch = number(5, 4096);
		size_t insert_batch = number(9, batch);
		unsigned repeats = number(6, 5);
		uint64_t seed = number(7, 42);
		if (power > 26 || power < 5 || qp > 27 || qp < 12 || !bpk || bpk > 32 || hit > 100 || !batch ||
		    batch > (1u << qp) || !insert_batch || insert_batch > (1u << 26) || !repeats)
			throw std::invalid_argument("unsupported benchmark arguments");
		size_t n = size_t {1} << power, q = size_t {1} << qp;
		if (n * bpk >= (size_t {1} << 31))
			throw std::invalid_argument("legacy size overflow");
		// Permuted unique integers give disjoint hit/miss sets; hashing is separately timed.
		std::vector<uint64_t> ins(n), query(q);
		SplitMix64 rng {seed};
		const uint64_t key_base = rng() % ((uint64_t {1} << 32) - n - q);
		std::iota(ins.begin(), ins.end(), key_base);
		shuffle(ins, rng);
		for (size_t i = 0; i < q; ++i)
			query[i] = key_base + ((i % 100 < hit) ? rng() % n : n + i);
		shuffle(query, rng);
		std::cout << "language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,hash_bits,hit_percent,present_"
		             "queries,batch,repeats,seed,insert_ns,allocate_insert_ns,lookup_ns,hash_lookup_ns,absent_queries,"
		             "false_positives,fpr,lookup_min_ns,lookup_max_ns,result_checksum,input_mode,hash_insert_ns,"
		             "allocate_hash_insert_ns,insert_batch\n";
		std::string selection = argc > 8 ? argv[8] : "";
		std::vector<std::function<void()>> jobs;
#define ADD(T, H)                                                                                                      \
	if (selection.empty() || ("," + selection + ",").find("," #T ",") != std::string::npos)                            \
	jobs.emplace_back([&] { run<T, H>(#T, ins, query, bpk, hit, batch, repeats, seed, key_base, insert_batch); })

#ifndef BF_EXTERNAL_ONLY
		ADD(RegisterBlockedBF32Bit, uint32_t);
		ADD(RegisterBlockedBF32BitMasks, uint32_t);
		ADD(RegisterBlockedBF64Bit, uint64_t);
		ADD(RegisterBlockedBF64BitMasks, uint64_t);
		ADD(RegisterBlockedBF2x32Bit, uint64_t);
		ADD(CacheSectorizedBF32Bit, uint64_t);
#ifdef BF_EXPERIMENTS
		ADD(PipelinedSectorizedBF, uint64_t);
#endif
#ifdef BF_EXPERIMENTS
		ADD(DirectSplitBF, uint64_t);
#endif
#ifdef BF_EXPERIMENTS
		ADD(PatternSectorizedBF, uint64_t);
#endif
#ifdef BF_EXPERIMENTS
		ADD(Pattern32BF, uint64_t);
#endif
#endif
		ADD(FastPatternBF, uint64_t);
#ifdef BF_REGISTER_EXTERNAL_FILTERS
		BF_REGISTER_EXTERNAL_FILTERS(ADD);
#endif
#ifndef BF_EXTERNAL_ONLY
		ADD(NewCacheSectorizedBF32Bit, uint64_t);
		ADD(ImpalaBlockedBF64Bit, uint64_t);
#ifdef __AVX512F__
		ADD(ImpalaBlockedBF64BitAVX512, uint64_t);
#endif
#endif
#undef ADD
		if (jobs.empty())
			throw std::invalid_argument("no matching filters");
		shuffle(jobs, rng);
		for (auto &job : jobs)
			job();
	} catch (const std::exception &e) {
		std::cerr << e.what() << '\n';
		return 1;
	}
}
