add_library(platform_stm32f072 STATIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal.c
    ${CMAKE_CURRENT_SOURCE_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_cortex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_gpio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_rcc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_dma.c
    ${CMAKE_CURRENT_SOURCE_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart.c
    ${CMAKE_CURRENT_SOURCE_DIR}/STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart_ex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/startup_stm32f072xb.s
    ${CMAKE_CURRENT_SOURCE_DIR}/src/stm32f0xx_hal_msp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/stm32f0xx_it.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/system_stm32f0xx.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/platform_hal.c
)

target_include_directories(platform_stm32f072 PUBLIC 
  ${CMAKE_CURRENT_SOURCE_DIR}/inc
  ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Device/ST/STM32F0xx/Include
  ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Include
  ${CMAKE_CURRENT_SOURCE_DIR}/STM32F0xx_HAL_Driver/Inc
)

target_compile_definitions(platform_stm32f072 PUBLIC 
    USE_HAL_DRIVER 
    STM32F072xB
)

target_compile_options(platform_stm32f072 PUBLIC 
    -mcpu=cortex-m0 
    -mthumb
) 