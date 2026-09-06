cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

project(cpp_u_test_nanopb C CXX ASM)

set(PLATFORM_DIR ${CMAKE_CURRENT_SOURCE_DIR}/platform)

add_subdirectory(${PLATFORM_DIR})

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../CppUTest
    ${CMAKE_CURRENT_BINARY_DIR}/CppUTest
)

target_link_libraries(CppUTest PRIVATE
    stm32f072_arch
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

# nanopb exposes stm32f072_arch transitively to generated protocol targets.
target_link_libraries(nanopb PUBLIC
    stm32f072_arch
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

target_link_options(cpp_u_test_nanopb PRIVATE
    -T${PLATFORM_DIR}/STM32F072RBTx_FLASH.ld
    -Wl,--gc-sections
    --specs=nosys.specs
    --specs=nano.specs
)

target_link_libraries(cpp_u_test_nanopb PRIVATE 
    stm32f072_platform 
    stm32f072_runtime
    stm32f072_arch
    proto
    wire_data
    CppUTest::CppUTest
)

add_custom_command(
    TARGET cpp_u_test_nanopb 
    POST_BUILD
    COMMAND arm-none-eabi-size $<TARGET_FILE:cpp_u_test_nanopb>
    COMMENT "Firmware size:"
    VERBATIM
)

file(GENERATE
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/run_hello_world.resc
    CONTENT
        "mach create
         machine LoadPlatformDescription @platforms/boards/stm32f072b_discovery.repl
         showAnalyzer sysbus.usart2
         sysbus LoadELF @$<TARGET_FILE:cpp_u_test_nanopb>
         start"
)

add_custom_target(run_in_renode
    COMMAND renode --console --disable-xwt -e "include @${CMAKE_CURRENT_BINARY_DIR}/run_hello_world.resc"
    DEPENDS cpp_u_test_nanopb
    USES_TERMINAL
    VERBATIM
)