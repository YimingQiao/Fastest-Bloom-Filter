#include "four_sector_range24.h"
#include <array>
#include <iostream>

using bloom_filters::FourSectorRange24;
using bloom_filters::RangeBytes;
static void Need(bool value, const char* message) {
    if (!value) throw std::runtime_error(message);
}
struct Probe { std::array<size_t, 4> words; std::array<uint32_t, 4> masks; };
// Independent arithmetic oracle: no SIMD, library mask, rotate or address helper.
static Probe Oracle(uint64_t hash, size_t lines) {
    const uint32_t hi = hash >> 32, lo = hash;
    const size_t line = static_cast<size_t>((static_cast<unsigned __int128>(hash >> 40) * lines) / (1u << 24));
    Need(line < lines, "oracle line bounds");
    Probe p;
    for (unsigned sector = 0; sector < 4; ++sector) {
        uint32_t code = 0;
        for (unsigned bit = 0; bit < 9; ++bit)
            code |= ((lo >> ((bit + 8 * sector) % 32)) & 1u) << bit;
        const unsigned first = (code / 16) % 32, distance = (code % 16) + 1;
        p.masks[sector] = (uint32_t{1} << first) | (uint32_t{1} << ((first + distance) % 32));
        const unsigned offset = (hi & 3) ^ (sector ? ((hi >> (2 * sector)) & 3) : 0);
        p.words[sector] = 16 * line + 4 * sector + offset;
        Need(__builtin_popcount(p.masks[sector]) == 2 && p.words[sector] / 16 == line,
             "oracle sector/mask invariant");
    }
    return p;
}
static uint32_t Expected(const std::vector<uint32_t>& words, uint64_t hash) {
    const auto p = Oracle(hash, words.size() / 16);
    bool found = true;
    for (size_t j = 0; j < 4; ++j) found &= (words[p.words[j]] & p.masks[j]) == p.masks[j];
    return found;
}
static uint64_t Mix(uint64_t value) {
    value ^= value >> 30; value *= UINT64_C(0xbf58476d1ce4e5b9);
    value ^= value >> 27; value *= UINT64_C(0x94d049bb133111eb);
    return value ^ (value >> 31);
}
int main() try {
    uint64_t digest = UINT64_C(14695981039346656037);
    for (size_t lines : {2u, 3u, 5u, 12u, 32u, 127u, 1001u, 3072u, 32768u, 32769u}) {
        FourSectorRange24 filter(RangeBytes{lines * 64 + 63});
        Need(filter.SizeInBytes() == lines * 64, "actual allocation differs");
        std::vector<uint32_t> bitmap(lines * 16);
        std::vector<uint64_t> inserted(65536), query(4200);
        for (size_t i = 0; i < inserted.size(); ++i) inserted[i] = Mix(i + 42);
        inserted[0] = 0; inserted[1] = UINT64_MAX; inserted[2] = inserted[3];
        for (uint64_t hash : inserted) {
            const auto p = Oracle(hash, lines);
            Need(filter.LineIndex(hash) == p.words[0] / 16, "public address disagrees");
            for (size_t j = 0; j < 4; ++j) bitmap[p.words[j]] |= p.masks[j];
        }
        // Unaligned incremental batches exercise scalar tails and vector inserts.
        size_t done = 0;
        for (size_t batch : {1u, 3u, 4u, 7u, 16u, 31u, 65u, 4096u}) {
            filter.Insert(batch, inserted.data() + done); done += batch;
        }
        filter.Insert(inserted.size() - done, inserted.data() + done);
        filter.Insert(0, nullptr);
        Need(std::equal(bitmap.begin(), bitmap.end(), filter.Data()), "complete oracle bitmap mismatch");
        for (auto hash : inserted) Need(filter.ContainsHash(hash), "inserted key false negative");
        for (size_t i = 0; i < query.size(); ++i)
            query[i] = i % 2 ? inserted[(i * 17) % inserted.size()] : Mix((UINT64_C(1) << 40) + i);
        for (size_t offset = 0; offset < 8; ++offset) {
            for (size_t n = 0; n <= 131; ++n) {
                std::vector<uint32_t> output(n + 2, 0xfeedbeef), scalar(n + 2, 0xfeedbeef);
                Need(filter.Lookup(n, query.data() + offset, output.data() + 1) == n, "query count");
                filter.LookupScalar(n, query.data() + offset, scalar.data() + 1);
                Need(output == scalar, "public/scalar output disagreement");
                Need(output.front() == 0xfeedbeef && output.back() == 0xfeedbeef, "output guard modified");
                for (size_t i = 0; i < n; ++i) {
                    Need(output[i + 1] == Expected(bitmap, query[i + offset]), "oracle output mismatch");
                    digest = (digest ^ output[i + 1]) * UINT64_C(1099511628211);
                }
            }
        }
        for (size_t n : {4096u, 4097u, 4127u}) {
            std::vector<uint32_t> output(n + 2, 0xfeedbeef);
            filter.Lookup(n, query.data() + 1, output.data() + 1);
            Need(output.front() == 0xfeedbeef && output.back() == 0xfeedbeef, "long output guard");
            for (size_t i = 0; i < n; ++i) Need(output[i + 1] == Expected(bitmap, query[i + 1]), "long oracle mismatch");
        }
        Need(filter.Lookup(0, nullptr, nullptr) == 0, "empty query");
        Need(std::equal(bitmap.begin(), bitmap.end(), filter.Data()), "queries changed the bitmap");
        for (auto word : bitmap) digest = (digest ^ word) * UINT64_C(1099511628211);
    }
    // Every essential bit must matter in an otherwise single-key filter.
    for (size_t lines : {3u, 3072u}) for (uint64_t hash : {uint64_t{0}, UINT64_MAX, UINT64_C(0x123456789abcdef0)}) {
        FourSectorRange24 one(RangeBytes{lines * 64}); one.Insert(1, &hash);
        const auto p = Oracle(hash, lines);
        auto* words = const_cast<uint32_t*>(one.Data()); // The owned object itself is non-const.
        for (size_t j = 0; j < 4; ++j) for (unsigned bit = 0; bit < 32; ++bit) {
            if (!(p.masks[j] & (uint32_t{1} << bit))) continue;
            words[p.words[j]] ^= uint32_t{1} << bit;
            Need(!one.ContainsHash(hash), "essential bit ignored");
            uint32_t output[16]; uint64_t hashes[16]; std::fill_n(hashes, 16, hash);
            one.Lookup(16, hashes, output);
            Need(std::all_of(output, output + 16, [](uint32_t x){return x == 0;}), "vector essential bit ignored");
            words[p.words[j]] ^= uint32_t{1} << bit;
        }
    }
    for (size_t bytes : {size_t{0}, size_t{127}, (size_t{1} << 28) + 1, SIZE_MAX}) {
        bool rejected = false;
        try { FourSectorRange24 bad(RangeBytes{bytes}); } catch (const std::exception&) { rejected = true; }
        Need(rejected, "invalid budget accepted");
    }
    std::cout << "oracle/full-bitmaps/tails/essential-bits passed " << digest << '\n';
    return 0;
} catch (const std::exception& e) { std::cerr << e.what() << '\n'; return 2; }
