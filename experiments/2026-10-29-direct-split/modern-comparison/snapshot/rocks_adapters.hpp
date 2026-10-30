#pragma once

#include "base.h"
#include "util/bloom_impl.h"
#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>

namespace rocksdb_external {
inline size_t PayloadBytes(size_t keys, uint32_t bits_per_key) {
	if (!bits_per_key || keys > std::numeric_limits<size_t>::max() / bits_per_key)
		throw std::invalid_argument("invalid RocksDB core filter size");
	const size_t bits = std::max<size_t>(512, keys * bits_per_key);
	if (bits >= (size_t {1} << 31))
		throw std::length_error("RocksDB comparison payload exceeds 256 MiB");
	size_t bytes = 128;
	while (bytes <= bits / 8)
		bytes *= 2;
	return bytes;
}

// This owns only a cache-aligned bitmap, not an SST FilterBitsBuilder/Reader.
// Both primitives and their SIMD/scalar implementations are unmodified upstream.
// FixedProbes=0 uses upstream's recommended probe count for the actual bitmap bpk.
template <int FixedProbes, bool Bulk>
class FastLocalBloom64 {
	using Core = ROCKSDB_NAMESPACE::FastLocalBloomImpl;
	static_assert(FixedProbes >= 0 && FixedProbes <= 24, "supported probe count");
	std::vector<char, bloom_filters::AlignedAllocator<char, 64>> data_;
	uint32_t length_;
	int probes_;
	int ProbeCount() const {
		// Fixed aliases specialize the unchanged upstream core API. Expose the
		// constant to the compiler just as the other fixed-k baseline families do.
		if constexpr (FixedProbes != 0)
			return FixedProbes;
		else
			return probes_;
	}

public:
	explicit FastLocalBloom64(size_t keys, uint32_t bits_per_key)
	    : data_(PayloadBytes(keys, bits_per_key), 0), length_(static_cast<uint32_t>(data_.size())),
	      probes_(FixedProbes ? FixedProbes : Core::ChooseNumProbes(static_cast<int>(
	          std::min<uint64_t>(uint64_t {length_} * 8000 / std::max<size_t>(keys, 1),
	                             std::numeric_limits<int>::max())))) {
	}
	size_t SizeInBytes() const {
		return data_.capacity();
	}
	size_t BuildScratchBytes() const {
		// Shared CSV contract: explicit temporary heap storage only. The bulk
		// insertion pipeline has 64 bytes of fixed stack arrays, not heap scratch.
		return 0;
	}
	int NumProbes() const {
		return ProbeCount();
	}
	const char *Data() const {
		return data_.data();
	}
	uint32_t LogicalBytes() const {
		return length_;
	}
	void Insert(uint32_t n, const uint64_t *hashes) {
		if constexpr (!Bulk) {
			for (size_t i = 0; i < n; ++i)
				Core::AddHash(static_cast<uint32_t>(hashes[i]), static_cast<uint32_t>(hashes[i] >> 32),
				              length_, ProbeCount(), data_.data());
		} else {
			// Same eight-slot prepare/add/drain schedule as upstream
			// FastLocalBloomBitsBuilder::AddAllEntries (deque input becomes a slice).
			constexpr size_t kBufferMask = 7;
			std::array<uint32_t, kBufferMask + 1> upper_hashes;
			std::array<uint32_t, kBufferMask + 1> byte_offsets;
			size_t i = 0;
			for (; i <= kBufferMask && i < n; ++i) {
				const uint64_t hash = hashes[i];
				Core::PrepareHash(static_cast<uint32_t>(hash), length_, data_.data(), &byte_offsets[i]);
				upper_hashes[i] = static_cast<uint32_t>(hash >> 32);
			}
			for (; i < n; ++i) {
				auto &upper = upper_hashes[i & kBufferMask];
				auto &offset = byte_offsets[i & kBufferMask];
				Core::AddHashPrepared(upper, ProbeCount(), data_.data() + offset);
				const uint64_t hash = hashes[i];
				Core::PrepareHash(static_cast<uint32_t>(hash), length_, data_.data(), &offset);
				upper = static_cast<uint32_t>(hash >> 32);
			}
			for (i = 0; i <= kBufferMask && i < n; ++i)
				Core::AddHashPrepared(upper_hashes[i], ProbeCount(), data_.data() + byte_offsets[i]);
		}
	}
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		if constexpr (!Bulk) {
			for (size_t i = 0; i < n; ++i)
				out[i] = Core::HashMayMatch(static_cast<uint32_t>(hashes[i]),
				                           static_cast<uint32_t>(hashes[i] >> 32), length_, ProbeCount(), data_.data());
		} else {
			// Upstream MultiGetContext::MAX_BATCH_SIZE is 32. Preserve the
			// reader's prepare-all/query-all schedule, with raw hashing removed.
			constexpr size_t kBatch = 32;
			std::array<uint32_t, kBatch> upper_hashes;
			std::array<uint32_t, kBatch> byte_offsets;
			for (size_t begin = 0; begin < n; begin += kBatch) {
				const size_t count = std::min<size_t>(kBatch, n - begin);
				for (size_t i = 0; i < count; ++i) {
					const uint64_t hash = hashes[begin + i];
					Core::PrepareHash(static_cast<uint32_t>(hash), length_, data_.data(), &byte_offsets[i]);
					upper_hashes[i] = static_cast<uint32_t>(hash >> 32);
				}
				for (size_t i = 0; i < count; ++i)
					out[begin + i] = Core::HashMayMatchPrepared(upper_hashes[i], ProbeCount(),
					                                          data_.data() + byte_offsets[i]);
			}
		}
		return n;
	}
};
} // namespace rocksdb_external

using RocksDBFastLocalBloom64 = rocksdb_external::FastLocalBloom64<0, false>;
using RocksDBFastLocalBloom64Batch32 = rocksdb_external::FastLocalBloom64<0, true>;
using RocksDBFastLocalBloom64K8 = rocksdb_external::FastLocalBloom64<8, false>;
using RocksDBFastLocalBloom64K9 = rocksdb_external::FastLocalBloom64<9, false>;
using RocksDBFastLocalBloom64K14 = rocksdb_external::FastLocalBloom64<14, false>;
using RocksDBFastLocalBloom64K8Batch32 = rocksdb_external::FastLocalBloom64<8, true>;
using RocksDBFastLocalBloom64K9Batch32 = rocksdb_external::FastLocalBloom64<9, true>;
using RocksDBFastLocalBloom64K14Batch32 = rocksdb_external::FastLocalBloom64<14, true>;

#define BF_REGISTER_ROCKSDB_FILTERS(ADD)                                                                                \
	ADD(RocksDBFastLocalBloom64, uint64_t);                                                                               \
	ADD(RocksDBFastLocalBloom64Batch32, uint64_t);                                                                        \
	ADD(RocksDBFastLocalBloom64K8, uint64_t);                                                                             \
	ADD(RocksDBFastLocalBloom64K9, uint64_t);                                                                             \
	ADD(RocksDBFastLocalBloom64K14, uint64_t);                                                                            \
	ADD(RocksDBFastLocalBloom64K8Batch32, uint64_t);                                                                      \
	ADD(RocksDBFastLocalBloom64K9Batch32, uint64_t);                                                                      \
	ADD(RocksDBFastLocalBloom64K14Batch32, uint64_t)
#ifndef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) BF_REGISTER_ROCKSDB_FILTERS(ADD)
#endif
