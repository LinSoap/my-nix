#include "mock_asr_client.h"
#include "debug_log.h"

#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#include <cstring>
#include <cctype>
#include <optional>
#include <sstream>
#include <string>

namespace {
std::string escapeJson(const std::string &value) {
    std::string escaped;
    escaped.reserve(value.size());
    for (char ch : value) {
        switch (ch) {
        case '\\':
            escaped += "\\\\";
            break;
        case '"':
            escaped += "\\\"";
            break;
        case '\n':
            escaped += "\\n";
            break;
        default:
            escaped += ch;
            break;
        }
    }
    return escaped;
}

std::optional<std::string> extractJsonString(const std::string &payload,
                                             const std::string &key) {
    const std::string needle = "\"" + key + "\"";
    const auto keyPos = payload.find(needle);
    if (keyPos == std::string::npos) {
        return std::nullopt;
    }

    auto valuePos = payload.find(':', keyPos + needle.size());
    if (valuePos == std::string::npos) {
        return std::nullopt;
    }

    valuePos += 1;
    while (valuePos < payload.size() &&
           std::isspace(static_cast<unsigned char>(payload[valuePos]))) {
        valuePos++;
    }

    if (valuePos >= payload.size() || payload[valuePos] != '"') {
        return std::nullopt;
    }

    std::string result;
    bool escaping = false;
    for (size_t i = valuePos + 1; i < payload.size(); ++i) {
        const char ch = payload[i];
        if (escaping) {
            switch (ch) {
            case 'n':
                result += '\n';
                break;
            default:
                result += ch;
                break;
            }
            escaping = false;
            continue;
        }
        if (ch == '\\') {
            escaping = true;
            continue;
        }
        if (ch == '"') {
            return result;
        }
        result += ch;
    }

    return std::nullopt;
}

bool extractJsonBool(const std::string &payload, const std::string &key,
                     bool defaultValue) {
    const std::string needle = "\"" + key + "\"";
    const auto keyPos = payload.find(needle);
    if (keyPos == std::string::npos) {
        return defaultValue;
    }

    auto valuePos = payload.find(':', keyPos + needle.size());
    if (valuePos == std::string::npos) {
        return defaultValue;
    }
    valuePos += 1;
    while (valuePos < payload.size() &&
           std::isspace(static_cast<unsigned char>(payload[valuePos]))) {
        valuePos++;
    }

    if (payload.compare(valuePos, 4, "true") == 0) {
        return true;
    }
    if (payload.compare(valuePos, 5, "false") == 0) {
        return false;
    }
    return defaultValue;
}
}

MockAsrClient::MockAsrClient(std::string socketPath)
    : socketPath_(std::move(socketPath)) {}

RecognitionResponse MockAsrClient::recognize(const std::string &contextProgram,
                                             bool optimizeText) const {
    RecognitionResponse result;
    voiceinput::debugLog("mock_asr_client: recognize start program=" + contextProgram);
    const int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) {
        voiceinput::debugLog("mock_asr_client: socket() failed");
        result.error = "socket_failed";
        return result;
    }

    sockaddr_un addr {};
    addr.sun_family = AF_UNIX;
    if (socketPath_.size() >= sizeof(addr.sun_path)) {
        close(fd);
        voiceinput::debugLog("mock_asr_client: socket path too long");
        result.error = "socket_path_too_long";
        return result;
    }
    std::strncpy(addr.sun_path, socketPath_.c_str(), sizeof(addr.sun_path) - 1);

    if (connect(fd, reinterpret_cast<sockaddr *>(&addr), sizeof(addr)) < 0) {
        close(fd);
        voiceinput::debugLog("mock_asr_client: connect() failed path=" + socketPath_);
        result.error = "connect_failed";
        return result;
    }

    std::ostringstream request;
    request << "{\"action\":\"recognize\",\"optimize\":"
            << (optimizeText ? "true" : "false")
            << ",\"context\":{\"program\":\""
            << escapeJson(contextProgram)
            << "\"}}\n";

    const std::string requestText = request.str();
    if (write(fd, requestText.data(), requestText.size()) < 0) {
        close(fd);
        voiceinput::debugLog("mock_asr_client: write() failed");
        result.error = "write_failed";
        return result;
    }

    std::string response;
    char buffer[1024];
    while (true) {
        const auto readBytes = read(fd, buffer, sizeof(buffer));
        if (readBytes < 0) {
            close(fd);
            voiceinput::debugLog("mock_asr_client: read() failed");
            result.error = "read_failed";
            return result;
        }
        if (readBytes == 0) {
            break;
        }
        response.append(buffer, readBytes);
        if (response.find('\n') != std::string::npos) {
            break;
        }
    }

    close(fd);
    result.ok = extractJsonBool(response, "ok", false);
    result.status = extractJsonString(response, "status").value_or("");
    result.text = extractJsonString(response, "text");
    result.error = extractJsonString(response, "error");

    if (result.text) {
        voiceinput::debugLog("mock_asr_client: got response text=" + *result.text);
    } else {
        voiceinput::debugLog("mock_asr_client: response without text payload=" + response);
    }
    return result;
}
