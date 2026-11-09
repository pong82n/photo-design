Add-Type -AssemblyName System.Drawing

$baseCardPath = "D:\PHOTO DESIGNING\MIRR_Modern_ID_Front_RaffySoguilon.jpg"
$photoPath = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"

$cardBmp = [System.Drawing.Bitmap]::FromFile($baseCardPath)
$photoBmp = [System.Drawing.Bitmap]::FromFile($photoPath)

$w = $cardBmp.Width
$h = $cardBmp.Height

$result = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$result.SetResolution($cardBmp.HorizontalResolution, $cardBmp.VerticalResolution)

$g = [System.Drawing.Graphics]::FromImage($result)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# 1. Draw base card image
$g.DrawImage($cardBmp, 0, 0, $w, $h)

# 2. Exact rectangular frame line coordinates
$frameX = [float]296.0
$frameY = [float]356.0
$frameW = [float]255.0
$frameH = [float]293.0

$rect = New-Object System.Drawing.RectangleF($frameX, $frameY, $frameW, $frameH)

# 3. Clip strictly to the rectangular line (sharp right angles, zero radius)
$gState = $g.Save()
$g.SetClip($rect)

# Draw master ID photo scaled to cover and perfectly centered
$srcW = [float]$photoBmp.Width
$srcH = [float]$photoBmp.Height

$scale = [Math]::Max($frameW / $srcW, $frameH / $srcH)
$drawW = [float]($srcW * $scale)
$drawH = [float]($srcH * $scale)
$drawX = [float]($frameX + ($frameW - $drawW) * 0.5)
$drawY = [float]$frameY

$g.DrawImage($photoBmp, $drawX, $drawY, $drawW, $drawH)
$g.Restore($gState)

# 4. Draw precision rectangular border flush on the rectangular line
# Subtle outer bevel
$bevelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 20, 32, 48), [float]1.0)
$g.DrawRectangle($bevelPen, [float]($frameX - 1.0), [float]($frameY - 1.0), [float]($frameW + 2.0), [float]($frameH + 2.0))
$bevelPen.Dispose()

# Precision rectangular frame border line (clean titanium silver/cyan matching the card's line)
$framePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(210, 205, 222, 235), [float]1.5)
$g.DrawRectangle($framePen, $frameX, $frameY, $frameW, $frameH)
$framePen.Dispose()

$g.Dispose()
$cardBmp.Dispose()
$photoBmp.Dispose()

# Save with maximum JPEG quality
$encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageDecoders() | Where-Object { $_.FormatID -eq [System.Drawing.Imaging.ImageFormat]::Jpeg.Guid }
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]98)

$destPaths = @(
    "D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg",
    "D:\PHOTO DESIGNING\MIRR_Employee_ID_Front.jpg",
    "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Modern_ID_Front.jpg",
    "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Employee_ID_Front.jpg"
)

foreach ($dest in $destPaths) {
    if (Test-Path $dest) { Remove-Item $dest -Force }
    $result.Save($dest, $encoder, $encParams)
    Write-Host "Saved: $dest"
}

$result.Dispose()
Write-Host "Embedding complete!"
