cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

project(hello_world C ASM)

set(PLATFORM_DIR ${CMAKE_CURRENT_SOURCE_DIR}/platform)

add_subdirectory(${PLATFORM_DIR})

add_executable(hello_world
    main.c
)

target_link_options(hello_world PRIVATE
    -T${PLATFORM_DIR}/STM32F072C8Tx_FLASH.ld
)

target_link_libraries(hello_world PRIVATE 
    stm32f072_platform 
    stm32f072_runtime
    stm32f072_arch
)

file(GENERATE
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/run_hello_world.resc
    CONTENT
        "mach create
         machine LoadPlatformDescription @platforms/boards/stm32f072b_discovery.repl
         showAnalyzer sysbus.usart2
         sysbus LoadELF @$<TARGET_FILE:hello_world>
         start"
)

add_custom_target(run_in_renode
    COMMAND renode --console --disable-xwt -e "include @${CMAKE_CURRENT_BINARY_DIR}/run_hello_world.resc"
    DEPENDS hello_world
    USES_TERMINAL
    VERBATIM
)