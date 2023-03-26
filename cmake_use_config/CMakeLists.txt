cmake_minimum_required(VERSION 3.15) # Mandatory. 
project(cmake_use_config) # Mandatory. 
set(CMAKE_CXX_STANDARD 17) # Use c++17.

# finds package tools
find_package(tools CONFIG REQUIRED PATHS /Users/bolundai/Documents/BuildingCPP/cmake_install_with_config/install/lib/cmake/tools)

# add executable main
add_executable(main src/main.cpp)  # main.o

# tell the linker to bind these objects together 
target_link_libraries(main tools)