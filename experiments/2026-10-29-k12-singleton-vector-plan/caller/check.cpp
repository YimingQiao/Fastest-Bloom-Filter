#include "control.h"
#include "candidate.h"
#include "mapping_oracle.hpp"
#include <algorithm>
#include <array>
#include <iostream>
#include <stdexcept>
#include <vector>

using namespace bloom_filters;
static void Require(bool pass,const char* text){if(!pass)throw std::runtime_error(text);}
static uint64_t Next(uint64_t& state){uint64_t z=(state+=0x9e3779b97f4a7c15ULL);z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;z=(z^(z>>27))*0x94d049bb133111ebULL;return z^(z>>31);}
template<class BF> void CheckQueries(const BF& bf,uint32_t lines,const std::vector<uint64_t>& hashes) {
    Require(bf.Lookup(0,nullptr,nullptr)==0,"zero lookup");
    Require(bf.LookupScalar(0,nullptr,nullptr)==0,"zero scalar lookup");
    for(size_t offset=0;offset<8;++offset) for(size_t n:std::array<size_t,7>{1,2,3,4,7,31,4096}) {
        std::vector<uint32_t> storage(n+32,0xfefefefe),scalar(n);
        uint32_t* output=storage.data()+16;
        Require(bf.Lookup(static_cast<uint32_t>(n),hashes.data()+offset,output)==n,"lookup count");
        Require(bf.LookupScalar(static_cast<uint32_t>(n),hashes.data()+offset,scalar.data())==n,"scalar count");
        for(size_t i=0;i<n;++i) {
            const bool oracle=k12_singleton_oracle::Contains(bf.Data(),lines,hashes[offset+i]);
            Require(output[i]<=1 && output[i]==scalar[i] && output[i]==oracle,"dense oracle mismatch");
            Require(bf.ContainsHash(hashes[offset+i])==oracle,"public singleton mismatch");
        }
        for(size_t i=0;i<16;++i)Require(storage[i]==0xfefefefe&&storage[n+16+i]==0xfefefefe,"guard mismatch");
    }
}
int main(){try {
    uint64_t state=74381;
    std::vector<uint64_t> hashes(4104);
    for(auto& h:hashes)h=Next(state);
    size_t fixtures=0;
    for(uint32_t lines:{2u,3u,32769u}) {
        FourSectorRange12BloomFilter before(RangeBytes{size_t{lines}*64});
        FourSectorRange12SingletonVectorExperiment after(RangeBytes{size_t{lines}*64});
        Require(before.SizeInBytes()==size_t{lines}*64 && after.SizeInBytes()==before.SizeInBytes(),"allocation");
        std::vector<uint32_t> bitmap(size_t{lines}*16);
        CheckQueries(before,lines,hashes);CheckQueries(after,lines,hashes);++fixtures;
        // Whole and incremental insertion remain the frozen public operation.
        before.Insert(1024,hashes.data());
        for(size_t i=0;i<1024;i+=3)after.Insert(static_cast<uint32_t>(std::min<size_t>(3,1024-i)),hashes.data()+i);
        for(size_t i=0;i<1024;++i){const auto p=k12_singleton_oracle::MakeProbe(hashes[i],lines);for(unsigned j=0;j<4;++j)bitmap[size_t{p.line}*16+p.local[j]]|=p.masks[j];}
        Require(std::equal(bitmap.begin(),bitmap.end(),before.Data()),"control bitmap oracle");
        Require(std::equal(bitmap.begin(),bitmap.end(),after.Data()),"candidate bitmap oracle");
        CheckQueries(before,lines,hashes);CheckQueries(after,lines,hashes);++fixtures;
        // Test-fixture writes are outside production APIs and any timer. They
        // exercise every offset byte and every dictionary/rotation choice.
        auto* data=const_cast<uint32_t*>(after.Data());
        for(uint32_t byte=0;byte<256;++byte) for(unsigned sector=0;sector<4;++sector) {
            const uint64_t h=(uint64_t{0xffffff}<<40)|(uint64_t{byte}<<32)|Next(state)%UINT32_MAX;
            const auto p=k12_singleton_oracle::MakeProbe(h,lines);
            Require(p.line==lines-1,"last line");
            std::fill(data+size_t{p.line}*16,data+size_t{p.line+1}*16,UINT32_MAX);
            Require(after.ContainsHash(h),"full line positive");
            const auto bits=p.masks[sector];const uint32_t bit=bits&(~bits+1u);
            data[size_t{p.line}*16+p.local[sector]]&=~bit;
            Require(!after.ContainsHash(h)&&!k12_singleton_oracle::Contains(data,lines,h),"sector negative");
            ++fixtures;
        }
        for(unsigned sector=0;sector<4;++sector)for(uint32_t dictionary=0;dictionary<16;++dictionary)for(uint32_t rotation=0;rotation<32;++rotation) {
            const uint32_t code=dictionary|(rotation<<4),shift=sector*8;
            const uint32_t low=(code<<shift)|(code>>((32-shift)&31));
            const uint64_t h=(uint64_t{0x9b}<<32)|low;
            const auto p=k12_singleton_oracle::MakeProbe(h,lines);
            std::fill(data+size_t{p.line}*16,data+size_t{p.line+1}*16,0);
            for(unsigned j=0;j<4;++j)data[size_t{p.line}*16+p.local[j]]=p.masks[j];
            Require(after.ContainsHash(h)&&k12_singleton_oracle::Contains(data,lines,h),"dictionary/rotation positive");
            data[size_t{p.line}*16+p.local[sector]]^=p.masks[sector]&(~p.masks[sector]+1u);
            Require(!after.ContainsHash(h),"dictionary/rotation negative");++fixtures;
        }
        CheckQueries(after,lines,hashes);
    }
    std::cout<<"{\"fixtures\":"<<fixtures<<",\"complete\":true}\n";
}catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 1;}}
