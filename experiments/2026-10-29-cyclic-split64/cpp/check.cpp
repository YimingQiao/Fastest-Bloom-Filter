#include "cyclic_split64.h"
#include <array>
#include <cstring>
#include <iostream>
using namespace bloom_filters;
static void require(bool v,const char *m){if(!v)throw std::runtime_error(m);}
static uint64_t next(uint64_t &s){uint64_t z=(s+=0x9e3779b97f4a7c15ULL);z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;z=(z^(z>>27))*0x94d049bb133111ebULL;return z^(z>>31);}
static std::array<uint64_t,8> mask(uint64_t h){
    std::array<uint64_t,8> m{};
    for(size_t j=0;j<8;++j){unsigned p=0;for(unsigned b=0;b<6;++b)p|=((uint32_t(h)>>((4*j+b)%32))&1)<<b;m[j]=uint64_t{1}<<p;}
    return m;
}
static size_t block(uint64_t h,size_t lines){return static_cast<unsigned __int128>(h>>32)*lines/(uint64_t{1}<<32);}
static uint32_t answer(const std::vector<uint64_t>&v,uint64_t h){const auto m=mask(h);const size_t a=block(h,v.size()/8)*8;for(size_t j=0;j<8;++j)if((v[a+j]&m[j])!=m[j])return 0;return 1;}
int main(){
    CyclicSplit64Range empty(RangeBytes{128});
    empty.Insert(0,nullptr);require(empty.Lookup(0,nullptr,nullptr)==0,"empty null batch");
    for(size_t bytes:{0UL,1UL,127UL,(1UL<<28)+1,SIZE_MAX}) {
        bool rejected=false;try{CyclicSplit64Range invalid(RangeBytes{bytes});}catch(const std::exception&){rejected=true;}
        require(rejected,"invalid byte budget");
    }
    for(const auto parameters:{std::pair<size_t,uint32_t>{0,16},{1,0},{SIZE_MAX,16}}) {
        bool rejected=false;try{CyclicSplit64Range invalid(parameters.first,parameters.second);}catch(const std::exception&){rejected=true;}
        require(rejected,"invalid product budget");
    }
    uint64_t digest=14695981039346656037ULL;
    for(size_t lines:{2UL,3UL,5UL,7UL,31UL,257UL,4097UL,32769UL}){
        CyclicSplit64Range f(RangeBytes{lines*64+31});require(f.SizeInBytes()==lines*64,"byte cap");
        std::vector<uint64_t> expected(lines*8),hashes;uint64_t state=0x243f6a8885a308d3ULL;
        for(size_t i=0;i<2048;++i)hashes.push_back(next(state));
        for(unsigned bit=0;bit<64;++bit){hashes.push_back(uint64_t{1}<<bit);hashes.push_back(~(uint64_t{1}<<bit));}
        for(size_t line=0;line<=std::min<size_t>(lines,4097);++line){
            const uint64_t boundary=((uint64_t(line)<<32)+lines-1)/lines;
            for(int d:{-1,0,1}){const int64_t high=int64_t(boundary)+d;if(high>=0&&uint64_t(high)<=UINT32_MAX)hashes.push_back((uint64_t(high)<<32)|uint32_t(next(state)));}
        }
        for(uint64_t h:hashes){const auto m=mask(h);const size_t at=block(h,lines)*8;for(size_t j=0;j<8;++j)expected[at+j]|=m[j];}
        for(size_t at=0;at<hashes.size();at+=37)f.Insert(std::min<size_t>(37,hashes.size()-at),hashes.data()+at);
        f.Insert(17,hashes.data());require(std::memcmp(f.Data(),expected.data(),expected.size()*8)==0,"full bitmap oracle");
        for(uint64_t h:hashes)require(f.ContainsHash(h),"false negative");
        std::vector<uint64_t> queries(4135);for(auto &h:queries)h=next(state);
        std::vector<size_t> lengths;for(size_t i=0;i<=131;++i)lengths.push_back(i);for(size_t i:{4096UL,4097UL,4127UL})lengths.push_back(i);
        for(size_t length:lengths)for(size_t offset:{0UL,1UL,7UL}){
            std::vector<uint32_t> out(length+2,0xfeed);f.Lookup(length,queries.data()+offset,out.data()+1);
            require(out.front()==0xfeed&&out.back()==0xfeed,"tail guard");
            for(size_t i=0;i<length;++i)require(out[i+1]==answer(expected,queries[i+offset]),"dense oracle");
        }
        for(uint64_t h:{0ULL,1ULL,~0ULL,0x8000000000000000ULL,0xfedcba9876543210ULL}){
            CyclicSplit64Range single(RangeBytes{lines*64});single.Insert(1,&h);const auto m=mask(h);
            auto *bytes=static_cast<unsigned char*>(const_cast<void*>(single.Data()));
            for(size_t j=0;j<8;++j){
                const size_t at=(block(h,lines)*8+j)*8;uint64_t word;std::memcpy(&word,bytes+at,8);word&=~m[j];std::memcpy(bytes+at,&word,8);
                require(!single.ContainsHash(h),"essential bit");uint32_t out=9;single.Lookup(1,&h,&out);require(!out,"SIMD essential bit");
                word|=m[j];std::memcpy(bytes+at,&word,8);
            }
        }
        for(uint64_t word:expected){digest^=word;digest*=1099511628211ULL;}
    }
    std::cout<<"Cyclic mask oracle/tail checks passed "<<digest<<'\n';
}
