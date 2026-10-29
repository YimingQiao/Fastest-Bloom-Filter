#include "modern_geometry.hpp"
#include "raw_hash.hpp"
namespace raw32_stage3 {
template<class F> struct ModernPolicy {
  static Geometry Plan(size_t n,uint32_t cap) {
    const auto old=exact_budget::Traits<F>::Plan(n,cap);
    Geometry g;g.budget=old.budget_bytes;g.bytes=old.allocated_bytes;g.logical=old.logical_bytes;
    g.unit=old.unit_bytes;g.units=old.units;g.argument=old.constructor_argument;g.probes=old.probes;
    g.kind=old.kind;g.probe_policy=old.probe_policy;g.origin=old.origin;g.surface="upstream_public_hash_api";
    if(g.kind=="simd_pow2_buckets")g.address="pow2";
    return g;
  }
  static F Make(size_t n,uint32_t cap){return exact_budget::Traits<F>::Make(n,cap);}
};
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
  void Dense(uint32_t n,const uint32_t* raw,uint32_t* out)const{for(size_t i=0;i<n;++i)out[i]=filter_.test(reinterpret_cast<const uint8_t*>(raw+i),sizeof(uint32_t));}
  void Prepare(Mode){}
  size_t QueryScratchBytes()const{return 0;}
  size_t BuildHashScratchBytes()const{return 0;}
  size_t FilterBuildScratchBytes()const{return 0;}
};
static const char* Names[]={"FastPatternBF","FourSectorBloomFilter","Split64BloomFilter","ByteSplitBloomFilter",
 "Boost192ClassicK11","Boost192Multi32K4","Boost192Multi32K8","Boost192Multi64K8",
 "FastFilterFixed16","FastFilterFixed16SingleV1","FastFilterFixed32","FastFilterFixed32Bulk","FastFilterFixed64",
 "FastFilterSimdBlock","FastFilterSimdBlockSingleV1","RocksDBFastLocalBloom64K8","RocksDBFastLocalBloom64K8Batch32",
 "PageBloom4Default","PageBloom4Compact","PageBloom6Default","PageBloom6Compact","PageBloom8Default","PageBloom8Compact"};
}
int main(int argc,char** argv)try {
  using namespace raw32_stage3;
  if(argc==2 && std::string(argv[1])=="--names"){for(auto name:Names)std::cout<<name<<'\n';return 0;}
  const Args a=Parse(argc,argv);
  Need(std::find(std::begin(Names),std::end(Names),a.name)!=std::end(Names),"unknown filter; no work performed");
  if(IsNative(a.name))return RunNative("modern",a);
#define RUN(F) if(a.name==#F)return Run<RawHash<F,ModernPolicy<F>>>("modern",a)
  RUN(Boost192ClassicK11);RUN(Boost192Multi32K4);RUN(Boost192Multi32K8);RUN(Boost192Multi64K8);
  RUN(FastFilterFixed16);RUN(FastFilterFixed16SingleV1);RUN(FastFilterFixed32);RUN(FastFilterFixed32Bulk);RUN(FastFilterFixed64);
  RUN(FastFilterSimdBlock);RUN(FastFilterSimdBlockSingleV1);RUN(RocksDBFastLocalBloom64K8);RUN(RocksDBFastLocalBloom64K8Batch32);
#undef RUN
#define PAGE(NAME,K,C) if(a.name==NAME)return Run<RawPage<K,C>>("modern",a)
  PAGE("PageBloom4Default",4,false);PAGE("PageBloom4Compact",4,true);PAGE("PageBloom6Default",6,false);PAGE("PageBloom6Compact",6,true);PAGE("PageBloom8Default",8,false);PAGE("PageBloom8Compact",8,true);
#undef PAGE
  throw std::runtime_error("registered filter has no dispatcher");
}catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 2;}
