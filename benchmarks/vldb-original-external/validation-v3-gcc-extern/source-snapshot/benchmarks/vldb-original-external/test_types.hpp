#pragma once
#include "adapters.hpp"
namespace vldb_external {
template<unsigned U> struct Sector32 {
  using Dynamic=DirectDynamic<uint32_t,8,8,8,U>;
  using Static=StaticLogic<uint32_t,8,8,8,U,dtl::block_addressing::POWER_OF_TWO>;
  using Public=ArtifactPublic<dtl::bbf_32,8,8,8,U>;
};
template<unsigned U> struct Sector64 {
  using Dynamic=DirectDynamic<uint64_t,8,8,8,U>;
  using Static=StaticLogic<uint64_t,8,8,8,U,dtl::block_addressing::POWER_OF_TWO>;
  using Public=ArtifactPublic<dtl::bbf_64,8,8,8,U>;
};
struct Register64 {
  using Dynamic=DirectDynamic<uint64_t,1,1,8,0>;
  using Static=StaticLogic<uint64_t,1,1,8,0,dtl::block_addressing::POWER_OF_TWO>;
  using Public=ArtifactPublic<dtl::bbf_64,1,1,8,0>;
};
} // namespace vldb_external
