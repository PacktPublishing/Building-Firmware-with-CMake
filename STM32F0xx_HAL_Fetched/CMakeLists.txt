if(NOT TARGET stm32f072_arch)
    message(FATAL_ERROR "stm32f0_hal requires target stm32f072_arch")
endif()

if(NOT TARGET stm32f0_hal_conf)
    message(FATAL_ERROR "stm32f0_hal requires target stm32f0_hal_conf")
endif()

include(FetchContent)

FetchContent_Declare(
    stm32f0xx_hal_driver
    GIT_REPOSITORY https://github.com/STMicroelectronics/stm32f0xx-hal-driver.git
    GIT_TAG f62876df9610cd61e688a9fdde5bdbb0a269f623
)

FetchContent_MakeAvailable(stm32f0xx_hal_driver)

add_library(stm32f0_hal STATIC
    ${stm32f0xx_hal_driver_SOURCE_DIR}/Src/stm32f0xx_hal.c
    ${stm32f0xx_hal_driver_SOURCE_DIR}/Src/stm32f0xx_hal_cortex.c
    ${stm32f0xx_hal_driver_SOURCE_DIR}/Src/stm32f0xx_hal_gpio.c
    ${stm32f0xx_hal_driver_SOURCE_DIR}/Src/stm32f0xx_hal_rcc.c
    ${stm32f0xx_hal_driver_SOURCE_DIR}/Src/stm32f0xx_hal_dma.c
    ${stm32f0xx_hal_driver_SOURCE_DIR}/Src/stm32f0xx_hal_uart.c
    ${stm32f0xx_hal_driver_SOURCE_DIR}/Src/stm32f0xx_hal_uart_ex.c
)

target_include_directories(stm32f0_hal PUBLIC
    ${stm32f0xx_hal_driver_SOURCE_DIR}/Inc
)

target_link_libraries(stm32f0_hal
    PRIVATE
        stm32f072_arch
    PUBLIC
        stm32f0_hal_conf
)