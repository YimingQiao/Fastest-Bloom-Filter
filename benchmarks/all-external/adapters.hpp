#pragma once
#include "../cpp-external/adapters.hpp"
#include "../boost-external/adapters.hpp"
#undef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    BF_REGISTER_FASTFILTER_FILTERS(ADD); \
    BF_REGISTER_BOOST_FILTERS(ADD)
