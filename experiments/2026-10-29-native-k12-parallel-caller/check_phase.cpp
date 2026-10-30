#include "phase_order.hpp"
#include <iostream>
#include <stdexcept>
static void Need(bool ok){if(!ok)throw std::runtime_error("phase-order contract failed");}
int main(){
 for(uint64_t seed:{0ULL,42ULL,731ULL,0xffffffffffffffffULL})for(unsigned repeats:{4u,8u,12u}){
  const auto rows=k12_phase::Schedule(seed,repeats);Need(rows.size()==repeats);
  for(unsigned begin=0;begin<repeats;begin+=4){unsigned positions[4][4]={},adjacent[4][4]={};
   for(unsigned trial=begin;trial<begin+4;++trial){unsigned seen=0;for(unsigned pos=0;pos<4;++pos){const auto phase=rows[trial][pos];Need(phase<4&&!(seen&(1u<<phase)));seen|=1u<<phase;++positions[pos][phase];if(pos)++adjacent[rows[trial][pos-1]][phase];}Need(seen==15);}
   for(unsigned a=0;a<4;++a)for(unsigned b=0;b<4;++b){Need(positions[a][b]==1);Need(adjacent[a][b]==(a==b?0u:1u));}
  }
 }
 for(unsigned repeats:{0u,1u,2u,5u,7u}){bool rejected=false;try{(void)k12_phase::Schedule(42,repeats);}catch(const std::invalid_argument&){rejected=true;}Need(rejected);}
 std::cout<<"Balanced phase positions and every ordered adjacent pair passed\n";
}
