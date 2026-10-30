#include "legacy-adapters.hpp"
#include "legacy-geometry.hpp"
#include "raw_hash.hpp"
namespace raw32_stage3 {
namespace old=vldb_external;
template<class T,class=void>struct HasConfigure:std::false_type{};
template<class T>struct HasConfigure<T,std::void_t<decltype(T::Configure())>>:std::true_type{};
template<class T,class=void>struct HasMetadata:std::false_type{};
template<class T>struct HasMetadata<T,std::void_t<decltype(std::declval<T&>().Metadata())>>:std::true_type{};
template<class T,class=void>struct HasCheck:std::false_type{};
template<class T>struct HasCheck<T,std::void_t<decltype(std::declval<const T&>().CheckConfiguration())>>:std::true_type{};
template<class Word,unsigned W,unsigned S,unsigned U,unsigned Surface,dtl::block_addressing Address>
class RawOriginal {
  using Public=std::conditional_t<sizeof(Word)==4,dtl::bbf_32,dtl::bbf_64>;
  using Filter=std::conditional_t<Surface==0,old::ArtifactPublic<Public,W,S,8,U>,
      std::conditional_t<Surface==1,old::DirectDynamic<Word,W,S,8,U>,old::StaticLogic<Word,W,S,8,U,Address>>>;
  static size_t Bits(size_t n,uint32_t cap){if constexpr(HasConfigure<Filter>::value)Filter::Configure();return vldb_stage2::Plan(exact_budget::Bytes(n,cap),sizeof(Word)*W).constructor_bits;}
  Filter filter_;Geometry geometry_;mutable std::vector<uint32_t> positions_;
public:
  RawOriginal(size_t n,uint32_t cap):filter_(Bits(n,cap)) {
    const auto g=vldb_stage2::Plan(exact_budget::Bytes(n,cap),sizeof(Word)*W);
    if constexpr(Surface==2)Need(g.address==Address,"original template address differs from public constructor");
    if constexpr(HasCheck<Filter>::value)filter_.CheckConfiguration();
    geometry_.budget=g.budget_bytes;geometry_.bytes=filter_.backing_bytes();geometry_.logical=filter_.logical_bytes();
    Need(geometry_.bytes==g.backing_bytes && geometry_.logical==g.logical_bytes,"original actual allocation differs");
    geometry_.unit=g.block_bytes;geometry_.units=g.block_count;geometry_.argument=g.constructor_bits;geometry_.probes=8;
    geometry_.kind="original_blocked_bloom";geometry_.address=vldb_stage2::AddressName(g.address);
    geometry_.surface=Surface==0?"artifact_pimpl":Surface==1?"public_dynamic":"public_static";
    if constexpr(HasMetadata<Filter>::value)geometry_.metadata=filter_.Metadata();
    else geometry_.metadata="{\"size\":"+std::to_string(g.logical_bytes)+",\"word_size\":"+std::to_string(sizeof(Word))+",\"k\":8,\"w\":"+std::to_string(W)+",\"s\":"+std::to_string(S)+",\"u\":"+std::to_string(U)+",\"addr\":\""+geometry_.address+"\",\"metadata_source\":\"public_static_template\"}";
    const auto& m=geometry_.metadata;
    for(const auto& token:{std::string("\"size\":")+std::to_string(g.logical_bytes)+",",std::string("\"word_size\":")+std::to_string(sizeof(Word))+",",std::string("\"k\":8,"),std::string("\"w\":")+std::to_string(W)+",",std::string("\"s\":")+std::to_string(S)+",",std::string("\"u\":")+std::to_string(U)+",",std::string("\"addr\":\"")+geometry_.address+"\""})
      Need(m.find(token)!=std::string::npos,"actual public metadata mismatch");
  }
  Geometry Info()const{return geometry_;}
  void Insert(uint32_t n,const uint32_t* raw){filter_.Insert(n,raw);}
  bool Single(uint32_t key)const{return filter_.Contains(key);}
  void Prepare(Mode mode){ExactScratch(positions_,BatchCapacity(mode));}
  void Dense(uint32_t n,const uint32_t* raw,uint32_t* out)const{filter_.Dense(n,raw,out,positions_.data());}
  size_t QueryScratchBytes()const{return positions_.capacity()*sizeof(uint32_t);}
  size_t BuildHashScratchBytes()const{return 0;}
  size_t FilterBuildScratchBytes()const{return 0;}
};
template<class Word,unsigned W,unsigned S,unsigned U,unsigned Surface> int Address(const Args& a) {
  if constexpr(Surface!=2)return Run<RawOriginal<Word,W,S,U,Surface,dtl::block_addressing::DYNAMIC>>("legacy",a);
  else {
  const auto plan=vldb_stage2::Plan(exact_budget::Bytes(a.n(),a.bpk),sizeof(Word)*W);
  if(plan.address==dtl::block_addressing::POWER_OF_TWO)return Run<RawOriginal<Word,W,S,U,Surface,dtl::block_addressing::POWER_OF_TWO>>("legacy",a);
  return Run<RawOriginal<Word,W,S,U,Surface,dtl::block_addressing::MAGIC>>("legacy",a);
  }
}
template<class Word,unsigned W,unsigned S,unsigned U> int Surface(const Args& a,const std::string& surface) {
  if(surface=="artifact_pimpl")return Address<Word,W,S,U,0>(a);
  if(surface=="public_dynamic")return Address<Word,W,S,U,1>(a);
  if(surface=="public_static")return Address<Word,W,S,U,2>(a);
  throw std::invalid_argument("unknown original public surface");
}
inline std::vector<std::string> Names() {
  std::vector<std::string> names={"FastPatternBF","FourSectorBloomFilter","Split64BloomFilter","ByteSplitBloomFilter"};
  for(const char* config:{"sector32-u1","sector32-u2","sector32-u4","sector64-u1","sector64-u2","sector64-u4","register64-u0"})
    for(const char* surface:{"artifact_pimpl","public_dynamic","public_static"})names.push_back(std::string(config)+"/"+surface);
  return names;
}
}
int main(int argc,char** argv)try {
  using namespace raw32_stage3;const auto names=Names();
  if(argc==2 && std::string(argv[1])=="--names"){for(const auto& name:names)std::cout<<name<<'\n';return 0;}
  const Args a=Parse(argc,argv);Need(std::find(names.begin(),names.end(),a.name)!=names.end(),"unknown filter; no work performed");
  if(IsNative(a.name))return RunNative("legacy",a);
  const auto slash=a.name.find('/');const std::string config=a.name.substr(0,slash),surface=a.name.substr(slash+1);
#define RUN(NAME,WORD,W,S,U) if(config==NAME)return Surface<WORD,W,S,U>(a,surface)
  RUN("sector32-u1",uint32_t,8,8,1);RUN("sector32-u2",uint32_t,8,8,2);RUN("sector32-u4",uint32_t,8,8,4);
  RUN("sector64-u1",uint64_t,8,8,1);RUN("sector64-u2",uint64_t,8,8,2);RUN("sector64-u4",uint64_t,8,8,4);RUN("register64-u0",uint64_t,1,1,0);
#undef RUN
  throw std::runtime_error("registered filter has no dispatcher");
}catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 2;}
