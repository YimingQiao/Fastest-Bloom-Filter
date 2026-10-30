#include "parallel_split64_range.h"
#include <array>
#include <cstring>
#include <iostream>
#include <string>
using namespace bloom_filters;
static void require(bool ok, const char *message) { if (!ok) throw std::runtime_error(message); }
static uint64_t next(uint64_t &state) {
    uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}
static size_t index(uint64_t h, size_t lines) {
    return (static_cast<unsigned __int128>(h >> 32) * lines) / (uint64_t{1} << 32);
}
static std::array<uint64_t, 8> masks(uint64_t h) {
    constexpr uint64_t salts[] = {0x47b6137b,0x44974d91,0x8824ad5b,0xa2b7289d,
                                  0x705495c7,0x2df1424b,0x9efc4947,0x5c6bfb31};
    std::array<uint64_t,8> result{};
    for (size_t i=0;i<8;++i) result[i]=uint64_t{1} << ((uint64_t(uint32_t(h))*salts[i] % (uint64_t{1}<<32))/(uint64_t{1}<<26));
    return result;
}
static std::vector<uint64_t> bitmap(size_t lines, const std::vector<uint64_t> &hashes, size_t n) {
    std::vector<uint64_t> result(lines*8);
    for(size_t i=0;i<n;++i) { const auto m=masks(hashes[i]); const size_t at=index(hashes[i],lines)*8;
        for(size_t j=0;j<8;++j) result[at+j] |= m[j]; }
    return result;
}
static uint32_t answer(const std::vector<uint64_t> &words, uint64_t h) {
    const auto m=masks(h); const size_t at=index(h,words.size()/8)*8;
    for(size_t j=0;j<8;++j) if ((words[at+j]&m[j])!=m[j]) return 0;
    return 1;
}
static void ownership() {
    for(size_t lines=2;lines<=97;++lines) for(size_t workers=1;workers<=std::min<size_t>(lines,16);++workers) {
        const RangePartition p(lines,workers);
        for(uint64_t x=0;x<4096;++x) { const uint64_t h=x<<52;
            require(p.Owner(h)==index(h,lines)*workers/lines,"reduced-domain owner"); }
    }
    for(size_t lines:{2UL,3UL,5UL,7UL,31UL,257UL,4097UL,(1UL<<22)-1,1UL<<22})
        for(size_t workers:{1UL,2UL,3UL,5UL,8UL,17UL,1024UL}) {
            if(workers>lines) continue;
            const RangePartition p(lines,workers);
            for(size_t part=0;part<=workers;++part) {
                const uint64_t line=(part*lines+workers-1)/workers;
                const uint64_t boundary=((line<<32)+lines-1)/lines;
                for(int delta:{-1,0,1}) {
                    const int64_t high=int64_t(boundary)+delta;
                    if(high<0 || uint64_t(high)>UINT32_MAX) continue;
                    const uint64_t h=uint64_t(high)<<32;
                    const size_t physical=index(h,lines),owner=p.Owner(h);
                    require(owner==physical*workers/lines,"full-width owner");
                    require(physical>=(owner*lines+workers-1)/workers && physical<((owner+1)*lines+workers-1)/workers,"owned interval");
                }
            }
        }
    require(RangePartition(3,2).Owner(uint64_t{1}<<63)==0,"nondivisible counterexample");
}
static void serial_parallel() {
    uint64_t state=0x243f6a8885a308d3ULL;
    std::vector<uint64_t> hashes(32768),queries(32768);
    for(auto &h:hashes)h=next(state);
    for(auto &h:queries)h=next(state);
    for(size_t lines:{2UL,3UL,5UL,7UL,31UL,257UL,4097UL}) {
        for(size_t n:{0UL,17UL,16384UL,32768UL}) {
            const auto expected=bitmap(lines,hashes,n);
            std::vector<uint32_t> answers(queries.size());
            for(size_t i=0;i<queries.size();++i)answers[i]=answer(expected,queries[i]);
            Split64Range serial(RangeBytes{lines*64+31}); serial.Insert(n,hashes.data());
            require(serial.SizeInBytes()==lines*64,"serial actual bytes");
            require(std::memcmp(serial.Data(),expected.data(),expected.size()*8)==0,"serial oracle bitmap");
            for(size_t workers:{0UL,1UL,2UL,3UL,5UL,8UL}) {
                ParallelSplit64RangeBloomFilter parallel(RangeBytes{lines*64+31});
                parallel.InsertParallel(n,hashes.data(),workers);parallel.InsertParallel(n,hashes.data(),workers);
                require(parallel.SizeInBytes()==lines*64,"parallel actual bytes");
                require(std::memcmp(parallel.Data(),expected.data(),expected.size()*8)==0,"parallel oracle bitmap");
                std::vector<uint32_t> out(queries.size()+2,0xfeed);
                parallel.LookupParallel(queries.size(),queries.data(),out.data()+1,workers);
                require(out.front()==0xfeed && out.back()==0xfeed,"parallel guards");
                require(std::equal(answers.begin(),answers.end(),out.begin()+1),"parallel dense output");
                parallel.InsertParallel(0,nullptr,workers);parallel.LookupParallel(0,nullptr,nullptr,workers);
            }
            for(size_t length=0;length<=131;++length) for(size_t offset:{0UL,1UL,7UL}) {
                std::vector<uint32_t> out(length+2,0xfeed);
                serial.Lookup(length,queries.data()+offset,out.data()+1);
                require(out.front()==0xfeed && out.back()==0xfeed,"serial guards");
                for(size_t i=0;i<length;++i)require(out[i+1]==answers[i+offset],"serial dense output");
            }
        }
    }
    ParallelSplit64RangeBloomFilter p(RangeBytes{192});
    bool rejected=false;try{(void)p.BuildScratchBytes(SIZE_MAX,2);}catch(const std::length_error&){rejected=true;}
    require(rejected && p.BuildScratchBytes(SIZE_MAX,1)==0,"scratch overflow");
    for(size_t bad:{0UL,1UL,127UL,(1UL<<28)+1,SIZE_MAX}) {
        rejected=false;try{Split64Range f(RangeBytes{bad});}catch(const std::exception&){rejected=true;}
        require(rejected,"invalid allocation");
    }
}
static void fixtures() {
    for(size_t lines:{2UL,3UL,5UL,31UL,257UL,4097UL}) for(size_t n:{31UL,2048UL}) {
        uint64_t state=0x243f6a8885a308d3ULL;
        std::vector<uint64_t> hashes(n),queries(1024);
        for(auto &h:hashes)h=next(state);for(auto &h:queries)h=next(state);
        queries.insert(queries.end(),hashes.begin(),hashes.begin()+31);
        Split64Range f(RangeBytes{lines*64+31});f.Insert(hashes.size(),hashes.data());
        std::vector<uint64_t> words(lines*8);std::memcpy(words.data(),f.Data(),words.size()*8);
        std::vector<uint32_t> out(queries.size());f.Lookup(queries.size(),queries.data(),out.data());
        std::cout<<"{\"lines\":"<<lines<<",\"insertions\":"<<n<<",\"words\":[";
        for(size_t i=0;i<words.size();++i){if(i)std::cout<<',';std::cout<<words[i];}
        std::cout<<"],\"out\":[";
        for(size_t i=0;i<out.size();++i){if(i)std::cout<<',';std::cout<<out[i];}
        std::cout<<"]}\n";
    }
}
int main(int argc,char **argv) {
    if(argc==2 && std::string(argv[1])=="--parity") {fixtures();return 0;}
    ownership();serial_parallel();std::cout<<"Split64 range serial/parallel checks passed\n";
}
