add_library(stm32f4_hal_conf INTERFACE)

target_include_directories(stm32f4_hal_conf INTERFACE
    hal-conf
    CMSIS/Device/ST/STM32F4xx/Include
    CMSIS/Include
) 

target_compile_definitions(stm32f4_hal_conf INTERFACE 
    USE_HAL_DRIVER 
    STM32F407xx
)

add_library(stm32f407_platform STATIC 
    src/stm32f4xx_hal_msp.c
    src/stm32f4xx_it.c
    src/system_stm32f4xx.c
    src/platform_hal.c
)

target_include_directories(stm32f407_platform PUBLIC 
    inc
)

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../../STM32F4xx_HAL_Fetched_Toolchain
    ${CMAKE_CURRENT_BINARY_DIR}/STM32F4xx_HAL_Fetched_Toolchain
)

target_link_libraries(stm32f407_platform PRIVATE stm32f4_hal)

add_library(platform INTERFACE)

target_sources(platform INTERFACE
    startup_stm32f407xx.s 
    src/syscall_stubs.c 
)

target_link_options(platform INTERFACE
    -T${CMAKE_CURRENT_SOURCE_DIR}/STM32F407XX_FLASH.ld
    --specs=rdimon.specs
    --specs=nano.specs
)

target_link_libraries(platform INTERFACE
    stm32f407_platform
    stm32f4_hal
)