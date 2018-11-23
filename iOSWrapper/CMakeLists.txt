cmake_minimum_required (VERSION 3.7)

# use elseif
cmake_policy(GET CMP0054 NEW)

# https://stackoverflow.com/questions/12547624/cant-link-macos-frameworks-with-cmake
macro(ADD_FRAMEWORK fwname appname)
    find_library(FRAMEWORK_${fwname}
    NAMES ${fwname}
    PATHS ${CMAKE_OSX_SYSROOT}/System/Library
    PATH_SUFFIXES Frameworks
    NO_DEFAULT_PATH)

    if( ${FRAMEWORK_${fwname}} STREQUAL FRAMEWORK_${fwname}-NOTFOUND)
        message(ERROR ": Framework ${fwname} not found")
    else()
        target_link_libraries(${appname} "${FRAMEWORK_${fwname}}/${fwname}")
        message(STATUS "Framework ${fwname} found at ${FRAMEWORK_${fwname}}")
    endif()
endmacro(ADD_FRAMEWORK)

# Framework/Test Parameter Settings
# start
set(FRAMEWORK_NAME pcl)                                       # <== Set to your framework's name
set(FRAMEWORK_ICON_FILE "")
set(FRAMEWORK_BUNDLE_IDENTIFIER com.sirokujira.framework)     # <== Set to your framework's bundle identifier (cannot be the same as app bundle identifier)
set(CODE_SIGN_IDENTITY "iPhone Developer")                    # <== Set to your preferred code sign identity, to see list:
                                                              # /usr/bin/env xcrun security find-identity -v -p codesigning
set(DEPLOYMENT_TARGET 8.0)                                    # <== Set your deployment target version of iOS
set(DEVICE_FAMILY "1,2")                                      # <== Set to "1" to target iPhone, set to "2" to target iPad, set to "1,2" to target both
set(TEST_NAME Tests)                                          # <== Set to your test's name
set(TEST_BUNDLE_IDENTIFIER com.sirokujira.tests)              # <== Set to your tests's bundle ID
set(LOGIC_ONLY_TESTS 0)                                       # <== Set to 1 if you do not want tests to be hosted by the application, 
                                                              # speeds up pure logic tests but you can not run them on real devices
set(DEVELOPMENT_TEAM_ID "AAAAAAAA")                           # <== Set to your team ID from Apple

set(MACOSX_BUNDLE_ICON_FILE "")
set(MACOSX_BUNDLE_LONG_VERSION_STRING "1.8.1")
set(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.8")
set(MACOSX_BUNDLE_BUNDLE_VERSION "1.8.1")
set(MACOSX_BUNDLE_COPYRIGHT "Copyright Sirokujira")
set(MACOSX_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET})
# end

# Framework
project(${FRAMEWORK_NAME})
include(BundleUtilities)

