#pragma once
#include "independent32_bloom.h"
#include "parallel_bloom.h"

namespace bloom_filters {
// Existing whole-cache-line construction; each line owns two32-byte buckets.
class ParallelIndependent32BloomFilter {
	static constexpr size_t CountersPerLine = 64 / sizeof(size_t);
	static size_t CounterStride(size_t workers) {
		return ((workers + CountersPerLine - 1) / CountersPerLine) * CountersPerLine;
	}

public:
	const void *Data() const { return filter_.Data(); }
	bool ContainsHash(uint64_t hash) const { return filter_.ContainsHash(hash); }
	ParallelIndependent32BloomFilter(size_t keys, uint32_t bits_per_key) : filter_(keys, bits_per_key) {
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
		return parallel_detail::Workers(n, requested, filter_.CacheLineCount());
	}
	size_t BuildScratchBytes(size_t n, size_t requested) const {
		const size_t workers = BuildWorkers(n, requested), stride = CounterStride(workers);
		if (workers == 1)
			return 0;
		const size_t metadata = (workers * stride + workers + 1) * sizeof(size_t);
		if (n > (SIZE_MAX - metadata) / sizeof(uint64_t))
			throw std::length_error("build scratch exceeds address space");
		return n * sizeof(uint64_t) + metadata;
	}
	void InsertParallel(uint32_t n, const uint64_t *keys, size_t requested = 0) {
		const size_t workers = BuildWorkers(n, requested);
		if (workers == 1) {
			filter_.Insert(n, keys);
			return;
		}
		const unsigned line_shift = parallel_detail::Log2(filter_.CacheLineCount());
		const size_t stride = CounterStride(workers);
		// Padding alone is insufficient: align the allocation too, otherwise
		// adjacent histogram rows can still share a boundary cache line.
		std::vector<size_t, AlignedAllocator<size_t, 64>> counts(workers * stride, 0);
		std::vector<size_t> starts(workers + 1);
		std::unique_ptr<uint64_t[]> partitioned(new uint64_t[n]);
		auto shard = [&](uint64_t h) {
			return (uint64_t(filter_.CacheLineIndex(h)) * workers) >> line_shift;
		};
		parallel_detail::For(workers, [&](size_t worker) {
			for (size_t i = uint64_t(n) * worker / workers; i < uint64_t(n) * (worker + 1) / workers; ++i)
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
			for (size_t i = uint64_t(n) * worker / workers; i < uint64_t(n) * (worker + 1) / workers; ++i) {
				auto &position = counts[worker * stride + shard(keys[i])];
				partitioned[position++] = keys[i];
			}
		});
		parallel_detail::For(workers, [&](size_t part) {
			// Every probe stays in one line, owned exclusively by this partition.
			filter_.Insert(static_cast<uint32_t>(starts[part + 1] - starts[part]), partitioned.get() + starts[part]);
		});
	}
	uint32_t LookupParallel(uint32_t n, const uint64_t *keys, uint32_t *out, size_t requested = 0) const {
		const size_t workers = parallel_detail::Workers(n, requested);
		parallel_detail::For(workers, [&](size_t worker) {
			const size_t begin = uint64_t(n) * worker / workers, end = uint64_t(n) * (worker + 1) / workers;
			if (begin < end)
				filter_.Lookup(end - begin, keys + begin, out + begin);
		});
		return n;
	}

private:
	Independent32BloomFilter filter_;
};

} // namespace bloom_filters
