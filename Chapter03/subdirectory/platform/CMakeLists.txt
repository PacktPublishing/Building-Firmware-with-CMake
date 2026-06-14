add_library(stm32f072_platform STATIC 
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_cortex.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_gpio.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_rcc.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_dma.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart.c
    STM32F0xx_HAL_Driver/Src/stm32f0xx_hal_uart_ex.c
    src/stm32f0xx_hal_msp.c
    src/stm32f0xx_it.c
    src/system_stm32f0xx.c
    src/platform_hal.c
)

target_include_directories(stm32f072_platform PUBLIC 
  inc
  CMSIS/Device/ST/STM32F0xx/Include
  CMSIS/Include
  STM32F0xx_HAL_Driver/Inc
)

target_compile_definitions(stm32f072_platform PUBLIC 
    USE_HAL_DRIVER 
    STM32F072xB
)

add_library(stm32f072_runtime OBJECT 
    startup_stm32f072xb.s 
    src/syscall_stubs.c 
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