#pragma once
#include <cerrno>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <pthread.h>
#include <sched.h>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

namespace external_parallel {
inline int ReadNumber(const std::filesystem::path &path) {
    std::ifstream file(path); int value = -1;
    if (!(file >> value)) throw std::runtime_error("cannot read topology: " + path.string());
    return value;
}
inline std::vector<int> ParseCpus(const std::string &text, size_t workers) {
    std::vector<int> result; std::set<std::pair<int,int>> cores; std::set<int> cpus;
    cpu_set_t allowed; CPU_ZERO(&allowed);
    if (sched_getaffinity(0,sizeof(allowed),&allowed)) throw std::runtime_error("get affinity failed");
    int socket = -1, node = -1;
    size_t begin = 0;
    for (;;) {
        const size_t end = text.find(',',begin);
        const std::string value = text.substr(begin,end == std::string::npos ? end : end-begin);
        if (value.empty() || value.find_first_not_of("0123456789") != std::string::npos)
            throw std::invalid_argument("invalid CPU list");
        const auto number = std::stoull(value);
        if (number >= CPU_SETSIZE || !CPU_ISSET(number,&allowed) || !cpus.insert(number).second)
            throw std::invalid_argument("duplicate or unavailable CPU");
        const int cpu = number;
        const auto root = std::filesystem::path("/sys/devices/system/cpu") / ("cpu" + value);
        const int cpu_socket = ReadNumber(root/"topology/physical_package_id");
        const int core = ReadNumber(root/"topology/core_id");
        int cpu_node = -1;
        for (const auto &entry : std::filesystem::directory_iterator(root)) {
            const auto name = entry.path().filename().string();
            if (name.rfind("node",0)==0 && name.size()>4 && name.find_first_not_of("0123456789",4)==std::string::npos)
                cpu_node = std::stoi(name.substr(4));
        }
        if (cpu_node < 0) throw std::runtime_error("NUMA node not found");
        if (socket < 0) { socket = cpu_socket; node = cpu_node; }
        if (socket != cpu_socket || node != cpu_node || !cores.insert({cpu_socket,core}).second)
            throw std::invalid_argument("CPUs must be distinct physical cores on one NUMA node/socket");
        result.push_back(cpu);
        if (end == std::string::npos) break;
        begin=end+1;
    }
    if (result.size()!=workers) throw std::invalid_argument("CPU count must equal worker count");
    return result;
}
inline void PinCpu(int cpu) {
    cpu_set_t set; CPU_ZERO(&set); CPU_SET(cpu,&set);
    const int result = pthread_setaffinity_np(pthread_self(),sizeof(set),&set);
    if (result) throw std::runtime_error(std::string("set affinity failed: ")+std::strerror(result));
}
struct Config { std::vector<int> cpus; };
} // namespace external_parallel
