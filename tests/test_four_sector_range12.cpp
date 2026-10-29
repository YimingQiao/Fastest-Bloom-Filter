#include "parallel_four_sector_range12_bloom.h"
#include <array>
#include <cstring>
#include <iostream>
#include <limits>
#include <string>
using namespace bloom_filters;
static void require(bool ok,const char* message){if(!ok)throw std::runtime_error(message);}
static uint64_t next(uint64_t& state){uint64_t z=(state+=0x9e3779b97f4a7c15ULL);z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;z=(z^(z>>27))*0x94d049bb133111ebULL;return z^(z>>31);}
static size_t line(uint64_t h,size_t count){return (static_cast<unsigned __int128>(h>>40)*count)/(uint64_t{1}<<24);}
struct Probe {std::array<size_t,4> index;std::array<uint32_t,4> masks;};
static Probe probe(uint64_t h,size_t count){
    constexpr uint32_t dictionary[]={0xb,0x211,0x2041,0x40101,0x1003,0x8005,0x10011,0x109,0x8041,0x40081,0x403,0x25,0x411,0x8081,0x2003,0x4009};
    const uint32_t lo=h,hi=h>>32;Probe p{};
    for(unsigned sector=0;sector<4;++sector){
        unsigned entry=0,rotation=0;
        for(unsigned bit=0;bit<4;++bit)entry|=((lo>>((sector*8+bit)%32))&1u)<<bit;
        for(unsigned bit=0;bit<5;++bit)rotation|=((lo>>((sector*8+4+bit)%32))&1u)<<bit;
        for(unsigned bit=0;bit<32;++bit)if((dictionary[entry]>>bit)&1u)p.masks[sector]|=uint32_t{1}<<((bit+rotation)%32);
        p.index[sector]=line(h,count)*16+sector*4+((hi&3)^(sector?((hi>>(sector*2))&3):0));
    }
    return p;
}
static std::vector<uint32_t> bitmap(size_t lines,const std::vector<uint64_t>& hashes,size_t n){
    std::vector<uint32_t> words(lines*16);
    for(size_t i=0;i<n;++i){const auto p=probe(hashes[i],lines);for(unsigned j=0;j<4;++j)words[p.index[j]]|=p.masks[j];}
    return words;
}
static uint32_t answer(const std::vector<uint32_t>& words,uint64_t h){const auto p=probe(h,words.size()/16);for(unsigned j=0;j<4;++j)if((words[p.index[j]]&p.masks[j])!=p.masks[j])return 0;return 1;}
static void ownership(){
    for(size_t lines:{2UL,3UL,5UL,7UL,31UL,257UL,4097UL,(1UL<<22)-1,1UL<<22})
        for(size_t workers:{1UL,2UL,3UL,7UL,8UL,17UL,1024UL}){
            if(workers>lines)continue;
            const parallel_detail::K12LinePartition p(lines,workers);
            require(p.BeginLine(0)==0&&p.BeginLine(workers)==lines,"partition endpoints");
            for(size_t part=0;part<=workers;++part){
                const uint64_t physical=(uint64_t(part)*lines+workers-1)/workers;
                const uint64_t boundary=((physical<<24)+lines-1)/lines;
                for(int delta:{-1,0,1}){
                    const int64_t address=int64_t(boundary)+delta;if(address<0||uint64_t(address)>0xffffff)continue;
                    for(uint64_t low:{0ULL,0xffffffffffULL}){
                        const uint64_t h=(uint64_t(address)<<40)|low;const size_t at=line(h,lines),owner=p.OwnerLine(at);
                        require(owner==at*workers/lines,"physical owner");
                        require(at>=p.BeginLine(owner)&&at<p.BeginLine(owner+1),"ceil owned interval");
                    }
                }
            }
        }
    // High32 multiply can disagree with K12's top24 physical mapping even for
    // a divisible partition: preserve the low8 address-bit counterexample.
    const uint64_t h=(uint64_t{5592405}<<40)|(uint64_t{255}<<32);
    require(line(h,3)==0&&(uint64_t(h>>32)*3>>32)==1,"top24 versus high32 boundary fixture");
}
static void required_bits(){
    FourSectorRange12BloomFilter f(RangeBytes{3*64});uint64_t state=19;
    auto* words=const_cast<uint32_t*>(f.Data());
    for(unsigned i=0;i<64;++i){const uint64_t h=next(state);const auto p=probe(h,3);
        std::fill(words,words+48,UINT32_MAX);require(f.ContainsHash(h),"full bitmap singleton");
        for(unsigned j=0;j<4;++j)for(unsigned bit=0;bit<32;++bit)if(p.masks[j]&(uint32_t{1}<<bit)){
            words[p.index[j]]&=~(uint32_t{1}<<bit);std::array<uint64_t,31> hashes;hashes.fill(h);std::array<uint32_t,31> out;
            f.Lookup(hashes.size(),hashes.data(),out.data());require(std::all_of(out.begin(),out.end(),[](uint32_t v){return v==0;}),"every required probe bit");
            words[p.index[j]]|=uint32_t{1}<<bit;
        }
    }
}
static void serial_parallel(){
    uint64_t state=0x243f6a8885a308d3ULL;std::vector<uint64_t> hashes(32768),queries(32783);
    for(auto& h:hashes)h=next(state);for(auto& h:queries)h=next(state);
    for(size_t i=1;i<hashes.size();i+=11)hashes[i]=hashes[i-1];
    for(size_t i=1;i<queries.size();i+=2)queries[i]=hashes[i%hashes.size()];
    for(size_t lines:{2UL,3UL,7UL,31UL,257UL,4097UL,32771UL}){
        for(size_t n:{0UL,31UL,32768UL}){
            const auto expected=bitmap(lines,hashes,n);std::vector<uint32_t> answers(queries.size());
            for(size_t i=0;i<queries.size();++i)answers[i]=answer(expected,queries[i]);
            FourSectorRange12BloomFilter serial(RangeBytes{lines*64+31});serial.Insert(n,hashes.data());
            require(serial.SizeInBytes()==lines*64&&std::memcmp(serial.Data(),expected.data(),expected.size()*4)==0,"serial complete bitmap oracle");
            for(size_t i=0;i<n;++i)require(serial.ContainsHash(hashes[i]),"all inserted keys");
            for(size_t workers:{1UL,3UL,7UL}){
                ParallelFourSectorRange12BloomFilter f(RangeBytes{lines*64+31});
                if(n==32768&&lines>=7)require(f.BuildWorkers(n,workers)==workers,"actual requested workers");
                f.InsertParallel(n,hashes.data(),workers);f.InsertParallel(n,hashes.data(),workers);
                require(std::memcmp(f.Data(),expected.data(),expected.size()*4)==0,"parallel duplicate complete bitmap");
                std::vector<uint32_t> out(queries.size()+2,0xfeed);f.LookupParallel(queries.size(),queries.data(),out.data()+1,workers);
                require(out.front()==0xfeed&&out.back()==0xfeed,"parallel guards");
                require(std::equal(answers.begin(),answers.end(),out.begin()+1),"parallel dense outputs");
                f.InsertParallel(0,nullptr,workers);f.LookupParallel(0,nullptr,nullptr,workers);
                if(n==32768){
                    // Distinct second streamed batch adds real bits, not only duplicates.
                    f.InsertParallel(queries.size(),queries.data(),workers);
                    auto union_bits=expected;const auto addition=bitmap(lines,queries,queries.size());
                    for(size_t k=0;k<union_bits.size();++k)union_bits[k]|=addition[k];
                    require(std::memcmp(f.Data(),union_bits.data(),union_bits.size()*4)==0,"streamed union bitmap");
                }
            }
            for(size_t length=0;length<=131;++length)for(size_t offset:{0UL,1UL,7UL}){
                std::vector<uint32_t> out(length+2,0xfeed);serial.Lookup(length,queries.data()+offset,out.data()+1);
                require(out.front()==0xfeed&&out.back()==0xfeed,"serial tail guards");
                require(std::equal(out.begin()+1,out.end()-1,answers.begin()+offset),"serial tail output");
            }
            for(size_t length:{4095UL,4096UL,4097UL,4127UL}){
                std::vector<uint32_t> out(length+2,0xfeed);serial.Lookup(length,queries.data()+7,out.data()+1);
                require(out.front()==0xfeed&&out.back()==0xfeed&&std::equal(out.begin()+1,out.end()-1,answers.begin()+7),"long serial tail");
            }
            serial.Insert(0,nullptr);serial.Lookup(0,nullptr,nullptr);
        }
    }
    ParallelFourSectorRange12BloomFilter scratch(RangeBytes{7*64});bool rejected=false;
    try{(void)scratch.BuildScratchBytes(SIZE_MAX,3);}catch(const std::length_error&){rejected=true;}
    require(rejected&&scratch.BuildScratchBytes(SIZE_MAX,1)==0,"scratch overflow");
    for(size_t bytes:{0UL,1UL,127UL,(1UL<<28)+1,SIZE_MAX}){
        rejected=false;try{FourSectorRange12BloomFilter f(RangeBytes{bytes});}catch(const std::exception&){rejected=true;}require(rejected,"invalid byte budget");
    }
    for(auto input:std::array<std::pair<size_t,uint32_t>,3>{{{0,12},{1,0},{SIZE_MAX,12}}}){
        rejected=false;try{FourSectorRange12BloomFilter f(input.first,input.second);}catch(const std::exception&){rejected=true;}require(rejected,"invalid item budget");
    }
    FourSectorRange12BloomFilter valid(65536,24);require(valid.SizeInBytes()==196608,"item budget exact lines");
}
int main(){ownership();required_bits();serial_parallel();std::cout<<"Optional K12 serial/physical-line parallel checks passed\n";}
