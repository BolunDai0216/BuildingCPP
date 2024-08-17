# CMake 101

## Build & Metabuild Systems

Make and Ninja are build systems, CMake is a metabuild system. CMake generates makefiles that are given to build systems to actually build the project. So the usual workflow is

```bash
mkdir build
cd build
cmake ../
make
```

To see what CMake does, we can write the CMake equivalence of 

```bash
clang++ -std=c++17 -c tools.cpp -o tools.o
ar rcs libtools.a tools.o
clang++ -std=c++17 main.cpp -L . -ltools -o main
```

which is

```cmake
add_library(tools tools.cpp)
add_executable(main main.cpp)
target_link_library(main tools)
```

We can find a one-to-one correspondence between them. The `add_library(tools tools.cpp)` command corresponds to `clang++ -std=c++17 -c tools.cpp -o tools.o` and `ar rcs libtools.a tools.o`. The `add_executable(main main.cpp)` part corresponds to `clang++ -std=c++17 main.cpp -o main`. The `target_link_library(main tools)` part corresponds to `-L . -ltools`.

If you want to find an external library, you can use the `find_package` command. Note that the `find_package` command is looking for `Find<package>.cmake` files.

## Basic Installing Using CMake

We now talk about how to install packages using CMake. All of the source code in this section is in the `cmake_install` folder. 

Compared to the last section, in the C++ code all we changed is remove the reliance on `Eigen3` in `main.cpp`. What it means to install a package is to store the generated binary file, the header files, and the library files to some predefined location. To do this we add the following three lines in `CMakeLists.txt`

```cmake
install(TARGETS tools DESTINATION lib)
install(FILES include/tools.hpp DESTINATION include)
install(TARGETS main DESTINATION bin)
```