# set Wrapper Code
set(LIBRARY_SOURCE
    ${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryWrapper.hpp
    ${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryWrapper.cpp
    ${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryConversions.h
    ${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryConversions.cxx
#     ${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryVoxelGrid.h
#     ${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryVoxelGrid.cxx
)

add_library(
    ${FRAMEWORK_NAME} STATIC
    ${LIBRARY_SOURCE}
)

# XCTest for Framework

if (IOS_TESTS)

# Based : https://github.com/Kitware/CMake/blob/master/Tests/XCTest/CMakeLists.txt
project(XCTest CXX C)
enable_testing()

include(FindXCTest)
find_package(XCTest REQUIRED)

message(STATUS XCTestFound:${XCTest_FOUND})
message(STATUS XCTest_EXECUTABLE:${XCTest_EXECUTABLE})
message(STATUS XCTest_INCLUDE_DIRS:${XCTest_INCLUDE_DIRS})
message(STATUS XCTest_LIBRARIES:${XCTest_LIBRARIES})

set(TEST_SOURCE
    ${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryInterface.mm
    ${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryInterface.h
    ${CMAKE_CURRENT_LIST_DIR}/tests/Tests.m
    ${CMAKE_CURRENT_LIST_DIR}/tests/tests.plist
)

# Simulator only?
# https://github.com/ruslo/polly/issues/149
# add_subdirectory(tests)
xctest_add_bundle(
    ${TEST_NAME} ${FRAMEWORK_NAME}
    ${TEST_SOURCE}
)

set_target_properties(${TEST_NAME} PROPERTIES 
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/tests/tests.plist 
)

target_include_directories(${TEST_NAME} PUBLIC
        "${CMAKE_SOURCE_DIR}"
)

xctest_add_test(
    XCTest.${FRAMEWORK_NAME}    # Test name
    ${TEST_NAME}                # Target name of XCTest bundle
)

set(FRAMEWORK_DIR "${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal")

# set custom framework path
set_target_properties(${TEST_NAME} PROPERTIES
    XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS "${FRAMEWORK_DIR}"
)

# set framework?
# standard
# add_framework(Foundation ${TEST_NAME})
# custom
# add_framework(${FRAMEWORK_NAME} ${TEST_NAME})
# target_link_libraries(${TEST_NAME} 
# "${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/pcl")
target_include_directories(${TEST_NAME} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/Headers
    ${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/Headers/boost-ios-simulator/include
    ${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/Headers/flann-ios-simulator/include
    ${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/Headers/qhull-ios-simulator/include
    ${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/Headers/qhull-ios-simulator/include/libqhull
    ${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/Headers/qhull-ios-simulator/include/libqhull_r
    ${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/Headers/qhull-ios-simulator/include/libqhullcpp
    ${CMAKE_CURRENT_LIST_DIR}/../build/CMakeExternals/Install/frameworks-universal/pcl.framework/Headers/pcl-ios-simulator/include/pcl-1.8
)
set_target_properties(${TEST_NAME} PROPERTIES
    COMPILE_FLAGS "-F ${FRAMEWORK_DIR}"
    LINK_FLAGS "-F ${FRAMEWORK_DIR} -framework ${FRAMEWORK_NAME}"
)

# target_link_libraries(${TEST_NAME} PRIVATE "-framework ${FRAMEWORK_NAME}")

# add libstdc++.6.dylib(sim only?)
# https://stackoverflow.com/questions/12920891/std-linker-error-with-apple-llvm-4-1
# target_link_libraries(${TEST_NAME} "libstdc++.6.tbd")
# target_link_libraries(${TEST_NAME} "libstdc++.6.0.9.tbd")
# target_link_libraries(${TEST_NAME} "libstdc++.6.dylib")
# target_link_libraries(${TEST_NAME} "libstdc++.6.0.9.dylib")
# target_link_libraries(${TEST_NAME} "libc++.dylib")

target_link_libraries(${FRAMEWORK_NAME} "${CMAKE_CURRENT_LIST_DIR}/boost/lib/libboost.a")

endif ()

# FolderPath Check
# CMAKE_INSTALL_PREFIX
message(STATUS "CMAKE_INSTALL_PREFIX : ${CMAKE_INSTALL_PREFIX}")
# -> ???
# message(${CMAKE_BINARY_DIR})
message(STATUS "CMAKE_BINARY_DIR : ${CMAKE_BINARY_DIR}")
# parent root.
# -> ./CMakeExternals/Build
# ./CMakeExternals/Install

# a/dylib
# boost?
# file(GLOB_RECURSE boost_includefiles "../build/CMakeExternals/Install/boost-ios-device/include/*.h*")
# file(GLOB_RECURSE boost_device_libraryfiles "../build/CMakeExternals/Install/boost-ios-device/lib/*.a")
file(GLOB_RECURSE boost_includefiles "../build/CMakeExternals/Install/boost-ios-device-arm64/include/*.h*")
file(GLOB_RECURSE boost_device_libraryfiles "../build/CMakeExternals/Install/boost-ios-device-arm64/lib/*.a")
file(GLOB_RECURSE boost_simulation_libraryfiles "../build/CMakeExternals/Install/boost-ios-simulator/lib/*.a")
file(GLOB_RECURSE boost_simulation_i386_libraryfiles "../build/CMakeExternals/Install/boost-ios-simulator-i386/lib/*.a")

# message(STATUS "boost(include)         : ${boost_includefiles}")
# message(STATUS "boost(device - lib)    : ${boost_device_libraryfiles}")
# message(STATUS "boost(simulator - lib) : ${boost_simulation_libraryfiles}")

# add_library(
#     ${FRAMEWORK_NAME} SHARED
#     ${boost_device_libraryfiles}
# )
# 
# add_library(
#     ${FRAMEWORK_NAME} SHARED
#     ${boost_simulation_libraryfiles}
# )
# 
###

# eigen
file(GLOB_RECURSE eigen_includefiles "../build/CMakeExternals/Install/eigen/Eigen/*.")
file(GLOB_RECURSE eigen_unsupported_includefiles "../build/CMakeExternals/Install/eigen/unsupported/*.")

# message(STATUS ${eigen_includefiles})
# message(STATUS ${eigen_unsupported_includefiles})

###

# flann
# file(GLOB_RECURSE flann_includefiles "../build/CMakeExternals/Install/flann-ios-device/include/flann/*.h*")
# file(GLOB_RECURSE flann_device_libraryfiles "../build/CMakeExternals/Install/flann-ios-device/lib/*.a")
file(GLOB_RECURSE flann_includefiles "../build/CMakeExternals/Install/flann-ios-device-arm64/include/flann/*.h*")
file(GLOB_RECURSE flann_device_libraryfiles "../build/CMakeExternals/Install/flann-ios-device-arm64/lib/*.a")
file(GLOB_RECURSE flann_simulation_libraryfiles "../build/CMakeExternals/Install/flann-ios-simulator/lib/*.a")
file(GLOB_RECURSE flann_simulation_i386_libraryfiles "../build/CMakeExternals/Install/flann-ios-simulator-i386/lib/*.a")

# message(STATUS "flann(include)         : ${flann_includefiles}")
# message(STATUS "flann(device - lib)    : ${flann_device_libraryfiles}")
# message(STATUS "flann(simulator - lib) : ${flann_simulation_libraryfiles}")

# add_library(
#     ${FRAMEWORK_NAME} SHARED
#     ${flann_device_libraryfiles}
# )
# 
# add_library(
#     ${FRAMEWORK_NAME} SHARED
#     ${flann_simulation_libraryfiles}
# )
# 
###

# qhull
# file(GLOB_RECURSE qhull_includefiles "../build/CMakeExternals/Install/qhull-ios-device/*.h*")
# file(GLOB_RECURSE qhull_device_libraryfiles "../build/CMakeExternals/Install/qhull-ios-device/*.a")
file(GLOB_RECURSE qhull_includefiles "../build/CMakeExternals/Install/qhull-ios-device-arm64/*.h*")
file(GLOB_RECURSE qhull_device_libraryfiles "../build/CMakeExternals/Install/qhull-ios-device-arm64/*.a")
file(GLOB_RECURSE qhull_simulation_libraryfiles "../build/CMakeExternals/Install/qhull-ios-simulator/*.a")
file(GLOB_RECURSE qhull_simulation_i386_libraryfiles "../build/CMakeExternals/Install/qhull-ios-simulator-i386/*.a")

# message(STATUS "qhull(include)         : ${qhull_includefiles}")
# message(STATUS "qhull(device - lib)    : ${qhull_device_libraryfiles}")
# message(STATUS "qhull(simulator - lib) : ${qhull_simulation_libraryfiles}")

# add_library(
#     ${FRAMEWORK_NAME} SHARED
#     ${qhull_device_libraryfiles}
# )
# 
# add_library(
#     ${FRAMEWORK_NAME} SHARED
#     ${qhull_simulation_libraryfiles}
# )
# 
###

# pcl
# file(GLOB_RECURSE pcl_includefiles "../build/CMakeExternals/Install/pcl-ios-device/include/pcl-1.8/*.h*")
# file(GLOB_RECURSE pcl_device_libraryfiles "../build/CMakeExternals/Install/pcl-ios-device/lib/*.a")
file(GLOB_RECURSE pcl_includefiles "../build/CMakeExternals/Install/pcl-ios-device-arm64/include/pcl-1.8/*.h*")
file(GLOB_RECURSE pcl_device_libraryfiles "../build/CMakeExternals/Install/pcl-ios-device-arm64/lib/*.a")
# file(GLOB_RECURSE pcl_device_libraryfiles "../build/CMakeExternals/Install/pcl-ios-device-armv7/lib/*.a")
# file(GLOB_RECURSE pcl_device_libraryfiles "../build/CMakeExternals/Install/pcl-ios-device-armv7s/lib/*.a")
file(GLOB_RECURSE pcl_simulation_libraryfiles "../build/CMakeExternals/Install/pcl-ios-simulator/lib/*.a")
file(GLOB_RECURSE pcl_simulation_i386_libraryfiles "../build/CMakeExternals/Install/pcl-ios-simulator-i386/lib/*.a")

# message(STATUS "pcl(include)         : ${pcl_includefiles}")
# message(STATUS "pcl(device - lib)    : ${pcl_device_libraryfiles}")
# message(STATUS "pcl(simulator - lib) : ${pcl_simulation_libraryfiles}")

# add_library(
#     ${FRAMEWORK_NAME} SHARED
#     ${pcl_device_libraryfiles}
# )
# 
# add_library(
#     ${FRAMEWORK_NAME} SHARED
#     ${pcl_simulation_libraryfiles}
# )
# 
###
# file(GLOB boost_libraryfiles RELATIVE ${CMAKE_BINARY_DIR} *.a)
###

set(CMAKE_SHARED_LINKER_FLAGS "-Wall")

include_directories(../build/CMakeExternals/Install/eigen)

# if (BUILD_IOS_DEVICE)
# set(INCLUDE_DIR
#     ../build/CMakeExternals/Install/boost-ios-device/include
#     ../build/CMakeExternals/Install/flann-ios-device/include
#     ../build/CMakeExternals/Install/qhull-ios-device/include/libqhull
#     ../build/CMakeExternals/Install/qhull-ios-device/include/libqhull_r
#     ../build/CMakeExternals/Install/qhull-ios-device/include/libqhullcpp
#     ../build/CMakeExternals/Install/pcl-ios-device/include/pcl-1.8
# )
if (IOS_PLATFORM STREQUAL "OS")
    set(INCLUDE_DIR
        ../build/CMakeExternals/Install/boost-ios-device-arm64/include
        ../build/CMakeExternals/Install/flann-ios-device-arm64/include
        ../build/CMakeExternals/Install/qhull-ios-device-arm64/include/libqhull
        ../build/CMakeExternals/Install/qhull-ios-device-arm64/include/libqhull_r
        ../build/CMakeExternals/Install/qhull-ios-device-arm64/include/libqhullcpp
        ../build/CMakeExternals/Install/pcl-ios-device-arm64/include/pcl-1.8
    )
elseif (IOS_PLATFORM STREQUAL "SIMULATOR")
    set(INCLUDE_DIR
        ../build/CMakeExternals/Install/boost-ios-simulator-i386/include
        ../build/CMakeExternals/Install/flann-ios-simulator-i386/include
        ../build/CMakeExternals/Install/qhull-ios-simulator-i386/include
        ../build/CMakeExternals/Install/qhull-ios-simulator-i386/include/libqhull
        ../build/CMakeExternals/Install/qhull-ios-simulator-i386/include/libqhull_r
        ../build/CMakeExternals/Install/qhull-ios-simulator-i386/include/libqhullcpp
        ../build/CMakeExternals/Install/pcl-ios-simulator-i386/include/pcl-1.8
    )
elseif (IOS_PLATFORM STREQUAL "SIMULATOR64")
    set(INCLUDE_DIR
        ../build/CMakeExternals/Install/boost-ios-simulator/include
        ../build/CMakeExternals/Install/flann-ios-simulator/include
        ../build/CMakeExternals/Install/qhull-ios-simulator/include
        ../build/CMakeExternals/Install/qhull-ios-simulator/include/libqhull
        ../build/CMakeExternals/Install/qhull-ios-simulator/include/libqhull_r
        ../build/CMakeExternals/Install/qhull-ios-simulator/include/libqhullcpp
        ../build/CMakeExternals/Install/pcl-ios-simulator/include/pcl-1.8
    )
endif ()


target_include_directories(pcl PRIVATE
    ${INCLUDE_DIR}
)

if (IOS_PLATFORM STREQUAL "OS")
    target_link_libraries(${FRAMEWORK_NAME} 
        ${boost_device_libraryfiles}
        ${flann_device_libraryfiles}
        ${qhull_device_libraryfiles}
        ${pcl_device_libraryfiles}
    )
elseif (IOS_PLATFORM STREQUAL "SIMULATOR")
    target_link_libraries(${FRAMEWORK_NAME} 
        ${boost_simulation_i386_libraryfiles}
        ${flann_simulation_i386_libraryfiles}
        ${qhull_simulation_i386_libraryfiles}
        ${pcl_simulation_i386_libraryfiles}
    )
elseif (IOS_PLATFORM STREQUAL "SIMULATOR64")
    target_link_libraries(${FRAMEWORK_NAME} 
        ${boost_simulation_libraryfiles}
        ${flann_simulation_libraryfiles}
        ${qhull_simulation_libraryfiles}
        ${pcl_simulation_libraryfiles}
    )
endif ()

# https://cmake.org/cmake/help/v3.10/prop_tgt/FRAMEWORK.html
# set_target_properties(${FRAMEWORK_NAME} PROPERTIES
#     FRAMEWORK TRUE
#     FRAMEWORK_VERSION A
#     MACOSX_FRAMEWORK_IDENTIFIER ${FRAMEWORK_BUNDLE_IDENTIFIER}
#     MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_LIST_DIR}/framework.plist.in
#     # info_plist properties
#     # MACOSX_FRAMEWORK_BUNDLE_VERSION
#     # MACOSX_FRAMEWORK_ICON_FILE ${FRAMEWORK_ICON_FILE}
#     # MACOSX_FRAMEWORK_SHORT_VERSION_STRING 1.0.0
#     # "current version" in semantic format in Mach-O binary file
#     VERSION 1.0.0
#     # "compatibility version" in semantic format in Mach-O binary file
#     SOVERSION 1.0.0
#     PUBLIC_HEADER "${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryWrapper.hpp"
#     # XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET}
#     XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${CODE_SIGN_IDENTITY}
#     # XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM_ID}
#     # XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${DEVICE_FAMILY}
#     # XCODE_ATTRIBUTE_SKIP_INSTALL "YES"
# )

if (IOS_PLATFORM STREQUAL "OS")
set_target_properties(${FRAMEWORK_NAME} PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A
    MACOSX_FRAMEWORK_IDENTIFIER com.sirokujira.framework
    # MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_LIST_DIR}/framework.plist
    MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_LIST_DIR}/framework.plist.in
    # "current version" in semantic format in Mach-O binary file
    VERSION 1.0.0
    # "compatibility version" in semantic format in Mach-O binary file
    SOVERSION 1.0.0
    PUBLIC_HEADER "${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryWrapper.hpp;${CMAKE_CURRENT_LIST_DIR}/vertex.h"
    XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET}
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${DEVICE_FAMILY}
    XCODE_ATTRIBUTE_SKIP_INSTALL "YES"
)
elseif (IOS_PLATFORM STREQUAL "SIMULATOR")
set_target_properties(${FRAMEWORK_NAME} PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A
    MACOSX_FRAMEWORK_IDENTIFIER com.sirokujira.framework
    MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_LIST_DIR}/framework.plist.in
    # "current version" in semantic format in Mach-O binary file
    VERSION 1.0.0
    # "compatibility version" in semantic format in Mach-O binary file
    SOVERSION 1.0.0
    PUBLIC_HEADER "${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryWrapper.hpp;${CMAKE_CURRENT_LIST_DIR}/vertex.h"
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${DEVICE_FAMILY}
    XCODE_ATTRIBUTE_SKIP_INSTALL "YES"
)
elseif (IOS_PLATFORM STREQUAL "SIMULATOR64")
set_target_properties(${FRAMEWORK_NAME} PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A
    MACOSX_FRAMEWORK_IDENTIFIER com.sirokujira.framework
    MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_LIST_DIR}/framework.plist.in
    # "current version" in semantic format in Mach-O binary file
    VERSION 1.0.0
    # "compatibility version" in semantic format in Mach-O binary file
    SOVERSION 1.0.0
    PUBLIC_HEADER "${CMAKE_CURRENT_LIST_DIR}/PointCloudLibraryWrapper.hpp;${CMAKE_CURRENT_LIST_DIR}/vertex.h"
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${DEVICE_FAMILY}
    XCODE_ATTRIBUTE_SKIP_INSTALL "YES"
)
endif ()

###
# toolchain macro
# set_xcode_property(${FRAMEWORK_NAME} CLANG_CXX_LANGUAGE_STANDARD "c++11")
# set_xcode_property(${FRAMEWORK_NAME} CLANG_CXX_LIBRARY "libc++")

# https://cmake.org/cmake/help/v3.1/prop_tgt/XCODE_ATTRIBUTE_an-attribute.html
# To disable bitcode:
set_target_properties(${FRAMEWORK_NAME} PROPERTIES XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")
# if (IOS_PLATFORM)
#     if (IOS_PLATFORM eq SIMULATOR64)
#         set_target_properties(${FRAMEWORK_NAME} PROPERTIES XCODE_ATTRIBUTE_VALID_ARCHS "x86_64")
#     endif()
# endif()

# -ObjC++
# Symbol visibility setup, COMPILE_FLAGS only affect C++ so for Objective C we
# have to use XCODE_ATTRIBUTE_OTHER_CFLAGS.
set_target_properties(${FRAMEWORK_NAME} PROPERTIES
    COMPILE_FLAGS "-fvisibility=hidden -fvisibility-inlines-hidden"
    XCODE_ATTRIBUTE_OTHER_CFLAGS "-fvisibility=hidden -fvisibility-inlines-hidden")

# set_target_properties(pcl PROPERTIES COMPILE_FLAGS "-x c++")

