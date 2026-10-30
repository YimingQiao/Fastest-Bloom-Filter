#include "adapters.hpp"
#include "four_sector_native_candidate.h"
#include <cstdio>
#include <stdexcept>
#include <vector>
void check() {
  using namespace bloom_filters;
  for (const size_t n : {size_t(0), size_t(33), size_t(65539), size_t((1u<<20)+3)}) {
    FourSectorBF<8> reference(n,16);
    FourSectorNativeCandidate candidate(n,16);
    std::vector<uint64_t> hashes(n);
    for (size_t i=0;i<n;++i) hashes[i]=MurmurHash64(i);
    reference.InsertScalar(n,hashes.data());candidate.Insert(n,hashes.data());
    std::vector<uint32_t> output(n);
    candidate.Lookup(n,hashes.data(),output.data());
    for (auto answer:output) if(answer!=1) throw std::runtime_error("false negative");
    std::vector<uint64_t> probes(8320);
    for(size_t i=0;i<probes.size();++i) probes[i]=MurmurHash64(n && (i%2) ? i%n : n+i);
    for(size_t len=0;len<=131;++len) for(size_t offset=0;offset<8;++offset) {
      std::vector<uint32_t> expected(len), actual(len+2,0xfeed);
      reference.LookupScalar(len,probes.data()+offset,expected.data());
      candidate.Lookup(len,probes.data()+offset,actual.data()+1);
      for(size_t i=0;i<len;++i) if(actual[i+1]!=expected[i]) throw std::runtime_error("query mismatch");
      if(actual.front()!=0xfeed||actual.back()!=0xfeed) throw std::runtime_error("output overrun");
    }
    candidate.Insert(n,hashes.data());
    for(size_t batch:{1,3,4,7,8,9,15,16,17,31,32,33,63,64,4096}) {
      std::vector<uint32_t> expected(probes.size()),actual(probes.size());
      reference.LookupScalar(probes.size(),probes.data(),expected.data());
      for(size_t i=0;i<probes.size();i+=batch) candidate.Lookup(std::min(batch,probes.size()-i),probes.data()+i,actual.data()+i);
      if(actual!=expected)throw std::runtime_error("full output mismatch");
    }
  }
}
int main(){check();puts("Native patch full-output and boundary checks passed");}
