#pragma once
#include "compat.hpp"
#include "allocation_audit.hpp"
#include <new>
// The original PImpl translation units use these same extern declarations.
// Reuse their separately compiled instances instead of emitting the entire
// runtime dispatcher a second time in each correctness adapter translation unit.
#include <dtl/filter/blocked_bloomfilter/instances/blocked_bloomfilter_logic_u32_instance.hpp>
#include <dtl/filter/blocked_bloomfilter/instances/blocked_bloomfilter_logic_u64_instance.hpp>
#include <dtl/filter/blocked_bloomfilter/blocked_bloomfilter.hpp>
#include <dtl/filter/bbf_32.hpp>
#include <dtl/filter/bbf_64.hpp>
#include "fast_pattern_BF.h"
#include "four_sector_bloom.h"
#include "split64_bloom.h"
#include "byte_split_bloom.h"
namespace vldb_external {
// Exact physical capacity for the pinned public blocked-Bloom compact API.
// Stores may extend past the returned count, but never past processed key_cnt.
inline size_t PositionScratchBytes(size_t key_count) {
  if(key_count>UINT32_MAX || key_count>std::numeric_limits<size_t>::max()/sizeof(uint32_t))
    throw std::overflow_error("compact scratch size");
  return key_count*sizeof(uint32_t);
}
inline size_t CheckedBits(size_t bits) {
  if(!bits || bits>(size_t(1)<<31)) throw std::invalid_argument("bit-length outside scaffold limits");
  return bits;
}
// Payload allocation is exact requested aligned storage, including explicit padding.
template<class Word> class AlignedWords {
  Word* data_=nullptr; size_t bytes_=0, logical_=0;
public:
  explicit AlignedWords(size_t words) {
    if(words>(std::numeric_limits<size_t>::max()-63)/sizeof(Word)) throw std::overflow_error("bitmap bytes");
    logical_=words*sizeof(Word); if(logical_>(size_t(1)<<28)) throw std::overflow_error("actual bitmap exceeds256MiB"); bytes_=(logical_+63)&~size_t(63);
    if(bytes_) {
      allocation_audit::Scope phase(allocation_audit::Phase::Bitmap);
      data_=static_cast<Word*>(::operator new(bytes_,std::align_val_t(64))); std::memset(data_,0,bytes_);
    }
  }
  ~AlignedWords() { ::operator delete(data_,std::align_val_t(64)); }
  AlignedWords(const AlignedWords&)=delete; AlignedWords& operator=(const AlignedWords&)=delete;
  Word* data() { return data_; } const Word* data() const { return data_; }
  size_t backing_bytes() const { return bytes_; } size_t logical_bytes() const { return logical_; }
};
// Conversion belongs in the raw batch timer. Validation belongs after it.
inline void PositionsToDense(size_t n,const uint32_t* positions,uint64_t count,uint32_t* out) {
  if(!n) return;
  std::fill(out,out+n,0u);
  for(uint64_t i=0;i<count;++i) out[positions[i]]=1;
}
inline void ValidatePositions(size_t n,const uint32_t* positions,uint64_t count) {
  if(count>n) throw std::runtime_error("invalid match count");
  std::vector<uint8_t> seen(n,0);
  for(uint64_t i=0;i<count;++i) {
    if(positions[i]>=n || seen[positions[i]]) throw std::runtime_error("invalid match position");
    seen[positions[i]]=1;
  }
}
struct FixedTune final : dtl::blocked_bloomfilter_tune {
  uint32_t unroll; explicit FixedTune(uint32_t u):unroll(u) {}
  uint32_t get_unroll_factor(const dtl::blocked_bloomfilter_config&) const override { return unroll; }
};
// Public std::function wrapper. This is distinct from the artifact's PImpl facade.
template<class Word,unsigned W,unsigned S,unsigned K,unsigned U> class DirectDynamic {
  FixedTune tune_; dtl::blocked_bloomfilter<Word> logic_; AlignedWords<Word> bitmap_;
public:
  explicit DirectDynamic(size_t bits):tune_(U),logic_(CheckedBits(bits),K,W,S,tune_),bitmap_(logic_.size()) {}
  void Insert(uint32_t n,const uint32_t* keys) { if(n) logic_.batch_insert(bitmap_.data(),keys,n); }
  bool Contains(uint32_t key) const { return logic_.contains(bitmap_.data(),key); }
  uint64_t Compact(uint32_t n,const uint32_t* keys,uint32_t* positions) const { return n?logic_.batch_contains(bitmap_.data(),keys,n,positions,0):0; }
  uint64_t Dense(uint32_t n,const uint32_t* keys,uint32_t* out,uint32_t* positions) const { const auto count=Compact(n,keys,positions); PositionsToDense(n,positions,count,out); return count; }
  std::string Metadata() { return logic_.name(); }
  const Word* data() const { return bitmap_.data(); } size_t logical_bytes() const { return logic_.size_in_bytes(); }
  size_t backing_bytes() const { return bitmap_.backing_bytes(); }
};
// Static alias exposed by the same public header. Address is explicitly registered.
template<class Word,unsigned W,unsigned S,unsigned K,unsigned U,dtl::block_addressing Address> class StaticLogic {
  using Logic=typename dtl::blocked_bloomfilter<Word>::template bbf<W,S,K,Address,false>;
  Logic logic_; AlignedWords<Word> bitmap_;
public:
  explicit StaticLogic(size_t bits):logic_(CheckedBits(bits)),bitmap_(logic_.word_cnt()) {}
  void Insert(uint32_t n,const uint32_t* keys) { if(n) logic_.batch_insert(bitmap_.data(),keys,n); }
  bool Contains(uint32_t key) const { return logic_.contains(bitmap_.data(),key); }
  uint64_t Compact(uint32_t n,const uint32_t* keys,uint32_t* positions) const {
    return n?logic_.template batch_contains<dtl::simd::lane_count<uint32_t>*U>(bitmap_.data(),keys,n,positions,0):0;
  }
  uint64_t Dense(uint32_t n,const uint32_t* keys,uint32_t* out,uint32_t* positions) const { const auto count=Compact(n,keys,positions); PositionsToDense(n,positions,count,out); return count; }
  const Word* data() const { return bitmap_.data(); } size_t logical_bytes() const { return (logic_.get_length()+7)/8; }
  size_t backing_bytes() const { return bitmap_.backing_bytes(); }
};
// name() reads the live tuner, while upstream query functions capture U at
// construction. Never allow a Configure call to relabel an older live object.
template<class Public> struct ArtifactState {
  inline static size_t alive=0;
  inline static bool configured=false;
  inline static unsigned unroll=0;
};
template<class Public,unsigned U> class ArtifactLifetime {
public:
  ArtifactLifetime() {
    if(!ArtifactState<Public>::configured || ArtifactState<Public>::unroll!=U)
      throw std::logic_error("Configure must precede artifact construction");
    ++ArtifactState<Public>::alive;
  }
  ~ArtifactLifetime() { --ArtifactState<Public>::alive; }
  ArtifactLifetime(const ArtifactLifetime&)=delete;
  ArtifactLifetime& operator=(const ArtifactLifetime&)=delete;
};
// Primary artifact facade: no access to pimpl or hidden logic instance.
template<class Public,unsigned W,unsigned S,unsigned K,unsigned U> class ArtifactPublic {
  using Word=typename Public::word_t;
  ArtifactLifetime<Public,U> lifetime_;
  Public logic_; AlignedWords<Word> bitmap_;
public:
  // Shared registry/tuner setup, called once per configuration outside build timers.
  static void Configure() {
    if(ArtifactState<Public>::alive) throw std::logic_error("Cannot retune while an artifact instance is alive");
    if(ArtifactState<Public>::configured && ArtifactState<Public>::unroll!=U)
      throw std::logic_error("Upstream tuner retains first U; a different U requires a fresh process");
    Public::force_unroll_factor(U);
    ArtifactState<Public>::unroll=U;ArtifactState<Public>::configured=true;
  }
  explicit ArtifactPublic(size_t bits):logic_(CheckedBits(bits),K,W,S),bitmap_(logic_.size()) {}
  std::string Metadata() const { return logic_.name(); }
  void CheckConfiguration() const {
    // Reject a tuner coverage gap or an inherited per-config calibration value.
    const std::string token="\"u\":"+std::to_string(U)+",";
    const auto actual=logic_.name();
    if(actual.find(token)==std::string::npos) throw std::runtime_error("requested U="+std::to_string(U)+" but upstream metadata="+actual);
  }
  void Insert(uint32_t n,const uint32_t* keys) { if(n && !logic_.batch_insert(bitmap_.data(),keys,n)) throw std::runtime_error("upstream insertion failed"); }
  bool Contains(uint32_t key) const { return logic_.contains(bitmap_.data(),key); }
  uint64_t Compact(uint32_t n,const uint32_t* keys,uint32_t* positions) const { return n?logic_.batch_contains(bitmap_.data(),keys,n,positions,0):0; }
  uint64_t Dense(uint32_t n,const uint32_t* keys,uint32_t* out,uint32_t* positions) const { const auto count=Compact(n,keys,positions); PositionsToDense(n,positions,count,out); return count; }
  const Word* data() const { return bitmap_.data(); } size_t logical_bytes() const { return logic_.size_in_bytes(); }
  size_t backing_bytes() const { return bitmap_.backing_bytes(); }
};
// Common hash is inside these raw-u32 API methods. No truncation or prehash shortcut.
template<class Filter> class NativeRaw {
  Filter filter_;
public:
  NativeRaw(size_t n,uint32_t bpk):filter_(n,bpk) {}
  void Insert(uint32_t n,const uint32_t* keys,uint64_t* scratch) {
    for(uint32_t i=0;i<n;++i) scratch[i]=bloom_filters::MurmurHash64(uint64_t(keys[i]));
    filter_.Insert(n,scratch);
  }
  bool Contains(uint32_t key) const { const uint64_t h=bloom_filters::MurmurHash64(uint64_t(key));uint32_t out;filter_.Lookup(1,&h,&out);return out!=0; }
  void Dense(uint32_t n,const uint32_t* keys,uint32_t* out,uint64_t* scratch) const {
    for(uint32_t i=0;i<n;++i) scratch[i]=bloom_filters::MurmurHash64(uint64_t(keys[i]));
    filter_.Lookup(n,scratch,out);
  }
  size_t backing_bytes() const { return filter_.SizeInBytes(); }
};
} // namespace vldb_external
