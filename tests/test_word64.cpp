#include "base.h"
#include "layout_detail.h"
#include <algorithm>
#include <cstring>
#include <iostream>
#include <set>
#include <stdexcept>
#include <vector>
#define private public
#include "word64_bloom.h"
#undef private
#include "parallel_layout_bloom.h"
using namespace bloom_filters;
static void Require(bool ok, const char *message) { if (!ok) throw std::runtime_error(message); }
static uint64_t ReferenceMask(uint64_t h) {
    const uint64_t pattern = Word64BloomFilter::patterns_[h % 64];
    const unsigned rotation = (h / 64) % 64;
    uint64_t result = 0;
    for (unsigned bit = 0; bit < 64; ++bit)
        if ((pattern >> bit) & 1) result |= uint64_t{1} << ((bit + rotation) % 64);
    return result;
}
int main() {
    std::set<uint64_t> masks;
    for (uint64_t code = 0; code < 4096; ++code) {
        const auto m = ReferenceMask(code);
        Require(__builtin_popcountll(m) == 4, "dictionary weight");
        Require(m == Word64BloomFilter::Mask(code), "exhaustive rotation oracle");
        Require(masks.insert(m).second, "duplicate cyclic mask");
    }
    uint64_t checksum = 14695981039346656037ULL;
    for (auto size : {std::pair<size_t,uint32_t>{0,8}, {1,4}, {65539,8}, {size_t{1}<<20,16},
                     {size_t{1}<<24,8}, {size_t{1}<<24,16}}) {
        Word64BloomFilter filter(size.first,size.second);
        Require(filter.SizeInBytes() == layout_detail::WordCount(size.first,size.second)*4, "allocated bytes");
        Require(reinterpret_cast<uintptr_t>(filter.words_.data()) % 64 == 0, "alignment");
        const size_t n = size.first ? 65539 : 0;
        std::vector<uint64_t> keys(n), query(131081), bitmap(filter.SizeInBytes()/8);
        for (size_t i=0;i<n;++i) {
            keys[i] = i%3 ? MurmurHash64(i+731) : (uint64_t(UINT32_MAX)<<32)|uint32_t(i/7);
            const size_t word = (keys[i] >> 32) % bitmap.size();
            bitmap[word] |= ReferenceMask(keys[i]);
            Require(filter.CacheLineIndex(keys[i]) == word/8, "line ownership");
        }
        filter.Insert(0,nullptr);
        Require(filter.Lookup(0,nullptr,nullptr)==0, "empty query");
        for (size_t i=0;i<n;i+=31) filter.Insert(std::min(size_t{31},n-i),keys.data()+i);
        Require(std::memcmp(filter.words_.data(),bitmap.data(),filter.SizeInBytes())==0, "bitmap oracle");
        filter.Insert(n,keys.data());
        Require(filter.words_ == decltype(filter.words_)(bitmap.begin(),bitmap.end()), "duplicate insertion");
        std::vector<uint32_t> expected(query.size()), out(query.size());
        for (size_t i=0;i<query.size();++i) {
            query[i] = i<n ? keys[i] : MurmurHash64(i+1000000007);
            const auto mask = ReferenceMask(query[i]);
            expected[i] = (bitmap[(query[i]>>32)%bitmap.size()] & mask) == mask;
            if (i<n) Require(expected[i]==1,"reference false negative");
        }
        filter.Lookup(query.size(),query.data(),out.data());
        Require(out==expected,"complete query parity");
        for(auto x:out) checksum=(checksum^x)*1099511628211ULL;
        for(size_t offset=0;offset<8;++offset) for(size_t count=0;count<=273;++count) {
            std::vector<uint64_t> tail(query.begin(),query.begin()+offset+count);
            std::vector<uint32_t> guarded(count+2,0xdeadbeef);
            Require(filter.Lookup(count,tail.data()+offset,guarded.data()+1)==count,"returned query count");
            Require(guarded.front()==0xdeadbeef && guarded.back()==0xdeadbeef,"tail output guard");
            for(size_t j=0;j<count;++j) Require(guarded[j+1]==expected[j+offset],"tail output");
        }
        auto copy=filter;
        Require(copy.words_.data()!=filter.words_.data(),"copy ownership");
        copy.Lookup(query.size(),query.data(),out.data());
        Require(out==expected,"copy query parity");
        for(size_t workers:{1u,2u,3u,7u}) {
            ParallelWord64BloomFilter parallel(size.first,size.second);
            parallel.InsertParallel(n,keys.data(),workers);
            parallel.InsertParallel(n,keys.data(),workers);
            parallel.LookupParallel(query.size(),query.data(),out.data(),workers);
            Require(out==expected,"parallel parity");
        }
    }
    for(auto size:{std::pair<size_t,uint32_t>{1,0},{SIZE_MAX,8},{size_t{1}<<28,8}}) {
        bool rejected=false;
        try { Word64BloomFilter invalid(size.first,size.second); }
        catch(const std::exception&) { rejected=true; }
        Require(rejected,"invalid size accepted");
    }
    std::cout << "Word64 dictionary, bitmaps, duplicate/tail/copy/parallel parity passed: " << checksum << '\n';
}
