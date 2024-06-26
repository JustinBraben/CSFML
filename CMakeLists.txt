cmake_minimum_required(VERSION 3.22)

# define a macro that helps defining an option
macro(csfml_set_option var default type docstring)
    if(NOT DEFINED ${var})
        set(${var} ${default})
    endif()
    set(${var} ${${var}} CACHE ${type} ${docstring} FORCE)
endmacro()

# set a default build type if none was provided
# this has to be done before the project() instruction!
csfml_set_option(CMAKE_BUILD_TYPE Release STRING "Choose the type of build (Debug or Release)")

# project name
project(CSFML VERSION 3.0.0)

# we use the paths from the cmake GNUInstallDirs module as defaults
# you can override these if you like
# https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
include(GNUInstallDirs)

include(FetchContent)
FetchContent_Declare(SFML
    GIT_REPOSITORY https://github.com/SFML/SFML.git
    GIT_TAG 2.6.x)
FetchContent_MakeAvailable(SFML)

# include the configuration file
include(${PROJECT_SOURCE_DIR}/cmake/Config.cmake)

# add an option for choosing the build type (shared or static)
csfml_set_option(BUILD_SHARED_LIBS TRUE BOOL "TRUE to build CSFML as shared libraries, FALSE to build it as static libraries")

# add an option for building the API documentation
csfml_set_option(CSFML_BUILD_DOC FALSE BOOL "TRUE to generate the API documentation, FALSE to ignore it")

# add an option for linking to sfml either statically or dynamically
# default on windows to static and on other platforms to dynamic
if(SFML_OS_WINDOWS)
    set(LINK_STATICALLY_DEFAULT TRUE)
else()
    set(LINK_STATICALLY_DEFAULT FALSE)
endif()
csfml_set_option(CSFML_LINK_SFML_STATICALLY ${LINK_STATICALLY_DEFAULT} BOOL "TRUE to link to a static version of SFML, FALSE to link dynamically")

# define an option for choosing between static and dynamic C runtime (Windows only)
if(SFML_OS_WINDOWS)
    set(STATIC_STD_LIBS FALSE CACHE BOOL "TRUE to statically link to the standard libraries, FALSE to use them as DLLs")

    # for VC++, we can apply it globally by modifying the compiler flags
    if(SFML_COMPILER_MSVC AND STATIC_STD_LIBS)
        foreach(flag
                CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
            if(${flag} MATCHES "/MD")
                string(REGEX REPLACE "/MD" "/MT" ${flag} "${${flag}}")
            endif()
        endforeach()
    endif()
endif()

# add the subdirectories
add_subdirectory(src/SFML)
if(CSFML_BUILD_DOC)
    add_subdirectory(doc)
endif()

# on Linux and BSD-like OS, install pkg-config files by default
set(CSFML_INSTALL_PKGCONFIG_DEFAULT FALSE)

if(SFML_OS_LINUX OR SFML_OS_FREEBSD OR SFML_OS_OPENBSD OR SFML_OS_NETBSD)
    set(CSFML_INSTALL_PKGCONFIG_DEFAULT TRUE)
endif()

csfml_set_option(CSFML_INSTALL_PKGCONFIG_FILES ${CSFML_INSTALL_PKGCONFIG_DEFAULT} BOOL "TRUE to automatically install pkg-config files so other projects can find SFML")

if(CSFML_INSTALL_PKGCONFIG_FILES)
    csfml_set_option(CSFML_PKGCONFIG_INSTALL_DIR "${CSFML_PKGCONFIG_DIR}" PATH "Install directory for CSFML's pkg-config .pc files")

    foreach(csfml_module IN ITEMS all system window graphics audio network)
        configure_file(
            "tools/pkg-config/csfml-${csfml_module}.pc.in"
            "tools/pkg-config/csfml-${csfml_module}.pc"
            @ONLY)
        install(FILES "${CMAKE_CURRENT_BINARY_DIR}/tools/pkg-config/csfml-${csfml_module}.pc"
            DESTINATION "${CSFML_PKGCONFIG_INSTALL_DIR}")
    endforeach()
endif()

# setup the install rules
install(DIRECTORY include/
        DESTINATION include
        COMPONENT devel)
install(FILES license.md DESTINATION ${INSTALL_MISC_DIR})
install(FILES readme.md DESTINATION ${INSTALL_MISC_DIR})

# add an option for building the examples
csfml_set_option(CSFML_BUILD_EXAMPLES FALSE BOOL "TRUE to build the CSFML examples, FALSE to ignore them")
if(CSFML_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

# add an option for building the tests
csfml_set_option(CSFML_BUILD_TEST_SUITE FALSE BOOL "TRUE to build the CSFML test suite, FALSE to ignore it")
if(CSFML_BUILD_TEST_SUITE)
    enable_testing()
    add_subdirectory(test)
endif()
