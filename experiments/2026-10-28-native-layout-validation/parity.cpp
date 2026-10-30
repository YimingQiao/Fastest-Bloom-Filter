#define BF_FOUR_EXTERNAL_BASE 1
#define BF_FOUR_SIMD 1
#define MASK_TABLE_ENTRIES 16
#include "four_sector.h"
#include "split64.hpp"
#include "parallel_layout_bloom.h"
#include <algorithm>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>
using namespace bloom_filters;
static void require(bool value) {if(!value)throw std::runtime_error("native/frozen parity mismatch");}
template<class Native,class Frozen> uint64_t check() {
    uint64_t checksum=0;
    for(size_t capacity : {size_t(1024),size_t(65539),size_t((1u<<20)+3)}) {
        const uint32_t count=capacity;
        std::vector<uint64_t> hashes(count*2+149);
        for(size_t i=0;i<hashes.size();++i) hashes[i]=i%5 ? MurmurHash64(i+104729) : (uint64_t(0xe5000123)<<32)|uint32_t(MurmurHash64(i/7));
        for(uint32_t bpk:{4u,8u,16u}) {
            Native native(capacity,bpk); Frozen frozen(capacity,bpk);
            require(native.SizeInBytes()==frozen.SizeInBytes());
            native.Insert(count,hashes.data());frozen.Insert(count,hashes.data());
            const Native copied=native;
            for(uint32_t batch:{7u,31u,4096u}) {
                std::vector<uint32_t> expected(batch),got(batch+2);
                for(size_t i=0;i<hashes.size();i+=batch) {
                    const uint32_t n=std::min<size_t>(batch,hashes.size()-i);
                    std::fill(got.begin(),got.end(),0xdeadbeef);
                    frozen.Lookup(n,hashes.data()+i,expected.data());
                    copied.Lookup(n,hashes.data()+i,got.data()+1);
                    require(got[0]==0xdeadbeef && got[n+1]==0xdeadbeef);
                    for(size_t j=0;j<n;++j) {
                        require(expected[j]==got[j+1]);
                        if(i+j<count)require(got[j+1]==1);
                        checksum=checksum*0x9e3779b97f4a7c15ULL+got[j+1];
                    }
                }
            }
            if(bpk==8) {
                ParallelLayoutBloomFilter<Native> parallel(capacity,bpk);
                parallel.InsertParallel(count,hashes.data(),3);
                std::vector<uint32_t> expected(hashes.size()),got(hashes.size());
                frozen.Lookup(hashes.size(),hashes.data(),expected.data());
                parallel.LookupParallel(hashes.size(),hashes.data(),got.data(),7);
                require(expected==got);
                std::vector<uint32_t> second(got.size());
                std::thread reader([&]{parallel.Lookup(hashes.size(),hashes.data(),second.data());});
                parallel.LookupParallel(hashes.size(),hashes.data(),got.data(),3);
                reader.join();require(expected==got && expected==second);
            }
        }
    }
    return checksum;
}
int main() {
    require(layout_detail::WordCount((size_t{1}<<27)-1,16)==(size_t{1}<<26));
    std::cout<<check<FourSectorBloomFilter,FourSectorBF<8>>()<<'\n';
    std::cout<<check<Split64BloomFilter,Split64P32>()<<'\n';
}
