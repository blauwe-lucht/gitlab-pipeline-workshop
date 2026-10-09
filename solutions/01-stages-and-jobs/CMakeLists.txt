cmake_minimum_required(VERSION 3.25)
project(roman CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(GTest REQUIRED)

add_library(roman_lib STATIC src/roman.cpp)
target_include_directories(roman_lib PUBLIC src)

add_executable(roman src/main.cpp)
target_link_libraries(roman PRIVATE roman_lib)
# Static so the binary runs in any Linux container, not only the CI image.
target_link_options(roman PRIVATE -static)

add_executable(roman_tests tests/roman_test.cpp)
target_link_libraries(roman_tests PRIVATE roman_lib GTest::gtest_main)
