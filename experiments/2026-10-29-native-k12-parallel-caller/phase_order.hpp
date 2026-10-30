#pragma once
#include <array>
#include <cstdint>
#include <sstream>
#include <stdexcept>
#include <vector>
namespace k12_phase {
inline std::vector<std::array<unsigned,4>> Schedule(uint64_t seed,unsigned repeats) {
    if (!repeats || repeats%4) throw std::invalid_argument("query repetitions must be positive multiples of four");
    std::array<unsigned,4> labels{0,1,2,3};uint64_t state=seed^0x6a09e667f3bcc909ULL;
    auto next=[&]{uint64_t z=(state+=0x9e3779b97f4a7c15ULL);z=(z^(z>>30))*0xbf58476d1ce4e5b9ULL;z=(z^(z>>27))*0x94d049bb133111ebULL;return z^(z>>31);};
    for(size_t n=4;n>1;--n)std::swap(labels[n-1],labels[next()%n]);
    constexpr unsigned rows[4][4]={{0,1,3,2},{1,2,0,3},{2,3,1,0},{3,0,2,1}};
    std::vector<std::array<unsigned,4>> result(repeats);
    for(unsigned trial=0;trial<repeats;++trial)for(unsigned pos=0;pos<4;++pos)result[trial][pos]=labels[rows[trial%4][pos]];
    return result;
}
inline std::string Encode(const std::vector<std::array<unsigned,4>>& rows) {
    std::ostringstream out;for(size_t i=0;i<rows.size();++i){if(i)out<<';';for(unsigned j=0;j<4;++j){if(j)out<<'|';out<<rows[i][j];}}return out.str();
}
}
