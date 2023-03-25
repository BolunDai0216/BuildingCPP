cmake_minimum_required(VERSION 3.1) # Mandatory. 
project(cmake_install) # Mandatory. 
set(CMAKE_CXX_STANDARD 17) # Use c++17.

set(CUSTOM_INSTALLATION_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../cmake_install/install)
message(CUSTOM_INSTALLATION_DIR=${CUSTOM_INSTALLATION_DIR})

# print commonly used CMake-defined variables
message(CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR})
message(CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR})

# Toggle between how basic we want the build process to be
option(REALLY_BASIC OFF)

# find the include directory that contains the header files
find_path(LIBTOOLS_INCLUDE_DIR
        NAMES tools.hpp
        HINTS ${CUSTOM_INSTALLATION_DIR}
        PATH_SUFFIXES include/
)

# tell cmake where to look for *.hpp, *.h files
if (REALLY_BASIC)
    include_directories(${CUSTOM_INSTALLATION_DIR}/include/) 
else()
    include_directories(${LIBTOOLS_INCLUDE_DIR})
endif()

message(LIBTOOLS_INCLUDE_DIR=${LIBTOOLS_INCLUDE_DIR})
message(SPECIFIED_INCLUDE_PATH=${CUSTOM_INSTALLATION_DIR}/include)


# add executable main
add_executable(main src/main.cpp)  # main.o

find_library(LIBTOOLS_LIBRARY 
             NAMES libtools.a
             HINTS ${CUSTOM_INSTALLATION_DIR}
             PATH_SUFFIXES lib/
)                   

message(LIBTOOLS_LIBRARY=${LIBTOOLS_LIBRARY})
message(  SPECIFIED_PATH=${CUSTOM_INSTALLATION_DIR}/lib/libtools.a)

# tell the linker to bind these objects together.
# By toggling whether REALLY_BASIC is ON or OFF, we can make target_link_libraries
# use the absolute path or the path from LIBTOOLS_LIBRARY.
if (REALLY_BASIC)
    target_link_libraries(main ${CUSTOM_INSTALLATION_DIR}/lib/libtools.a)
else()
    add_library(tools STATIC IMPORTED)
    set_target_properties(
        tools
        PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${LIBTOOLS_INCLUDE_DIR}
        IMPORTED_LOCATION ${LIBTOOLS_LIBRARY}
    )
    target_link_libraries(main tools)
endif()