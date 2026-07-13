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

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../../STM32F0xx_HAL
    ${CMAKE_CURRENT_BINARY_DIR}/STM32F0xx_HAL
)

target_link_libraries(stm32f072_platform PRIVATE stm32f072_arch stm32f0_hal)
target_link_libraries(stm32f072_runtime PRIVATE stm32f072_arch)
