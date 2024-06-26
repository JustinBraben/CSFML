
# include the SFML specific macros
include(${PROJECT_SOURCE_DIR}/cmake/Macros.cmake)

# add the CSFML sources path
include_directories(${PROJECT_SOURCE_DIR}/src)

# set the output directory for CSFML libraries
set(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/lib")

# define the export symbol
add_definitions(-DCSFML_EXPORTS)

# disable stupid warnings with Visual C++
if(SFML_COMPILER_MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

# find SFML libraries (C++)
if(CSFML_LINK_SFML_STATICALLY)
    set(SFML_STATIC_LIBRARIES TRUE)
    add_definitions(-DSFML_STATIC)
endif()
find_package(SFML 3.0.0 COMPONENTS Network Graphics Audio REQUIRED)

# add the modules subdirectories
add_subdirectory(System)
add_subdirectory(Window)
add_subdirectory(Network)
add_subdirectory(Graphics)
add_subdirectory(Audio)
if(SFML_OS_WINDOWS)
    add_subdirectory(Main)
endif()
