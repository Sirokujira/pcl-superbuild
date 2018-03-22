#!/bin/bash

#------------------------------------------------------------------------------
install=./CMakeExternals/Install
if [ ! -d $install ]; then
  echo "Install directory not found.  This script should be run from the top level build directory that contains CMakeExternals/Install."
  exit 1
fi

#------------------------------------------------------------------------------
make_pcl_framework ()
{
  # device_folder = "ios-device"
  # simulator_folder = "ios-simulator"

  # pcl_device_libs=`find $install/pcl-${device_folder} $install/flann-${device_folder} $install/boost-${device_folder} -name *.a`
  pcl_device_libs=`find $install/pcl-ios-device -name *.a`
  boost_device_libs=`find $install/boost-ios-device -name *.a`
  flann_device_libs=`find $install/flann-ios-device -name *.a`
  # pcl_sim_libs=`find $install/pcl-${simulator_folder} $install/flann-${simulator_folder} $install/boost-${simulator_folder} -name *.a`
  pcl_sim_libs=`find $install/pcl-ios-simulator -name *.a`
  boost_sim_libs=`find $install/boost-ios-simulator -name *.a`
  flann_sim_libs=`find $install/flann-ios-simulator -name *.a`

  # args -> version
  # version 1.7
  # pcl_header_dir=$install/pcl-${device_folder}/include/pcl-1.7
  # version 1.8
  pcl_header_dir=$install/pcl-ios-device/include/pcl-1.8
  boost_header_dir=$install/boost-ios-device/include
  eigen_header_dir=$install/eigen
  flann_header_dir=$install/flann-ios-device/include
  qhull_header_dir=$install/qhull-ios-device/include

  pcl_framework=$install/frameworks/pcl.framework
  mkdir -p $pcl_framework
  rm -rf $pcl_framework/*

  # Public Header
  mkdir $pcl_framework/Headers
  cp -R $pcl_header_dir/* $pcl_framework/Headers/
  cp -R $boost_header_dir/* $pcl_framework/Headers/
  cp -R $eigen_header_dir/* $pcl_framework/Headers/
  cp -R $flann_header_dir/* $pcl_framework/Headers/

  # mkdir $pcl_framework/Modules
  # cp module.modulemap $pcl_framework/Modules/

  libtool -static -o $pcl_framework/pcl_device $pcl_device_libs $boost_device_libs $flann_device_libs
  libtool -static -o $pcl_framework/pcl_sim $pcl_sim_libs $boost_sim_libs $flann_sim_libs

  # 
  # lipo -create $pcl_framework/pcl_device -output $pcl_framework/pcl
  # lipo -create $pcl_framework/pcl_sim -output $pcl_framework/pcl
  lipo -create $pcl_framework/pcl_device $pcl_framework/pcl_sim -output $pcl_framework/pcl

  # remove tmp library files
  rm $pcl_framework/pcl_*
}


#------------------------------------------------------------------------------
make_pcl_framework_device ()
{
  # Xcode device Wrapper
  current_pcl_ios_device_framework=../iOSWrapper/build.ios/Release-iphoneos/pcl.framework

  # Step 1. Build Device and Simulator versions complete
  # common
  pcl_device_libs=`find $install/pcl-ios-device -name *.a`
  boost_device_libs=`find $install/boost-ios-device -name *.a`
  flann_device_libs=`find $install/flann-ios-device -name *.a`
  qhull_device_libs=`find $install/qhull-ios-device -name *.a`
  # arm64
  pcl_device_arm64_libs=`find $install/pcl-ios-device-arm64 -name *.a`
  boost_device_arm64_libs=`find $install/boost-ios-device-arm64 -name *.a`
  flann_device_arm64_libs=`find $install/flann-ios-device-arm64 -name *.a`
  qhull_device_arm64_libs=`find $install/qhull-ios-device-arm64 -name *.a`
  # armv7
  pcl_device_armv7_libs=`find $install/pcl-ios-device-armv7 -name *.a`
  boost_device_armv7_libs=`find $install/boost-ios-device-armv7 -name *.a`
  flann_device_armv7_libs=`find $install/flann-ios-device-armv7 -name *.a`
  qhull_device_armv7_libs=`find $install/qhull-ios-device-armv7 -name *.a`
  # armv7s
  pcl_device_armv7s_libs=`find $install/pcl-ios-device-armv7s -name *.a`
  boost_device_armv7s_libs=`find $install/boost-ios-device-armv7s -name *.a`
  flann_device_armv7s_libs=`find $install/flann-ios-device-armv7s -name *.a`
  qhull_device_armv7s_libs=`find $install/qhull-ios-device-armv7s -name *.a`

  # args -> version
  # common
  # version 1.8
  pcl_header_dir=$install/pcl-ios-device/include/pcl-1.8
  boost_header_dir=$install/boost-ios-device/include
  eigen_header_dir=$install/eigen
  flann_header_dir=$install/flann-ios-device/include
  qhull_header_dir=$install/qhull-ios-device/include
  # ioswrapper_header_dir=$install/ios_device_wrapper/include
  # arm64
  pcl_arm64_header_dir=$install/pcl-ios-device-arm64/include/pcl-1.8
  boost_arm64_header_dir=$install/boost-ios-device-arm64/include
  eigen_arm64_header_dir=$install/eigen
  flann_arm64_header_dir=$install/flann-ios-device-arm64/include
  qhull_arm64_header_dir=$install/qhull-ios-device-arm64/include
  # ioswrapper_header_dir=$install/ios_device_wrapper/include

  # Step 2. Copy the framework structure (from iphoneos build) to the device folder
  pcl_framework=$install/frameworks-device/pcl.framework
  mkdir -p ${pcl_framework}
  rm -rf $pcl_framework/*

  cp -R "${current_pcl_ios_device_framework}" "${pcl_framework}/.."

  # mkdir $pcl_framework/Headers
  # common
  cp -R $pcl_header_dir/* $pcl_framework/Headers/ 2>&1
  cp -R $boost_header_dir/* $pcl_framework/Headers/ 2>&1
  cp -R $eigen_header_dir/* $pcl_framework/Headers/ 2>&1
  cp -R $flann_header_dir/* $pcl_framework/Headers/ 2>&1
  cp -R $qhull_header_dir/* $pcl_framework/Headers/ 2>&1
  # cp -R $ioswrapper_header_dir/* $pcl_framework/Headers/
  # arm64
  cp -R $pcl_arm64_header_dir/* $pcl_framework/Headers/ 2>&1
  cp -R $boost_arm64_header_dir/* $pcl_framework/Headers/ 2>&1
  cp -R $eigen_arm64_header_dir/* $pcl_framework/Headers/ 2>&1
  cp -R $flann_arm64_header_dir/* $pcl_framework/Headers/ 2>&1
  cp -R $qhull_arm64_header_dir/* $pcl_framework/Headers/ 2>&1

  # mkdir $pcl_framework/Modules
  cp ../iOSWrapper/module.modulemap $pcl_framework/

  # combine libraries
  # libtool -static -o $pcl_framework/pcl_device $pcl_device_libs $boost_device_libs $flann_device_libs $qhull_device_libs $current_pcl_ios_device_framework/pcl
  libtool -static -o $pcl_framework/pcl_device $pcl_device_arm64_libs $boost_arm64_device_libs $flann_arm64_device_libs $qhull_arm64_device_libs $pcl_device_armv7_libs $boost_armv7_device_libs $flann_armv7_device_libs $qhull_armv7_device_libs $pcl_device_armv7s_libs $boost_armv7s_device_libs $flann_armv7s_device_libs $qhull_armv7s_device_libs $current_pcl_ios_device_framework/pcl

  # combine Xcode generator frameworks and external build libraries
  lipo -create -output $pcl_framework/pcl $pcl_framework/pcl_device

  # remove tmp library files
  rm -rf $pcl_framework/pcl_*
}

make_pcl_framework_simulator ()
{
  # Xcode simulation Wrapper
  current_pcl_ios_sim_framework=../iOSWrapper/build.sim64/Release-iphonesimulator/pcl.framework
  # current_pcl_ios_sim_i386_framework=../iOSWrapper/build.sim/Release-iphonesimulator/pcl.framework

  pcl_sim_libs=`find $install/pcl-ios-simulator -name *.a`
  boost_sim_libs=`find $install/boost-ios-simulator -name *.a`
  flann_sim_libs=`find $install/flann-ios-simulator -name *.a`
  qhull_sim_libs=`find $install/qhull-ios-simulator -name *.a`

  # x86_64
  # pcl_sim_x86_64_libs=`find $install/pcl-ios-simulator-x86-64 -name *.a`
  # boost_sim_x86_64_libs=`find $install/boost-ios-simulator-x86-64 -name *.a`
  # flann_sim_x86_64_libs=`find $install/flann-ios-simulator-x86-64 -name *.a`
  # qhull_sim_x86_64_libs=`find $install/qhull-ios-simulator-x86-64 -name *.a`
  # i386
  # pcl_sim_i386_libs=`find $install/pcl-ios-simulator-i386 -name *.a`
  # boost_sim_i386_libs=`find $install/boost-ios-simulator-i386 -name *.a`
  # flann_sim_i386_libs=`find $install/flann-ios-simulator-i386 -name *.a`
  # qhull_sim_i386_libs=`find $install/qhull-ios-simulator-i386 -name *.a`

  # args -> version
  # version 1.8
  pcl_header_dir=$install/pcl-ios-simulator/include/pcl-1.8
  boost_header_dir=$install/boost-ios-simulator/include
  eigen_header_dir=$install/eigen
  flann_header_dir=$install/flann-ios-simulator/include
  qhull_header_dir=$install/qhull-ios-simulator/include
  # ioswrapper_header_dir=$install/ioswrapper-ios-simulator/include

  # Step 3. Copy the framework structure (from iphoneos-simulator build) to the device folder
  pcl_framework=$install/frameworks-simulator/pcl.framework
  mkdir -p ${pcl_framework}
  rm -rf $pcl_framework/*

  cp -R "${current_pcl_ios_sim_framework}" "${pcl_framework}/.."

  # Public Header
  # mkdir $pcl_framework/Headers
  cp -R $pcl_header_dir/* $pcl_framework/Headers/
  cp -R $boost_header_dir/* $pcl_framework/Headers/
  cp -R $eigen_header_dir/* $pcl_framework/Headers/
  cp -R $flann_header_dir/* $pcl_framework/Headers/
  cp -R $qhull_header_dir/* $pcl_framework/Headers/

  # mkdir $pcl_framework/Modules
  # cp module.modulemap $pcl_framework/Modules/
  cp ../iOSWrapper/module.modulemap $pcl_framework/

  # debug libs
  # ranlib $boost_sim_libs
  # ranlib $flann_sim_libs
  # ranlib $qhull_sim_libs
  # ranlib $pcl_sim_libs

  # combine libraries
  # libtool -static -o $pcl_framework/pcl_sim $pcl_sim_libs $boost_sim_libs $flann_sim_libs $qhull_sim_libs $pcl_sim_i386_libs $boost_sim_i386_libs $flann_sim_i386_libs $qhull_sim_i386_libs $current_pcl_ios_sim_framework/pcl $current_pcl_ios_sim_i386_framework/pcl
  libtool -static -o $pcl_framework/pcl_sim $pcl_sim_libs $boost_sim_libs $flann_sim_libs $qhull_sim_libs $current_pcl_ios_sim_framework/pcl

  # combine Xcode generator frameworks and external build libraries
  lipo -create -output $pcl_framework/pcl $pcl_framework/pcl_sim

  # remove tmp library files
  rm -rf $pcl_framework/pcl_*
}

make_pcl_framework_universal ()
{
  # Xcode device/simulation Wrapper framework path
  current_pcl_ios_device_framework=../iOSWrapper/build.ios/Release-iphoneos/pcl.framework
  current_pcl_ios_sim_framework=../iOSWrapper/build.sim64/Release-iphonesimulator/pcl.framework
  # current_pcl_ios_sim_i386_framework=../iOSWrapper/build.sim/Release-iphonesimulator/pcl.framework

  # device_folder = "ios-device"
  # simulator_folder = "ios-simulator"

  # pcl_device_libs=`find $install/pcl-${device_folder} $install/flann-${device_folder} $install/boost-${device_folder} -name *.a`
  # all device arch(not use)
  # pcl_device_libs=`find $install/pcl-ios-device -name *.a`
  # boost_device_libs=`find $install/boost-ios-device -name *.a`
  # flann_device_libs=`find $install/flann-ios-device -name *.a`
  # qhull_device_libs=`find $install/qhull-ios-device -name *.a`
  # arm64
  pcl_device_arm64_libs=`find $install/pcl-ios-device-arm64 -name *.a`
  boost_device_arm64_libs=`find $install/boost-ios-device-arm64 -name *.a`
  flann_device_arm64_libs=`find $install/flann-ios-device-arm64 -name *.a`
  qhull_device_arm64_libs=`find $install/qhull-ios-device-arm64 -name *.a`
  # armv7
  pcl_device_armv7_libs=`find $install/pcl-ios-device-armv7 -name *.a`
  boost_device_armv7_libs=`find $install/boost-ios-device-armv7 -name *.a`
  flann_device_armv7_libs=`find $install/flann-ios-device-armv7 -name *.a`
  qhull_device_armv7_libs=`find $install/qhull-ios-device-armv7 -name *.a`
  # armv7s
  pcl_device_armv7s_libs=`find $install/pcl-ios-device-armv7s -name *.a`
  boost_device_armv7s_libs=`find $install/boost-ios-device-armv7s -name *.a`
  flann_device_armv7s_libs=`find $install/flann-ios-device-armv7s -name *.a`
  qhull_device_armv7s_libs=`find $install/qhull-ios-device-armv7s -name *.a`

  # pcl_sim_libs=`find $install/pcl-${simulator_folder} $install/flann-${simulator_folder} $install/boost-${simulator_folder} -name *.a`
  pcl_sim_libs=`find $install/pcl-ios-simulator -name *.a`
  boost_sim_libs=`find $install/boost-ios-simulator -name *.a`
  flann_sim_libs=`find $install/flann-ios-simulator -name *.a`
  qhull_sim_libs=`find $install/qhull-ios-simulator -name *.a`
  # x86_64
  # pcl_sim_x86_64_libs=`find $install/pcl-ios-simulator-x86-64 -name *.a`
  # boost_sim_x86_64_libs=`find $install/boost-ios-simulator-x86-64 -name *.a`
  # flann_sim_x86_64_libs=`find $install/flann-ios-simulator-x86-64 -name *.a`
  # qhull_sim_x86_64_libs=`find $install/qhull-ios-simulator-x86-64 -name *.a`
  # i386
  # pcl_sim_i386_libs=`find $install/pcl-ios-simulator-i386 -name *.a`
  # boost_sim_i386_libs=`find $install/boost-ios-simulator-i386 -name *.a`
  # flann_sim_i386_libs=`find $install/flann-ios-simulator-i386 -name *.a`
  # qhull_sim_i386_libs=`find $install/qhull-ios-simulator-i386 -name *.a`

  # args -> version
  # version 1.7
  # pcl_header_dir=$install/pcl-${device_folder}/include/pcl-1.7
  # version 1.8
  # common
  pcl_header_dir=$install/pcl-ios-device/include/pcl-1.8
  boost_header_dir=$install/boost-ios-device/include
  eigen_header_dir=$install/eigen
  flann_header_dir=$install/flann-ios-device/include
  qhull_header_dir=$install/qhull-ios-device/include
  # arm64
  pcl_arm64_header_dir=$install/pcl-ios-device-arm64/include/pcl-1.8
  boost_arm64_header_dir=$install/boost-ios-device-arm64/include
  eigen_arm64_header_dir=$install/eigen
  flann_arm64_header_dir=$install/flann-ios-device-arm64/include
  qhull_arm64_header_dir=$install/qhull-ios-device-arm64/include

  pcl_framework=$install/frameworks-universal/pcl.framework
  mkdir -p ${pcl_framework}
  rm -rf $pcl_framework/*

  cp -R "${current_pcl_ios_device_framework}" "${pcl_framework}/.."
  cp -R "${current_pcl_ios_sim_framework}" "${pcl_framework}/.."

  # Public Header
  mkdir $pcl_framework/Headers
  # cp -R $pcl_header_dir/* $pcl_framework/Headers/
  # cp -R $boost_header_dir/* $pcl_framework/Headers/
  # cp -R $eigen_header_dir/* $pcl_framework/Headers/
  # cp -R $flann_header_dir/* $pcl_framework/Headers/
  # cp -R $qhull_header_dir/* $pcl_framework/Headers/

  cp -R $pcl_arm64_header_dir/* $pcl_framework/Headers/
  cp -R $boost_arm64_header_dir/* $pcl_framework/Headers/
  cp -R $eigen_arm64_header_dir/* $pcl_framework/Headers/
  cp -R $flann_arm64_header_dir/* $pcl_framework/Headers/
  cp -R $qhull_arm64_header_dir/* $pcl_framework/Headers/


  # mkdir $pcl_framework/Modules
  # cp module.modulemap $pcl_framework/Modules/
  cp ../iOSWrapper/module.modulemap $pcl_framework/

  # debug libs
  # ranlib $boost_sim_libs
  # ranlib $flann_sim_libs
  # ranlib $qhull_sim_libs
  # ranlib $pcl_sim_libs

  # combine libraries
  # libtool -static -o $pcl_framework/pcl_device $pcl_device_libs $boost_device_libs $flann_device_libs $qhull_device_libs $current_pcl_ios_device_framework/pcl
  # device
  libtool -static -o $pcl_framework/pcl_device $pcl_device_arm64_libs $boost_arm64_device_libs $flann_arm64_device_libs $qhull_arm64_device_libs $pcl_device_armv7_libs $boost_armv7_device_libs $flann_armv7_device_libs $qhull_armv7_device_libs $pcl_device_armv7s_libs $boost_armv7s_device_libs $flann_armv7s_device_libs $qhull_armv7s_device_libs $current_pcl_ios_device_framework/pcl
  # simulator
  # libtool -static -o $pcl_framework/pcl_sim $pcl_sim_libs $boost_sim_libs $flann_sim_libs $qhull_sim_libs $pcl_sim_i386_libs $boost_sim_i386_libs $flann_sim_i386_libs $qhull_sim_i386_libs $current_pcl_ios_sim_framework/pcl $current_pcl_ios_sim_i386_framework/pcl
  libtool -static -o $pcl_framework/pcl_sim $pcl_sim_libs $boost_sim_libs $flann_sim_libs $qhull_sim_libs $current_pcl_ios_sim_framework/pcl

  # combine Xcode generator frameworks and external build libraries
  lipo -create -output $pcl_framework/pcl $pcl_framework/pcl_device $pcl_framework/pcl_sim

  # remove tmp library files
  rm -rf $pcl_framework/pcl_*
}

#------------------------------------------------------------------------------
if [ "$1" == "pcl" ]; then
  make_pcl_framework
elif [ "$1" == "universal" ]; then
  make_pcl_framework_universal
elif [ "$1" == "device" ]; then
  make_pcl_framework_device
elif [ "$1" == "simulator" ]; then
  make_pcl_framework_simulator
else
  echo "Usage: $0 pcl"
  exit 1
fi
