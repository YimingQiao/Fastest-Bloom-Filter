#include "split64.hpp"
#include <vector>
#include <stdexcept>
#include <algorithm>
using namespace bloom_filters;
static constexpr uint32_t salts[8]={0x47b6137bU,0x44974d91U,0x8824ad5bU,0xa2b7289dU,0x705495c7U,0x2df1424bU,0x9efc4947U,0x5c6bfb31U};
static void require(bool x) { if(!x) throw std::runtime_error("split64 mismatch"); }
template<class Filter> void check() {
 for (unsigned bpk:{4u,8u,16u}) for (bool hot:{false,true}) {
  Filter bf(65539,bpk);
  std::vector<uint64_t> bitmap(bf.SizeInBytes()/8),input(65539);
  const size_t mask=bf.SizeInBytes()/64-1;
  for(size_t i=0;i<input.size();++i) input[i]=hot?MurmurHash64(i)&0xffffffffULL:MurmurHash64(i);
  input[0]=0;input[1]=UINT64_MAX;
  for(uint64_t h:input) for(size_t j=0;j<8;++j)
   bitmap[(((h>>32)&mask)*8)+j]|=uint64_t{1}<<((static_cast<uint32_t>(h)*salts[j])>>26);
  for(size_t i=0;i<input.size();i+=31) bf.Insert(std::min<size_t>(31,input.size()-i),input.data()+i);
  bf.Insert(2,input.data());
  std::vector<uint32_t> out(input.size());bf.Lookup(input.size(),input.data(),out.data());
  for(uint32_t x:out)require(x==1);
  for(size_t len=0;len<145;++len) for(size_t offset=0;offset<8;++offset) {
   std::vector<uint64_t> q(len+offset+1);
   std::vector<uint32_t> actual(len+2,0xdeadbeef);
   for(size_t i=0;i<q.size();++i)q[i]=MurmurHash64(i*711);
   bf.Lookup(len,q.data()+offset,actual.data()+1);
   require(actual[0]==0xdeadbeef&&actual.back()==0xdeadbeef);
   for(size_t i=0;i<len;++i) {
    uint64_t h=q[i+offset];bool yes=true;
    for(size_t j=0;j<8;++j)yes&=(bitmap[(((h>>32)&mask)*8)+j]&(uint64_t{1}<<((static_cast<uint32_t>(h)*salts[j])>>26)))!=0;
    require(actual[i+1]==yes);
   }
  }
 }
}
int main(){check<Split64P0>();check<Split64P16>();check<Split64P32>();check<Split64P64>();}
