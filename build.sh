#!/bin/bash

# Stolen from GPUImage: https://github.com/BradLarson/GPUImage/blob/master/build.sh

set -e

IOSSDK_VER="7.0"
FRAMEWORK_NAME="CryptoPP"
LIBRARY_FILE="libcryptopp.a"

# xcodebuild -showsdks

xcodebuild clean
xcodebuild -project cryptopp.xcodeproj -target cryptopp -configuration Release -sdk iphoneos${IOSSDK_VER} build
xcodebuild -project cryptopp.xcodeproj -target cryptopp -configuration Release -sdk iphonesimulator${IOSSDK_VER} build

cd build
# for the fat lib file
mkdir -p Release-iphone/lib
xcrun -sdk iphoneos lipo -create Release-iphoneos/${LIBRARY_FILE} Release-iphonesimulator/${LIBRARY_FILE} -output Release-iphone/lib/${LIBRARY_FILE}
xcrun -sdk iphoneos lipo -info Release-iphone/lib/${LIBRARY_FILE}
# for header files
mkdir -p Release-iphone/include
cp ../cryptopp/*.h Release-iphone/include

# Build static framework
mkdir -p ${FRAMEWORK_NAME}.framework/Versions/A
cp Release-iphone/lib/${LIBRARY_FILE} ${FRAMEWORK_NAME}.framework/Versions/A/${FRAMEWORK_NAME}
mkdir -p ${FRAMEWORK_NAME}.framework/Versions/A/Headers
cp Release-iphone/include/*.h ${FRAMEWORK_NAME}.framework/Versions/A/Headers
ln -sfh A ${FRAMEWORK_NAME}.framework/Versions/Current
ln -sfh Versions/Current/${FRAMEWORK_NAME} ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}
ln -sfh Versions/Current/Headers ${FRAMEWORK_NAME}.framework/Headers

