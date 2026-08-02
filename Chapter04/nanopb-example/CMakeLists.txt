cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

project(nanopb_example C ASM)

set(PLATFORM_DIR ${CMAKE_CURRENT_SOURCE_DIR}/platform)

add_subdirectory(${PLATFORM_DIR})

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../nanopb
    ${CMAKE_CURRENT_BINARY_DIR}/nanopb
)

nanopb_generate_cpp(TARGET proto simple.proto)

# nanopb exposes stm32f072_arch transitively to generated protocol targets.
target_link_libraries(nanopb PUBLIC
    stm32f072_arch
)

add_executable(nanopb_example
    main.c
)

target_link_options(nanopb_example PRIVATE
    -T${PLATFORM_DIR}/STM32F072C8Tx_FLASH.ld
)

target_link_libraries(nanopb_example PRIVATE 
    stm32f072_platform 
    stm32f072_runtime
    stm32f072_arch
    proto
)

file(GENERATE
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/run_hello_world.resc
    CONTENT
        "mach create
         machine LoadPlatformDescription @platforms/boards/stm32f072b_discovery.repl
         showAnalyzer sysbus.usart2
         sysbus LoadELF @$<TARGET_FILE:nanopb_example>
         start"
)

add_custom_target(run_in_renode
    COMMAND renode --console --disable-xwt -e "include @${CMAKE_CURRENT_BINARY_DIR}/run_hello_world.resc"
    DEPENDS nanopb_example
    USES_TERMINAL
    VERBATIM
)