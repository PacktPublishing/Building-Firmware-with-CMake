cmake_minimum_required(VERSION 3.25)

project(multi_mcu
    VERSION 1.0.0
    LANGUAGES C CXX ASM
)

add_compile_options(
    $<$<COMPILE_LANGUAGE:C,CXX>:-ffunction-sections>
    $<$<COMPILE_LANGUAGE:C,CXX>:-fdata-sections>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
)

add_subdirectory("platform_${PLATFORM}")

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../CppUTest
    ${CMAKE_CURRENT_BINARY_DIR}/CppUTest
)

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../nanopb
    ${CMAKE_CURRENT_BINARY_DIR}/nanopb
)

get_filename_component(
    PROTO_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/../proto"
    ABSOLUTE
)

set(PROTO_FILES
    ${PROTO_DIR}/device_info.proto
    ${PROTO_DIR}/versions.proto
    ${PROTO_DIR}/calibration_data.proto
)

nanopb_generate_cpp(
    TARGET proto
    RELPATH ${PROTO_DIR}
    ${PROTO_FILES}
)

include(cmake/GenerateWireData.cmake)

generate_wire_data(
    TARGET wire_data
    PROTO_DIR ${PROTO_DIR}
    PROTO_FILES ${PROTO_FILES}
)

add_executable(multi_mcu
    main.cpp
)

set(map_file "${CMAKE_CURRENT_BINARY_DIR}/multi_mcu.map")

target_link_options(multi_mcu PRIVATE
    -Wl,--gc-sections
    "LINKER:-Map,${map_file}"
)

target_link_libraries(multi_mcu PRIVATE
    proto
    wire_data
    CppUTest::CppUTest
    platform
)

enable_testing()

add_test(
    NAME cross_platform_tests
    COMMAND multi_mcu
)

find_package(Git REQUIRED)

execute_process(
    COMMAND "${GIT_EXECUTABLE}" rev-parse HEAD
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    OUTPUT_VARIABLE source_commit
    OUTPUT_STRIP_TRAILING_WHITESPACE
    COMMAND_ERROR_IS_FATAL ANY
)

execute_process(
    COMMAND "${CMAKE_MAKE_PROGRAM}" --version
    OUTPUT_VARIABLE ninja_version
    OUTPUT_STRIP_TRAILING_WHITESPACE
    COMMAND_ERROR_IS_FATAL ANY
)

set(build_info "${CMAKE_CURRENT_BINARY_DIR}/build-info.txt")

file(WRITE "${build_info}"
    "Source commit: ${source_commit}\n"
    "Compiler version: ${CMAKE_C_COMPILER_VERSION}\n"
    "CMake version: ${CMAKE_VERSION}\n"
    "Ninja version: ${ninja_version}\n"
)

install(FILES "${build_info}"
    DESTINATION metadata
)

install(FILES "$<TARGET_FILE:multi_mcu>"
    DESTINATION firmware
    RENAME multi_mcu.elf
)

install(FILES "${map_file}"
    DESTINATION firmware
)

install(FILES ${PROTO_FILES}
    DESTINATION proto
)

if(NOT "$ENV{RELEASE_COMMAND_LOG}" STREQUAL "")
    install(FILES "$ENV{RELEASE_COMMAND_LOG}"
        DESTINATION metadata
    )
endif()

string(SUBSTRING "${source_commit}" 0 8 source_commit_short)

set(CPACK_PACKAGE_FILE_NAME
    "${PROJECT_NAME}-${PROJECT_VERSION}-${source_commit_short}-${PLATFORM}"
)

include(CPack)
