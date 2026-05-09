cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

project(hello_world C)

add_executable(hello_world
    main.c
)

target_link_options(hello_world PRIVATE
    --specs=nosys.specs
)