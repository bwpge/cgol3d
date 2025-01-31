cmake_minimum_required(VERSION 3.30)
project(cgol3dlib VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ==============
# PROJECT SOURCE
# ==============

set(ENGINE_HEADER_FILES
    "include/cgol/cgol.hpp"
    "include/cgol/types.hpp"
)

set(ENGINE_SRC_FILES
    "src/engine.cpp"
)

add_library(${PROJECT_NAME} STATIC ${ENGINE_HEADER_FILES};${ENGINE_SRC_FILES})
add_library(cgol3dlib::cgol3dlib ALIAS cgol3dlib)

# ================
# COMPILER OPTIONS
# ================

if(MSVC)
    # static linking for msvc
    set_property(TARGET ${PROJECT_NAME} PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    # enable all warnings, use CMAKE_COMPILE_WARNING_AS_ERROR for errors
    target_compile_options(${PROJECT_NAME} PRIVATE /W4)
else()
    # enable all warnings, use CMAKE_COMPILE_WARNING_AS_ERROR for errors
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
endif()

# ============
# DEPENDENCIES
# ============

# configure dependency options
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(SPDLOG_FMT_EXTERNAL ON CACHE BOOL "" FORCE)

# NOTE: find_package needs to know about the VulkanSDK, which should be
# configured through the SDK installer, however the editor may not know about
# the include directory. This is a separate issue that needs to be configured
# through the editor/extension/plugin. The other packages can be found through
# vcpkg by setting the CMAKE_TOOLCHAIN_FILE variable (through editor, in this
# script, or with `--toolchain` cmake option).
message(STATUS "Configuring package: Vulkan")
find_package(Vulkan REQUIRED)
find_program(glslc_executable NAMES glslc HINTS Vulkan::glslc)
message("   -> lib:     ${Vulkan_LIBRARIES}")
message("   -> include: ${Vulkan_INCLUDE_DIR}")
message("   -> glslc:   ${glslc_executable}")

set(deps
    "fmt"
    "spdlog"
)
foreach(dep ${deps})
    message(STATUS "Adding dependency: ${dep}")
    find_package(${dep} CONFIG REQUIRED)
endforeach()

# ============================
# COMPILER DEFINITIONS/LINKING
# ============================

target_include_directories(${PROJECT_NAME}
    PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>"
        "$<BUILD_INTERFACE:${Vulkan_INCLUDE_DIR}>"
)

target_link_libraries(${PROJECT_NAME}
    PUBLIC
        spdlog::spdlog
        fmt::fmt
)
