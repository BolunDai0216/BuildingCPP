cmake_minimum_required(VERSION 3.15) # Mandatory. 
project(cmake_install_with_config) # Mandatory. 
set(CMAKE_CXX_STANDARD 17) # Use c++17.

# tell cmake where to look for *.hpp, *.h files
include_directories(include/) 

# create library "libtools.a"
add_library(tools src/tools.cpp) 

# state that anybody linking to us needs to include the current source dir
# to find tools.hpp, while we don't.
target_include_directories(tools 
                          INTERFACE 
                          $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> 
                          $<INSTALL_INTERFACE:include>
)

# add executable main
add_executable(main src/main.cpp)  # main.o

# tell the linker to bind these objects together 
target_link_libraries(main tools)

# install libraries and export the toolsTargets for later usage
install(TARGETS tools EXPORT toolsTargets DESTINATION lib)

# installs the header files
install(FILES include/tools.hpp DESTINATION include)

# install toolsTargets.cmake
install(EXPORT toolsTargets
  FILE toolsTargets.cmake
  DESTINATION lib/cmake/tools
)

include(CMakePackageConfigHelpers)

# generate the config file that is includes the exports
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/toolsConfig.cmake"
  INSTALL_DESTINATION "lib/cmake/tools"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

# generate toolsConfigVersion.cmake
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/toolsConfigVersion.cmake"
  VERSION "${Tutorial_VERSION_MAJOR}.${Tutorial_VERSION_MINOR}"
  COMPATIBILITY AnyNewerVersion
)

# install toolsConfig.cmake and toolsConfigVersion.cmake in <install-dir>/lib/cmake/MathFunctions
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/toolsConfig.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/toolsConfigVersion.cmake
  DESTINATION lib/cmake/tools
)

install(TARGETS main DESTINATION bin)