which is then installed using (only for CMake V3.15.0 and up, see [here](https://cmake.org/cmake/help/v3.24/guide/tutorial/Installing%20and%20Testing.html) for older versions)

```console
cmake --install .
```

We can see that the installation can be seperated into two types, installing targets and installing files. The targets are what is generated within the building process such as the library file `libtools.a` and the binary file `main`. The files are files that alread exists like the header file. The `DESTINATION` specifies where the installed files are stored at. The destinations are relative to a prefix directory, which can be specified when performing the installation using

```console
cmake --install . --prefix "/Users/BolunDai0216/Documents/BuildingCPP/cmake_install/install/"
```

and the files will then be installed within

```
/Users/BolunDai0216/Documents/BuildingCPP/cmake_install/install/bin/
/Users/BolunDai0216/Documents/BuildingCPP/cmake_install/install/include/
/Users/BolunDai0216/Documents/BuildingCPP/cmake_install/install/lib
```

## The Basic Way to Use Installed Packages

To use installed libraries the easiest way is to figure out where the header files and library files are located and just use them directly. The source code of this section can be found in the `cmake_use_installed_package_basic` folder.

First, to make our life easier we create a variable to store the location of the installation

```cmake
set(CUSTOM_INSTALLATION_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../cmake_install/install)
```

We are using a CMake-defined variable `CMAKE_CURRENT_SOURCE_DIR`, which gives us the directory where the `CMakeLists.txt` files is stored. Another commonly used CMake-defined variable is `CMAKE_CURRENT_BINARY_DIR` which gives us the directory within the build folder.

We will be using the installed files from the last section, so the `CUSTOM_INSTALLATION_DIR` will be the `install` folder from last section. Then, like before we can include the header files as

```cmake
include_directories(${CUSTOM_INSTALLATION_DIR}/include/) 
```

Since we already have the library files (`.a` files), we would not need to run `add_library`, we can directly link the `.a` file using 

```
target_link_libraries(main ${CUSTOM_INSTALLATION_DIR}/lib/libtools.a)
```

A bit more advanced and general way to do this is using `find_library`. In this example, we can use `find_library` as

```cmake
find_library(LIBTOOLS_LIBRARY 
             NAMES libtools.a
             HINTS ${CUSTOM_INSTALLATION_DIR}
             PATH_SUFFIXES lib/
) 
```

a nice intro to `find_library` can be found [here](https://dominikberner.ch/cmake-find-library/). Then if we compare the variable `LIBTOOLS_LIBRARY` and what we had before `${CUSTOM_INSTALLATION_DIR}/lib/libtools.a`, we can see that they are the same. Then, we can simply change the `target_link_libraries` to

```cmake
target_link_libraries(main ${LIBTOOLS_LIBRARY})
```

Similarly, for the header files we can do the same thing. We can find the path to the include folder using the `find_path` command

```cmake
find_path(LIBTOOLS_INCLUDE_DIR
        NAMES tools.hpp
        HINTS ${CUSTOM_INSTALLATION_DIR}
        PATH_SUFFIXES include/
)
```

and if we compare the result of `LIBTOOLS_INCLUDE_DIR` and `${CUSTOM_INSTALLATION_DIR}/include/` we can see that they are pointing to the same directory. Then to utilize `LIBTOOLS_INCLUDE_DIR` and `LIBTOOLS_LIBRARY`, we can first create an empty library target (I don't think empty is the official terminology), and then set the required properties. In this case, we only need to set the `INTERFACE_INCLUDE_DIRECTORIES` to `LIBTOOLS_INCLUDE_DIR` and `IMPORTED_LOCATION` to `LIBTOOLS_LIBRARY`. We do this using the following commands

```cmake
add_library(tools STATIC IMPORTED)
set_target_properties(tools
                      PROPERTIES
                      INTERFACE_INCLUDE_DIRECTORIES ${LIBTOOLS_INCLUDE_DIR}
                      IMPORTED_LOCATION ${LIBTOOLS_LIBRARY}
)
```

After this is done, we can then simply link the library using 

```cmake
target_link_libraries(main tools)
```

## CMake Installation Using Config Files

A more general approach to use external packages is using `<package-name>Config.cmake` files. This section, we will look into how to create such a config file. All of the source code of this section can be found in the `cmake_install_with_config` folder.

We first build the tools library using the commands

```cmake
include_directories(include/) 
add_library(tools src/tools.cpp) 
target_include_directories(tools INTERFACE 
                          $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> 
                          $<INSTALL_INTERFACE:include>)
```

The `target_include_directories` commands uses generator expressions to say when using the built tools library the content within the `${CMAKE_CURRENT_SOURCE_DIR}` directory is included, while when using the installed tools library the content within the `/include` directory in the installation directory is included. Next, we generate the executables as before using the commands

```cmake
add_executable(main src/main.cpp)
target_link_libraries(main tools)
```

The next step is to install the files.

```
install(TARGETS tools EXPORT toolsTargets DESTINATION lib)
install(FILES include/tools.hpp DESTINATION include)
```

These lines installs the tools library within the `lib` folder within the installation directory and install the header files within the `include` folder within the installation directory. The installation directory is specified when installing it. When installing the tools library, it also exports a target called `toolsTargets`. Then, we use the following line

```cmake
install(EXPORT toolsTargets FILE toolsTargets.cmake DESTINATION lib/cmake/tools)
```
to install a `<lib-name>Targets.cmake` file that contains information about the `toolsTargets` target. Now, we are in a good position to install the `Config.cmake` file. First, we include `CMakePackageConfigHelpers`, which provides helper functions for generating the `Config.cmake` file. The `Config.cmake` file is generated using the command

```cmake
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/toolsConfig.cmake"
  INSTALL_DESTINATION "lib/cmake/tools"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)
```

The `INSTALL_DESTINATION` only needs to have the same number of subdirectories, i.e., if we want to install it in `install/lib/cmake/tools` we would need a three level destination as `a/b/c` here. By changing the `INSTALL_DESTINATION` to `a/b/c` and `a/b` you'll get what I mean. The `Config.cmake.in` file simply points to the `Target.cmake` file. A `ConfigVersion.cmake` file can be created using the command

```cmake
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/toolsConfigVersion.cmake"
  VERSION "${Tutorial_VERSION_MAJOR}.${Tutorial_VERSION_MINOR}"
  COMPATIBILITY AnyNewerVersion)
```
Then we install both the `Config.cmake` and `ConfigVersion.cmake` files. Finally, we can build and install the package using the commands

```bash
cmake .. && cmake --build .
cmake --install . --prefix "~/Documents/BuildingCPP/cmake_install_with_config/install/"
```

## Using `find_package()` to use external libraries

In the last section, we showed how to create config files. This section, we will look into how to use the config files to import external libraries in your own CMake project. All of the source code of this section can be found in the `cmake_use_config` folder.

In the last section, we created a `Config.cmake` file. In this section, we will enable the `find_package` command to find it. Since we are installing it in a non-default location, we will need to pass on the directory to the `find_package` command

```cmake
find_package(tools 
             CONFIG 
             REQUIRED 
             PATHS /path/to/cmake_install_with_config/install/lib/cmake/tools)
```

Then, we can directly using the `tools` library by linking it

```cmake
target_link_libraries(main tools)
```
