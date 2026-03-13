cmake_minimum_required(VERSION 3.20)
project(voice_input VERSION 0.1.0 LANGUAGES CXX)

include(GNUInstallDirs)

find_package(PkgConfig REQUIRED)
pkg_check_modules(FCITX5_CORE REQUIRED IMPORTED_TARGET Fcitx5Core)
pkg_check_modules(FCITX5_MODULE REQUIRED IMPORTED_TARGET Fcitx5Module)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(voiceinput MODULE
    src/mock_asr_client.cpp
    src/voice_input_engine.cpp
)

target_include_directories(voiceinput PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
target_link_libraries(voiceinput PRIVATE PkgConfig::FCITX5_CORE PkgConfig::FCITX5_MODULE)
target_compile_definitions(voiceinput PRIVATE FCITX_GETTEXT_DOMAIN="voiceinput")

install(TARGETS voiceinput
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/fcitx5
)

install(FILES
    data/voiceinput-addon.conf
    DESTINATION ${CMAKE_INSTALL_DATADIR}/fcitx5/addon
    RENAME voiceinput.conf
)

install(PROGRAMS python/mock_asr_service.py DESTINATION ${CMAKE_INSTALL_BINDIR})
install(PROGRAMS python/status_overlay.py DESTINATION ${CMAKE_INSTALL_BINDIR})
install(PROGRAMS scripts/run_mock_service.sh DESTINATION ${CMAKE_INSTALL_BINDIR})
install(PROGRAMS scripts/run_status_overlay.sh DESTINATION ${CMAKE_INSTALL_BINDIR})
