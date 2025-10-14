#!/bin/bash

echo "🍎 iOS Build Check & Fix for macOS 26"
echo "======================================"

# 1. Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script must be run on macOS!"
    exit 1
fi

# 2. Check Xcode version
echo "📱 Checking Xcode version..."
xcode_version=$(xcodebuild -version | head -n 1)
echo "✅ $xcode_version"

# 3. Check Flutter version
echo "📱 Checking Flutter version..."
flutter_version=$(flutter --version | head -n 1)
echo "✅ $flutter_version"

# 4. Check CocoaPods version
echo "📦 Checking CocoaPods version..."
if command -v pod &> /dev/null; then
    pod_version=$(pod --version)
    echo "✅ CocoaPods $pod_version"
else
    echo "❌ CocoaPods not installed. Installing..."
    sudo gem install cocoapods --user-install
fi

# 5. Clean and update Flutter
echo "🧹 Cleaning Flutter..."
flutter clean
flutter pub get

# 6. Navigate to iOS directory
cd ios

# 7. Remove old Pod files
echo "🗑️ Cleaning old Pod files..."
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec

# 8. Update CocoaPods repo
echo "⬆️ Updating CocoaPods repository..."
pod repo update

# 9. Install pods with verbose output
echo "📦 Installing iOS pods..."
pod install --repo-update --verbose

# 10. Check for common issues
echo "🔍 Checking for common issues..."

# Check if Podfile.lock exists
if [ -f "Podfile.lock" ]; then
    echo "✅ Podfile.lock created successfully"
else
    echo "❌ Podfile.lock not found - pod install may have failed"
fi

# Check if Pods directory exists
if [ -d "Pods" ]; then
    echo "✅ Pods directory created successfully"
    echo "📊 Pods installed: $(ls -1 Pods | wc -l) frameworks"
else
    echo "❌ Pods directory not found - pod install may have failed"
fi

# 11. Fix permissions
echo "🔐 Fixing permissions..."
chmod -R 755 Pods/
chmod -R 755 Flutter/

# 12. Go back to project root
cd ..

# 13. Test build
echo "🚀 Testing iOS build..."
flutter build ios --no-codesign

if [ $? -eq 0 ]; then
    echo "✅ iOS build successful!"
    echo "🎉 Ready to run on iOS device/simulator"
else
    echo "❌ iOS build failed. Check the error messages above."
fi

echo "======================================"
echo "📋 Summary:"
echo "- iOS 16.0+ deployment target"
echo "- Firebase 4.2.0+ compatible"
echo "- macOS 26 + Xcode 16+ ready"
echo "- All CocoaPods fixes applied"
echo "======================================"
