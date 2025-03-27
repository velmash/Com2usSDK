#!/bin/bash

# 설정
FRAMEWORK_NAME="Com2uSTestSDK"
CONFIGURATION="Release"
BUILD_DIR="$(pwd)/build"
OUTPUT_DIR="${BUILD_DIR}/outputs"
#SPM_DIR="$(pwd)/${FRAMEWORK_NAME}_Package"

# 디렉터리 준비
rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"

# iOS용 빌드
echo "Building for iOS devices..."
xcodebuild archive \
  -project "${FRAMEWORK_NAME}.xcodeproj" \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration ${CONFIGURATION} \
  -destination "generic/platform=iOS" \
  -archivePath "${OUTPUT_DIR}/ios.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Simulator용 빌드
echo "Building for iOS Simulator..."
xcodebuild archive \
  -project "${FRAMEWORK_NAME}.xcodeproj" \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration ${CONFIGURATION} \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "${OUTPUT_DIR}/iossimulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# XCFramework 생성
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "${OUTPUT_DIR}/ios.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "${OUTPUT_DIR}/iossimulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -output "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

echo "XCFramework created at: ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

#let package = Package(
#    name: "${FRAMEWORK_NAME}",
#    platforms: [.iOS(.v15)], // 필요에 따라 수정
#    products: [
#        .library(
#            name: "${FRAMEWORK_NAME}",
#            targets: ["${FRAMEWORK_NAME}"]
#        )
#    ],
#    targets: [
#        .binaryTarget(
#            name: "${FRAMEWORK_NAME}",
#            path: "${FRAMEWORK_NAME}.xcframework"
#        )
#    ]
#)
#EOF
#
#echo "Swift Package created at: ${SPM_DIR}"
