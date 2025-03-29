#!/bin/bash

# 빌드 디렉토리 생성 (이미 존재하면 내용 비우기)
if [ -d "./build" ]; then
  echo "기존 build 디렉토리를 비웁니다..."
  rm -rf ./build/*
else
  echo "build 디렉토리를 생성합니다..."
  mkdir -p ./build
fi

echo "iOS 디바이스용 아카이브 생성 중..."
xcodebuild archive \
  -project Com2uSTestSDK.xcodeproj \
  -scheme Com2uSTestSDK \
  -destination "generic/platform=iOS" \
  -archivePath "./build/iOS.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

if [ $? -ne 0 ]; then
  echo "iOS 디바이스용 아카이브 생성 실패"
  exit 1
fi

echo "iOS 시뮬레이터용 아카이브 생성 중..."
xcodebuild archive \
  -project Com2uSTestSDK.xcodeproj \
  -scheme Com2uSTestSDK \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "./build/iOS_Simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

if [ $? -ne 0 ]; then
  echo "iOS 시뮬레이터용 아카이브 생성 실패"
  exit 1
fi

# 프레임워크 경로 확인
IOS_FRAMEWORK_PATH=$(find "./build/iOS.xcarchive" -name "Com2uSTestSDK.framework" | head -n 1)
SIMULATOR_FRAMEWORK_PATH=$(find "./build/iOS_Simulator.xcarchive" -name "Com2uSTestSDK.framework" | head -n 1)

if [ -z "$IOS_FRAMEWORK_PATH" ]; then
  echo "iOS 프레임워크를 찾을 수 없습니다. 정확한 경로를 확인하세요."
  find "./build/iOS.xcarchive" -name "*.framework"
  exit 1
fi

if [ -z "$SIMULATOR_FRAMEWORK_PATH" ]; then
  echo "시뮬레이터 프레임워크를 찾을 수 없습니다. 정확한 경로를 확인하세요."
  find "./build/iOS_Simulator.xcarchive" -name "*.framework"
  exit 1
fi

echo "iOS 프레임워크 경로: $IOS_FRAMEWORK_PATH"
echo "시뮬레이터 프레임워크 경로: $SIMULATOR_FRAMEWORK_PATH"

# XCFramework 파일이 이미 존재하면 삭제
if [ -d "./build/Com2uSTestSDK.xcframework" ]; then
  echo "기존 XCFramework 파일을 삭제합니다..."
  rm -rf "./build/Com2uSTestSDK.xcframework"
fi

echo "XCFramework 생성 중..."
xcodebuild -create-xcframework \
  -framework "$IOS_FRAMEWORK_PATH" \
  -framework "$SIMULATOR_FRAMEWORK_PATH" \
  -output "./build/Com2uSTestSDK.xcframework"

if [ $? -ne 0 ]; then
  echo "XCFramework 생성 실패"
  exit 1
fi

echo "성공적으로 XCFramework를 생성했습니다: ./build/Com2uSTestSDK.xcframework"
