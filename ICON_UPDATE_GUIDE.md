# Icon Update Guide for AP Matrimony

This guide explains how to update the app icons and favicon for the AP Matrimony application.

## Overview

The app name has been changed from "matrimony_app" to "AP Matrimony". Now you need to replace the icon files with your custom AP Matrimony logo.

## 1. Web App Icons (Favicon)

### Files to Replace:
- **Main Favicon**: `web/favicon.png` (recommended: 32x32 or 64x64 px)
- **PWA Icons**:
  - `web/icons/Icon-192.png` (192x192 px)
  - `web/icons/Icon-512.png` (512x512 px)
  - `web/icons/Icon-maskable-192.png` (192x192 px with safe zone)
  - `web/icons/Icon-maskable-512.png` (512x512 px with safe zone)

### Maskable Icons Note:
For maskable icons, ensure your logo is centered within 80% of the canvas, leaving 10% padding on all sides to prevent clipping on different device shapes.

## 2. Android App Icons

### Location:
`android/app/src/main/res/`

### Files to Replace:
- `mipmap-mdpi/ic_launcher.png` (48x48 px)
- `mipmap-hdpi/ic_launcher.png` (72x72 px)
- `mipmap-xhdpi/ic_launcher.png` (96x96 px)
- `mipmap-xxhdpi/ic_launcher.png` (144x144 px)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192 px)

### Recommended Tool:
Use [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html) to generate all required sizes automatically.

## 3. iOS App Icons

### Location:
`ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Files to Replace:
- `Icon-App-20x20@1x.png` (20x20 px)
- `Icon-App-20x20@2x.png` (40x40 px)
- `Icon-App-20x20@3x.png` (60x60 px)
- `Icon-App-29x29@1x.png` (29x29 px)
- `Icon-App-29x29@2x.png` (58x58 px)
- `Icon-App-29x29@3x.png` (87x87 px)
- `Icon-App-40x40@1x.png` (40x40 px)
- `Icon-App-40x40@2x.png` (80x80 px)
- `Icon-App-40x40@3x.png` (120x120 px)
- `Icon-App-60x60@2x.png` (120x120 px)
- `Icon-App-60x60@3x.png` (180x180 px)
- `Icon-App-76x76@1x.png` (76x76 px)
- `Icon-App-76x76@2x.png` (152x152 px)
- `Icon-App-83.5x83.5@2x.png` (167x167 px)
- `Icon-App-1024x1024@1x.png` (1024x1024 px) - **App Store icon**

### Recommended Tools:
- Use [App Icon Generator](https://appicon.co/) to generate all iOS icon sizes
- Or use Xcode's built-in asset catalog with a single 1024x1024 image

## Quick Start

### Option 1: Use Online Icon Generator (Recommended)
1. Create a 1024x1024 px icon with your AP Matrimony logo
2. Visit [Icon Kitchen](https://icon.kitchen/) or [App Icon Generator](https://www.appicon.co/)
3. Upload your icon and download the generated package
4. Extract and replace files in the respective folders

### Option 2: Manual Replacement
1. Prepare your icon in different sizes as listed above
2. Replace each file in the respective platform folders
3. Keep the same file names

## After Replacing Icons

### Clean and Rebuild:
```bash
# Clean the build
flutter clean

# Get dependencies
flutter pub get

# Run on your target platform
flutter run
```

### Verify Changes:
1. **Web**: Check the browser tab icon and PWA install prompt
2. **Android**: Check the app drawer and home screen
3. **iOS**: Check the SpringBoard (home screen) and App Switcher

## Important Notes

- **File names must remain the same** - only replace the content
- **Maintain exact dimensions** for each platform's requirements
- **PNG format** is required for all icons
- **No transparency** for Android adaptive icons (use solid background)
- **iOS icons** should have no transparency (use white or colored background)
- Test on actual devices to ensure icons look crisp and properly aligned

## App Name Display

The app will now display as:
- **Android**: "AP Matrimony" (in app drawer and notification bar)
- **iOS**: "AP Matrimony" (under icon on home screen)
- **Web**: "AP Matrimony" (in browser tab and PWA)

## Troubleshooting

If icons don't update:
1. Run `flutter clean`
2. Delete the app from the device/emulator
3. Rebuild and reinstall: `flutter run`
4. For iOS, clean build folder in Xcode: `Product > Clean Build Folder`
5. For Android, clear Gradle cache if needed

---

**Last Updated**: February 18, 2026
