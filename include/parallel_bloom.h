#pragma once

#include "fast_pattern_BF.h"
#include <atomic>
#include <memory>
#include <thread>
#include <vector>

namespace bloom_filters {
namespace parallel_detail {
inline size_t Workers(size_t items, size_t requested, size_t limit = SIZE_MAX) {
	if (items < (1u << 14))
		return 1;
	if (!requested)
		requested = std::max(1u, std::thread::hardware_concurrency());
	return std::max<size_t>(1, std::min({requested, limit, items / 4096, size_t {1024}}));
}
template <class F>
void For(size_t workers, F &&fn) {
	if (workers == 1) {
		fn(0);
		return;
	}
	// Join during stack unwinding too, including a failed thread creation.
	struct Joiner {
		std::vector<std::thread> threads;
		~Joiner() {
			for (auto &t : threads)
				if (t.joinable())
					t.join();
		}
	} group;
	group.threads.reserve(workers - 1);
	for (size_t worker = 1; worker < workers; ++worker)
		group.threads.emplace_back([&, worker] { fn(worker); });
	fn(0);
}
inline unsigned Log2(size_t n) {
	unsigned result = 0;
	while (n > 1) {
		n >>= 1;
		++result;
	}
	return result;
}
} // namespace parallel_detail

// Exclusive bulk construction with parallel workers; read-only query batches can
// run concurrently. Every build worker owns whole cache lines, so bitmap updates
// need no atomics. Partitioning uses O(input hashes + workers^2) scratch space.
class ParallelFastPatternBF {
public:
	ParallelFastPatternBF(size_t keys, uint32_t bits_per_key) : filter_(keys, bits_per_key) {
	}
	size_t SizeInBytes() const {
		return filter_.SizeInBytes();
	}
	void Insert(uint32_t n, const uint64_t *keys) {
		filter_.Insert(n, keys);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *keys, uint32_t *out) const {
		return filter_.Lookup(n, keys, out);
	}
	size_t BuildWorkers(size_t n, size_t requested) const {
		return parallel_detail::Workers(n, requested, filter_.blocks_.size() / 16);
	}
	size_t BuildScratchBytes(size_t n, size_t requested) const {
		const size_t workers = BuildWorkers(n, requested), stride = (workers + 7) & ~size_t {7};
		return workers == 1 ? 0 : n * sizeof(uint64_t) + (workers * stride + workers + 1) * sizeof(size_t);
	}
	void InsertParallel(uint32_t n, const uint64_t *keys, size_t requested = 0) {
		const size_t workers = BuildWorkers(n, requested);
		if (workers == 1) {
			filter_.Insert(n, keys);
			return;
		}
		const unsigned line_shift = parallel_detail::Log2(filter_.blocks_.size() / 16);
		const size_t stride = (workers + 7) & ~size_t {7};
		// Padding alone is insufficient: align the allocation too, otherwise
		// adjacent histogram rows can still share a boundary cache line.
		std::vector<size_t, AlignedAllocator<size_t, 64>> counts(workers * stride, 0);
		std::vector<size_t> starts(workers + 1);
		std::unique_ptr<uint64_t[]> partitioned(new uint64_t[n]);
		auto shard = [&](uint64_t h) {
			return ((uint64_t(filter_.Block(h)) >> 4) * workers) >> line_shift;
		};
		parallel_detail::For(workers, [&](size_t worker) {
			for (size_t i = size_t(n) * worker / workers; i < size_t(n) * (worker + 1) / workers; ++i)
				++counts[worker * stride + shard(keys[i])];
		});
		size_t cursor = 0;
		for (size_t part = 0; part < workers; ++part) {
			starts[part] = cursor;
			for (size_t worker = 0; worker < workers; ++worker) {
				auto &count = counts[worker * stride + part];
				const size_t old = count;
				count = cursor;
				cursor += old;
			}
		}
		starts[workers] = cursor;
		parallel_detail::For(workers, [&](size_t worker) {
			for (size_t i = size_t(n) * worker / workers; i < size_t(n) * (worker + 1) / workers; ++i) {
				auto &position = counts[worker * stride + shard(keys[i])];
				partitioned[position++] = keys[i];
			}
		});
		parallel_detail::For(workers, [&](size_t part) {
			// Both sectors stay in one line, owned exclusively by this partition.
			filter_.Insert(static_cast<uint32_t>(starts[part + 1] - starts[part]), partitioned.get() + starts[part]);
		});
	}
	uint32_t LookupParallel(uint32_t n, const uint64_t *keys, uint32_t *out, size_t requested = 0) const {
		const size_t workers = parallel_detail::Workers(n, requested);
		parallel_detail::For(workers, [&](size_t worker) {
			const size_t begin = size_t(n) * worker / workers, end = size_t(n) * (worker + 1) / workers;
			if (begin < end)
				filter_.Lookup(end - begin, keys + begin, out + begin);
		});
		return n;
	}

private:
	FastPatternBF filter_;
};

// Supports overlapping inserts and queries. A query overlapping an unfinished
// insert may miss that key. After externally synchronizing completed inserts
// (e.g. joining the writers), there are no false negatives. No concurrent clear,
// resize, destruction, or non-atomic access to the bitmap is permitted.
class AtomicFastPatternBF {
	struct alignas(64) Line {
		std::atomic<uint32_t> words[16];
		Line() {
			for (auto &w : words)
				w.store(0, std::memory_order_relaxed);
		}
	};
	static_assert(sizeof(Line) == 64, "atomic line layout");

public:
	AtomicFastPatternBF(size_t keys, uint32_t bits_per_key)
	    : words_(FastPatternBF::WordCount(keys, bits_per_key)), lines_(new Line[words_ / 16]),
	      patterns_(keys > words_ * 32 / 12 ? FastPatternBF::sparse_patterns_ : FastPatternBF::dense_patterns_) {
	}
	size_t SizeInBytes() const {
		return words_ * 4;
	}
	void Insert(uint32_t n, const uint64_t *keys) {
		for (size_t i = 0; i < n; ++i) {
			const uint64_t h = keys[i];
			const uint32_t lo = h;
			const size_t a = (h >> 32) & (words_ - 1), b = a ^ (8u + ((lo >> 20) & 7));
			Set(a, Mask(lo));
			Set(b, Mask(lo >> 10));
		}
	}
	uint32_t Lookup(uint32_t n, const uint64_t *keys, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i) {
			const uint64_t h = keys[i];
			const uint32_t lo = h;
			const size_t a = (h >> 32) & (words_ - 1), b = a ^ (8u + ((lo >> 20) & 7));
			const uint32_t m1 = Mask(lo), m2 = Mask(lo >> 10);
			out[i] = ((lines_[a / 16].words[a % 16].load(std::memory_order_relaxed) & m1) == m1) &
			         ((lines_[b / 16].words[b % 16].load(std::memory_order_relaxed) & m2) == m2);
		}
		return n;
	}
	void InsertParallel(uint32_t n, const uint64_t *keys, size_t requested = 0) {
		const size_t workers = parallel_detail::Workers(n, requested);
		parallel_detail::For(workers, [&](size_t worker) {
			const size_t begin = size_t(n) * worker / workers, end = size_t(n) * (worker + 1) / workers;
			if (begin < end)
				Insert(end - begin, keys + begin);
		});
	}
	uint32_t LookupParallel(uint32_t n, const uint64_t *keys, uint32_t *out, size_t requested = 0) const {
		const size_t workers = parallel_detail::Workers(n, requested);
		parallel_detail::For(workers, [&](size_t worker) {
			const size_t begin = size_t(n) * worker / workers, end = size_t(n) * (worker + 1) / workers;
			if (begin < end)
				Lookup(end - begin, keys + begin, out + begin);
		});
		return n;
	}

private:
	uint32_t Mask(uint32_t code) const {
		return FastPatternBF::Rotate(patterns_[code & 31], code >> 5);
	}
	void Set(size_t index, uint32_t mask) {
		auto &word = lines_[index / 16].words[index % 16];
		if ((word.load(std::memory_order_relaxed) & mask) != mask)
			word.fetch_or(mask, std::memory_order_relaxed);
	}
	size_t words_;
	std::unique_ptr<Line[]> lines_;
	const uint32_t *patterns_;
};
} // namespace bloom_filters
