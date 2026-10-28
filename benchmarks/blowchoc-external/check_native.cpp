#include "snapshot/include/base.h"
#include <algorithm>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <vector>

extern "C" {
const char *bc_native_error() noexcept;
int bc_native_create(unsigned, size_t, uint32_t, void **) noexcept;
void bc_native_destroy(void *) noexcept;
size_t bc_native_bytes(const void *) noexcept;
int bc_native_operation(void *, unsigned, unsigned, size_t, const uint64_t *, uint32_t *, size_t, uint64_t *) noexcept;
}
static void require(bool condition) {
    if (!condition) throw std::runtime_error(std::string("native bridge check: ") + bc_native_error());
}
int main() {
    constexpr uint32_t guard = 0x5a5a5a5a;
    for (unsigned kind = 0; kind < 4; ++kind) {
        for (uint32_t bpk : {8u, 16u}) {
            std::vector<uint64_t> raw(1024), inserted(raw.size());
            std::iota(raw.begin(), raw.end(), UINT64_C(731));
            bloom_filters::HashVector(raw.size(), raw.data(), inserted.data());
            std::vector<uint32_t> reference;
            for (unsigned build_mode = 0; build_mode < 3; ++build_mode) {
                void *handle = nullptr;
                require(bc_native_create(kind, raw.size(), bpk, &handle) == 0 && handle);
                require(bc_native_bytes(handle) == (bpk == 8 ? 2048 : 4096));
                std::vector<uint64_t> scratch(4096);
                require(bc_native_operation(handle, 0, build_mode, raw.size(),
                        build_mode ? raw.data() : inserted.data(), nullptr, 31, scratch.data()) == 0);
                std::vector<uint32_t> hits(raw.size());
                require(bc_native_operation(handle, 1, 0, inserted.size(), inserted.data(), hits.data(), 31,
                                             scratch.data()) == 0);
                require(std::all_of(hits.begin(), hits.end(), [](uint32_t value) { return value == 1; }));
                std::vector<uint32_t> all;
                for (size_t length : {size_t(0), size_t(1), size_t(7), size_t(31), size_t(131), size_t(4097)}) {
                    std::vector<uint64_t> query_raw(length), hashes(length);
                    for (size_t i = 0; i < length; ++i) query_raw[i] = UINT64_C(1000000) + i;
                    for (size_t i = 0; i < length; i += 2) query_raw[i] = raw[i % raw.size()];
                    bloom_filters::HashVector(length, query_raw.data(), hashes.data());
                    std::vector<uint32_t> expected;
                    for (unsigned mode = 0; mode < 3; ++mode) {
                        for (size_t batch : {size_t(1), size_t(7), size_t(31), size_t(4096)}) {
                            std::vector<uint32_t> out(length + 10, guard);
                            require(bc_native_operation(handle, 1, mode, length,
                                    mode ? query_raw.data() : hashes.data(), out.data() + 5, batch, scratch.data()) == 0);
                            require(std::all_of(out.begin(), out.begin() + 5, [](uint32_t value) { return value == guard; }));
                            require(std::all_of(out.end() - 5, out.end(), [](uint32_t value) { return value == guard; }));
                            std::vector<uint32_t> answer(out.begin() + 5, out.end() - 5);
                            require(std::all_of(answer.begin(), answer.end(), [](uint32_t value) { return value <= 1; }));
                            if (mode == 0 && batch == 1) expected = answer;
                            else require(answer == expected);
                        }
                    }
                    all.insert(all.end(), expected.begin(), expected.end());
                }
                if (build_mode == 0) reference = all;
                else require(all == reference);
                require(bc_native_operation(handle, 1, 0, 0, nullptr, nullptr, 1, nullptr) == 0);
                require(bc_native_operation(handle, 1, 0, 0, nullptr, nullptr, size_t{1} << 32, nullptr) == -1);
                require(bc_native_operation(handle, 1, 0, 1, nullptr, hits.data(), 1, nullptr) == -1);
                bc_native_destroy(handle);
            }
        }
    }
    void *handle = nullptr;
    require(bc_native_create(99, 1024, 8, &handle) == -1 && !handle);
    require(bc_native_create(0, 1024, 0, &handle) == -1 && !handle);
    require(bc_native_create(0, size_t{1} << 29, 8, &handle) == -1 && !handle);
    require(bc_native_create(0, 1024, 8, nullptr) == -1);
    bc_native_destroy(nullptr);
    require(bc_native_bytes(nullptr) == 0);
    std::cout << "native whole-array ABI guards, modes, complete outputs and noFN passed\n";
}
