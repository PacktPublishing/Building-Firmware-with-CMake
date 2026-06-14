add_library(stm32f0_hal_conf INTERFACE)

target_include_directories(stm32f0_hal_conf INTERFACE
    hal-conf
    CMSIS/Device/ST/STM32F0xx/Include
    CMSIS/Include
) 

target_compile_definitions(stm32f0_hal_conf INTERFACE 
    USE_HAL_DRIVER 
    STM32F072xB
)

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

add_library(stm32f072_platform STATIC 
    src/stm32f0xx_hal_msp.c
    src/stm32f0xx_it.c
    src/system_stm32f0xx.c
    src/platform_hal.c
)

target_include_directories(stm32f072_platform PUBLIC 
    inc
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

target_link_libraries(stm32f0_hal 
    PRIVATE stm32f072_arch 
    PUBLIC stm32f0_hal_conf
)

target_link_libraries(stm32f072_platform PRIVATE stm32f072_arch stm32f0_hal)
target_link_libraries(stm32f072_runtime PRIVATE stm32f072_arch)
