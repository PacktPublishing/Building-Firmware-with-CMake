function(generate_wire_data)
    # Define the public arguments accepted by this function.
    set(one_value_args
        TARGET
        PROTO_DIR
    )

    set(multi_value_args
        PROTO_FILES
    )

    cmake_parse_arguments(
        ARG
        ""
        "${one_value_args}"
        "${multi_value_args}"
        ${ARGN}
    )

    if(NOT ARG_TARGET)
        message(FATAL_ERROR "generate_wire_data(): TARGET is required")
    endif()

    if(NOT ARG_PROTO_DIR)
        message(FATAL_ERROR "generate_wire_data(): PROTO_DIR is required")
    endif()

    if(NOT ARG_PROTO_FILES)
        message(FATAL_ERROR "generate_wire_data(): PROTO_FILES is required")
    endif()

    find_package(Python3 REQUIRED COMPONENTS Interpreter)
    find_program(PROTOC_EXECUTABLE protoc REQUIRED)

    # Use an absolute path as the protoc import root.
    get_filename_component(
        PROTO_DIR
        "${ARG_PROTO_DIR}"
        ABSOLUTE
    )

    message(STATUS "Wire data proto directory: ${PROTO_DIR}")
    message(STATUS "Wire data proto files:")

    foreach(PROTO_FILE ${ARG_PROTO_FILES})
        message(STATUS "  ${PROTO_FILE}")
    endforeach()

    # Python bindings are generated into the build directory.
    set(PYTHON_BINDINGS_DIR
        ${CMAKE_CURRENT_BINARY_DIR}/${ARG_TARGET}-python-bindings
    )

    set(PYTHON_BINDINGS)

    foreach(PROTO_FILE ${ARG_PROTO_FILES})
        get_filename_component(
            PROTO_NAME
            "${PROTO_FILE}"
            NAME_WE
        )

        list(APPEND PYTHON_BINDINGS
            ${PYTHON_BINDINGS_DIR}/${PROTO_NAME}_pb2.py
        )
    endforeach()

    message(STATUS "Python bindings will be generated in:")
    message(STATUS "  ${PYTHON_BINDINGS_DIR}")

    foreach(PYTHON_BINDING ${PYTHON_BINDINGS})
        message(STATUS "  ${PYTHON_BINDING}")
    endforeach()

    add_custom_command(
        OUTPUT ${PYTHON_BINDINGS}

        COMMAND ${CMAKE_COMMAND} -E make_directory
            ${PYTHON_BINDINGS_DIR}

        COMMAND ${PROTOC_EXECUTABLE}
            --proto_path=${PROTO_DIR}
            --python_out=${PYTHON_BINDINGS_DIR}
            ${ARG_PROTO_FILES}

        DEPENDS
            ${ARG_PROTO_FILES}

        COMMENT "Generating Python Protocol Buffer bindings"
        VERBATIM
    )

    # The Python script serializes DeviceInfo and emits a C header.
    set(WIRE_DATA_DIR
        ${CMAKE_CURRENT_BINARY_DIR}/${ARG_TARGET}-generated
    )

    set(WIRE_DATA_HEADER
        ${WIRE_DATA_DIR}/wire_data.h
    )

    set(GENERATOR_SCRIPT
        ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../generate_wire_data.py
    )

    message(STATUS "Wire data header will be generated at:")
    message(STATUS "  ${WIRE_DATA_HEADER}")

    add_custom_command(
        OUTPUT ${WIRE_DATA_HEADER}

        COMMAND ${Python3_EXECUTABLE}
            ${GENERATOR_SCRIPT}
            --python-bindings ${PYTHON_BINDINGS_DIR}
            --output-header ${WIRE_DATA_HEADER}

        DEPENDS
            ${PYTHON_BINDINGS}
            ${GENERATOR_SCRIPT}

        COMMENT "Generating wire_data.h"
        VERBATIM
    )

    # Represent generated wire data as a CMake target.
    add_custom_target(${ARG_TARGET}_codegen
        DEPENDS ${WIRE_DATA_HEADER}
    )

    add_library(${ARG_TARGET} INTERFACE)

    add_dependencies(
        ${ARG_TARGET}
        ${ARG_TARGET}_codegen
    )

    target_include_directories(${ARG_TARGET} INTERFACE
        ${WIRE_DATA_DIR}
    )
endfunction()