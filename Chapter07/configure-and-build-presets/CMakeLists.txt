cmake_minimum_required(VERSION 3.20)

project(configure_and_build_presets C CXX ASM)

add_compile_options(
    $<$<COMPILE_LANGUAGE:C,CXX>:-ffunction-sections>
    $<$<COMPILE_LANGUAGE:C,CXX>:-fdata-sections>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
)

if(CMAKE_CROSSCOMPILING)
    set(PLATFORM_DIR ${CMAKE_CURRENT_SOURCE_DIR}/platform)
    add_subdirectory(${PLATFORM_DIR})
endif()

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

add_executable(configure_and_build_presets
    main.cpp
)

target_link_options(configure_and_build_presets PRIVATE
    -Wl,--gc-sections
)

target_link_libraries(configure_and_build_presets PRIVATE
    proto
    wire_data
    CppUTest::CppUTest
)

if(CMAKE_CROSSCOMPILING)
    target_link_options(configure_and_build_presets PRIVATE
        -T${PLATFORM_DIR}/STM32F072RBTx_FLASH.ld
        --specs=rdimon.specs
        --specs=nano.specs
    )

    target_link_libraries(configure_and_build_presets PRIVATE
        stm32f072_platform
        stm32f072_runtime
    )
endif()