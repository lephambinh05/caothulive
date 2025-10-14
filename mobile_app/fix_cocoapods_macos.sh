#!/bin/bash

echo "🔧 Fixing CocoaPods for macOS 26..."

# 1. Clean Flutter
echo "📱 Cleaning Flutter..."
flutter clean
flutter pub get

# 2. Remove old Pod files
echo "🗑️ Removing old Pod files..."
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec

# 3. Update CocoaPods
echo "⬆️ Updating CocoaPods..."
sudo gem install cocoapods --user-install
pod repo update

# 4. Install pods with fixes
echo "📦 Installing pods..."
pod install --repo-update --verbose

# 5. Fix permissions
echo "🔐 Fixing permissions..."
chmod -R 755 Pods/
chmod -R 755 Flutter/

echo "✅ CocoaPods fix completed!"
echo "🚀 Now you can run: flutter build ios"
