set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

if(DEFINED ENV{ARM_GCC_ROOT})
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

set(ARM_ARCH_FLAGS "-mcpu=cortex-m0 -mthumb")
set(CMAKE_C_FLAGS_INIT "${ARM_ARCH_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${ARM_ARCH_FLAGS}")
set(CMAKE_ASM_FLAGS_INIT "${ARM_ARCH_FLAGS}")
