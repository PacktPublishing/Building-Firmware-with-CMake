include(FetchContent)

FetchContent_Declare(
    nanopb_upstream
    GIT_REPOSITORY https://github.com/nanopb/nanopb.git
    GIT_TAG d21fa5084287ab67da2f166f4def045bedcb535e

    # Fetch the repository without processing its top-level CMakeLists.txt.
    SOURCE_SUBDIR  _not_used
)

FetchContent_MakeAvailable(nanopb_upstream)

list(APPEND CMAKE_MODULE_PATH
    "${nanopb_upstream_SOURCE_DIR}/extra"
)

find_package(Nanopb REQUIRED)