cmake_minimum_required(VERSION 3.20)

project(cpp_u_test_nanopb C CXX ASM)

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

add_executable(cpp_u_test_nanopb
    main.cpp
)

target_compile_options(nanopb PRIVATE
    --coverage
)

target_compile_options(cpp_u_test_nanopb PRIVATE
    --coverage
)

target_link_options(cpp_u_test_nanopb PRIVATE
    --coverage
)

target_link_libraries(cpp_u_test_nanopb PRIVATE 
    proto
    wire_data
    CppUTest::CppUTest
)

add_custom_command(
    TARGET cpp_u_test_nanopb 
    POST_BUILD
    COMMAND size $<TARGET_FILE:cpp_u_test_nanopb>
    COMMENT "Program size:"
    VERBATIM
)

find_program(GCOVR gcovr REQUIRED)

add_custom_target(coverage_report
    COMMAND ${GCOVR}
        --root ${CMAKE_CURRENT_SOURCE_DIR}
        --object-directory ${CMAKE_CURRENT_BINARY_DIR}
        --html-details ${CMAKE_CURRENT_BINARY_DIR}/coverage.html
    COMMENT "Generating coverage report"
    VERBATIM
)

enable_testing()

set(TEST_RESULTS_DIR
    ${CMAKE_CURRENT_BINARY_DIR}/test-results
)

file(MAKE_DIRECTORY
    ${TEST_RESULTS_DIR}
)

add_test(
    NAME nanopb_test
    COMMAND $<TARGET_FILE:cpp_u_test_nanopb>
)