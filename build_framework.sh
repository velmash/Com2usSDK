#!/bin/bash

# 빌드 설정
FRAMEWORK_NAME="Com2uSTestSDK"
CONFIGURATION="Release"
UNIVERSAL_OUTPUTFOLDER="build/${CONFIGURATION}-universal"

# 빌드 디렉토리 생성
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# 빌드 디렉토리 경로 설정 (현재 디렉토리 기준)
BUILD_DIR="$(pwd)/build"

# 시뮬레이터와 기기용으로 빌드
echo "Building for iphonesimulator..."
xcodebuild -project "${FRAMEWORK_NAME}.xcodeproj" -scheme "${FRAMEWORK_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator -arch x86_64 BUILD_LIBRARIES_FOR_DISTRIBUTION=YES BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_DIR}" clean build

echo "Building for iphoneos..."
xcodebuild -project "${FRAMEWORK_NAME}.xcodeproj" -scheme "${FRAMEWORK_NAME}" -configuration ${CONFIGURATION} -sdk iphoneos -arch arm64 BUILD_LIBRARIES_FOR_DISTRIBUTION=YES BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_DIR}" clean build

# 경로 확인
echo "Checking paths..."
ls -la "${BUILD_DIR}/${CONFIGURATION}-iphoneos/"
ls -la "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/"

# 프레임워크 디렉토리 복사
echo "Copying framework..."
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# 유니버설 바이너리 생성
echo "Creating universal binary..."
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

# 빌드 결과 출력
echo "Framework built at ${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework"
