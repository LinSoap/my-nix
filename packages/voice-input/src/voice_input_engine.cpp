#include "debug_log.h"
#include "mock_asr_client.h"

#include <fstream>
#include <memory>
#include <string>

#include <fcitx/addonfactory.h>
#include <fcitx/addonmanager.h>
#include <fcitx/inputcontext.h>
#include <fcitx/inputmethodengine.h>
#include <fcitx/inputpanel.h>
#include <fcitx/instance.h>
#include <fcitx-utils/dbus/objectvtable.h>
#include <fcitx-utils/i18n.h>
#include <fcitx-utils/key.h>
#include <fcitx-module/dbus/dbus_public.h>

namespace {
std::string defaultSocketPath() {
    if (const char *configuredPath = std::getenv("VOICE_INPUT_SOCKET")) {
        return configuredPath;
    }
    if (const char *runtimeDir = std::getenv("XDG_RUNTIME_DIR")) {
        return std::string(runtimeDir) + "/voice-input/mock-asr.sock";
    }
    return "/tmp/voice-input/mock-asr.sock";
}

}

class VoiceInputEngine final : public fcitx::InputMethodEngineV2,
                               public fcitx::dbus::ObjectVTable<VoiceInputEngine> {
  public:
    explicit VoiceInputEngine(fcitx::Instance *instance)
        : instance_(instance),
          client_(std::make_unique<MockAsrClient>(defaultSocketPath())) {
        voiceinput::debugLog("engine: constructor start");
        if (auto *dbusAddon = instance_->addonManager().addon("dbus", true)) {
            if (auto *bus = dbusAddon->call<fcitx::IDBusModule::bus>()) {
                const bool ok = bus->addObjectVTable("/voiceinput", "org.fcitx.Fcitx.VoiceInput1", *this);
                voiceinput::debugLog(std::string("engine: register /voiceinput result=") + (ok ? "ok" : "fail"));
            } else {
                voiceinput::debugLog("engine: dbus bus() returned null");
            }
        } else {
            voiceinput::debugLog("engine: addonManager().addon(\"dbus\") returned null");
        }
    }

    void activate(const fcitx::InputMethodEntry &entry,
                  fcitx::InputContextEvent &event) override {
        auto *inputContext = event.inputContext();
        voiceinput::debugLog("engine: activate program=" + inputContext->program());
    }

    void deactivate(const fcitx::InputMethodEntry &entry,
                    fcitx::InputContextEvent &event) override {
        voiceinput::debugLog("engine: deactivate");
        event.inputContext()->inputPanel().reset();
        event.inputContext()->updateUserInterface(fcitx::UserInterfaceComponent::InputPanel);
    }

    void reset(const fcitx::InputMethodEntry &entry,
               fcitx::InputContextEvent &event) override {
        voiceinput::debugLog("engine: reset");
        event.inputContext()->inputPanel().reset();
        event.inputContext()->updateUserInterface(fcitx::UserInterfaceComponent::InputPanel);
    }

    void keyEvent(const fcitx::InputMethodEntry &entry,
                  fcitx::KeyEvent &keyEvent) override {
        voiceinput::debugLog("engine: keyEvent received");
    }

    bool trigger() {
        auto *inputContext = instance_->lastFocusedInputContext();
        if (!inputContext) {
            inputContext = instance_->mostRecentInputContext();
        }
        if (!inputContext) {
            voiceinput::debugLog("engine: trigger failed, no input context");
            return false;
        }

        voiceinput::debugLog("engine: trigger program=" + inputContext->program());
        const auto response = client_->recognize(inputContext->program(), true);
        if (!response.ok) {
            voiceinput::debugLog("engine: trigger failed status=" + response.status);
            return false;
        }
        if (response.status == "recording_started") {
            voiceinput::debugLog("engine: trigger started recording");
            return true;
        }
        if (response.status != "recognized" || !response.text || response.text->empty()) {
            voiceinput::debugLog("engine: trigger no commit status=" + response.status);
            return false;
        }

        voiceinput::debugLog("engine: trigger commit text=" + *response.text);
        inputContext->commitString(*response.text);
        return true;
    }

  private:
    FCITX_OBJECT_VTABLE_METHOD(trigger, "Trigger", "", "b");

    fcitx::Instance *instance_;
    std::unique_ptr<MockAsrClient> client_;
};

class VoiceInputFactory final : public fcitx::AddonFactory {
  public:
    fcitx::AddonInstance *create(fcitx::AddonManager *manager) override {
        return new VoiceInputEngine(manager->instance());
    }
};

FCITX_ADDON_FACTORY(VoiceInputFactory)
