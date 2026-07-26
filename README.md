> ### ℹ️ Active development moved to pcl_mobile_framework
>
> This repository's last commit is from November 2018. Work continues in
> **[Sirokujira/pcl_mobile_framework](https://github.com/Sirokujira/pcl_mobile_framework)**,
> which took over this project's build system in June 2019 and modernized it:
> PCL 1.9 → 1.14, NDK r16b → r26+, `lipo` fat frameworks → XCFramework,
> AppVeyor/Travis/CircleCI → GitHub Actions, plus SwiftPM / CocoaPods / Maven
> distribution.
>
> The last commit here (`83cc231`, 2018-11-23) is tagged in the successor
> repository as `pcl-superbuild-origin`, and this history is grafted onto its
> own, so `git log` there walks straight back through these commits. See
> [docs/LINEAGE.md](https://github.com/Sirokujira/pcl_mobile_framework/blob/master/docs/LINEAGE.md)
> for the file-by-file derivation map.
>
> Everything below is kept for historical reference.

---

CMake build scripts for cross compiling PCL and its dependencies for Android and iOS.

Windows
[![Build status](https://ci.appveyor.com/api/projects/status/u8l4ixwdpysbx45h/branch/master?svg=true)](https://ci.appveyor.com/project/Sirokujira/pcl-superbuild/branch/master)

Ubuntu/MacOSX
[![Build Status](https://travis-ci.org/Sirokujira/pcl-superbuild.svg?branch=master)](https://travis-ci.org/Sirokujira/pcl-superbuild)

pcl use libraries

[boost 1.60.0](http://www.boost.org/), [custom boost patches](https://svn.boost.org/trac10/ticket/13230), [custom source code](https://github.com/sirokujira/boost-build/)

[eigen 3.3.4](http://eigen.tuxfamily.org/)

[flann 1.9.1](https://www.cs.ubc.ca/research/flann/)

[qhull(2015.2)](http://www.qhull.org/)

[PCL API/ABI Tracker](https://abi-laboratory.pro/tracker/timeline/pcl/)

Requirements
============

    Android
    * Windows/Linux(Test Windows 7?, Ubuntu 14.04/16.04?)
    * Android NDK, Revision 15c/16b(Test 16b)
    * CMake >=3.6.x(Test 3.9.2/3.10.1)

    iOS
    * MacOSX ??.?(Test 10.x)
    * Xcode 8.3, 9.0(?)(Test 9.0)
    * CMake >=3.7.x(Test 3.9.4)


To Build 
========

Building for Android(Ubuntu 14.04/16.04)
========================================

```Sample:Bash
$ wget -qO- https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip -O /tmp/android-ndk-r16b-linux-x86_64.zip
$ unzip -q /tmp/android-ndk-r16b-linux-x86_64.zip

$ cd android-ndk-r16b
$ export ANDROID_NDK=$PWD

$ export ANDROID_TARGET_API="23"
$ export ANDROID_ABIs="armeabi-v7a"
$ export TOOLCHAIN_NAME="arm-linux-android-clang3.6"
$ export TARGET_COMPILER="clang"

$ mkdir build && cd build
$ cmake -DBUILD_ANDROID:BOOL="ON" -DBUILD_IOS_DEVICE:BOOL="OFF" -DBUILD_IOS_SIMULATOR:BOOL="OFF" -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${ANDROID_NDK}/build/cmake/android.toolchain.cmake -DCMAKE_MAKE_PROGRAM=${ANDROID_NDK}/prebuilt/linux-x86_64/bin/make -DANDROID_TOOLCHAIN_NAME=${TOOLCHAIN_NAME} -DANDROID_NATIVE_API_LEVEL=${ANDROID_TARGET_API} -DANDROID_ABI=${ANDROID_ABIs} -DANDROID_TOOLCHAIN=${TARGET_COMPILER} ..
$ cmake --build .
```

other target

```arm64-v8a:Bash
$ export ANDROID_ABIs="arm64-v8a"
$ export TOOLCHAIN_NAME="aarch64-linux-android-clang3.6"
$ export TARGET_COMPILER="clang"
```

```armeabi-v7a_gcc:Bash
$ export ANDROID_ABIs="armeabi-v7a"
$ export TOOLCHAIN_NAME="arm-linux-androideabi-4.9"
$ export TARGET_COMPILER="gcc"
```

```arm64-v8a_gcc:Bash
$ export ANDROID_ABIs="arm64-v8a"
$ export TOOLCHAIN_NAME="aarch64-linux-android-4.9"
$ export TARGET_COMPILER="gcc"
```

Building for iOS(Mac OSX 10.x)
==============================

```Sample:Bash
$ mkdir build && cd build
$ cmake -DBUILD_ANDROID:BOOL="OFF" -DBUILD_IOS_DEVICE:BOOL="OFF" -DBUILD_IOS_SIMULATOR:BOOL="OFF" ../
$ cmake --build .
```

Reference modules
=================

* Base module

    https://github.com/patmarion/pcl-superbuild
    https://github.com/hirotakaster/pcl-superbuild

* Android

    https://github.com/taka-no-me/android-cmake

* iOS

    https://github.com/sheldonth/ios-cmake

