#!/bin/bash

echo "🍎 Setting up iOS dependencies for macOS 26..."

# 1. Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script must be run on macOS!"
    exit 1
fi

# 2. Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "📦 Installing CocoaPods..."
    sudo gem install cocoapods --user-install
else
    echo "✅ CocoaPods already installed"
    pod --version
fi

# 3. Update Flutter dependencies
echo "📱 Updating Flutter dependencies..."
flutter clean
flutter pub get

# 4. Navigate to iOS directory
cd ios

# 5. Remove old Pod files
echo "🗑️ Cleaning old Pod files..."
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec

# 6. Update CocoaPods repo
echo "⬆️ Updating CocoaPods repository..."
pod repo update

# 7. Install pods
echo "📦 Installing iOS pods..."
pod install --repo-update --verbose

# 8. Fix permissions
echo "🔐 Fixing permissions..."
chmod -R 755 Pods/
chmod -R 755 Flutter/

# 9. Go back to project root
cd ..

echo "✅ iOS setup completed!"
echo "🚀 You can now run:"
echo "   flutter build ios"
echo "   flutter run -d ios"
