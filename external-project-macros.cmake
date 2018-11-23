
#
# force build macro
#
macro(force_build proj)
  ExternalProject_Add_Step(${proj} forcebuild
    COMMAND ${CMAKE_COMMAND} -E remove ${base}/Stamp/${proj}/${proj}-build
    DEPENDEES configure
    DEPENDERS build
    ALWAYS 1
  )
endmacro()

macro(get_toolchain_file tag)
  string(REPLACE "-" "_" tag_with_underscore ${tag})
  set(toolchain_file ${toolchain_${tag_with_underscore}})
endmacro()

macro(get_compiler_c_tool tag)
  string(REPLACE "-" "_" tag_with_underscore ${tag})
  set(compiler_c_tool ${compiler_c_tool_${tag_with_underscore}})
endmacro()

macro(get_compiler_cpp_tool tag)
  string(REPLACE "-" "_" tag_with_underscore ${tag})
  set(compiler_cpp_tool ${compiler_cpp_tool_${tag_with_underscore}})
endmacro()

macro(get_try_run_results_file tag)
  string(REPLACE "-" "_" tag_with_underscore ${tag})
  set(try_run_results_file ${try_run_results_${tag_with_underscore}})
endmacro()

#
# Eigen fetch and install
#
macro(install_eigen)
  set(eigen_url http://bitbucket.org/eigen/eigen/get/3.3.4.tar.bz2)
  ExternalProject_Add(
    eigen
    SOURCE_DIR ${source_prefix}/eigen
    URL ${eigen_url}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory "${source_prefix}/eigen/Eigen" "${install_prefix}/eigen/Eigen" && ${CMAKE_COMMAND} -E copy_directory "${source_prefix}/eigen/unsupported" "${install_prefix}/eigen/unsupported"
  )
endmacro()


# FLANN fetch
macro(fetch_flann)
  ExternalProject_Add(
    flann-fetch
    SOURCE_DIR ${source_prefix}/flann
    GIT_REPOSITORY git://github.com/mariusmuja/flann
    # old(no use LZ4?)
    # GIT_TAG cee08ec38a8df7bc70397f10a4d30b9b33518bb4
    # use LZ4?
    # build NG(check : ndk14r)
    # GIT_TAG 1.8.4
    # GIT_TAG 1.8.5
    GIT_TAG 1.9.1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# FLANN crosscompile
#
macro(crosscompile_flann tag)
  set(proj flann-${tag})
  get_toolchain_file(${tag})

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/flann
    DOWNLOAD_COMMAND ""
    DEPENDS flann-fetch
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
               -DCMAKE_BUILD_TYPE:STRING=${build_type}
               -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
               -DANDROID_ABI=$ENV{ANDROID_ABIs}
               -DANDROID_NATIVE_API_LEVEL=$ENV{ANDROID_TARGET_API}
               -DANDROID_TOOLCHAIN=$ENV{TARGET_COMPILER}
               -DANDROID_TOOLCHAIN_NAME=$ENV{TOOLCHAIN_NAME}
               -DANDROID_STL=c++_static
               -DANDROID_STL_FORCE_FEATURES:BOOL=ON
               -DBUILD_EXAMPLES:BOOL=OFF
               -DBUILD_TESTS:BOOL=OFF
               -DBUILD_DOC:BOOL=OFF
               -DBUILD_C_BINDINGS:BOOL=OFF
               -DBUILD_PYTHON_BINDINGS:BOOL=OFF
               -DBUILD_MATLAB_BINDINGS:BOOL=OFF
               -DBUILD_SHARED_LIBS:BOOL=OFF
  )

  force_build(${proj})
endmacro()


# qhull fetch
macro(fetch_qhull)
  ExternalProject_Add(
    qhull-fetch
    SOURCE_DIR ${source_prefix}/qhull
    GIT_REPOSITORY git://github.com/Sirokujira/qhull.git
    # iOS build error[link static libraries error(execute to target_link)]
    # GIT_REPOSITORY git://github.com/qhull/qhull.git
    # GIT_TAG master
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# qhull crosscompile
#
macro(crosscompile_qhull tag)
  set(proj qhull-${tag})
  get_toolchain_file(${tag})

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/qhull
    DOWNLOAD_COMMAND ""
    DEPENDS qhull-fetch
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
               -DCMAKE_BUILD_TYPE:STRING=${build_type}
               -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
               -DANDROID_ABI=$ENV{ANDROID_ABIs}
               -DANDROID_NATIVE_API_LEVEL=$ENV{ANDROID_TARGET_API}
               -DANDROID_TOOLCHAIN=$ENV{TARGET_COMPILER}
               -DANDROID_TOOLCHAIN_NAME=$ENV{TOOLCHAIN_NAME}
               -DANDROID_STL=c++_static
               -DANDROID_STL_FORCE_FEATURES:BOOL=ON
               -DBUILD_SHARED_LIBS:BOOL=ON
               -DQhull_BUILD_QHULL_BINARIES:BOOL=OFF
               -DBUILD_PYTHON_BINDINGS:BOOL=OFF
               -DBUILD_MATLAB_BINDINGS:BOOL=OFF
  )

  force_build(${proj})
endmacro()

#
# Boost fetch
#
macro(fetch_boost)
  ExternalProject_Add(
    boost-fetch
    SOURCE_DIR ${source_prefix}/boost
    # Based 1.60.0
    GIT_REPOSITORY git://github.com/Sirokujira/boost-build.git
    GIT_TAG origin/master
    # official(not cmake file)
    # GIT_REPOSITORY git://github.com/boostorg/boost.git
    # 1.8.1?
    # GIT_TAG boost-1.64.0
    # 1.9.0
    # GIT_TAG boost-1.68.0
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# Boost crosscompile
#
macro(crosscompile_boost tag)
  set(proj boost-${tag})
  get_toolchain_file(${tag})

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/boost
    DOWNLOAD_COMMAND ""
    DEPENDS boost-fetch
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
      -DANDROID_ABI=$ENV{ANDROID_ABIs}
      -DANDROID_NATIVE_API_LEVEL=$ENV{ANDROID_TARGET_API}
      -DANDROID_TOOLCHAIN=$ENV{TARGET_COMPILER}
      -DANDROID_TOOLCHAIN_NAME=$ENV{TOOLCHAIN_NAME}
      # https://developer.android.com/ndk/guides/cpp-support.html
      # boost error
      # https://github.com/android-ndk/ndk/issues/442
      # https://github.com/android-ndk/ndk/issues/480
      -DANDROID_STL=c++_static
      # ndk r14
      # -D_FILE_OFFSET_BITS=64
      -DANDROID_STL_FORCE_FEATURES:BOOL=ON
      -DBUILD_SHARED_LIBS:BOOL=OFF
  )

  force_build(${proj})
endmacro()

#
# Boost crosscompile(use b2.exe)
#
macro(crosscompile_boost_on_b2 tag)
  set(proj boost-${tag})

  if (${tag} eq "android")
    # ./b2 toolset=$ENV{TARGET_COMPILER} cxxflags="-stdlib=libc++" threading=multi threadapi=pthread link=shared runtime-link=shared -j 6
    execute_process(
      # NDK not support gcc
      # COMMAND ./b2 toolset=gcc-android4.9 link=static runtime-link=static target-os=linux -stagedir
      COMMAND ./b2 toolset=clang-android3.6 link=static runtime-link=static target-os=linux -stagedir
      WORKING_DIRECTORY ${source_prefix}/boost
    )
  endif()
  if (${tag} eq "ios-device")
    execute_process(
      COMMAND ./b2 toolset=$ENV{TARGET_COMPILER} cflags="-arch arm64 -fvisibility=default -miphoneos-version-min=8.0" architecture=arm target-os=iphone link=static threading=multi define=_LITTLE_ENDIAN include=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.3.sdk/usr/include/
      WORKING_DIRECTORY ${source_prefix}/boost
    )
  endif()
  if(${tag} eq "ios-simulator")
    execute_process(
      COMMAND ./b2 toolset=$ENV{TARGET_COMPILER} cflags="-arch i386 -fvisibility=default -miphoneos-version-min=8.0" architecture=arm target-os=iphone link=static threading=multi define=_LITTLE_ENDIAN include=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.3.sdk/usr/include/
      WORKING_DIRECTORY ${source_prefix}/boost
    )
  endif()

  # ./b2 toolset=$ENV{TARGET_COMPILER} cflags="-arch arm64 -fvisibility=default -miphoneos-version-min=5.0" architecture=arm target-os=iphone link=static threading=multi define=_LITTLE_ENDIAN include=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.3.sdk/usr/include/
  # --prefix=(インストールしたいディレクトリ)

endmacro()


#
# PCL fetch
#
macro(fetch_pcl)
  ExternalProject_Add(
    pcl-fetch
    SOURCE_DIR ${source_prefix}/pcl
    GIT_REPOSITORY git://github.com/PointCloudLibrary/pcl.git
    GIT_TAG pcl-1.9.0
    # BUild NG : (Boost)
    # GIT_TAG pcl-1.9.0
    # Test
    # GIT_REPOSITORY git://github.com/Sirokujira/pcl.git
    # GIT_TAG Branch_pcl-1.8.1
    # GIT_REPOSITORY git://github.com/patmarion/PCL.git
    # GIT_TAG origin/android-tag
    # GIT_TAG origin/master
    # End
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# PCL crosscompile
# 
# reference windows base settings.
# https://gist.github.com/UnaNancyOwen/59319050d53c137ca8f3#file-pcl1-8-1-md
macro(crosscompile_pcl tag)
  set(proj pcl-${tag})
  get_toolchain_file(${tag})
  get_try_run_results_file(${proj})

  # copy the toolchain file and append the boost install dir to CMAKE_FIND_ROOT_PATH
  # set(original_toolchain_file ${toolchain_file})
  # get_filename_component(toolchain_file ${original_toolchain_file} NAME)
  # set(toolchain_file ${build_prefix}/${proj}/${toolchain_file})
  # configure_file(${original_toolchain_file} ${toolchain_file} COPYONLY)
  # file(APPEND ${toolchain_file}
  #   "\nlist(APPEND CMAKE_FIND_ROOT_PATH ${install_prefix}/boost-${tag})\n")

  # octree_base.hpp: warning: taking the max of a value and unsigned zero is always equal to the other value [-Wmax-unsigned-zero]
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${source_prefix}/pcl
    DOWNLOAD_COMMAND ""
    # DEPENDS pcl-fetch boost-${tag} flann-${tag} eigen
    DEPENDS pcl-fetch boost-${tag} flann-${tag} qhull-${tag} eigen
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
      # Android Build Parameters
      -DANDROID_ABI=$ENV{ANDROID_ABIs}
      -DANDROID_NATIVE_API_LEVEL=$ENV{ANDROID_TARGET_API}
      -DANDROID_TOOLCHAIN=$ENV{TARGET_COMPILER}
      -DANDROID_STL=c++_static
      -DANDROID_STL_FORCE_FEATURES:BOOL=ON
      -DBUILD_SHARED_LIBS:BOOL=OFF
      -DPCL_SHARED_LIBS:BOOL=OFF
      -DPCL_ENABLE_SSE:BOOL=OFF
      # Set Off Parameter(On : CMake Error)
      -DWITH_CUDA:BOOL=OFF
      -DWITH_OPENGL:BOOL=OFF
      -DWITH_FZAPI:BOOL=OFF
      -DWITH_LIBUSB:BOOL=OFF
      -DWITH_OPENNI:BOOL=OFF
      -DWITH_OPENNI2:BOOL=OFF
      -DWITH_PCAP:BOOL=OFF
      -DWITH_PNG:BOOL=OFF
      # iOS Error(on : multi arch build ng -> single arch parameter ok.)
      # -DWITH_QHULL:BOOL=OFF
      -DWITH_QHULL:BOOL=ON
      -DWITH_QT:BOOL=OFF
      -DWITH_VTK:BOOL=OFF
      -DBUILD_CUDA:BOOL=OFF
      -DBUILD_GPU:BOOL=OFF
      -DBUILD_OPENNI:BOOL=OFF
      -DBUILD_OPENNI2:BOOL=OFF
      -DBUILD_all_in_one_installer:BOOL=OFF
      -DBUILD_apps:BOOL=OFF
      -DBUILD_common:BOOL=ON
      -DBUILD_example:BOOL=OFF
      -DBUILD_features:BOOL=ON
      -DBUILD_geometry:BOOL=ON
      -DBUILD_global_tests:BOOL=OFF
      -DBUILD_io:BOOL=ON
      -DBUILD_kdtree:BOOL=ON
      -DBUILD_keypoints:BOOL=ON
      # use vtk?
      # depend sample_consensus
      -DBUILD_filters:BOOL=ON
      -DBUILD_recognition:BOOL=ON
      -DBUILD_registration:BOOL=ON
      # over TestCI build time(50 min)
      # local environment build case(on set).
      # start setting
      -DBUILD_sample_consensus:BOOL=ON
      # -DBUILD_sample_consensus:BOOL=OFF
      # -DBUILD_surface_on_nurbs:BOOL=ON
      -DBUILD_surface_on_nurbs:BOOL=OFF
      # -DBUILD_outofcore:BOOL=ON
      -DBUILD_outofcore:BOOL=OFF
      # -DBUILD_people:BOOL=ON
      -DBUILD_people:BOOL=OFF
      # -DBUILD_tools:BOOL=ON
      -DBUILD_tools:BOOL=OFF
      # -DBUILD_tracking:BOOL=ON
      -DBUILD_tracking:BOOL=OFF
      # end setting
      -DBUILD_search:BOOL=ON
      -DBUILD_segmentation:BOOL=ON
      -DBUILD_surface:BOOL=ON
      -DBUILD_visualization:BOOL=OFF
      -DBUILD_examples:BOOL=OFF
      # use pcl cmake paths
      -DEIGEN_INCLUDE_DIR:PATH=${install_prefix}/eigen
      -DFLANN_ROOT:PATH=${install_prefix}/flann-${tag}
      # use pcl cmake paths
      -DFLANN_INCLUDE_DIR:PATH=${install_prefix}/flann-${tag}/include
      -DFLANN_LIBRARY:FILEPATH=${install_prefix}/flann-${tag}/lib/libflann_cpp_s.a
      -DFLANN_LIBRARY_DEBUG:FILEPATH=${install_prefix}/flann-${tag}/lib/libflann_cpp_s-gd.lib
      -DQHULL_ROOT:PATH=${install_prefix}/qhull-${tag}
      -DQHULL_INCLUDE_DIR:PATH=${install_prefix}/qhull-${tag}/include
      # -DQHULL_INCLUDE_DIRS:PATH=${install_prefix}/qhull-${tag}/include
      # libqhullcpp.a libqhullstatic.a libqhullstatic_r.a
      # 1.9.0?
      # -DBOOSTROOT:PATH=${install_prefix}/boost-${tag}
      # 1.8.1
      -DBOOST_ROOT:PATH=${install_prefix}/boost-${tag}
      -DBOOST_INCLUDEDIR:PATH=${install_prefix}/boost-${tag}/include
      -DBOOST_LIBRARYDIR:PATH=${install_prefix}/boost-${tag}/lib
      -DBoost_INCLUDE_DIR:PATH=${install_prefix}/boost-${tag}/include
      -DBoost_LIBRARY_DIRS:PATH=${install_prefix}/boost-${tag}/lib
      # http://pointclouds.org/documentation/tutorials/building_pcl.php
      -DBoost_SYSTEM_LIBRARY:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_system.a
      -DBoost_SYSTEM_LIBRARY_DEBUG:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_system-gd.a
      -DBoost_SYSTEM_LIBRARY_RELEASE:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_system.a
      -DBoost_FILESYSTEM_LIBRARY:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_filesystem.a
      -DBoost_FILESYSTEM_LIBRARY_DEBUG:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_filesystem-gd.a
      -DBoost_FILESYSTEM_LIBRARY_RELEASE:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_filesystem.a
      -DBoost_THREAD_LIBRARY:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_thread.a
      -DBoost_THREAD_LIBRARY_DEBUG:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_thread-gd.a
      -DBoost_THREAD_LIBRARY_RELEASE:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_thread.a
      -DBoost_DATE_TIME_LIBRARY:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_date_time.a
      -DBoost_DATE_TIME_LIBRARY_DEBUG:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_date_time-gd.a
      -DBoost_DATE_TIME_LIBRARY_RELEASE:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_date_time.a
      -DBoost_IOSTREAMS_LIBRARY:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_iostreams.a
      -DBoost_IOSTREAMS_LIBRARY_DEBUG:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_iostreams-gd.a
      -DBoost_IOSTREAMS_LIBRARY_RELEASE:FILEPATH=${install_prefix}/boost-${tag}/lib/libboost_iostreams.a
      # must not delete
      -C ${try_run_results_file}
  )

  force_build(${proj})
endmacro()


#
# ios device wrapper compile
# 
macro(ios_device_wrapper_compile)
  set(proj ios_device_wrapper)
  get_toolchain_file("ios-device")

  # framework.plist setting
  set(FRAMEWORK_NAME "pcl")                                     # <== Set to your framework's name
  set(FRAMEWORK_BUNDLE_IDENTIFIER "com.sirokujira.framework")   # <== Set to your framework's bundle identifier (cannot be the same as app bundle identifier)
  # set(CODE_SIGN_IDENTITY "iPhone Developer")                  # <== Set to your preferred code sign identity, to see list:
  #                                                             # /usr/bin/env xcrun security find-identity -v -p codesigning
  set(CODESIGNIDENTITY "iPhone Developer")
  set(DEPLOYMENT_TARGET 8.0)                                    # <== Set your deployment target version of iOS
  set(DEVICE_FAMILY "1,2")                                      # <== Set to "1" to target iPhone, set to "2" to target iPad, set to "1,2" to target both
  set(DEVELOPMENT_TEAM_ID "AAAAAAAA")                           # <== Set to your team ID from Apple

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/iOSWrapper
    DOWNLOAD_COMMAND ""
    # CMAKE_GENERATOR "Xcode"
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
  )

  # set before?
  add_custom_command(
      TARGET
      ${FRAMEWORK_NAME}
      POST_BUILD
      COMMAND /bin/sh -c
      COMMAND ${CMAKE_SOURCE_DIR}/makeFramework.sh device
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS pcl-ios-device
      COMMENT "Creating device pcl.framework")

  # force_build(${proj})

  # All is UnixMakefile only?
  # add_custom_target(pclFramework ALL
  # add_custom_target(pclFramework
  #     COMMAND ${CMAKE_SOURCE_DIR}/makeFramework.sh device
  #     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  #     DEPENDS pcl-ios-device
  #     COMMENT "Creating device pcl.framework")
  # add_custom_command(
  #     TARGET
  #     ${FRAMEWORK_NAME}
  #     POST_BUILD
  #     COMMAND /bin/sh -c
  #     COMMAND ${CMAKE_SOURCE_DIR}/makeFramework.sh device
  #     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  #     DEPENDS pcl-ios-device
  #     COMMENT "Creating device pcl.framework")
  
  # # Codesign the framework in it's new spot
  # add_custom_command(
  #     TARGET
  #     ${FRAMEWORK_NAME}
  #     POST_BUILD COMMAND /bin/sh -c
  #     \"COMMAND_DONE=0 \;
  #     if codesign --force --verbose
  #         ${CMAKE_BINARY_DIR}/CMakeExternals/Install/frameworks-device/pcl.framework
  #         --sign ${CODE_SIGN_IDENTITY}
  #         \&\>/dev/null \; then
  #         COMMAND_DONE=1 \;
  #     fi \;
  #     if codesign --force --verbose
  #         \${BUILT_PRODUCTS_DIR}/frameworks-device/pcl.framework
  #         --sign ${CODE_SIGN_IDENTITY}
  #         \&\>/dev/null \; then
  #         COMMAND_DONE=1 \;
  #     fi \;
  #     if [ \\$$COMMAND_DONE -eq 0 ] \; then
  #         echo Framework codesign failed \;
  #         exit 1 \;
  #     fi\"
  # )

