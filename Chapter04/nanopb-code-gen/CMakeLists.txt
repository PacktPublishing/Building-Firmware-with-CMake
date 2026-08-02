cmake_minimum_required(VERSION 3.20)

project(nanopb_code_gen)

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../nanopb
    ${CMAKE_CURRENT_BINARY_DIR}/nanopb
)

nanopb_generate_cpp(TARGET proto simple.proto)