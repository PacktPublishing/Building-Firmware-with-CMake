cmake_minimum_required(VERSION 3.20)

project(hello_world C)

add_executable(hello_world
    main.c
    src/print_hello.c
)

target_include_directories(hello_world
    PRIVATE
        inc
)