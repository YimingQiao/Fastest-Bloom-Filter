// Independent unsigned128 range / individual bit oracle, exact public geometry caller.
#include "geometry.hpp"
#include <array>
#include <cstring>
#include <numeric>
#include <stdexcept>
#include <vector>
using namespace bloom_filters;
static void need(bool ok,const char* why){if(!ok)throw std::runtime_error(why);}
struct RNG { uint64_t state; uint64_t operator()(){uint64_t z=(state+=0x9e3779b97f4a7c15ULL);z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;z=(z^(z>>27))*0x94d049bb133111ebULL;return z^(z>>31);} };
template<class T> static void shuffle(std::vector<T>&v,RNG&r){for(size_t i=v.size();i>1;--i)std::swap(v[i-1],v[r()%i]);}
static std::array<size_t,12> positions(uint64_t h,size_t bytes) {
  constexpr unsigned triples[16][3]={{0,1,3},{0,4,9},{0,6,13},{0,8,18},{0,1,12},{0,2,15},{0,4,16},{0,3,8},{0,6,15},{0,7,18},{0,1,10},{0,2,5},{0,4,10},{0,7,15},{0,1,13},{0,3,14}};
  const size_t line=(static_cast<unsigned __int128>(h>>40)*(bytes/64))/16777216;
  const unsigned base=(h>>32)&3;std::array<size_t,12> result{};
  for(unsigned j=0;j<4;++j){
    const uint32_t lo=h;const unsigned r=j*8;
    const uint32_t code=(lo>>r)|(lo<<((32-r)%32));
    const size_t word=line*16+j*4+(base^(j?unsigned((h>>(32+2*j))&3):0));
    for(unsigned k=0;k<3;++k)result[j*3+k]=word*32+(triples[code%16][k]+(code/16)%32)%32;
  }return result;
}
static uint32_t contains(const std::vector<uint8_t>&bits,uint64_t h){for(auto b:positions(h,bits.size()))if((bits[b/8]&(1u<<(b%8)))==0)return 0;return 1;}
int main(int argc,char**argv){try{
  need(argc==2,"cap required");const uint32_t cap=std::stoul(argv[1]);need(cap==16||cap==24||cap==32,"cap");
  constexpr size_t n=1024,q=4096;RNG rng{731};const uint64_t base=rng()%((uint64_t{1}<<32)-n-q);
  std::vector<uint64_t> ins(n),raw(q),cal(q);std::iota(ins.begin(),ins.end(),base);shuffle(ins,rng);
  for(size_t i=0;i<q;++i)raw[i]=base+((i%100<50)?rng()%n:n+i);shuffle(raw,rng);
  for(size_t i=0;i<q;++i)cal[i]=base+n+q+i;
  auto bf=exact_budget::Traits<FourSectorRange12Experiment>::Make(n,cap);auto plan=exact_budget::Traits<FourSectorRange12Experiment>::Plan(n,cap);
  need(bf.SizeInBytes()==plan.allocated_bytes&&bf.SizeInBytes()<=plan.budget_bytes,"backing bytes");
  std::vector<uint8_t> bits(bf.SizeInBytes());std::vector<uint64_t> hashes(n+16,0x45bcd6789ULL);
  for(size_t i=0;i<n;++i){auto h=MurmurHash64(ins[i]);hashes[i+8]=h;for(auto b:positions(h,bits.size()))bits[b/8]|=uint8_t(1u<<(b%8));}
  auto inputs=hashes;bf.Insert(n,hashes.data()+8);need(inputs==hashes,"insert mutated guarded input");
  need(std::memcmp(bits.data(),bf.Data(),bits.size())==0,"complete bitmap mismatch");
  uint64_t mixed_checksum=14695981039346656037ULL,mixed_fp=0,cal_fp=0;
  auto check=[&](const std::vector<uint64_t>&keys,size_t batch,bool inserted){
    std::vector<uint64_t> input(keys.size()+16,0x45bcd6789ULL);std::vector<uint32_t> out(keys.size()+32,0xa5a5a5a5),scalar(keys.size()+32,0xa5a5a5a5);
    for(size_t i=0;i<keys.size();++i)input[i+8]=MurmurHash64(keys[i]);const auto copy=input;
    for(size_t start=0;start<keys.size();start+=batch){auto length=std::min(batch,keys.size()-start);bf.Lookup(length,input.data()+8+start,out.data()+16+start);bf.LookupScalar(length,input.data()+8+start,scalar.data()+16+start);}
    need(input==copy,"query mutated input/guards");
    for(size_t i=0;i<16;++i)need(out[i]==0xa5a5a5a5&&out[out.size()-1-i]==0xa5a5a5a5&&scalar[i]==0xa5a5a5a5&&scalar[scalar.size()-1-i]==0xa5a5a5a5,"output guard");
    for(size_t i=0;i<keys.size();++i){const auto expected=contains(bits,input[i+8]);need(out[i+16]==expected&&scalar[i+16]==expected&&bf.ContainsHash(input[i+8])==bool(expected),"full answer mismatch");if(inserted)need(expected==1,"false negative");}
    need(std::memcmp(bits.data(),bf.Data(),bits.size())==0,"query mutated bitmap");
  };
  for(size_t batch:{size_t{31},size_t{4096}}){check(ins,batch,true);check(raw,batch,false);check(cal,batch,false);}
  for(auto key:raw){auto value=contains(bits,MurmurHash64(key));mixed_checksum=(mixed_checksum^value)*1099511628211ULL;if(key>=base+n)mixed_fp+=value;}
  for(auto key:cal)cal_fp+=contains(bits,MurmurHash64(key));
  std::cout<<"filter,filter_bytes,result_checksum,false_positives,calibration_false_positives,calibration_absent_queries\nFourSectorRange12Experiment,"<<bf.SizeInBytes()<<','<<mixed_checksum<<','<<mixed_fp<<','<<cal_fp<<','<<q<<'\n';
}catch(const std::exception&e){std::cerr<<e.what()<<'\n';return 1;}}
