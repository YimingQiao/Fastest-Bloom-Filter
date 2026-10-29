#pragma once

#include <cstddef>
#include <cstdint>
#include <utility>

namespace native_build_policy {

// This is the current incremental batch size, not the constructor's real_n.
inline constexpr size_t EffectiveRequest(size_t batch_n, size_t bitmap_bytes,
                                         size_t requested) noexcept {
    return batch_n <= 65536 && bitmap_bytes <= 256 * 1024 ? 1 : requested;
}

// Both controls use the same typed public forwarding surface. The native filter,
// partition passes, scheduler, bitmap, masks, and query implementation stay exact.
template <class Native, bool Enabled> class Filter {
public:
    template <class... Args> explicit Filter(Args&&... args)
        : native_(std::forward<Args>(args)...) {}

    size_t SizeInBytes() const { return native_.SizeInBytes(); }
    size_t EffectiveBuildRequest(size_t n, size_t requested) const {
        if constexpr (Enabled)
            return EffectiveRequest(n, SizeInBytes(), requested);
        return requested;
    }
    size_t BuildWorkers(size_t n, size_t requested) const {
        return native_.BuildWorkers(n, EffectiveBuildRequest(n, requested));
    }
    size_t BuildScratchBytes(size_t n, size_t requested) const {
        return native_.BuildScratchBytes(n, EffectiveBuildRequest(n, requested));
    }
    void Insert(uint32_t n, const uint64_t* hashes) { native_.Insert(n, hashes); }
    void InsertParallel(uint32_t n, const uint64_t* hashes, size_t requested = 0) {
        // Selection remains inside the timed candidate public call.
        native_.InsertParallel(n, hashes, EffectiveBuildRequest(n, requested));
    }
    uint32_t Lookup(uint32_t n, const uint64_t* hashes, uint32_t* out) const {
        return native_.Lookup(n, hashes, out);
    }
    uint32_t LookupParallel(uint32_t n, const uint64_t* hashes, uint32_t* out,
                            size_t requested = 0) const {
        // Query always receives the original requested budget.
        return native_.LookupParallel(n, hashes, out, requested);
    }

private:
    Native native_;
};

} // namespace native_build_policy
