#pragma once
#include "before.h"
#include "after.h"
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
 ADD(FourSectorBefore,uint64_t); \
 ADD(FourSectorAfter,uint64_t)
