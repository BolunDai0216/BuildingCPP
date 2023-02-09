cmake_minimum_required(VERSION 3.1) # Mandatory. 
project(build_systems) # Mandatory. 
set(CMAKE_CXX_STANDARD 17) # Use c++17.
set(CMAKE_PREFIX_PATH "/usr/local/include/eigen3/cmake")

# tell cmake where to look for *.hpp, *.h files
include_directories(include/) 

# set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
message(STATUS ${CMAKE_MODULE_PATH})

# find Eigen3
find_package(Eigen3 3.3)

# create library "libtools.a"
add_library(tools src/tools.cpp) 

# add executable main
add_executable(main src/main.cpp)  # main.o

# tell the linker to bind these objects together 
target_link_libraries(main tools Eigen3::Eigen)