endmacro()

#
# ios simulator wrapper compile
# 
macro(ios_simulator_wrapper_compile)
  set(proj ios_simulator_wrapper)
  get_toolchain_file("ios-simulator")

  # framework.plist setting
  set(FRAMEWORK_NAME "pcl")                                     # <== Set to your framework's name
  set(FRAMEWORK_BUNDLE_IDENTIFIER "com.sirokujira.framework")   # <== Set to your framework's bundle identifier (cannot be the same as app bundle identifier)
  # set(CODE_SIGN_IDENTITY "iPhone Developer")                  # <== Set to your preferred code sign identity, to see list:
  #                                                             # /usr/bin/env xcrun security find-identity -v -p codesigning
  set(CODESIGNIDENTITY "iPhone Developer")
  set(DEPLOYMENT_TARGET 8.0)                                    # <== Set your deployment target version of iOS
  set(DEVICE_FAMILY "1,2")                                      # <== Set to "1" to target iPhone, set to "2" to target iPad, set to "1,2" to target both
  set(DEVELOPMENT_TEAM_ID "AAAAAAAA")                           # <== Set to your team ID from Apple

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/iOSWrapper
    DOWNLOAD_COMMAND ""
    # CMAKE_GENERATOR "Xcode"
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${build_type}
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file}
  )

  message(STATUS "binary_dir : ${CMAKE_BINARY_DIR}")

  # set before?
  add_custom_command(
      TARGET
      ${FRAMEWORK_NAME}
      POST_BUILD
      COMMAND /bin/sh -c
      COMMAND ${CMAKE_SOURCE_DIR}/makeFramework.sh simulator
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS pcl-ios-simulator
      COMMENT "Creating simulator pcl.framework")

  # force_build(${proj})

  # All is UnixMakefile only?
  # add_custom_target(pclFramework ALL
  # add_custom_target(pclFramework
  #     COMMAND ${CMAKE_SOURCE_DIR}/makeFramework.sh simulator
  #     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  #     DEPENDS pcl-ios-simulator
  #     COMMENT "Creating simulator pcl.framework")

  # add_custom_command(
  #     TARGET
  #     ${FRAMEWORK_NAME}
  #     POST_BUILD
  #     COMMAND /bin/sh -c
  #     COMMAND ${CMAKE_SOURCE_DIR}/makeFramework.sh simulator
  #     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  #     DEPENDS pcl-ios-simulator
  #     COMMENT "Creating device pcl.framework")

  # # Codesign the framework in it's new spot
  # add_custom_command(
  #     TARGET
  #     ${FRAMEWORK_NAME}
  #     POST_BUILD COMMAND /bin/sh -c
  #     \"COMMAND_DONE=0 \;
  #     if codesign --force --verbose
  #         ${CMAKE_BINARY_DIR}/CMakeExternals/Install/frameworks-simulator/pcl.framework
  #         --sign ${CODE_SIGN_IDENTITY}
  #         \&\>/dev/null \; then
  #         COMMAND_DONE=1 \;
  #     fi \;
  #     if codesign --force --verbose
  #         \${BUILT_PRODUCTS_DIR}/frameworks-simulator/pcl.framework
  #         --sign ${CODE_SIGN_IDENTITY}
  #         \&\>/dev/null \; then
  #         COMMAND_DONE=1 \;
  #     fi \;
  #     if [ \\$$COMMAND_DONE -eq 0 ] \; then
  #         echo Framework codesign failed \;
  #         exit 1 \;
  #     fi\"
  # )

endmacro()

macro(create_pcl_framework)
    add_custom_target(pclFramework ALL
      COMMAND ${CMAKE_SOURCE_DIR}/makeFramework.sh pcl
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      # DEPENDS pcl-ios-device pcl-ios-simulator
      DEPENDS pcl-ios-device
      COMMENT "Creating pcl.framework")
endmacro()

