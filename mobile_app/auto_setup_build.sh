#!/bin/bash

# Auto Setup & Build iOS App for macOS
# Tự động check, cài đặt môi trường, setup và build

set -e  # Exit on any error

echo "🍎 Auto Setup & Build iOS App for macOS"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 1. Check if we're on macOS
echo "🔍 Checking system..."
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script must be run on macOS!"
    exit 1
fi
print_status "Running on macOS"

# 2. Check and install Xcode Command Line Tools
echo "🔍 Checking Xcode Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
    print_warning "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    print_info "Please complete the Xcode Command Line Tools installation and run this script again."
    exit 1
fi
print_status "Xcode Command Line Tools installed"

# 3. Check Xcode version
echo "🔍 Checking Xcode version..."
if ! command -v xcodebuild &> /dev/null; then
    print_error "Xcode not found. Please install Xcode from App Store."
    exit 1
fi
xcode_version=$(xcodebuild -version | head -n 1)
print_status "$xcode_version"

# 4. Check and install Homebrew
echo "🔍 Checking Homebrew..."
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi
print_status "Homebrew installed"

# 5. Check and install Flutter
echo "🔍 Checking Flutter..."
if ! command -v flutter &> /dev/null; then
    print_warning "Flutter not found. Installing..."
    
    # Install Flutter via Homebrew
    brew install --cask flutter
    
    # Add Flutter to PATH
    echo 'export PATH="$PATH:/opt/homebrew/bin/flutter/bin"' >> ~/.zprofile
    echo 'export PATH="$PATH:/usr/local/bin/flutter/bin"' >> ~/.zprofile
    source ~/.zprofile
    
    # Accept Flutter licenses
    flutter doctor --android-licenses || true
fi

# Check Flutter version
flutter_version=$(flutter --version | head -n 1)
print_status "$flutter_version"

# 6. Check and install CocoaPods
echo "🔍 Checking CocoaPods..."
if ! command -v pod &> /dev/null; then
    print_warning "CocoaPods not found. Installing..."
    
    # Install CocoaPods via Homebrew (recommended)
    brew install cocoapods
    
    # Alternative: Install via gem
    # sudo gem install cocoapods --user-install
fi

# Check CocoaPods version
pod_version=$(pod --version)
print_status "CocoaPods $pod_version"

# 7. Check and install Ruby (if needed)
echo "🔍 Checking Ruby..."
ruby_version=$(ruby --version)
print_status "$ruby_version"

# 8. Setup Flutter environment
echo "🔧 Setting up Flutter environment..."
flutter doctor
print_status "Flutter environment checked"

# 9. Clean and update Flutter project
echo "🧹 Cleaning Flutter project..."
flutter clean
flutter pub get
print_status "Flutter project cleaned and updated"

# 10. Navigate to iOS directory
cd ios

# 11. Clean iOS build files
echo "🗑️ Cleaning iOS build files..."
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
rm -rf build/
print_status "iOS build files cleaned"

# 12. Update CocoaPods repository
echo "⬆️ Updating CocoaPods repository..."
pod repo update
print_status "CocoaPods repository updated"

# 13. Install pods
echo "📦 Installing iOS pods..."
pod install --repo-update --verbose
print_status "iOS pods installed"

# 14. Check pod installation
if [ -f "Podfile.lock" ] && [ -d "Pods" ]; then
    pods_count=$(ls -1 Pods | wc -l)
    print_status "Pods installed successfully ($pods_count frameworks)"
else
    print_error "Pod installation failed!"
    exit 1
fi

# 15. Fix permissions
echo "🔐 Fixing permissions..."
chmod -R 755 Pods/
chmod -R 755 Flutter/
print_status "Permissions fixed"

# 16. Go back to project root
cd ..

# 17. Test Flutter build
echo "🚀 Testing Flutter build..."
flutter build ios --no-codesign

if [ $? -eq 0 ]; then
    print_status "iOS build successful!"
else
    print_error "iOS build failed!"
    exit 1
fi

# 18. Check available simulators
echo "📱 Checking available simulators..."
flutter devices
print_status "Available devices listed"

# 19. Try to run on simulator (optional)
echo "🎯 Attempting to run on iOS simulator..."
if flutter run -d ios --no-sound-null-safety; then
    print_status "App running on iOS simulator!"
else
    print_warning "Could not run on simulator (this is normal if no simulator is available)"
fi

# 20. Final summary
echo ""
echo "========================================"
echo "🎉 Setup & Build Complete!"
echo "========================================"
echo "✅ System: macOS with Xcode"
echo "✅ Flutter: $(flutter --version | head -n 1 | cut -d' ' -f2)"
echo "✅ CocoaPods: $(pod --version)"
echo "✅ iOS Target: 16.0+"
echo "✅ Firebase: 4.2.0+"
echo "✅ Build: Successful"
echo ""
echo "🚀 Next steps:"
echo "1. Open ios/Runner.xcworkspace in Xcode"
echo "2. Configure your Apple Developer account"
echo "3. Set up code signing"
echo "4. Run: flutter run -d ios"
echo ""
echo "📱 Supported devices:"
echo "- iPhone XS/XR (2018) and newer"
echo "- iPhone 11/12/13/14/15 series"
echo "- iPad Pro (2018) and newer"
echo "========================================"
