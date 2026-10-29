#pragma once
#include <cstddef>
#include <cstdint>

// This hook is active only in the separate accounting executable. It is never
// linked into the ordinary correctness/sanitizer target or a timed benchmark.
namespace vldb_external::allocation_audit {
enum class Phase : unsigned { Startup, Harness, SharedSetup, Control, Bitmap, Metadata, Api, Count };
constexpr size_t PhaseCount = static_cast<size_t>(Phase::Count);
struct Counters {
  uint64_t allocations=0, frees=0, requested_total=0, requested_live=0, requested_peak=0;
  uint64_t tracker_overhead_live=0, tracker_overhead_peak=0;
  uint64_t mappings=0, unmaps=0, mapped_requested_live=0, mapped_pages_live=0, mapped_pages_peak=0;
};
struct Snapshot { Counters phase[PhaseCount]; };
#ifdef VLDB_ALLOCATION_AUDIT
Phase ExchangePhase(Phase phase) noexcept;
Snapshot Read() noexcept;
// Use only between completed serial phases, after any upstream workers joined.
void ResetPeaks(Phase phase) noexcept;
class Scope {
  Phase previous_;
public:
  explicit Scope(Phase phase) noexcept : previous_(ExchangePhase(phase)) {}
  ~Scope() { ExchangePhase(previous_); }
  Scope(const Scope&)=delete;
  Scope& operator=(const Scope&)=delete;
};
#else
class Scope {
public:
  explicit Scope(Phase) noexcept {}
};
#endif
inline constexpr size_t Index(Phase phase) { return static_cast<size_t>(phase); }
inline const char* Name(Phase phase) {
  constexpr const char* names[]={"startup","harness","shared_setup","control","bitmap","metadata","api"};
  return names[Index(phase)];
}
} // namespace vldb_external::allocation_audit
