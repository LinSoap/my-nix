#pragma once

#include <chrono>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>

namespace voiceinput {

inline std::string logPath() {
    if (const char *runtimeDir = std::getenv("XDG_RUNTIME_DIR")) {
        return std::string(runtimeDir) + "/voice-input/debug.log";
    }
    return "/tmp/voice-input/debug.log";
}

inline void debugLog(const std::string &message) {
    std::ofstream stream(logPath(), std::ios::app);
    if (!stream.is_open()) {
        return;
    }

    const auto now = std::chrono::system_clock::now();
    const auto nowTime = std::chrono::system_clock::to_time_t(now);
    stream << std::put_time(std::localtime(&nowTime), "%F %T") << " " << message << '\n';
}

} // namespace voiceinput
