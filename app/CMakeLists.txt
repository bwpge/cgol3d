cmake_minimum_required(VERSION 3.30)
project(cgol3dapp VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(APP_SRC_FILES src/main.cpp)

add_executable(${PROJECT_NAME} ${APP_SRC_FILES})

if(MSVC)
    # static linking for msvc
    set_property(TARGET ${PROJECT_NAME} PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    # enable all warnings, use CMAKE_COMPILE_WARNING_AS_ERROR for errors
    target_compile_options(${PROJECT_NAME} PRIVATE /W4)
else()
    # enable all warnings, use CMAKE_COMPILE_WARNING_AS_ERROR for errors
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
endif()

target_link_libraries(${PROJECT_NAME} cgol3dlib::cgol3dlib)
