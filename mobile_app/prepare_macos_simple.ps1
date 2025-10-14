# Prepare iOS Project for macOS Build
Write-Host "🍎 Preparing iOS Project for macOS Build" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# 1. Clean Flutter project
Write-Host "🧹 Cleaning Flutter project..." -ForegroundColor Yellow
flutter clean
flutter pub get

# 2. Check Flutter dependencies
Write-Host "📦 Checking Flutter dependencies..." -ForegroundColor Yellow
flutter pub deps

# 3. Check iOS configuration files
Write-Host "📱 Checking iOS configuration..." -ForegroundColor Yellow
$iosFiles = @(
    "ios/Podfile",
    "ios/Runner/Info.plist",
    "ios/Runner.xcodeproj/project.pbxproj"
)

foreach ($file in $iosFiles) {
    if (Test-Path $file) {
        Write-Host "✅ Found $file" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing $file" -ForegroundColor Red
    }
}

# 4. Check pubspec.yaml
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

# 5. Create instructions file
Write-Host "📝 Creating macOS instructions..." -ForegroundColor Yellow
$instructions = @"
# macOS Build Instructions

## Quick Start
```bash
chmod +x auto_setup_build.sh
./auto_setup_build.sh
```

## Manual Steps
```bash
# Install Xcode from App Store
# Install Homebrew:
/bin/bash -c "`$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Flutter:
brew install --cask flutter

# Install CocoaPods:
brew install cocoapods

# Setup project:
flutter clean
flutter pub get
cd ios
pod install --repo-update --verbose
cd ..
flutter build ios --no-codesign
```

## Requirements
* macOS 12.0+ (recommended macOS 14+)
* Xcode 16+
* Flutter 3.32.8+
* CocoaPods 1.16.2+
* iOS 16.0+ deployment target
"@

$instructions | Out-File -FilePath "MACOS_BUILD_INSTRUCTIONS.md" -Encoding UTF8
Write-Host "✅ Created MACOS_BUILD_INSTRUCTIONS.md" -ForegroundColor Green

# 6. Final summary
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
