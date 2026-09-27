cmake_minimum_required(VERSION 3.20)

project(unified_host_and_arm C CXX ASM)

if(CMAKE_CROSSCOMPILING)
    set(PLATFORM_DIR ${CMAKE_CURRENT_SOURCE_DIR}/platform)
    add_subdirectory(${PLATFORM_DIR})
endif()

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../CppUTest
    ${CMAKE_CURRENT_BINARY_DIR}/CppUTest
)

if(CMAKE_CROSSCOMPILING)
    target_link_libraries(CppUTest PRIVATE
        stm32f072_arch
    )
endif()

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

if(CMAKE_CROSSCOMPILING)
    # nanopb exposes stm32f072_arch transitively to generated protocol targets.
    target_link_libraries(nanopb PUBLIC
        stm32f072_arch
    )
endif()

include(cmake/GenerateWireData.cmake)

generate_wire_data(
    TARGET wire_data
    PROTO_DIR ${PROTO_DIR}
    PROTO_FILES ${PROTO_FILES}
)

add_executable(unified_host_and_arm
    main.cpp
)

target_link_options(unified_host_and_arm PRIVATE
    -Wl,--gc-sections
)

target_link_libraries(unified_host_and_arm PRIVATE
    proto
    wire_data
    CppUTest::CppUTest
)

if(CMAKE_CROSSCOMPILING)
    target_link_options(unified_host_and_arm PRIVATE
        -T${PLATFORM_DIR}/STM32F072RBTx_FLASH.ld
        --specs=rdimon.specs
        --specs=nano.specs
    )

    target_link_libraries(unified_host_and_arm PRIVATE
        stm32f072_platform
        stm32f072_runtime
        stm32f072_arch
    )
endif()