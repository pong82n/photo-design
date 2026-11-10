Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg")
$w = $img.Width
$h = $img.Height

# Sample horizontal line across center at various Y to locate photo boundaries
for ($y = 150; $y -lt 800; $y += 25) {
    # count non-dark pixels in middle
    $brightCount = 0
    for ($x = 200; $x -lt 650; $x += 10) {
        $c = $img.GetPixel($x, $y)
        if ($c.R -gt 80 -or $c.G -gt 80 -or $c.B -gt 80) {
            $brightCount++
        }
    }
    Write-Host "Y=$y BrightCount=$brightCount"
}

$img.Dispose()
