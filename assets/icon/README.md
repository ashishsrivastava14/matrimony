# App Icon Assets

## Required File

Place your app icon here as: **app_icon.png**

## Specifications

- **Format**: PNG
- **Size**: 1024x1024 pixels (minimum)
- **Recommended**: 2048x2048 pixels for best quality
- **Background**: Transparent OR solid color
- **Content**: Your AP Matrimony logo centered

## Important Notes

1. The icon should be a **square** image
2. For adaptive icons (Android), keep important content in the **center 66%** of the image
3. Avoid thin lines or small text (won't be visible at small sizes)
4. Use high contrast colors for better visibility

## After Adding Your Icon

Run the following command to generate icons for all platforms:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will automatically generate:
- All Android icon sizes (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- All iOS icon sizes (20pt to 1024pt at different scales)
- Web icons (favicon, PWA icons)
- Adaptive icons for Android 8.0+

## Quick Icon Creation Options

### Option 1: Use Canva (Free)
1. Go to Canva.com
2. Create custom size: 1024x1024
3. Design your logo
4. Download as PNG
5. Save as `app_icon.png` in this folder

### Option 2: Use Figma (Free)
1. Create 1024x1024 artboard
2. Design your logo
3. Export as PNG @2x (creates 2048x2048)
4. Save as `app_icon.png` in this folder

### Option 3: Use GIMP (Free Desktop App)
1. Create new image 1024x1024
2. Design your logo
3. Export as PNG
4. Save as `app_icon.png` in this folder

### Option 4: Hire a Designer
- Fiverr: $5-$50
- Upwork: $50-$200
- 99designs: Contest-based

## Testing Your Icon

After generation, test on:
- Android emulator/device
- iOS simulator/device  
- Web browser (check favicon)

The icon will appear in:
- App drawer (Android)
- Home screen (iOS)
- Browser tab (Web)
- App switcher
- Settings
