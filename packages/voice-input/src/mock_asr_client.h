#pragma once

#include <optional>
#include <string>

struct RecognitionResponse {
    bool ok = false;
    std::string status;
    std::optional<std::string> text;
    std::optional<std::string> error;
};

class MockAsrClient {
  public:
    explicit MockAsrClient(std::string socketPath);

    RecognitionResponse recognize(const std::string &contextProgram,
                                  bool optimizeText) const;

  private:
    std::string socketPath_;
};
