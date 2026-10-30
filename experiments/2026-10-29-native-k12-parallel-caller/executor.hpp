#pragma once
#include <algorithm>
#include <chrono>
#include <condition_variable>
#include <cstddef>
#include <exception>
#include <limits>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>

namespace external_parallel {
using Clock = std::chrono::steady_clock;
inline double Nanos(Clock::time_point a, Clock::time_point b) {
    return std::chrono::duration<double, std::nano>(b-a).count();
}
struct Timing {
    double end_to_end = 0, launch = 0, query = 0, join = 0;
};
struct Range { size_t begin, end; };
inline size_t BatchCount(size_t n, size_t batch) {
    if (!batch) throw std::invalid_argument("zero query batch");
    return n / batch + (n % batch != 0);
}
inline Range BatchRange(size_t count, size_t workers, size_t worker) {
    if (!workers || workers > 1024 || worker >= workers || workers > count)
        throw std::invalid_argument("invalid batch worker range");
    // Equivalent to floor(count * worker / workers), without multiplication overflow.
    const size_t whole = count / workers, tail = count % workers;
    return {whole * worker + tail * worker / workers,
            whole * (worker + 1) + tail * (worker + 1) / workers};
}
struct NoopHook { void operator()(size_t) const {} };

// Caller is worker zero. Only T-1 additional threads execute queries. The caller
// is pinned by the harness before construction/serial controls; Pin applies to
// each newly spawned thread. Hooks permit deterministic fault-path tests.
template<class Work, class Pin = NoopHook, class BeforeSpawn = NoopHook>
Timing Execute(size_t workers, Work work, Pin pin = {}, BeforeSpawn before_spawn = {}) {
    if (!workers || workers > 1024) throw std::invalid_argument("unsupported worker count");
    const auto start = Clock::now();
    Clock::time_point ready_time, complete_time;
    {
        std::mutex mutex;
        std::condition_variable ready_cv, start_cv, done_cv;
        size_t ready = 0, done = 0;
        bool start_work = false, cancel = false;
        std::vector<std::exception_ptr> errors(workers);
        std::vector<std::thread> threads;
        threads.reserve(workers - 1);
        auto join_all = [&] { for (auto &thread : threads) if (thread.joinable()) thread.join(); };
        try {
            for (size_t worker = 1; worker < workers; ++worker) {
                before_spawn(worker);
                threads.emplace_back([&, worker] {
                    try { pin(worker); }
                    catch (...) { errors[worker] = std::current_exception(); }
                    {
                        std::unique_lock<std::mutex> lock(mutex);
                        ++ready; ready_cv.notify_one();
                        start_cv.wait(lock, [&] { return start_work; });
                        if (cancel) return;
                    }
                    if (!errors[worker]) {
                        try { work(worker); }
                        catch (...) { errors[worker] = std::current_exception(); }
                    }
                    {
                        std::lock_guard<std::mutex> lock(mutex);
                        ++done; done_cv.notify_one();
                    }
                });
            }
        } catch (...) {
            {
                std::lock_guard<std::mutex> lock(mutex);
                cancel = true; start_work = true;
            }
            start_cv.notify_all(); join_all(); throw;
        }
        {
            std::unique_lock<std::mutex> lock(mutex);
            ready_cv.wait(lock, [&] { return ready == workers - 1; });
        }
        // Worker pin errors are published by the ready barrier. Abort the whole
        // operation before any query runs if a worker could not be placed.
        for (size_t worker = 1; worker < workers; ++worker) {
            if (errors[worker]) {
                {
                    std::lock_guard<std::mutex> lock(mutex);
                    cancel = true; start_work = true;
                }
                start_cv.notify_all(); join_all(); std::rethrow_exception(errors[worker]);
            }
        }
        ready_time = Clock::now();
        {
            std::lock_guard<std::mutex> lock(mutex);
            start_work = true;
        }
        start_cv.notify_all();
        try { work(0); }
        catch (...) { errors[0] = std::current_exception(); }
        {
            std::unique_lock<std::mutex> lock(mutex);
            done_cv.wait(lock, [&] { return done == workers - 1; });
        }
        complete_time = Clock::now();
        join_all();
        for (const auto &error : errors) if (error) std::rethrow_exception(error);
    }
    // All thread handles, synchronization objects and exception storage are
    // destroyed before ending the end-to-end interval.
    const auto end = Clock::now();
    return {Nanos(start,end), Nanos(start,ready_time), Nanos(ready_time,complete_time), Nanos(complete_time,end)};
}
} // namespace external_parallel
