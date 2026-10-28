#include <algorithm>
#include <chrono>
#include <functional>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <limits>
#include <type_traits>
#include <random>
#include <set>
#include <sstream>
#include <string>
#include <vector>
#include "fast_pattern_BF.h"
#ifndef BF_EXTERNAL_ONLY
#include "four_sector_bloom.h"
#include "split64_bloom.h"
#include "byte_split_bloom.h"
#endif
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
template <class BF, class = void>
struct BuildScratch {
	static size_t bytes(const BF &) {
		return 0;
	}
};
template <class BF>
struct BuildScratch<BF, std::void_t<decltype(std::declval<const BF &>().BuildScratchBytes())>> {
	static size_t bytes(const BF &bf) {
		return bf.BuildScratchBytes();
	}
};
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
         size_t insert_batch, unsigned calibration_power) {
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
	// Keep one bitmap alive in each phase. Validation and destruction are outside
	// timing; the first trial validates the complete pure and hash+insert builds.
	auto validate_build = [&](BF &filter, bool full) {
		const size_t count = full ? n : std::min(n, batch);
		for (size_t i = 0; i < count; i += batch) {
			const size_t len = std::min(batch, count - i);
			lookup_kernel(filter, len, inserted.data() + i, output);
			for (size_t j = 0; j < len; ++j)
				if (output[j] != 1)
					throw std::runtime_error("false negative in timed build");
			sink = std::accumulate(output, output + len, uint64_t {0});
		}
	};
	std::vector<double> insert_times, build_times, hash_insert_times, hash_build_times;
	for (unsigned trial = 0; trial < repeats; ++trial) {
		{
			auto a = Clock::now();
			BF fresh = make_filter<BF>(n, bpk);
			auto ready = Clock::now();
			for (size_t i = 0; i < n; i += insert_batch)
				insert(fresh, std::min(insert_batch, n - i), inserted.data() + i);
			auto b = Clock::now();
			insert_times.push_back(ns(ready, b) / n);
			build_times.push_back(ns(a, b) / n);
			validate_build(fresh, trial == 0);
		}
		if constexpr (RawKeyApi<BF>::value) {
			hash_insert_times.push_back(insert_times.back());
			hash_build_times.push_back(build_times.back());
		} else {
			auto a = Clock::now();
			BF hashed = make_filter<BF>(n, bpk);
			auto ready = Clock::now();
			for (size_t i = 0; i < n; i += insert_batch) {
				const size_t len = std::min(insert_batch, n - i);
				HashVector(len, raw_insert.data() + i, scratch.data());
				insert(hashed, len, scratch.data());
			}
			auto b = Clock::now();
			hash_insert_times.push_back(ns(ready, b) / n);
			hash_build_times.push_back(ns(a, b) / n);
			validate_build(hashed, trial == 0);
		}
	}
	BF bf = make_filter<BF>(n, bpk);
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
	auto validate_timed_output = [&](const char *phase) {
		uint64_t checksum = 14695981039346656037ULL;
		for (size_t i = 0; i < q; ++i) {
			if (output[i] > 1)
				throw std::runtime_error(std::string("invalid output in ") + phase);
			checksum = (checksum ^ output[i]) * 1099511628211ULL;
		}
		if (checksum != result_checksum)
			throw std::runtime_error(std::string("query output mismatch in ") + phase);
	};
	for (unsigned r = 0; r < repeats; ++r) {
		auto start = Clock::now();
		for (size_t i = 0; i < q; i += batch)
			lookup_kernel(bf, std::min(batch, q - i), hashes.data() + i, output + i);
		auto end = Clock::now();
		lookup.push_back(ns(start, end) / q);
		sink = std::accumulate(output, output + q, uint64_t {0});
		if (r == 0)
			validate_timed_output("timed prehashed lookup");
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
		if (r == 0)
			validate_timed_output("timed hash+lookup");
	}
	// Independent negative calibration after all timed phases. Stream probes to
	// increase FPR resolution without changing the timed query working set.
	uint64_t calibration_queries = calibration_power ? uint64_t {1} << calibration_power : 0;
	uint64_t calibration_fp = 0;
	if (calibration_queries) {
		std::vector<uint64_t> raw(batch);
		std::vector<Hash, AlignedAllocator<Hash, 4096>> prepared(batch);
		for (uint64_t i = 0; i < calibration_queries; i += batch) {
			const size_t len = std::min<uint64_t>(batch, calibration_queries - i);
			for (size_t j = 0; j < len; ++j)
				raw[j] = key_base + n + q + i + j;
			if constexpr (RawKeyApi<BF>::value)
				std::copy(raw.begin(), raw.begin() + len, prepared.begin());
			else
				HashVector(len, raw.data(), prepared.data());
			lookup_kernel(bf, len, prepared.data(), output);
			for (size_t j = 0; j < len; ++j) {
				if (output[j] > 1)
					throw std::runtime_error("invalid calibration output");
				calibration_fp += output[j];
			}
		}
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
	std::cout << ','
	          << (RawKeyApi<BF>::value ? std::numeric_limits<double>::quiet_NaN()
	                                   : *std::min_element(lookup.begin(), lookup.end()))
	          << ','
	          << (RawKeyApi<BF>::value ? std::numeric_limits<double>::quiet_NaN()
	                                   : *std::max_element(lookup.begin(), lookup.end()))
	          << ',' << result_checksum << ',' << (RawKeyApi<BF>::value ? "raw_bytes" : "prehashed") << ','
	          << median(hash_insert_times) << ',' << median(hash_build_times) << ',' << insert_batch << ','
	          << BuildScratch<BF>::bytes(bf) << ',' << sizeof(Hash) * scratch.size() << ','
	          << *std::min_element(total.begin(), total.end()) << ',' << *std::max_element(total.begin(), total.end())
	          << ',' << calibration_queries << ',' << calibration_fp << '\n';
}
int main(int argc, char **argv) {
	try {
		if (argc > 11)
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
		unsigned calibration_power = number(10, 0);
		unsigned repeats = number(6, 5);
		uint64_t seed = number(7, 42);
		if (power > 26 || power < 5 || qp > 27 || qp < 12 || !bpk || bpk > 32 || hit > 100 || !batch ||
		    batch > (1u << qp) || !insert_batch || insert_batch > (1u << 26) ||
		    (calibration_power && (calibration_power < 12 || calibration_power > 27)) || !repeats)
			throw std::invalid_argument("unsupported benchmark arguments");
		size_t n = size_t {1} << power, q = size_t {1} << qp;
		if (n * bpk >= (size_t {1} << 31))
			throw std::invalid_argument("legacy size overflow");
		std::string selection = argc > 8 ? argv[8] : "";
		std::set<std::string> requested;
		if (!selection.empty()) {
			size_t begin = 0;
			for (;;) {
				const size_t end = selection.find(',', begin);
				const std::string name = selection.substr(begin, end == std::string::npos ? end : end - begin);
				if (name.empty())
					throw std::invalid_argument("empty filter name in selection");
				if (!requested.insert(name).second)
					throw std::invalid_argument("duplicate filter name: " + name);
				if (end == std::string::npos)
					break;
				begin = end + 1;
			}
		}
		std::set<std::string> unmatched = requested;
		// Register and validate the complete selection before allocating workloads
		// or running any jobs, so a typo cannot silently benchmark a partial suite.
		std::vector<uint64_t> ins, query;
		uint64_t key_base = 0;
		std::vector<std::function<void()>> jobs;
#define ADD(T, H)                                                                                                      \
	if (selection.empty() || unmatched.erase(#T))                                                                        \
	jobs.emplace_back(                                                                                                 \
	    [&] { run<T, H>(#T, ins, query, bpk, hit, batch, repeats, seed, key_base, insert_batch, calibration_power); })

#ifndef BF_EXTERNAL_ONLY
		ADD(FourSectorBloomFilter, uint64_t);
		ADD(Split64BloomFilter, uint64_t);
			ADD(ByteSplitBloomFilter, uint64_t);
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
		if (!unmatched.empty())
			throw std::invalid_argument("unknown filter name: " + *unmatched.begin());
		if (jobs.empty())
			throw std::invalid_argument("no matching filters");
		// Permuted unique integers give disjoint hit/miss sets; hashing is separately timed.
		ins.resize(n);
		query.resize(q);
		SplitMix64 rng {seed};
		key_base = rng() % ((uint64_t {1} << 32) - n - q);
		std::iota(ins.begin(), ins.end(), key_base);
		shuffle(ins, rng);
		for (size_t i = 0; i < q; ++i)
			query[i] = key_base + ((i % 100 < hit) ? rng() % n : n + i);
		shuffle(query, rng);
		std::cout << "language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,hash_bits,hit_percent,present_"
		             "queries,batch,repeats,seed,insert_ns,allocate_insert_ns,lookup_ns,hash_lookup_ns,absent_queries,"
		             "false_positives,fpr,lookup_min_ns,lookup_max_ns,result_checksum,input_mode,hash_insert_ns,"
		             "allocate_hash_insert_ns,insert_batch,filter_build_scratch_bytes,harness_hash_scratch_bytes,hash_"
		             "lookup_min_ns,hash_lookup_max_ns,calibration_absent_queries,calibration_false_positives\n";
		shuffle(jobs, rng);
		for (auto &job : jobs)
			job();
	} catch (const std::exception &e) {
		std::cerr << e.what() << '\n';
		return 1;
	}
}
