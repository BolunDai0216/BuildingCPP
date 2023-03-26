#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "tools" for configuration ""
set_property(TARGET tools APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(tools PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libtools.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS tools )
list(APPEND _IMPORT_CHECK_FILES_FOR_tools "${_IMPORT_PREFIX}/lib/libtools.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
