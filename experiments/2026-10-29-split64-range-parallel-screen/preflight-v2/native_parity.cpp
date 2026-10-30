#include "../native-range/split64_bloom.h"
#include <cstring>
#include <iostream>
using namespace bloom_filters;
static uint64_t next(uint64_t &state) {
    uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}
static void fixtures() {
    for(size_t lines:{2UL,3UL,5UL,31UL,257UL,4097UL}) for(size_t n:{31UL,2048UL}) {
        uint64_t state=0x243f6a8885a308d3ULL;
        std::vector<uint64_t> hashes(n),queries(1024);
        for(auto &h:hashes)h=next(state);for(auto &h:queries)h=next(state);
        queries.insert(queries.end(),hashes.begin(),hashes.begin()+31);
        Split64RangeNative f(RangeBytes{lines*64+31});f.Insert(hashes.size(),hashes.data());
        std::vector<uint64_t> words(lines*8);std::memcpy(words.data(),f.Data(),words.size()*8);
        std::vector<uint32_t> out(queries.size());f.Lookup(queries.size(),queries.data(),out.data());
        std::cout<<"{\"lines\":"<<lines<<",\"insertions\":"<<n<<",\"words\":[";
        for(size_t i=0;i<words.size();++i){if(i)std::cout<<',';std::cout<<words[i];}
        std::cout<<"],\"out\":[";
        for(size_t i=0;i<out.size();++i){if(i)std::cout<<',';std::cout<<out[i];}
        std::cout<<"]}\n";
    }
}
int main() { fixtures(); }
