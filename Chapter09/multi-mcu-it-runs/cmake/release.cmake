cmake_minimum_required(VERSION 3.25)

if(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    message(FATAL_ERROR "Run this script inside the Linux development container")
endif()

get_filename_component(source_dir "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)

set(command_log "${source_dir}/build/release-commands.txt")

file(WRITE "${command_log}"
    "# Release commands, recorded immediately before execution\n"
    "cd ${source_dir}\n"
)

function(run_step name)
    set(command_line "")
    foreach(argument IN LISTS ARGN)
        string(APPEND command_line "${argument} ")
    endforeach()

    string(STRIP "${command_line}" command_line)

    file(APPEND "${command_log}" "\n# ${name}\n${command_line}\n")
    message(STATUS "${name}: ${command_line}")

    execute_process(
        COMMAND ${ARGN}
        WORKING_DIRECTORY "${source_dir}"
        RESULT_VARIABLE result
    )

    if(NOT "${result}" STREQUAL "0")
        file(APPEND "${command_log}" "# FAILED: ${name}: ${result}\n")
        message(FATAL_ERROR "${name} failed: ${result}")
    endif()
endfunction()

set(ENV{RELEASE_COMMAND_LOG} "${command_log}")

run_step("Bootstrap toolchain"
    "${CMAKE_COMMAND}" -P "${source_dir}/cmake/setup-arm-gcc.cmake"
)

run_step("Release workflow"
    "${CMAKE_COMMAND}" --workflow --preset stm32f072-release --fresh
)

message(STATUS "Release completed. Commands recorded in: ${command_log}")
