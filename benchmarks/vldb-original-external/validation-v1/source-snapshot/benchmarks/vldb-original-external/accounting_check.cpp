#include "test_types.hpp"
#include "raw32_workload.hpp"
#include <optional>
#include <sys/mman.h>
#include <unistd.h>
using namespace vldb_external;
namespace audit=vldb_external::allocation_audit;
static void Require(bool value,const char* message) { if(!value) throw std::runtime_error(message); }
template<class F,class=void> struct HasConfigure:std::false_type {};
template<class F> struct HasConfigure<F,std::void_t<decltype(F::Configure())>>:std::true_type {};
template<class F,class=void> struct HasMetadata:std::false_type {};
template<class F> struct HasMetadata<F,std::void_t<decltype(std::declval<const F&>().CheckConfiguration())>>:std::true_type {};
static const audit::Counters& At(const audit::Snapshot& s,audit::Phase p) { return s.phase[audit::Index(p)]; }

static void CheckHooks() {
  const auto before=audit::Read();
  {
    audit::Scope phase(audit::Phase::Metadata);
    void* ordinary=::operator new(17);
    void* aligned=::operator new(23,std::align_val_t(128));
    Require(reinterpret_cast<uintptr_t>(aligned)%128==0,"tracker changed aligned new contract");
    const auto live=audit::Read();
    Require(At(live,audit::Phase::Metadata).requested_live-At(before,audit::Phase::Metadata).requested_live==40,"new requested-byte accounting");
    ::operator delete(ordinary);::operator delete(aligned,std::align_val_t(128));
    const size_t page=static_cast<size_t>(::sysconf(_SC_PAGESIZE));
    void* mapped=::mmap(nullptr,page,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    Require(mapped!=MAP_FAILED,"tracker mapping fixture failed");
    const auto during=audit::Read();
    Require(At(during,audit::Phase::Metadata).mapped_requested_live-At(before,audit::Phase::Metadata).mapped_requested_live==page,"mmap requested-byte accounting");
    Require(At(during,audit::Phase::Metadata).mapped_pages_live-At(before,audit::Phase::Metadata).mapped_pages_live==page,"mmap page accounting");
    Require(::munmap(mapped,page)==0,"tracker unmap fixture failed");
  }
  const auto after=audit::Read();
  Require(At(after,audit::Phase::Metadata).requested_live==At(before,audit::Phase::Metadata).requested_live,"tracker free accounting");
  Require(At(after,audit::Phase::Metadata).mapped_requested_live==At(before,audit::Phase::Metadata).mapped_requested_live,"tracker unmap accounting");
}

template<class F> void CheckOne(const char* name,const Raw32Workload& workload,bool expects_control_heap) {
  // Input/output/test allocations are outside the classified API phases.
  std::vector<uint32_t> output(workload.query.size()),positions(workload.query.size());
  audit::ResetPeaks(audit::Phase::SharedSetup);
  const auto setup_before=audit::Read();
  if constexpr(HasConfigure<F>::value) {
    audit::Scope phase(audit::Phase::SharedSetup);F::Configure();
  }
  const auto setup_after=audit::Read();
  audit::ResetPeaks(audit::Phase::Control);audit::ResetPeaks(audit::Phase::Bitmap);
  const auto before=audit::Read();
  std::optional<F> filter;
  { audit::Scope phase(audit::Phase::Control);filter.emplace(32768); }
  const auto constructed=audit::Read();
  const auto control=At(constructed,audit::Phase::Control).requested_live-At(before,audit::Phase::Control).requested_live;
  const auto bitmap=At(constructed,audit::Phase::Bitmap).requested_live-At(before,audit::Phase::Bitmap).requested_live;
  Require(bitmap==filter->backing_bytes(),"bitmap allocation omitted or double-counted");
  Require(filter->logical_bytes()<=bitmap && bitmap%64==0,"bitmap padding contract");
  Require((control>0)==expects_control_heap,"unexpected public control heap classification");
  const auto metadata_before=audit::Read();
  { audit::Scope phase(audit::Phase::Metadata);if constexpr(HasMetadata<F>::value) filter->CheckConfiguration(); }
  const auto metadata_after=audit::Read();
  Require(At(metadata_after,audit::Phase::Metadata).requested_live==At(metadata_before,audit::Phase::Metadata).requested_live,"metadata left hidden live heap");
  const auto api_before=audit::Read();
  uint64_t count=0;
  {
    audit::Scope phase(audit::Phase::Api);
    filter->Insert(workload.inserted.size(),workload.inserted.data());
    for(auto key:workload.inserted) Require(filter->Contains(key),"accounting target false negative");
    count=filter->Dense(workload.query.size(),workload.query.data(),output.data(),positions.data());
  }
  const auto api_after=audit::Read();
  Require(At(api_after,audit::Phase::Api).allocations==At(api_before,audit::Phase::Api).allocations,"public API allocated hidden C++ heap scratch");
  Require(At(api_after,audit::Phase::Api).mappings==At(api_before,audit::Phase::Api).mappings,"public API mapped hidden scratch");
  ValidatePositions(workload.query.size(),positions.data(),count);
  size_t hits=0;
  for(size_t i=0;i<output.size();++i) { Require(output[i]==uint32_t(filter->Contains(workload.query[i])),"accounting dense parity");hits+=output[i]; }
  Require(hits==count,"accounting compact count");
  const size_t logical=filter->logical_bytes(),backing=filter->backing_bytes();
  { audit::Scope phase(audit::Phase::Control);filter.reset(); }
  const auto destroyed=audit::Read();
  Require(At(destroyed,audit::Phase::Control).requested_live==At(before,audit::Phase::Control).requested_live,"public control heap not released");
  Require(At(destroyed,audit::Phase::Bitmap).requested_live==At(before,audit::Phase::Bitmap).requested_live,"bitmap not released");
  const auto& sb=At(setup_before,audit::Phase::SharedSetup);const auto& sa=At(setup_after,audit::Phase::SharedSetup);
  const auto& cb=At(before,audit::Phase::Control);const auto& ca=At(constructed,audit::Phase::Control);
  const auto& ba=At(constructed,audit::Phase::Bitmap);const auto& bb=At(before,audit::Phase::Bitmap);
  std::cout<<name<<','<<HasConfigure<F>::value<<','<<logical<<','<<backing<<','<<sizeof(F)<<','<<control
           <<','<<ca.requested_total-cb.requested_total<<','<<ca.requested_peak-cb.requested_live
           <<','<<bitmap<<','<<ca.tracker_overhead_live-cb.tracker_overhead_live+ba.tracker_overhead_live-bb.tracker_overhead_live
           <<','<<sa.requested_live<<','<<sa.requested_total-sb.requested_total<<','<<sa.requested_peak-sb.requested_live
           <<','<<sa.mapped_requested_live<<','<<sa.mapped_pages_live
           <<','<<At(metadata_after,audit::Phase::Metadata).requested_total-At(metadata_before,audit::Phase::Metadata).requested_total
           <<','<<At(api_after,audit::Phase::Api).requested_total-At(api_before,audit::Phase::Api).requested_total
           <<','<<PositionScratchBytes(workload.query.size())<<','<<At(before,audit::Phase::Startup).requested_live
           <<','<<count<<",true\n";
}

int main() {
  audit::Scope harness(audit::Phase::Harness);
  CheckHooks();
  Raw32Workload workload(1024,4096,0,50,42);
  std::cout<<"filter,requires_shared_setup,logical_bitmap_bytes,backing_bitmap_bytes,adapter_object_bytes,control_heap_live_bytes,control_heap_requested_total_bytes,control_heap_peak_extra_bytes,bitmap_heap_live_bytes,tracker_owned_overhead_bytes,process_shared_setup_live_bytes,setup_requested_total_delta_bytes,setup_peak_extra_bytes,process_shared_mapped_requested_bytes,process_shared_mapped_page_bytes,metadata_requested_total_bytes,api_requested_total_bytes,position_scratch_bytes,startup_cpp_heap_live_bytes,matches,owned_heap_released\n";
  CheckOne<Sector32<1>::Dynamic>("DirectDynamic32W8S8K8U1",workload,true);
  CheckOne<Sector32<1>::Static>("StaticLogic32W8S8K8U1",workload,false);
  CheckOne<Sector32<1>::Public>("ArtifactPublic32W8S8K8U1",workload,true);
  CheckOne<Sector64<1>::Dynamic>("DirectDynamic64W8S8K8U1",workload,true);
  CheckOne<Sector64<1>::Static>("StaticLogic64W8S8K8U1",workload,false);
  CheckOne<Sector64<1>::Public>("ArtifactPublic64W8S8K8U1",workload,true);
  CheckOne<Register64::Dynamic>("DirectDynamic64W1S1K8U0",workload,true);
  CheckOne<Register64::Static>("StaticLogic64W1S1K8U0",workload,false);
  CheckOne<Register64::Public>("ArtifactPublic64W1S1K8U0",workload,true);
}
