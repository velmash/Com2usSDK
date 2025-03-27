#!/bin/bash

# 빌드 설정
FRAMEWORK_NAME="Com2usTestSDK"
CONFIGURATION="Release"
UNIVERSAL_OUTPUTFOLDER="build/${CONFIGURATION}-universal"

# 빌드 디렉토리 생성
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# 시뮬레이터와 기기용으로 빌드
xcodebuild -workspace "${FRAMEWORK_NAME}.xcworkspace" -scheme "${FRAMEWORK_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator -arch x86_64 BUILD_LIBRARIES_FOR_DISTRIBUTION=YES BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
xcodebuild -workspace "${FRAMEWORK_NAME}.xcworkspace" -scheme "${FRAMEWORK_NAME}" -configuration ${CONFIGURATION} -sdk iphoneos -arch arm64 BUILD_LIBRARIES_FOR_DISTRIBUTION=YES BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# 프레임워크 디렉토리 복사
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# 유니버설 바이너리 생성
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

# 빌드 결과 출력
echo "Framework built at ${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework"
