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

add_subdirectory(
    ${CMAKE_CURRENT_LIST_DIR}/../../../STM32F0xx_HAL_Fetched_Toolchain
    ${CMAKE_CURRENT_BINARY_DIR}/STM32F0xx_HAL_Fetched_Toolchain
)

target_link_libraries(stm32f072_platform PRIVATE stm32f0_hal)

add_library(platform INTERFACE)

target_sources(platform INTERFACE
    startup_stm32f072xb.s 
    src/syscall_stubs.c 
)

target_link_options(platform INTERFACE
    -T${CMAKE_CURRENT_SOURCE_DIR}/STM32F072RBTx_FLASH.ld
    --specs=rdimon.specs
    --specs=nano.specs
)

target_link_libraries(platform INTERFACE
    stm32f072_platform
    stm32f0_hal
)

function(platform_add_renode_target)
    cmake_parse_arguments(PARSE_ARGV 0 RENODE "" "TARGET;FIRMWARE_TARGET" "")

    if("${RENODE_TARGET}" STREQUAL "" OR "${RENODE_FIRMWARE_TARGET}" STREQUAL "")
        message(FATAL_ERROR
            "platform_add_renode_target requires TARGET and FIRMWARE_TARGET"
        )
    endif()

    set(script "${CMAKE_CURRENT_BINARY_DIR}/${RENODE_TARGET}.resc")

    file(GENERATE
        OUTPUT "${script}"
        CONTENT
            "mach create
machine LoadPlatformDescription @platforms/boards/stm32f072b_discovery.repl
showAnalyzer sysbus.usart2
sysbus LoadELF @$<TARGET_FILE:${RENODE_FIRMWARE_TARGET}>
start
"
    )

    add_custom_target("${RENODE_TARGET}"
        COMMAND renode --console --disable-xwt -e "include @${script}"
        USES_TERMINAL
        VERBATIM
    )
    add_dependencies("${RENODE_TARGET}" "${RENODE_FIRMWARE_TARGET}")
endfunction()