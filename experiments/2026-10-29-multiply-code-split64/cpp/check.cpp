#include "multiply_code_split64.h"
#include "cyclic_split64.h"
#include "split64_reference.h"
#include <array>
#include <cstring>
#include <iostream>
#include <utility>
using namespace bloom_filters;
#if EXPECTED_BACKEND == 2
static_assert(__AVX512F__, "native test must compile the AVX512F branch");
#elif EXPECTED_BACKEND == 1
#if !defined(__AVX2__) || defined(__AVX512F__)
#error "AVX2-only test compiled the wrong backend"
#endif
#else
#if defined(__AVX2__) || defined(__AVX512F__)
#error "Scalar test compiled a SIMD backend"
#endif
#endif
static void require(bool value, const char *message) {
    if (!value) throw std::runtime_error(message);
}
static uint64_t next(uint64_t &state) {
    uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}
enum class Mapping { Original, Cyclic, MultiplyCode };
// Independent128-bit multiplication and explicit bit extraction: no call to
// candidate Code/Position/Mask, and no SIMD intrinsic or uint64 wrap operation.
template<Mapping Kind> static std::array<uint64_t, 8> oracle_mask(uint64_t hash) {
    static constexpr uint32_t salts[8] = {0x47b6137bU,0x44974d91U,0x8824ad5bU,0xa2b7289dU,
                                         0x705495c7U,0x2df1424bU,0x9efc4947U,0x5c6bfb31U};
    std::array<uint64_t, 8> result{};
    const uint32_t low = static_cast<uint32_t>(hash);
    const unsigned __int128 full = static_cast<unsigned __int128>(low) * 0x9e3779b97f4a7c15ULL;
    for (size_t j = 0; j < 8; ++j) {
        unsigned position = 0;
        for (unsigned bit = 0; bit < 6; ++bit) {
            unsigned value;
            if constexpr (Kind == Mapping::MultiplyCode)
                value = static_cast<unsigned>((full >> (8 * j + bit)) & 1);
            else if constexpr (Kind == Mapping::Cyclic)
                value = (low >> ((4 * j + bit) % 32)) & 1;
            else {
                const unsigned __int128 product = static_cast<unsigned __int128>(low) * salts[j];
                value = static_cast<unsigned>((product >> (26 + bit)) & 1);
            }
            position |= value << bit;
        }
        result[j] = uint64_t{1} << position;
    }
    return result;
}
static size_t oracle_block(uint64_t hash, size_t lines) {
    return static_cast<unsigned __int128>(hash >> 32) * lines / (uint64_t{1} << 32);
}
namespace bloom_filters {
struct RangeLayoutInspector {
    static std::array<uint64_t, 8> Mask(uint64_t hash) {
        std::array<uint64_t, 8> result{};
#if defined(__AVX512F__)
        _mm512_storeu_si512(result.data(), MultiplyCodeSplit64Range::Mask(hash));
        std::array<uint64_t, 8> wide{};
        _mm512_storeu_si512(wide.data(), MultiplyCodeSplit64Range::WideMask(hash));
        require(wide == result, "short-mask alias mismatch");
#elif defined(__AVX2__)
        __m256i low, high;
        MultiplyCodeSplit64Range::Mask256(hash, low, high);
        _mm256_storeu_si256(reinterpret_cast<__m256i *>(result.data()), low);
        _mm256_storeu_si256(reinterpret_cast<__m256i *>(result.data() + 4), high);
#else
        for (size_t j = 0; j < 8; ++j)
            result[j] = uint64_t{1} << MultiplyCodeSplit64Range::Position(hash, j);
#endif
        return result;
    }
};
}
template<Mapping Kind> static uint32_t oracle_answer(const std::vector<uint64_t> &words, uint64_t hash) {
    const auto mask = oracle_mask<Kind>(hash);
    const size_t at = oracle_block(hash, words.size() / 8) * 8;
    for (size_t j = 0; j < 8; ++j)
        if ((words[at + j] & mask[j]) != mask[j]) return 0;
    return 1;
}
template<class Filter, Mapping Kind> static uint64_t check_filter() {
    Filter empty(RangeBytes{128});
    empty.Insert(0, nullptr);
    require(empty.Lookup(0, nullptr, nullptr) == 0, "empty null batch");
    for (size_t bytes : {0UL,1UL,127UL,(1UL<<28)+1,SIZE_MAX}) {
        bool rejected = false;
        try { Filter invalid(RangeBytes{bytes}); } catch (const std::exception &) { rejected = true; }
        require(rejected, "invalid byte budget");
    }
    for (const auto parameters : {std::pair<size_t,uint32_t>{0,16},{1,0},{SIZE_MAX,16}}) {
        bool rejected = false;
        try { Filter invalid(parameters.first, parameters.second); } catch (const std::exception &) { rejected = true; }
        require(rejected, "invalid product budget");
    }
    uint64_t digest = 14695981039346656037ULL;
    for (size_t lines : {2UL,3UL,5UL,7UL,31UL,257UL,4097UL,32769UL}) {
        Filter filter(RangeBytes{lines * 64 + 31});
        require(filter.SizeInBytes() == lines * 64, "actual backing byte cap");
        require(reinterpret_cast<uintptr_t>(filter.Data()) % 64 == 0, "bitmap alignment");
        std::vector<uint64_t> expected(lines * 8), hashes;
        uint64_t state = 0x243f6a8885a308d3ULL;
        for (size_t i = 0; i < 2048; ++i) hashes.push_back(next(state));
        for (unsigned bit = 0; bit < 64; ++bit) {
            hashes.push_back(uint64_t{1} << bit);
            hashes.push_back(~(uint64_t{1} << bit));
        }
        // Concentrate distinct low hashes and duplicates into the same physical line.
        for (uint64_t low = 0; low < 128; ++low) { hashes.push_back(low); hashes.push_back(low); }
        for (size_t line = 0; line <= std::min<size_t>(lines,4097); ++line) {
            const uint64_t boundary = ((uint64_t(line) << 32) + lines - 1) / lines;
            for (int d : {-1,0,1}) {
                const int64_t high = int64_t(boundary) + d;
                if (high >= 0 && uint64_t(high) <= UINT32_MAX)
                    hashes.push_back((uint64_t(high) << 32) | uint32_t(next(state)));
            }
        }
        for (uint64_t hash : hashes) {
            const auto mask = oracle_mask<Kind>(hash);
            const size_t at = oracle_block(hash, lines) * 8;
            for (size_t j = 0; j < 8; ++j) expected[at + j] |= mask[j];
        }
        for (size_t at = 0; at < hashes.size(); at += 37)
            filter.Insert(std::min<size_t>(37,hashes.size()-at), hashes.data()+at);
        filter.Insert(17, hashes.data());
        require(std::memcmp(filter.Data(),expected.data(),expected.size()*8)==0, "full bitmap oracle");
        for (uint64_t hash : hashes) require(filter.ContainsHash(hash), "singleton false negative");
        std::array<uint32_t,37> hits{};
        for (size_t at=0; at<hashes.size(); at+=hits.size()) {
            const size_t take=std::min(hits.size(),hashes.size()-at);
            filter.Lookup(take,hashes.data()+at,hits.data());
            for(size_t i=0;i<take;++i)require(hits[i]==1,"batch false negative");
        }
        std::vector<uint64_t> queries(4135);
        for(auto &hash:queries)hash=next(state);
        std::copy_n(hashes.begin(),std::min(hashes.size(),queries.size()/2),queries.begin());
        std::vector<size_t> lengths;
        for(size_t i=0;i<=131;++i)lengths.push_back(i);
        for(size_t i:{4096UL,4097UL,4127UL})lengths.push_back(i);
        for(size_t length:lengths)for(size_t offset:{0UL,1UL,7UL}) {
            std::vector<uint32_t> output(length+2,0xfeed);
            require(filter.Lookup(length,queries.data()+offset,output.data()+1)==length,"dense count");
            require(output.front()==0xfeed && output.back()==0xfeed,"tail guard");
            for(size_t i=0;i<length;++i)
                require(output[i+1]==oracle_answer<Kind>(expected,queries[i+offset]),"dense oracle");
        }
        require(std::memcmp(filter.Data(),expected.data(),expected.size()*8)==0,"immutable query bitmap");
        for(uint64_t hash:{0ULL,1ULL,~0ULL,0x8000000000000000ULL,0xfedcba9876543210ULL}) {
            Filter single(RangeBytes{lines*64});
            single.Insert(1,&hash);
            const auto mask=oracle_mask<Kind>(hash);
            auto *bytes=static_cast<unsigned char*>(const_cast<void*>(single.Data()));
            for(size_t j=0;j<8;++j) {
                const size_t at=(oracle_block(hash,lines)*8+j)*8;
                uint64_t word;std::memcpy(&word,bytes+at,8);word&=~mask[j];std::memcpy(bytes+at,&word,8);
                require(!single.ContainsHash(hash),"essential bit");
                std::array<uint64_t,3> input{hash,hash,hash};std::array<uint32_t,5> output{9,9,9,9,9};
                single.Lookup(3,input.data(),output.data()+1);
                require(output[0]==9 && output[4]==9 && output[1]==0 && output[2]==0 && output[3]==0,"short SIMD essential bit");
                word|=mask[j];std::memcpy(bytes+at,&word,8);
            }
        }
        for(uint64_t word:expected){digest^=word;digest*=1099511628211ULL;}
    }
    return digest;
}
int main() {
    uint64_t state=0x13198a2e03707344ULL;
    for(uint64_t low=0;low<(1UL<<16);++low) {
        const uint64_t hash=(next(state)&0xffffffff00000000ULL)|low;
        require(RangeLayoutInspector::Mask(hash)==oracle_mask<Mapping::MultiplyCode>(hash),"low16 direct mask oracle");
        require(RangeLayoutInspector::Mask(hash)==RangeLayoutInspector::Mask(low),"mask depends on high32");
    }
    for(size_t i=0;i<16384;++i) {
        const uint64_t hash=next(state);
        require(RangeLayoutInspector::Mask(hash)==oracle_mask<Mapping::MultiplyCode>(hash),"full32 direct mask oracle");
    }
    std::cout<<"Full bitmap/mask/tail oracles passed "
             <<check_filter<Split64Range,Mapping::Original>()<<' '
             <<check_filter<CyclicSplit64Range,Mapping::Cyclic>()<<' '
             <<check_filter<MultiplyCodeSplit64Range,Mapping::MultiplyCode>()<<'\n';
}
