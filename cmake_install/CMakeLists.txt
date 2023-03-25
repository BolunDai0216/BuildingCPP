cmake_minimum_required(VERSION 3.1) # Mandatory. 
project(cmake_install) # Mandatory. 
set(CMAKE_CXX_STANDARD 17) # Use c++17.

# tell cmake where to look for *.hpp, *.h files
include_directories(include/) 

# create library "libtools.a"
add_library(tools src/tools.cpp) 

# add executable main
add_executable(main src/main.cpp)  # main.o

# tell the linker to bind these objects together 
target_link_libraries(main tools)

install(TARGETS tools DESTINATION lib)
install(FILES include/tools.hpp DESTINATION include)
install(TARGETS main DESTINATION bin)