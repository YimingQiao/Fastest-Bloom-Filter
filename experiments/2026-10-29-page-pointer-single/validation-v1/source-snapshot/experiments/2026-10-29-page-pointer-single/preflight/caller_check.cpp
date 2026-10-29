#include "../query_pointer.hpp"

namespace {
using namespace raw32_stage3;
template<class F> size_t Check() {
  F filter(1024,24);
  const vldb_external::Raw32Workload workload(1024,8192,0,50,42);
  filter.Insert(workload.inserted.size(),workload.inserted.data());
  for(const uint32_t key:workload.inserted)
    Need(filter.SinglePointer(&key),"pointer caller false negative");
  std::vector<uint32_t> expected(workload.query.size());
  for(size_t i=0;i<expected.size();++i)expected[i]=filter.Single(workload.query[i]);
  const auto before=Digest(workload.query.data(),workload.query.size());
  size_t checks=0;
  for(unsigned m=0;m<3;++m) {
    const auto mode=static_cast<Mode>(m);filter.Prepare(mode);
    vldb_stage2::Query(filter,mode,0,nullptr,nullptr);++checks;
    for(size_t offset=0;offset<4;++offset) {
      for(size_t count=0;count<=131;++count) {
        GuardedOutput out(count);
        vldb_stage2::Query(filter,mode,count,workload.query.data()+offset,out.data());
        out.Check(expected.data()+offset);++checks;
      }
      for(size_t count:{4095,4096,4097,4127}) {
        GuardedOutput out(count);
        vldb_stage2::Query(filter,mode,count,workload.query.data()+offset,out.data());
        out.Check(expected.data()+offset);++checks;
      }
    }
  }
  Need(Digest(workload.query.data(),workload.query.size())==before,"pointer caller mutated input");
  Need(filter.QueryScratchBytes()==0,"Page caller introduced scratch");
  return checks;
}
}

int main()try {
  const size_t checks=Check<Pointer4Default>()+Check<Pointer4Compact>()+
    Check<Pointer6Default>()+Check<Pointer6Compact>()+
    Check<Pointer8Default>()+Check<Pointer8Compact>();
  Need(checks==9810,"caller coverage drift");
  std::cout<<"{\"facades\":6,\"query_checks\":"<<checks
           <<",\"null_zero\":true,\"full_outputs\":true,\"timed\":false}\n";
  return 0;
}catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 2;}
