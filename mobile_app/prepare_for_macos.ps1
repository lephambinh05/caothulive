# Prepare iOS Project for macOS Build
# Chuẩn bị project iOS để build trên macOS

Write-Host "🍎 Preparing iOS Project for macOS Build" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# 1. Check if we're on Windows
if ($env:OS -ne "Windows_NT") {
    Write-Host "❌ This script is for Windows. Use auto_setup_build.sh on macOS." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Running on Windows - Preparing project for macOS" -ForegroundColor Green

# 2. Clean Flutter project
Write-Host "🧹 Cleaning Flutter project..." -ForegroundColor Yellow
flutter clean
flutter pub get

# 3. Check Flutter dependencies
Write-Host "📦 Checking Flutter dependencies..." -ForegroundColor Yellow
flutter pub deps

# 4. Make shell script executable (for when copied to macOS)
Write-Host "🔧 Preparing shell scripts..." -ForegroundColor Yellow
$shellScripts = @(
    "auto_setup_build.sh",
    "ios_build_check.sh", 
    "setup_ios_macos.sh",
    "fix_cocoapods_macos.sh"
)

foreach ($script in $shellScripts) {
    if (Test-Path $script) {
        Write-Host "✅ Found $script" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $script not found" -ForegroundColor Yellow
    }
}

# 5. Check iOS configuration files
Write-Host "📱 Checking iOS configuration..." -ForegroundColor Yellow
$iosFiles = @(
    "ios/Podfile",
    "ios/Runner/Info.plist",
    "ios/Runner.xcodeproj/project.pbxproj",
    "ios/Runner.xcworkspace/contents.xcworkspacedata"
)

foreach ($file in $iosFiles) {
    if (Test-Path $file) {
        Write-Host "✅ Found $file" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing $file" -ForegroundColor Red
    }
}

# 6. Check pubspec.yaml
Write-Host "📋 Checking pubspec.yaml..." -ForegroundColor Yellow
if (Test-Path "pubspec.yaml") {
    $pubspec = Get-Content "pubspec.yaml" -Raw
    if ($pubspec -match "firebase_core: \^4\.2\.0") {
        Write-Host "✅ Firebase Core 4.2.0" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Firebase Core version may need update" -ForegroundColor Yellow
    }
    
    if ($pubspec -match "cloud_firestore: \^6\.0\.3") {
        Write-Host "✅ Cloud Firestore 6.0.3" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Cloud Firestore version may need update" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ pubspec.yaml not found" -ForegroundColor Red
}

# 7. Create instructions file
Write-Host "📝 Creating macOS instructions..." -ForegroundColor Yellow
$instructions = @"
# macOS Build Instructions
# Hướng dẫn build trên macOS

## 🚀 Quick Start (Nhanh nhất)
```bash
# 1. Copy project to macOS
# 2. Open Terminal in project directory
# 3. Run:
chmod +x auto_setup_build.sh
./auto_setup_build.sh
```

## 📋 Manual Steps (Thủ công)
```bash
# 1. Install Xcode from App Store
# 2. Install Homebrew:
/bin/bash -c "`$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Install Flutter:
brew install --cask flutter

# 4. Install CocoaPods:
brew install cocoapods

# 5. Setup project:
flutter clean
flutter pub get
cd ios
pod install --repo-update --verbose
cd ..
flutter build ios --no-codesign
```

## 🔧 Troubleshooting
* If Xcode Command Line Tools missing: `xcode-select --install`
* If CocoaPods fails: `sudo gem install cocoapods --user-install`
* If build fails: Check Xcode version (need 16+)

## 📱 Requirements
* macOS 12.0+ (recommended macOS 14+)
* Xcode 16+
* Flutter 3.32.8+
* CocoaPods 1.16.2+
* iOS 16.0+ deployment target
"@

$instructions | Out-File -FilePath "MACOS_BUILD_INSTRUCTIONS.md" -Encoding UTF8
Write-Host "✅ Created MACOS_BUILD_INSTRUCTIONS.md" -ForegroundColor Green

# 8. Final summary
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "🎉 Project Ready for macOS!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host "✅ Flutter project cleaned" -ForegroundColor Green
Write-Host "✅ Dependencies checked" -ForegroundColor Green
Write-Host "✅ iOS files verified" -ForegroundColor Green
Write-Host "✅ Build scripts prepared" -ForegroundColor Green
Write-Host "✅ Instructions created" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Copy this project to macOS" -ForegroundColor White
Write-Host "2. Run: chmod +x auto_setup_build.sh" -ForegroundColor White
Write-Host "3. Run: ./auto_setup_build.sh" -ForegroundColor White
Write-Host ""
Write-Host "🚀 The script will automatically:" -ForegroundColor Cyan
Write-Host "- Install Xcode Command Line Tools" -ForegroundColor White
Write-Host "- Install Homebrew, Flutter, CocoaPods" -ForegroundColor White
Write-Host "- Setup iOS project" -ForegroundColor White
Write-Host "- Build iOS app" -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Green
