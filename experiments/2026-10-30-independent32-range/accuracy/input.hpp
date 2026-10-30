#pragma once
#include "../snapshot/base.h"
#include <algorithm>
#include <cstdint>
#include <numeric>
#include <vector>
using bloom_filters::HashVector;
struct SplitMix64 {
    uint64_t state;
    uint64_t operator()() {
        uint64_t z = (state += 0x9e3779b97f4a7c15ULL);
        z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
        z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
        return z ^ (z >> 31);
    }
};
template <class T> void Shuffle(std::vector<T>& v, SplitMix64& rng) {
    for (size_t i = v.size(); i > 1; --i) std::swap(v[i-1], v[rng() % i]);
}
template <class T> uint64_t Digest(const T* values, size_t n) {
    uint64_t value = 14695981039346656037ULL;
    for (size_t i = 0; i < n; ++i) value = (value ^ values[i]) * 1099511628211ULL;
    return value;
}
struct Input {
    std::vector<uint64_t> inserted_raw, query_raw, inserted, query;
    uint64_t key_base, inserted_digest, query_digest, inserted_hash_digest, query_hash_digest;
};

inline Input MakeInput(size_t n, size_t q) {
    struct { uint64_t seed=42; unsigned hit=50; } c;
        Input d;d.inserted_raw.resize(n);d.query_raw.resize(q);d.inserted.resize(n);d.query.resize(q);
        SplitMix64 rng{c.seed};d.key_base=rng()%((uint64_t{1}<<32)-n-q);
        std::iota(d.inserted_raw.begin(),d.inserted_raw.end(),d.key_base);Shuffle(d.inserted_raw,rng);
        for(size_t i=0;i<q;++i)d.query_raw[i]=d.key_base+((i%100<c.hit)?rng()%n:n+i);
        Shuffle(d.query_raw,rng);
        HashVector(n,d.inserted_raw.data(),d.inserted.data());HashVector(q,d.query_raw.data(),d.query.data());
        d.inserted_digest=Digest(d.inserted_raw.data(),n);d.query_digest=Digest(d.query_raw.data(),q);
        d.inserted_hash_digest=Digest(d.inserted.data(),n);d.query_hash_digest=Digest(d.query.data(),q);
    return d;
}
