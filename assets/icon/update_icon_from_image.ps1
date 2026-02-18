# PowerShell Script to Update App Icon from User's Image
# This script helps you select and use your matrimony logo

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  AP Matrimony - Icon Update Helper" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Define target path
$targetPath = Join-Path $PSScriptRoot "app_icon.png"

Write-Host "Please select your matrimony logo image file..." -ForegroundColor Yellow
Write-Host ""

# Create OpenFileDialog
Add-Type -AssemblyName System.Windows.Forms
$fileDialog = New-Object System.Windows.Forms.OpenFileDialog
$fileDialog.Title = "Select Your AP Matrimony Logo Image"
$fileDialog.Filter = "Image Files (*.png;*.jpg;*.jpeg)|*.png;*.jpg;*.jpeg|All Files (*.*)|*.*"
$fileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')

# Show dialog
$result = $fileDialog.ShowDialog()

if ($result -eq 'OK') {
    $selectedFile = $fileDialog.FileName
    Write-Host "Selected: $selectedFile" -ForegroundColor Green
    Write-Host ""
    
    # Load the image
    Add-Type -AssemblyName System.Drawing
    try {
        $image = [System.Drawing.Image]::FromFile($selectedFile)
        $width = $image.Width
        $height = $image.Height
        
        Write-Host "Image dimensions: ${width}x${height}" -ForegroundColor Cyan
        
        # Check if image needs resizing
        if ($width -ne 1024 -or $height -ne 1024) {
            Write-Host "Resizing image to 1024x1024..." -ForegroundColor Yellow
            
            # Create new bitmap
            $newImage = New-Object System.Drawing.Bitmap 1024, 1024
            $graphics = [System.Drawing.Graphics]::FromImage($newImage)
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            
            # Draw resized image
            $graphics.DrawImage($image, 0, 0, 1024, 1024)
            
            # Save resized image
            $newImage.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
            
            # Cleanup
            $graphics.Dispose()
            $newImage.Dispose()
            $image.Dispose()
            
            Write-Host "Image resized and saved!" -ForegroundColor Green
        } else {
            # Image is already correct size, just copy
            $image.Dispose()
            Copy-Item -Path $selectedFile -Destination $targetPath -Force
            Write-Host "Image copied successfully!" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "Icon saved to: $targetPath" -ForegroundColor Green
        Write-Host ""
        Write-Host "=============================================" -ForegroundColor Cyan
        Write-Host "  Generating Icons for All Platforms..." -ForegroundColor Cyan
        Write-Host "=============================================" -ForegroundColor Cyan
        Write-Host ""
        
        # Change to project directory
        $projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
        Set-Location $projectDir
        
        # Run flutter_launcher_icons
        Write-Host "Running flutter_launcher_icons..." -ForegroundColor Yellow
        & flutter pub run flutter_launcher_icons
        
        Write-Host ""
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host "  SUCCESS! Icons Generated!" -ForegroundColor Green
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "What was created:" -ForegroundColor Cyan
        Write-Host "  - Android icons (5 sizes)" -ForegroundColor White
        Write-Host "  - iOS icons (21 sizes)" -ForegroundColor White
        Write-Host "  - Web icons (favicon + PWA)" -ForegroundColor White
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "  1. Run: flutter clean" -ForegroundColor White
        Write-Host "  2. Run: flutter pub get" -ForegroundColor White
        Write-Host "  3. Run: flutter run" -ForegroundColor White
        Write-Host ""
        Write-Host "Your app will now display the matrimony logo!" -ForegroundColor Green
        
    } catch {
        Write-Host "Error processing image: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please ensure:" -ForegroundColor Yellow
        Write-Host "  - The file is a valid image (PNG, JPG)" -ForegroundColor White
        Write-Host "  - The file is not corrupted" -ForegroundColor White
        Write-Host "  - You have permission to read the file" -ForegroundColor White
    }
} else {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
