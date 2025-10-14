# 🍎 macOS Build Guide

## 🚀 Quick Start (Nhanh nhất)

### 1. Copy project to macOS
```bash
# Copy the entire mobile_app folder to your macOS
```

### 2. Run auto setup script
```bash
cd mobile_app
chmod +x auto_setup_build.sh
./auto_setup_build.sh
```

## 📋 What the script does automatically:

✅ **Checks system requirements**
- macOS compatibility
- Xcode Command Line Tools

✅ **Installs missing tools**
- Homebrew (if not installed)
- Flutter (if not installed)  
- CocoaPods (if not installed)

✅ **Sets up project**
- Cleans Flutter project
- Updates dependencies
- Installs iOS pods
- Fixes permissions

✅ **Builds iOS app**
- Tests iOS build
- Runs on simulator (if available)

## 🔧 Manual Installation (if needed)

### Install Xcode
```bash
# Download from App Store or Apple Developer
```

### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install Flutter
```bash
brew install --cask flutter
```

### Install CocoaPods
```bash
brew install cocoapods
```

### Setup Project
```bash
cd mobile_app
flutter clean
flutter pub get
cd ios
pod install --repo-update --verbose
cd ..
flutter build ios --no-codesign
```

## 📱 Requirements

- **macOS**: 12.0+ (recommended 14+)
- **Xcode**: 16+
- **Flutter**: 3.32.8+
- **CocoaPods**: 1.16.2+
- **iOS Target**: 16.0+

## 🎯 Supported Devices

- iPhone XS/XR (2018) and newer
- iPhone 11/12/13/14/15 series
- iPad Pro (2018) and newer
- iPad Air (2019) and newer

## ⚠️ Troubleshooting

### Xcode Command Line Tools missing
```bash
xcode-select --install
```

### CocoaPods installation fails
```bash
sudo gem install cocoapods --user-install
```

### Build fails
- Check Xcode version (need 16+)
- Update Flutter: `flutter upgrade`
- Clean project: `flutter clean`

### Pod install fails
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update --verbose
```

## 🎉 Success!

After successful build, you can:
- Open `ios/Runner.xcworkspace` in Xcode
- Configure code signing
- Run on device or simulator
- Archive for App Store

## 📞 Support

If you encounter issues:
1. Check the error messages
2. Verify all requirements are met
3. Try manual installation steps
4. Check Flutter and Xcode versions
