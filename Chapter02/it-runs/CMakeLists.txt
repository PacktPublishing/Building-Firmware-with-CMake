cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

project(hello_world C ASM)

add_executable(hello_world
    main.c
    platform/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal.c
    platform/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_cortex.c
    platform/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_gpio.c
    platform/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_rcc.c
    platform/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_dma.c
    platform/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart.c
    platform/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart_ex.c
    platform/startup_stm32f072xb.s
    platform/src/stm32f0xx_hal_msp.c
    platform/src/stm32f0xx_it.c
    platform/src/system_stm32f0xx.c
    platform/src/platform_hal.c
)

# global include directories
target_include_directories(hello_world PRIVATE 
  ${CMAKE_SOURCE_DIR}/platform/inc
  ${CMAKE_SOURCE_DIR}/platform/CMSIS/Device/ST/STM32F0xx/Include
  ${CMAKE_SOURCE_DIR}/platform/CMSIS/Include
  ${CMAKE_SOURCE_DIR}/platform/STM32F0xx_HAL_Driver/Inc
  )

target_compile_options(hello_world PRIVATE 
    -mcpu=cortex-m0 
    -mthumb
) 
target_compile_definitions(hello_world PRIVATE 
    USE_HAL_DRIVER 
    STM32F072xB
)

target_link_options(hello_world PRIVATE
    --specs=nosys.specs
    -mcpu=cortex-m0 
    -mthumb
    -T${CMAKE_SOURCE_DIR}/platform/STM32F072C8Tx_FLASH.ld
)

# file(GENERATE
#     OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/run_hello_world.resc
#     CONTENT
#         "mach create
#          machine LoadPlatformDescription @platforms/boards/stm32f072b_discovery.repl
#          showAnalyzer sysbus.usart1
#          sysbus LoadELF @$<TARGET_FILE:hello_world>
#          start"
# )

# add_custom_target(
#   run_in_renode
#   COMMAND ${RENODE} --console --disable-xwt ${CMAKE_SOURCE_DIR}/renode_scripts/stm32f072.resc -e start 
#   DEPENDS ${PROJECT_NAME}.elf)

add_custom_target(run_in_renode
    COMMAND renode --console --disable-xwt -e "include @${CMAKE_CURRENT_SOURCE_DIR}/run_hello_world.resc"
    DEPENDS hello_world
    USES_TERMINAL
    VERBATIM
)