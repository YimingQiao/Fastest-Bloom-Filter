#pragma once
#include "modern_geometry.hpp"
#include "raw_hash.hpp"
namespace raw32_stage3 {
template<unsigned K,bool Compact> class RawPage {
  static unsigned Level(size_t n,uint32_t cap){return exact_budget::PageLevel<K,Compact>(exact_budget::Bytes(n,cap));}
  pbf::PageBloomFilter<K> filter_;Geometry geometry_;
public:
  RawPage(size_t n,uint32_t cap):filter_(Level(n,cap),static_cast<unsigned>(exact_budget::Bytes(n,cap)>>Level(n,cap))) {
    const unsigned level=Level(n,cap);geometry_.budget=exact_budget::Bytes(n,cap);
    geometry_.unit=size_t{1}<<level;geometry_.units=geometry_.budget/geometry_.unit;
    geometry_.bytes=geometry_.logical=geometry_.units*geometry_.unit;geometry_.argument=geometry_.units;
    geometry_.probes=K;geometry_.kind="page_raw4_bytes";geometry_.surface="upstream_raw4_byte_api";
    geometry_.metadata="{\"key_bytes\":4,\"page_level\":"+std::to_string(level)+"}";
    Need(filter_.data()!=nullptr && filter_.data_size()==geometry_.bytes,"PageBloom allocation/constructor failed");
  }
  Geometry Info()const{return geometry_;}
  void Insert(uint32_t n,const uint32_t* raw){for(size_t i=0;i<n;++i)filter_.set(reinterpret_cast<const uint8_t*>(raw+i),sizeof(uint32_t));}
  bool Single(uint32_t key)const{return filter_.test(reinterpret_cast<const uint8_t*>(&key),sizeof(uint32_t));}
  bool SinglePointer(const uint32_t* key)const{return filter_.test(reinterpret_cast<const uint8_t*>(key),sizeof(uint32_t));}
  void Dense(uint32_t n,const uint32_t* raw,uint32_t* out)const{for(size_t i=0;i<n;++i)out[i]=filter_.test(reinterpret_cast<const uint8_t*>(raw+i),sizeof(uint32_t));}
  void Prepare(Mode){}
  size_t QueryScratchBytes()const{return 0;}
  size_t BuildHashScratchBytes()const{return 0;}
  size_t FilterBuildScratchBytes()const{return 0;}
};
// Same owned filter/geometry. This empty derived facade changes only the
// public-single caller; inherited Insert/Single/Dense/Prepare stay exact.
template<unsigned K,bool Compact> class RawPagePointer:public RawPage<K,Compact> {
public:
  using Base=RawPage<K,Compact>;
  using Base::Base;
  Geometry Info()const {auto g=Base::Info();g.surface="upstream_raw4_input_pointer_single_v1";return g;}
};
using Pointer4Default=RawPagePointer<4,false>;
using Pointer4Compact=RawPagePointer<4,true>;
using Pointer6Default=RawPagePointer<6,false>;
using Pointer6Compact=RawPagePointer<6,true>;
using Pointer8Default=RawPagePointer<8,false>;
using Pointer8Compact=RawPagePointer<8,true>;
static_assert(sizeof(Pointer4Default)==sizeof(RawPage<4,false>));
static_assert(sizeof(Pointer4Compact)==sizeof(RawPage<4,true>));
static_assert(sizeof(Pointer6Default)==sizeof(RawPage<6,false>));
static_assert(sizeof(Pointer6Compact)==sizeof(RawPage<6,true>));
static_assert(sizeof(Pointer8Default)==sizeof(RawPage<8,false>));
static_assert(sizeof(Pointer8Compact)==sizeof(RawPage<8,true>));
} // namespace raw32_stage3
