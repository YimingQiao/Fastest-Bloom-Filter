#pragma once
#include "fast_pattern_BF.h"
#include "four_sector_bloom.h"
#include "split64_bloom.h"
#include "byte_split_bloom.h"
#include "split64_range_bloom.h"
#include "control.h"
#include "candidate.h"
#include "cpp-adapters.hpp"
#include "boost-adapters.hpp"
#include "rocks-adapters.hpp"
using K12Control = FourSectorRange12BloomFilter;
using K12SingletonVector = FourSectorRange12SingletonVectorExperiment;
using Split64Range = Split64RangeBloomFilter;
