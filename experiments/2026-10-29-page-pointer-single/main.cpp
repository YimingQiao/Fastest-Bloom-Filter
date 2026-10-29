#include "query_pointer.hpp"
namespace raw32_stage3 {
static const char* Names[]={"FastPatternBF","FourSectorBloomFilter","Split64BloomFilter","ByteSplitBloomFilter",
 "PageBloom4Default","PageBloom4Compact","PageBloom6Default","PageBloom6Compact","PageBloom8Default","PageBloom8Compact",
 "PageBloom4DefaultPointerSingleV1","PageBloom4CompactPointerSingleV1","PageBloom6DefaultPointerSingleV1","PageBloom6CompactPointerSingleV1","PageBloom8DefaultPointerSingleV1","PageBloom8CompactPointerSingleV1"};
}
int main(int argc,char** argv)try {
  using namespace raw32_stage3;
  if(argc==2 && std::string(argv[1])=="--names"){for(const auto* name:Names)std::cout<<name<<'\n';return 0;}
  const Args a=Parse(argc,argv);Need(std::find(std::begin(Names),std::end(Names),a.name)!=std::end(Names),"unknown filter; no work performed");
  constexpr auto worker="modern_page_pointer_control";
  if(IsNative(a.name))return RunNative(worker,a);
#define VALUE(NAME,K,C) if(a.name==NAME)return Run<RawPage<K,C>>(worker,a)
  VALUE("PageBloom4Default",4,false);VALUE("PageBloom4Compact",4,true);
  VALUE("PageBloom6Default",6,false);VALUE("PageBloom6Compact",6,true);
  VALUE("PageBloom8Default",8,false);VALUE("PageBloom8Compact",8,true);
#undef VALUE
#define POINTER(NAME,F) if(a.name==NAME)return Run<F>(worker,a)
  POINTER("PageBloom4DefaultPointerSingleV1",Pointer4Default);POINTER("PageBloom4CompactPointerSingleV1",Pointer4Compact);
  POINTER("PageBloom6DefaultPointerSingleV1",Pointer6Default);POINTER("PageBloom6CompactPointerSingleV1",Pointer6Compact);
  POINTER("PageBloom8DefaultPointerSingleV1",Pointer8Default);POINTER("PageBloom8CompactPointerSingleV1",Pointer8Compact);
#undef POINTER
  throw std::runtime_error("registered filter has no dispatcher");
}catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 2;}
