cmake_minimum_required(VERSION 3.25)

if(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    message(FATAL_ERROR "Run this script inside the Linux development container")
endif()

get_filename_component(source_dir "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)

if(NOT DEFINED PRESET)
    set(PRESET "arm-pinned")
endif()

foreach(kind IN ITEMS CONFIGURE BUILD TEST PACKAGE)
    if(NOT DEFINED ${kind}_PRESET)
        set(${kind}_PRESET "${PRESET}")
    endif()
endforeach()

get_filename_component(cmake_bin "${CMAKE_COMMAND}" DIRECTORY)
find_program(ctest NAMES ctest HINTS "${cmake_bin}" NO_DEFAULT_PATH REQUIRED)
find_program(cpack NAMES cpack HINTS "${cmake_bin}" NO_DEFAULT_PATH REQUIRED)

set(command_log "${source_dir}/build/release-commands.txt")
file(MAKE_DIRECTORY "${source_dir}/build")

function(shell_quote output value)
    string(REPLACE "'" "'\\''" escaped "${value}")
    set(${output} "'${escaped}'" PARENT_SCOPE)
endfunction()

shell_quote(quoted_source_dir "${source_dir}")
file(WRITE "${command_log}"
    "# Release commands, recorded immediately before execution\n"
    "cd ${quoted_source_dir}\n"
)

function(run_step name)
    set(command_line "")
    foreach(argument IN LISTS ARGN)
        shell_quote(quoted_argument "${argument}")
        string(APPEND command_line "${quoted_argument} ")
    endforeach()

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

run_step("Bootstrap toolchain"
    "${CMAKE_COMMAND}" -P "${source_dir}/cmake/setup-arm-gcc.cmake"
)

run_step("Configure"
    "${CMAKE_COMMAND}" --preset "${CONFIGURE_PRESET}"
    "-DRELEASE_COMMAND_LOG:FILEPATH=${command_log}"
)

run_step("Build"
    "${CMAKE_COMMAND}" --build --preset "${BUILD_PRESET}"
)

run_step("Test"
    "${ctest}" --preset "${TEST_PRESET}" --output-on-failure --no-tests=error
)

run_step("Package"
    "${cpack}" --preset "${PACKAGE_PRESET}"
)

message(STATUS "Release completed. Commands recorded in: ${command_log}")
