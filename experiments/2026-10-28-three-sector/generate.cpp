// Exact orbit-compressed version of scripts/generate_patterns.py's objective.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <limits>
#include <unordered_map>
#include <vector>
constexpr size_t Features = 171; // 16 pair rotation orbits, 155 triple orbits.
uint32_t canonical(uint32_t mask) {
    uint32_t best = mask;
    for(unsigned r=1; r<32; ++r) best=std::min(best,(mask<<r)|(mask>>(32-r)));
    return best;
}
struct Candidate { uint32_t mask; std::array<uint8_t,Features> frequencies{}; bool used=false; };
int triple[32][32][32];
std::vector<Candidate> candidates;
std::array<unsigned,8> positions{};
void enumerate(unsigned index, unsigned bits, unsigned next, uint32_t mask) {
    if(index != bits) {
        for(unsigned p=next; p+bits-index<=32; ++p) {
            positions[index]=p;
            enumerate(index+1,bits,p+1,mask|(uint32_t{1}<<p));
        }
        return;
    }
    if(mask != canonical(mask)) return;
    Candidate c; c.mask=mask;
    for(unsigned i=0;i<bits;++i) for(unsigned j=i+1;j<bits;++j) {
        const unsigned d=std::min(positions[j]-positions[i],32-(positions[j]-positions[i]));
        c.frequencies[d-1] += d==16?2:1;
        for(unsigned k=j+1;k<bits;++k) ++c.frequencies[16+triple[positions[i]][positions[j]][positions[k]]];
    }
    candidates.push_back(c);
}
int main(int argc,char**argv) {
    const unsigned bits=argc>1?std::stoul(argv[1]):4;
    const unsigned count=argc>2?std::stoul(argv[2]):32;
    if(bits<2||bits>8) return 1;
    std::unordered_map<uint32_t,int> ids;
    for(unsigned i=0;i<32;++i) for(unsigned j=i+1;j<32;++j) for(unsigned k=j+1;k<32;++k) {
        const auto mask=canonical((uint32_t{1}<<i)|(uint32_t{1}<<j)|(uint32_t{1}<<k));
        auto entry=ids.emplace(mask,static_cast<int>(ids.size()));
        triple[i][j][k]=entry.first->second;
    }
    if(ids.size()!=155) return 2;
    positions[0]=0; enumerate(1,bits,1,1);
    std::cerr<<"bits="<<bits<<" candidates="<<candidates.size()<<'\n';
    std::array<int,Features> used{};
    if(count>candidates.size()) return 3;
    for(unsigned n=0;n<count;++n) {
        size_t best=0; int best_score=std::numeric_limits<int>::max();
        for(size_t c=0;c<candidates.size();++c) {
            if(candidates[c].used) continue;
            int score=0;
            for(size_t f=0;f<Features;++f) {
                const int x=candidates[c].frequencies[f];
                const int weight=f<15?2:(f==15?1:16);
                score += weight*(2*used[f]*x+x*x);
            }
            if(score<best_score) {best=c;best_score=score;}
        }
        auto& chosen=candidates[best];chosen.used=true;
        for(size_t f=0;f<Features;++f) used[f]+=chosen.frequencies[f];
        std::cout<<(n?", ":"")<<"0x"<<std::hex<<chosen.mask<<std::dec;
    }
    std::cout<<'\n';
}
