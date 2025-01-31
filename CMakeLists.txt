# vcpkg note:
#   configure VCPKG_TARGET_TRIPLET somewhere (for this project, this is done in
#   the Justfile) prior to the project directive to ensure static libraries are
#   linked (e.g., x64-windows-static)

cmake_minimum_required(VERSION 3.30)
project(cgol3d LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_COMPILE_WARNING_AS_ERROR ON)

# prevent clang-tidy from linting dependency code
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/.clang-tidy" "Checks: '-*'")

# utf8 support for msvc
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")

add_subdirectory("engine")
add_subdirectory("app")
