#include "allocation_audit.hpp"
#include <atomic>
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <limits>
#include <new>
#include <sys/mman.h>
#include <unistd.h>

// Prefix accounting is deliberately isolated from ASan's ordinary target:
// these bookkeeping bytes change malloc request sizes and redzone placement.
namespace vldb_external::allocation_audit {
namespace {
struct AtomicCounters {
  std::atomic<uint64_t> allocations{0},frees{0},requested_total{0},requested_live{0},requested_peak{0};
  std::atomic<uint64_t> overhead_live{0},overhead_peak{0};
  std::atomic<uint64_t> mappings{0},unmaps{0},mapped_requested_live{0},mapped_pages_live{0},mapped_pages_peak{0};
};
AtomicCounters counters[PhaseCount];
std::atomic<unsigned> current{static_cast<unsigned>(Phase::Startup)};
struct Header { void* base; size_t requested,overhead; Phase owner; uint64_t cookie; };
constexpr uint64_t Cookie=UINT64_C(0x564c444241554449);
void Peak(std::atomic<uint64_t>& peak,uint64_t value) noexcept {
  auto old=peak.load(std::memory_order_relaxed);
  while(old<value && !peak.compare_exchange_weak(old,value,std::memory_order_relaxed)) {}
}
Phase Owner() noexcept { return static_cast<Phase>(current.load(std::memory_order_relaxed)); }
void* Allocate(size_t requested,size_t alignment) {
  if(alignment<alignof(std::max_align_t)) alignment=alignof(std::max_align_t);
  if((alignment&(alignment-1)) || alignment>std::numeric_limits<size_t>::max()-sizeof(Header)) throw std::bad_alloc();
  const size_t payload=requested?requested:1;
  const size_t extra=sizeof(Header)+alignment-1;
  if(payload>std::numeric_limits<size_t>::max()-extra) throw std::bad_alloc();
  const size_t total=payload+extra;
  void* base=nullptr;
  while(!(base=std::malloc(total))) {
    auto handler=std::get_new_handler();
    if(!handler) throw std::bad_alloc();
    handler();
  }
  const auto address=(reinterpret_cast<uintptr_t>(base)+sizeof(Header)+alignment-1)&~uintptr_t(alignment-1);
  auto* h=reinterpret_cast<Header*>(address-sizeof(Header));
  const auto owner=Owner();
  ::new(static_cast<void*>(h)) Header{base,requested,total-requested,owner,Cookie^address};
  auto& c=counters[Index(owner)];
  c.allocations.fetch_add(1,std::memory_order_relaxed);
  c.requested_total.fetch_add(requested,std::memory_order_relaxed);
  Peak(c.requested_peak,c.requested_live.fetch_add(requested,std::memory_order_relaxed)+requested);
  Peak(c.overhead_peak,c.overhead_live.fetch_add(total-requested,std::memory_order_relaxed)+total-requested);
  return reinterpret_cast<void*>(address);
}
void Deallocate(void* p) noexcept {
  if(!p) return;
  const auto address=reinterpret_cast<uintptr_t>(p);
  auto* h=reinterpret_cast<Header*>(address-sizeof(Header));
  if(h->cookie!=(Cookie^address) || Index(h->owner)>=PhaseCount) std::abort();
  auto& c=counters[Index(h->owner)];
  c.frees.fetch_add(1,std::memory_order_relaxed);
  c.requested_live.fetch_sub(h->requested,std::memory_order_relaxed);
  c.overhead_live.fetch_sub(h->overhead,std::memory_order_relaxed);
  void* base=h->base;h->cookie=0;std::free(base);
}
struct Mapping { void* address=nullptr; size_t requested=0,pages=0; Phase owner=Phase::Startup; bool active=false; };
Mapping mappings[128];
std::atomic_flag mapping_lock=ATOMIC_FLAG_INIT;
struct Lock {
  Lock() { while(mapping_lock.test_and_set(std::memory_order_acquire)) {} }
  ~Lock() { mapping_lock.clear(std::memory_order_release); }
};
void Map(void* address,size_t requested) noexcept {
  const size_t page=static_cast<size_t>(::sysconf(_SC_PAGESIZE));
  if(!page || requested>std::numeric_limits<size_t>::max()-(page-1)) std::abort();
  const size_t pages=(requested+page-1)/page*page;
  const Phase owner=Owner();
  Lock lock;
  for(auto& m:mappings) if(!m.active) {
    m={address,requested,pages,owner,true};auto& c=counters[Index(owner)];
    c.mappings.fetch_add(1,std::memory_order_relaxed);
    c.mapped_requested_live.fetch_add(requested,std::memory_order_relaxed);
    Peak(c.mapped_pages_peak,c.mapped_pages_live.fetch_add(pages,std::memory_order_relaxed)+pages);
    return;
  }
  std::abort(); // This bounded correctness tracker must fail rather than omit a mapping.
}
void Unmap(void* address,size_t requested) noexcept {
  Lock lock;
  for(auto& m:mappings) if(m.active && m.address==address) {
    // The pinned calibration file uses one complete mapping and complete unmap.
    // Reject partial unmaps instead of silently misaccounting them.
    if(m.requested!=requested) std::abort();
    auto& c=counters[Index(m.owner)];c.unmaps.fetch_add(1,std::memory_order_relaxed);
    c.mapped_requested_live.fetch_sub(m.requested,std::memory_order_relaxed);
    c.mapped_pages_live.fetch_sub(m.pages,std::memory_order_relaxed);
    m={};return;
  }
  std::abort();
}
} // namespace
Phase ExchangePhase(Phase phase) noexcept { return static_cast<Phase>(current.exchange(static_cast<unsigned>(phase),std::memory_order_relaxed)); }
void ResetPeaks(Phase phase) noexcept {
  auto& c=counters[Index(phase)];
  c.requested_peak.store(c.requested_live.load());
  c.overhead_peak.store(c.overhead_live.load());
  c.mapped_pages_peak.store(c.mapped_pages_live.load());
}
Snapshot Read() noexcept {
  Snapshot result;
  for(size_t i=0;i<PhaseCount;++i) {
    const auto& c=counters[i];auto& r=result.phase[i];
    r.allocations=c.allocations.load();r.frees=c.frees.load();r.requested_total=c.requested_total.load();r.requested_live=c.requested_live.load();r.requested_peak=c.requested_peak.load();
    r.tracker_overhead_live=c.overhead_live.load();r.tracker_overhead_peak=c.overhead_peak.load();
    r.mappings=c.mappings.load();r.unmaps=c.unmaps.load();r.mapped_requested_live=c.mapped_requested_live.load();r.mapped_pages_live=c.mapped_pages_live.load();r.mapped_pages_peak=c.mapped_pages_peak.load();
  }
  return result;
}
} // namespace vldb_external::allocation_audit

