Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\Professional_ID_Photo.jpg")
$w = $img.Width
$h = $img.Height
Write-Host "Width: $w, Height: $h"

# Look for orange/bright pixels in left chest area (viewer's left: X from 150 to 400, Y from 800 to 1100)
$minX = 9999; $maxX = 0; $minY = 9999; $maxY = 0; $foundCount = 0

for ($y = 800; $y -lt 1150; $y += 2) {
    for ($x = 120; $x -lt 450; $x += 2) {
        $c = $img.GetPixel($x, $y)
        # Orange has R > 150, G between 40 and 150, B < 70
        if ($c.R -gt 150 -and $c.G -gt 40 -and $c.G -lt 160 -and $c.B -lt 80) {
            $foundCount++
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

Write-Host "Found $foundCount orange pixels in chest logo area: X: $minX to $maxX, Y: $minY to $maxY"
$img.Dispose()
