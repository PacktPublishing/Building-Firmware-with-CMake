cmake_minimum_required(VERSION 3.25)

if(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    message(FATAL_ERROR "Run this script inside the Linux development container")
endif()

set(version "14.2.rel1")
cmake_host_system_information(RESULT host QUERY OS_PLATFORM)

if(host STREQUAL "x86_64")
    set(sha256 "62a63b981fe391a9cbad7ef51b17e49aeaa3e7b0d029b36ca1e9c3b2a9b78823")
elseif(host STREQUAL "aarch64")
    set(sha256 "87330bab085dd8749d4ed0ad633674b9dc48b237b61069e3b481abd364d0a684")
else()
    message(FATAL_ERROR "Unsupported container architecture: ${host}")
endif()

set(name "arm-gnu-toolchain-${version}-${host}-arm-none-eabi")
set(cache "$ENV{HOME}/.cache/cmake-toolchains")
set(root "${cache}/${name}")
set(archive "${cache}/${name}.tar.xz")
set(url "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/${name}.tar.xz")

set(link "${cache}/arm-gnu-toolchain-${version}-arm-none-eabi")

if(EXISTS "${root}/.complete" AND EXISTS "${root}/bin/arm-none-eabi-gcc")
    file(CREATE_LINK "${name}" "${link}" SYMBOLIC)
    message(STATUS "Toolchain already installed: ${root}")
    return()
endif()

file(MAKE_DIRECTORY "${cache}")

message(STATUS "Downloading ${name}")
file(DOWNLOAD "${url}" "${archive}"
    EXPECTED_HASH "SHA256=${sha256}"
    TLS_VERIFY ON
)

file(REMOVE_RECURSE "${root}")
file(ARCHIVE_EXTRACT INPUT "${archive}" DESTINATION "${cache}")
file(REMOVE "${archive}")

if(NOT EXISTS "${root}/bin/arm-none-eabi-gcc")
    message(FATAL_ERROR "Compiler missing after extraction: ${root}")
endif()
file(WRITE "${root}/.complete" "${sha256}\n")
file(CREATE_LINK "${name}" "${link}" SYMBOLIC)
message(STATUS "Toolchain installed: ${root}")
