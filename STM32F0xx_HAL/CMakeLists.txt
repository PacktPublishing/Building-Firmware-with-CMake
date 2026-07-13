if(NOT TARGET stm32f072_arch)
    message(FATAL_ERROR "stm32f0_hal requires target stm32f072_arch")
endif()

if(NOT TARGET stm32f0_hal_conf)
    message(FATAL_ERROR "stm32f0_hal requires target stm32f0_hal_conf")
endif()

add_library(stm32f0_hal STATIC 
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_cortex.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_gpio.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_rcc.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_dma.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart_ex.c
)

target_include_directories(stm32f0_hal PUBLIC 
  STM32F0xx_HAL_Driver/Inc
)

target_link_libraries(stm32f0_hal 
    PRIVATE stm32f072_arch 
    PUBLIC stm32f0_hal_conf
)