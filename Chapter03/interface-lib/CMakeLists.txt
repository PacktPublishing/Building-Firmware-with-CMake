cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

project(hello_world C ASM)

set(PLATFORM_DIR ${CMAKE_CURRENT_SOURCE_DIR}/platform)

add_library(stm32f072_platform STATIC 
    ${PLATFORM_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal.c
    ${PLATFORM_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_cortex.c
    ${PLATFORM_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_gpio.c
    ${PLATFORM_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_rcc.c
    ${PLATFORM_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_dma.c
    ${PLATFORM_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart.c
    ${PLATFORM_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart_ex.c
    ${PLATFORM_DIR}/src/stm32f0xx_hal_msp.c
    ${PLATFORM_DIR}/src/stm32f0xx_it.c
    ${PLATFORM_DIR}/src/system_stm32f0xx.c
    ${PLATFORM_DIR}/src/platform_hal.c
)

target_include_directories(stm32f072_platform PUBLIC 
  ${PLATFORM_DIR}/inc
  ${PLATFORM_DIR}/CMSIS/Device/ST/STM32F0xx/Include
  ${PLATFORM_DIR}/CMSIS/Include
  ${PLATFORM_DIR}/STM32F0xx_HAL_Driver/Inc
)

target_compile_definitions(stm32f072_platform PUBLIC 
    USE_HAL_DRIVER 
    STM32F072xB
)

add_library(stm32f072_runtime OBJECT 
    ${PLATFORM_DIR}/startup_stm32f072xb.s 
    ${PLATFORM_DIR}/src/syscall_stubs.c 
)

add_library(stm32f072_arch INTERFACE)

target_compile_options(stm32f072_arch INTERFACE
    -mcpu=cortex-m0
    -mthumb
)

target_link_options(stm32f072_arch INTERFACE
    -mcpu=cortex-m0
    -mthumb
)

target_link_libraries(stm32f072_platform PRIVATE stm32f072_arch)
target_link_libraries(stm32f072_runtime PRIVATE stm32f072_arch)

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