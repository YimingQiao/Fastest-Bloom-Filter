"""Shared C++ harness SplitMix64/Fisher-Yates input construction, in Numba."""
import numpy as np
from numba import njit, uint64


@njit(inline="always")
def next_random(state):
    state += uint64(0x9e3779b97f4a7c15)
    z = state
    z = (z ^ (z >> uint64(30))) * uint64(0xbf58476d1ce4e5b9)
    z = (z ^ (z >> uint64(27))) * uint64(0x94d049bb133111eb)
    return state, z ^ (z >> uint64(31))


@njit(nogil=True)
def generate(n, q, hit, seed):
    state, value = next_random(uint64(seed))
    base = value % uint64((1 << 32) - n - q)
    inserted = np.empty(n, dtype=np.uint64)
    query = np.empty(q, dtype=np.uint64)
    for i in range(n):
        inserted[i] = base + uint64(i)
    for i in range(n, 1, -1):
        state, value = next_random(state)
        j = int(value % uint64(i))
        inserted[i - 1], inserted[j] = inserted[j], inserted[i - 1]
    for i in range(q):
        if i % 100 < hit:
            state, value = next_random(state)
            query[i] = base + value % uint64(n)
        else:
            query[i] = base + uint64(n + i)
    for i in range(q, 1, -1):
        state, value = next_random(state)
        j = int(value % uint64(i))
        query[i - 1], query[j] = query[j], query[i - 1]
    return inserted, query, base


@njit(nogil=True)
def checksum(values):
    result = uint64(14695981039346656037)
    for value in values:
        result = (result ^ uint64(value)) * uint64(1099511628211)
    return result
