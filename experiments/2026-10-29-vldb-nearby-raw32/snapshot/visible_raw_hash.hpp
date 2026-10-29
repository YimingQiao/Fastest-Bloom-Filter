#pragma once
#include "raw_hash.hpp"
namespace raw32_stage3 {
template<class F,class Policy> class VisibleRawHash {
  F filter_;Geometry geometry_;size_t keys_;mutable std::vector<uint64_t> scratch_;
public:
  VisibleRawHash(size_t n,uint32_t cap):filter_(Policy::Make(n,cap)),geometry_(Policy::Plan(n,cap)),keys_(n){Need(filter_.SizeInBytes()==geometry_.bytes,"actual bitmap allocation differs from plan");}
  Geometry Info() const { return geometry_; }
  const void* BitmapData() const { return filter_.Data(); }
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
}
