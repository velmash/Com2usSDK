# iOS 디바이스용 아카이브 생성
xcodebuild archive \
  -workspace Com2uSTestSDK.xcworkspace \
  -scheme Com2uSTestSDK \
  -destination "generic/platform=iOS" \
  -archivePath "./build/iOS.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# iOS 시뮬레이터용 아카이브 생성
xcodebuild archive \
  -workspace Com2uSTestSDK.xcworkspace \
  -scheme Com2uSTestSDK \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "./build/iOS_Simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# xcframework 생성
xcodebuild -create-xcframework \
  -framework "./build/iOS.xcarchive/Products/Library/Frameworks/Com2uSTestSDK.framework" \
  -framework "./build/iOS_Simulator.xcarchive/Products/Library/Frameworks/Com2uSTestSDK.framework" \
  -output "./build/Com2uSTestSDK.xcframework"
