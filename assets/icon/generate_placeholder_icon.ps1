# PowerShell Script to Generate a Placeholder Icon for AP Matrimony
# This creates a simple 1024x1024 PNG icon with "AP" text

Add-Type -AssemblyName System.Drawing

# Create a new bitmap (1024x1024)
$bitmap = New-Object System.Drawing.Bitmap 1024, 1024

# Create graphics object
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

# Define colors
$backgroundColor = [System.Drawing.Color]::FromArgb(1, 117, 194)  # #0175C2
$textColor = [System.Drawing.Color]::White

# Fill background with gradient
$gradientBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point 0, 0),
    (New-Object System.Drawing.Point 1024, 1024),
    $backgroundColor,
    [System.Drawing.Color]::FromArgb(3, 95, 165)
)
$graphics.FillRectangle($gradientBrush, 0, 0, 1024, 1024)

# Draw a circle background
$circleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 255, 255, 255))
$graphics.FillEllipse($circleBrush, 112, 112, 800, 800)

# Create font and text
$fontFamily = New-Object System.Drawing.FontFamily("Arial")
$font = New-Object System.Drawing.Font($fontFamily, 380, [System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush($textColor)

# Measure text and center it
$text = "AP"
$textSize = $graphics.MeasureString($text, $font)
$x = (1024 - $textSize.Width) / 2
$y = (1024 - $textSize.Height) / 2

# Draw text with shadow effect
$shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 0, 0, 0))
$graphics.DrawString($text, $font, $shadowBrush, $x + 5, $y + 5)
$graphics.DrawString($text, $font, $textBrush, $x, $y)

# Add subtitle
$subtitleFont = New-Object System.Drawing.Font($fontFamily, 72, [System.Drawing.FontStyle]::Regular)
$subtitle = "Matrimony"
$subtitleSize = $graphics.MeasureString($subtitle, $subtitleFont)
$subtitleX = (1024 - $subtitleSize.Width) / 2
$subtitleY = 720

$graphics.DrawString($subtitle, $subtitleFont, $shadowBrush, $subtitleX + 3, $subtitleY + 3)
$graphics.DrawString($subtitle, $subtitleFont, $textBrush, $subtitleX, $subtitleY)

# Save as PNG
$outputPath = Join-Path $PSScriptRoot "app_icon.png"
$bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

# Cleanup
$graphics.Dispose()
$bitmap.Dispose()
$gradientBrush.Dispose()
$circleBrush.Dispose()
$textBrush.Dispose()
$shadowBrush.Dispose()
$font.Dispose()
$subtitleFont.Dispose()

Write-Host "✓ Placeholder icon created successfully!" -ForegroundColor Green
Write-Host "  Location: $outputPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review the generated icon" -ForegroundColor White
Write-Host "2. Replace with your custom design (optional)" -ForegroundColor White
Write-Host "3. Run: flutter pub get" -ForegroundColor White
Write-Host "4. Run: flutter pub run flutter_launcher_icons" -ForegroundColor White
