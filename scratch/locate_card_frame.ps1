Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg")
$w = $img.Width
$h = $img.Height
Write-Host "Width: $w, Height: $h"

# Find photo frame borders:
# It's centered horizontally (X ~ 250 to 600), vertical Y ~ 300 to 650
# Let's inspect rows around Y = 320 to 650
for ($y = 300; $y -le 700; $y += 20) {
    # Check average brightness and colors across X
    $cMid = $img.GetPixel([int]($w*0.5), $y)
    $cLeft = $img.GetPixel(200, $y)
    $cRight = $img.GetPixel(650, $y)
    Write-Host "Y=$y Mid=(R:$($cMid.R), G:$($cMid.G), B:$($cMid.B)) Left=(R:$($cLeft.R), G:$($cLeft.G), B:$($cLeft.B))"
}

$img.Dispose()
