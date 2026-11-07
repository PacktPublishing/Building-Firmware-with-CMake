add_subdirectory(
    "${CMAKE_CURRENT_LIST_DIR}/../../../CppUTest"
    "${CMAKE_CURRENT_BINARY_DIR}/CppUTest"
)

add_executable(portable_tests
    main.cpp
    wire_data_decode_test.cpp
)

target_link_options(portable_tests PRIVATE
    -Wl,--gc-sections
)

target_link_libraries(portable_tests PRIVATE
    proto
    wire_data
    CppUTest::CppUTest
    platform
)

add_test(NAME portable_tests COMMAND portable_tests)

if(CMAKE_CROSSCOMPILING)
    add_executable(platform_tests
        main.cpp
    )

    target_link_options(platform_tests PRIVATE
        -Wl,--gc-sections
    )

    target_link_libraries(platform_tests PRIVATE
        CppUTest::CppUTest
        platform
    )

    add_subdirectory(
        "${CMAKE_CURRENT_LIST_DIR}/../platform_${PLATFORM}/tests"
        "${CMAKE_CURRENT_BINARY_DIR}/platform_${PLATFORM}"
    )

    add_test(NAME platform_tests COMMAND platform_tests)
endif()