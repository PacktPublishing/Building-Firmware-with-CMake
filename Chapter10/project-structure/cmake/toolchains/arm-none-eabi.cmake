set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

if(NOT "$ENV{ARM_GCC_ROOT}" STREQUAL "")
    set(prefix "$ENV{ARM_GCC_ROOT}/bin/arm-none-eabi-")
    if(NOT EXISTS "${prefix}gcc")
        message(FATAL_ERROR
            "Compiler not found at ${prefix}gcc. Run setup-arm-gcc.cmake and set ARM_GCC_ROOT to its installation directory.")
    endif()
else()
    set(prefix "arm-none-eabi-")
endif()

set(CMAKE_C_COMPILER "${prefix}gcc")
set(CMAKE_CXX_COMPILER "${prefix}g++")
set(CMAKE_ASM_COMPILER "${prefix}gcc")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(ARM_CPU "cortex-m0" CACHE STRING "Target Arm CPU")
list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES ARM_CPU)

set(ARM_ARCH_FLAGS "-mcpu=${ARM_CPU} -mthumb")
set(CMAKE_C_FLAGS_INIT "${ARM_ARCH_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${ARM_ARCH_FLAGS}")
set(CMAKE_ASM_FLAGS_INIT "${ARM_ARCH_FLAGS}")
