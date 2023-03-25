cmake_minimum_required(VERSION 3.1) # Mandatory. 
project(cmake_install) # Mandatory. 
set(CMAKE_CXX_STANDARD 17) # Use c++17.

set(CUSTOM_INSTALLATION_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../cmake_install/install)
message(CUSTOM_INSTALLATION_DIR=${CUSTOM_INSTALLATION_DIR})

# print commonly used CMake-defined variables
message(CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR})
message(CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR})

# tell cmake where to look for *.hpp, *.h files
include_directories(${CUSTOM_INSTALLATION_DIR}/include/) 

# add executable main
add_executable(main src/main.cpp)  # main.o

# tell the linker to bind these objects together 
target_link_libraries(main ${CUSTOM_INSTALLATION_DIR}/lib/libtools.a)