// Exact frozen public C++ K12 oracle. No timing; emits full bitmap+dense u32 answers.
#include "../2026-10-29-four-sector-range12-screen/four_sector_range12.h"
#include <iostream>
#include <vector>
#include <stdexcept>
uint64_t hash(uint64_t z){z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;z=(z^(z>>27))*0x94d049bb133111ebULL;return z^(z>>31);}
int main(int argc,char**argv){try{
 if(argc!=3)throw std::runtime_error("BYTES HOT required");
 const auto bytes=std::stoull(argv[1]),hot=std::stoull(argv[2]);if(hot>1)throw std::runtime_error("hot");
 std::vector<uint64_t> h(32771),q(8193);
 for(size_t i=0;i<h.size();++i)h[i]=hash(i+731)&(hot?0x000000ffffffffffULL:~uint64_t{0});
 for(size_t i=0;i<q.size();++i)q[i]=i%2==0?h[i%h.size()]:hash(i+100000);
 const auto h_before=h,q_before=q;
 bloom_filters::FourSectorRange12 f(bloom_filters::RangeBytes{bytes});f.Insert(h.size(),h.data());
 std::vector<uint32_t> out(q.size());f.Lookup(q.size(),q.data(),out.data());
 for(auto v:h)if(!f.ContainsHash(v))throw std::runtime_error("false negative");
 if(h!=h_before||q!=q_before)throw std::runtime_error("input mutation");
#if defined(__AVX512F__)
 const char* backend="avx512";
#elif defined(__AVX2__)
 const char* backend="avx2";
#else
 const char* backend="scalar";
#endif
 std::cerr<<"{\"backend\":\""<<backend<<"\",\"bytes\":"<<f.SizeInBytes()<<"}\n";
 auto emit=[](uint32_t x){for(unsigned j=0;j<4;++j)std::cout.put(char(x>>(8*j)));};
 for(size_t i=0;i<f.SizeInBytes()/4;++i)emit(f.Data()[i]);for(auto x:out)emit(x);
}catch(const std::exception&e){std::cerr<<e.what()<<'\n';return 1;}}
