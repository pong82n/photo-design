Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\Professional_ID_Photo.jpg")
$w = $bmp.Width
$h = $bmp.Height
Write-Host "Width: $w, Height: $h"

# Find chin tip and collar position by analyzing brightness and color vertically down the center column
$cx = [int]($w * 0.5)
for ($y = [int]($h * 0.45); $y -lt [int]($h * 0.85); $y += 5) {
    $c = $bmp.GetPixel($cx, $y)
    Write-Host "Y=$y R=$($c.R) G=$($c.G) B=$($c.B)"
}

$bmp.Dispose()