using vldb_external::allocation_audit::Allocate;
using vldb_external::allocation_audit::Deallocate;
void* operator new(size_t n) { return Allocate(n,alignof(std::max_align_t)); }
void* operator new[](size_t n) { return Allocate(n,alignof(std::max_align_t)); }
void* operator new(size_t n,std::align_val_t a) { return Allocate(n,static_cast<size_t>(a)); }
void* operator new[](size_t n,std::align_val_t a) { return Allocate(n,static_cast<size_t>(a)); }
void operator delete(void* p) noexcept { Deallocate(p); }
void operator delete[](void* p) noexcept { Deallocate(p); }
void operator delete(void* p,size_t) noexcept { Deallocate(p); }
void operator delete[](void* p,size_t) noexcept { Deallocate(p); }
void operator delete(void* p,std::align_val_t) noexcept { Deallocate(p); }
void operator delete[](void* p,std::align_val_t) noexcept { Deallocate(p); }
void operator delete(void* p,size_t,std::align_val_t) noexcept { Deallocate(p); }
void operator delete[](void* p,size_t,std::align_val_t) noexcept { Deallocate(p); }
void* operator new(size_t n,const std::nothrow_t&) noexcept { try { return ::operator new(n); } catch(...) { return nullptr; } }
void* operator new[](size_t n,const std::nothrow_t&) noexcept { try { return ::operator new[](n); } catch(...) { return nullptr; } }
void* operator new(size_t n,std::align_val_t a,const std::nothrow_t&) noexcept { try { return ::operator new(n,a); } catch(...) { return nullptr; } }
void* operator new[](size_t n,std::align_val_t a,const std::nothrow_t&) noexcept { try { return ::operator new[](n,a); } catch(...) { return nullptr; } }
void operator delete(void* p,const std::nothrow_t&) noexcept { Deallocate(p); }
void operator delete[](void* p,const std::nothrow_t&) noexcept { Deallocate(p); }
void operator delete(void* p,std::align_val_t,const std::nothrow_t&) noexcept { Deallocate(p); }
void operator delete[](void* p,std::align_val_t,const std::nothrow_t&) noexcept { Deallocate(p); }

extern "C" void* __real_mmap(void*,size_t,int,int,int,off_t);
extern "C" int __real_munmap(void*,size_t);
extern "C" void* __wrap_mmap(void* address,size_t length,int protection,int flags,int fd,off_t offset) {
  void* result=__real_mmap(address,length,protection,flags,fd,offset);
  if(result!=MAP_FAILED) vldb_external::allocation_audit::Map(result,length);
  return result;
}
extern "C" int __wrap_munmap(void* address,size_t length) {
  const int result=__real_munmap(address,length);
  if(result==0) vldb_external::allocation_audit::Unmap(address,length);
  return result;
}
