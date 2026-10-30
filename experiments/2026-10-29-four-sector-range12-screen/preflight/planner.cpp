// Plan only; the actual benchmark independently checks public backing allocation.
#include "geometry.hpp"
using bloom_filters::FastPatternBF;
template<class BF> void print(const char* name, uint32_t bpk) {
  auto g=exact_budget::Traits<BF>::Plan(1024,bpk);
  std::cout<<name<<','<<g.allocated_bytes<<',';
  exact_budget::PrintGeometry(std::cout,g);std::cout<<'\n';
}
int main(int argc,char**argv) {
  if(argc!=2)return 1;
  auto cap=std::stoul(argv[1]);if(cap!=16&&cap!=24&&cap!=32)return 1;
  std::cout<<"filter,filter_bytes,"<<exact_budget::GeometryHeader()<<'\n';
#define ADD(T,H) print<T>(#T,cap)
  ADD(FastPatternBF,uint64_t);
  BF_REGISTER_EXTERNAL_FILTERS(ADD);
#undef ADD
}
