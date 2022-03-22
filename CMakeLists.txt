
## Configure cmake and project
cmake_minimum_required(VERSION 3.22)
project(cc VERSION 0.0.1 LANGUAGES C CXX)


## Find C++ sources, except main.cpp driver files
#  --> ${sources}
execute_process(COMMAND find . -type f \( -path "./sources*" ! -name "*main.cpp" \( -name "*.cpp" -o -name "*.c" \) \) -printf %P
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  RESULT_VARIABLE sources_result
  OUTPUT_VARIABLE sources)

## Find C++ tests sources
#  --> ${tests}
execute_process(COMMAND find . -type f \( -path "./tests*" -name "*.cpp" \) -printf %P
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  RESULT_VARIABLE tests_result
  OUTPUT_VARIABLE tests)

## Find sources and tests file paths
#  --> ${includes}
execute_process(COMMAND find . -mindepth 1 -type d -path "./sources*" -o -path "./tests*" -printf %P
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  RESULT_VARIABLE includes_result
  OUTPUT_VARIABLE includes)


## Enable Google Test
enable_testing()


## Create application and tests binarires
set(binary "cc.app")
set(binary_tests "cc.tests")

add_executable(${binary} ./sources/main.cpp ${sources})
add_executable(${binary_tests} ${tests} ${sources})


## Configure C/C++ compiler flags
set(warnings "-Wall -Wextra -Werror -Wfatal-errors")
set(pedantic "-pedantic -pedantic-errors")

set(cppstd "-std=c++20")
set(cstd "-ansi")

set(optimization "-O3")
set(debbuger "-ggdb")

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${warnings}")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${cstd}")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${optimization}")

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${warnings}")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${pedantic}")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${cppstd}")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${optimization}")


## Find dependencies
find_package(glfw3 3.3 REQUIRED)
find_package(OpenGL REQUIRED)
find_package(Freetype REQUIRED)


## Application executable image
target_link_libraries(${binary} PRIVATE glfw)
target_link_libraries(${binary} PRIVATE OpenGL::GL)
target_link_libraries(${binary} PRIVATE ${FREETYPE_LIBRARIES})
target_link_libraries(${binary} PRIVATE ${CMAKE_DL_LIBS})

target_include_directories(${binary} PRIVATE ${includes})
target_include_directories(${binary} PRIVATE ${FREETYPE_INCLUDE_DIRS})

add_custom_command(TARGET ${binary} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${binary}> ../${binary})


## Fetch Google Test framework
include(FetchContent)
FetchContent_Declare(googletest
  URL https://github.com/google/googletest/archive/e2239ee6043f73722e7aa812a459f54a28552929.zip)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)


## Tests executable image
target_link_libraries(${binary_tests} PRIVATE glfw)
target_link_libraries(${binary_tests} PRIVATE OpenGL::GL)
target_link_libraries(${binary_tests} PRIVATE ${FREETYPE_LIBRARIES})
target_link_libraries(${binary_tests} PRIVATE ${CMAKE_DL_LIBS})
target_link_libraries(${binary_tests} PRIVATE gtest_main)

target_include_directories(${binary_tests} PRIVATE ${includes})
target_include_directories(${binary_tests} PRIVATE ${FREETYPE_INCLUDE_DIRS})

## Configure Google Test framework
include(GoogleTest)
gtest_discover_tests(${binary_tests})

add_custom_command(TARGET ${binary_tests} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${binary_tests}> ../${binary_tests})

