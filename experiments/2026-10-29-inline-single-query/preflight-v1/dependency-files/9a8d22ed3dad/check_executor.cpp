#include "executor.hpp"
#include <atomic>
#include <cmath>
#include <iostream>
#include <numeric>
#include <string>
using namespace external_parallel;
void Require(bool value, const char *message) { if (!value) throw std::runtime_error(message); }
template<class Function> void Throws(Function fn, const char *message) {
    bool threw = false; try { fn(); } catch (const std::exception&) { threw = true; }
    Require(threw,message);
}
int main() {
    for (size_t q : {size_t(1),size_t(31),size_t(4097),size_t(65539)}) {
        for (size_t batch : {size_t(1),size_t(7),size_t(31),size_t(4096)}) {
            const size_t count = BatchCount(q,batch);
            for (size_t workers : {size_t(1),size_t(3),size_t(8)}) {
                if (workers>count) continue;
                std::vector<unsigned> output(q+2,0), calls(count);
                output.front()=output.back()=0xfeed;
                auto sample = Execute(workers,[&](size_t worker) {
                    const auto range=BatchRange(count,workers,worker);
                    for (size_t b=range.begin;b<range.end;++b) {
                        ++calls[b];
                        const size_t begin=b*batch, end=std::min(q,begin+batch);
                        for (size_t i=begin;i<end;++i) output[i+1]=i%97+1;
                    }
                });
                Require(output.front()==0xfeed && output.back()==0xfeed,"guard overwritten");
                for (size_t i=0;i<q;++i) Require(output[i+1]==i%97+1,"coverage mismatch");
                for (auto c:calls) Require(c==1,"global batch was split or repeated");
                Require(std::abs(sample.end_to_end-sample.launch-sample.query-sample.join)<1,"incomplete timing");
            }
        }
    }
    const auto huge=BatchRange(SIZE_MAX,8,7);
    Require(huge.end==SIZE_MAX,"large batch range overflow");
    Throws([]{BatchCount(1,0);},"zero batch accepted");
    Throws([]{BatchRange(2,3,0);},"too many workers accepted");
    Throws([]{Execute(0,[](size_t){});},"zero workers accepted");
    std::atomic<unsigned> work{0},pins{0};
    Throws([&]{Execute(8,[&](size_t){++work;},[&](size_t w){++pins;if(w==3)throw std::runtime_error("pin fault");});},"pin error lost");
    Require(work==0 && pins==7,"pin error did not cancel before work");
    pins=0;
    Throws([&]{Execute(8,[&](size_t){++work;},[&](size_t w){++pins;if(w==1 || w==3)throw std::runtime_error("multiple pin faults");});},"multiple pin errors lost");
    Require(work==0 && pins==7,"multiple pin errors did not cancel all work");
    pins=0;
    Throws([&]{Execute(8,[&](size_t){++work;},[&](size_t){++pins;},[](size_t w){if(w==4)throw std::runtime_error("spawn fault");});},"spawn error lost");
    Require(work==0 && pins==3,"spawn error did not join started workers");
    for(size_t failed: {size_t(0),size_t(3)}) {
        work=0;
        Throws([&]{Execute(8,[&](size_t w){++work;if(w==failed)throw std::runtime_error("work fault");});},"work error lost");
        Require(work==8,"work error escaped before all joins");
    }
    std::cout<<"Global batch coverage, timing decomposition, overflow and cancellation/join tests passed.\n";
}
