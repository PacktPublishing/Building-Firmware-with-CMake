cmake_minimum_required(VERSION 3.25)

project(declarative_platform C CXX ASM)

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

add_executable(declarative_platform
    main.cpp
)

target_link_options(declarative_platform PRIVATE
    -Wl,--gc-sections
)

target_link_libraries(declarative_platform PRIVATE
    proto
    wire_data
    CppUTest::CppUTest
    platform
)

enable_testing()

add_test(
    NAME cross_platform_tests
    COMMAND declarative_platform
)
