#pragma once
#include "common.hpp"
#include "budget.hpp"
#include "fast_pattern_BF.h"
#include "four_sector_bloom.h"
#include "split64_bloom.h"
#include "byte_split_bloom.h"
#include <type_traits>

namespace raw32_stage3 {
inline size_t BatchCapacity(Mode mode) { return mode==Mode::PublicSingle?0:mode==Mode::DenseBatch1?1:4096; }
template<class T> void ExactScratch(std::vector<T>& scratch,size_t n) {
  std::vector<T> replacement(n);Need(replacement.capacity()==n,"allocator scratch capacity differs from contract");scratch.swap(replacement);
}
template<class F,class=void> struct HasSingle:std::false_type{};
template<class F> struct HasSingle<F,std::void_t<decltype(std::declval<const F&>().ScalarContains(uint64_t{}))>>:std::true_type{};
template<class F,class=void> struct HasBuildScratch:std::false_type{};
template<class F> struct HasBuildScratch<F,std::void_t<decltype(std::declval<const F&>().BuildScratchBytes())>>:std::true_type{};
template<class F,int Probes> struct NativePolicy {
  static Geometry Plan(size_t n,uint32_t cap) {
    Geometry g;g.budget=exact_budget::Bytes(n,cap);g.argument=exact_budget::NativeArgument(n,g.budget);
    g.bytes=g.logical=exact_budget::NativeBytes(n,g.argument);g.unit=64;g.units=g.bytes/64;
    g.kind="native_pow2_lines";g.address="pow2";g.origin="production_native";g.surface="public_native_lookup";
    g.probes=Probes;if constexpr(Probes==0)g.probes=n>g.bytes*8/12?6:8;
    if constexpr(Probes==-1)g.probe_policy="variable_byte_mask_0_16";
    return g;
  }
  static F Make(size_t n,uint32_t cap){return F(n,Plan(n,cap).argument);}
};
template<class F,class Policy> class RawHash {
  F filter_;Geometry geometry_;size_t keys_;mutable std::vector<uint64_t> scratch_;
public:
  RawHash(size_t n,uint32_t cap):filter_(Policy::Make(n,cap)),geometry_(Policy::Plan(n,cap)),keys_(n){Need(filter_.SizeInBytes()==geometry_.bytes,"actual bitmap allocation differs from plan");}
  Geometry Info() const { return geometry_; }
  void Insert(uint32_t n,const uint32_t* raw) {
    std::vector<uint64_t> hashes(n);
    for(size_t i=0;i<n;++i)hashes[i]=bloom_filters::MurmurHash64(uint64_t(raw[i]));
    filter_.Insert(n,hashes.data());
  }
  void Prepare(Mode mode){ExactScratch(scratch_,BatchCapacity(mode));}
  bool Single(uint32_t key) const {
    const uint64_t hash=bloom_filters::MurmurHash64(uint64_t(key));
    if constexpr(HasSingle<F>::value)return filter_.ScalarContains(hash);
    else { uint32_t answer=0;filter_.Lookup(1,&hash,&answer);return answer!=0; }
  }
  void Dense(uint32_t n,const uint32_t* raw,uint32_t* out) const {
    // The shared caller limits n to the prepared batch capacity.
    for(size_t i=0;i<n;++i)scratch_[i]=bloom_filters::MurmurHash64(uint64_t(raw[i]));
    filter_.Lookup(n,scratch_.data(),out);
  }
  size_t QueryScratchBytes() const { return scratch_.capacity()*sizeof(uint64_t); }
  size_t BuildHashScratchBytes() const { return keys_*sizeof(uint64_t); }
  size_t FilterBuildScratchBytes() const { if constexpr(HasBuildScratch<F>::value)return filter_.BuildScratchBytes();else return 0; }
};
using RawFastPattern=RawHash<bloom_filters::FastPatternBF,NativePolicy<bloom_filters::FastPatternBF,0>>;
using RawFourSector=RawHash<bloom_filters::FourSectorBloomFilter,NativePolicy<bloom_filters::FourSectorBloomFilter,8>>;
using RawSplit64=RawHash<bloom_filters::Split64BloomFilter,NativePolicy<bloom_filters::Split64BloomFilter,8>>;
using RawByteSplit=RawHash<bloom_filters::ByteSplitBloomFilter,NativePolicy<bloom_filters::ByteSplitBloomFilter,-1>>;
inline bool IsNative(const std::string& name){return name=="FastPatternBF"||name=="FourSectorBloomFilter"||name=="Split64BloomFilter"||name=="ByteSplitBloomFilter";}
inline int RunNative(const char* worker,const Args& a) {
  if(a.name=="FastPatternBF")return Run<RawFastPattern>(worker,a);
  if(a.name=="FourSectorBloomFilter")return Run<RawFourSector>(worker,a);
  if(a.name=="Split64BloomFilter")return Run<RawSplit64>(worker,a);
  if(a.name=="ByteSplitBloomFilter")return Run<RawByteSplit>(worker,a);
  throw std::invalid_argument("unknown native filter");
}
} // namespace raw32_stage3
