if(NOT TARGET stm32f4_hal_conf)
    message(FATAL_ERROR "stm32f4_hal requires target stm32f4_hal_conf")
endif()

include(FetchContent)

FetchContent_Declare(
    stm32f4xx_hal_driver
    GIT_REPOSITORY https://github.com/STMicroelectronics/stm32f4xx-hal-driver.git
    GIT_TAG c2e1406d7ea4b73aa42b98ddeb75a8670b1a5a16
)

FetchContent_MakeAvailable(stm32f4xx_hal_driver)

add_library(stm32f4_hal STATIC
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_cortex.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_gpio.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_rcc.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_rcc_ex.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_dma.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_uart.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_flash.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_flash_ex.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_pwr.c
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Src/stm32f4xx_hal_pwr_ex.c
)

target_include_directories(stm32f4_hal PUBLIC
    ${stm32f4xx_hal_driver_SOURCE_DIR}/Inc
)

target_link_libraries(stm32f4_hal PUBLIC stm32f4_hal_conf)