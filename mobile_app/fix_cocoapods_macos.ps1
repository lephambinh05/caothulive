# Fix CocoaPods for macOS 26
Write-Host "🔧 Fixing CocoaPods for macOS 26..." -ForegroundColor Green

# 1. Clean Flutter
Write-Host "📱 Cleaning Flutter..." -ForegroundColor Yellow
flutter clean
flutter pub get

# 2. Instructions for macOS
Write-Host "📋 Instructions to run on macOS:" -ForegroundColor Cyan
Write-Host "1. Copy this project to macOS" -ForegroundColor White
Write-Host "2. Open Terminal in project directory" -ForegroundColor White
Write-Host "3. Run: chmod +x fix_cocoapods_macos.sh" -ForegroundColor White
Write-Host "4. Run: ./fix_cocoapods_macos.sh" -ForegroundColor White
Write-Host "5. Or manually run these commands:" -ForegroundColor White
Write-Host "   cd ios" -ForegroundColor Gray
Write-Host "   rm -rf Pods Podfile.lock .symlinks" -ForegroundColor Gray
Write-Host "   rm -rf Flutter/Flutter.framework Flutter/Flutter.podspec" -ForegroundColor Gray
Write-Host "   sudo gem install cocoapods --user-install" -ForegroundColor Gray
Write-Host "   pod repo update" -ForegroundColor Gray
Write-Host "   pod install --repo-update --verbose" -ForegroundColor Gray
Write-Host "   chmod -R 755 Pods/ Flutter/" -ForegroundColor Gray

Write-Host "✅ Script ready for macOS!" -ForegroundColor Green
