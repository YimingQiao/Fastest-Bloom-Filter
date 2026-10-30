#pragma once
#include <cstddef>

namespace bloom_filters {
namespace parallel_detail {
// A bounded build policy for Split64 and Split64Range only. n is the current
// insertion batch length; bytes is the actual allocated bitmap footprint.
inline size_t Split64BuildRequest(size_t n, size_t bytes, size_t requested) {
    return n <= 65536 && bytes <= 262144 ? 1 : requested;
}
} // namespace parallel_detail
} // namespace bloom_filters
