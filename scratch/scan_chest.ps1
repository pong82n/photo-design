Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\Professional_ID_Photo.jpg")
$w = $img.Width
$h = $img.Height

for ($y = 820; $y -lt 1150; $y += 20) {
    for ($x = 100; $x -lt 450; $x += 20) {
        $c = $img.GetPixel($x, $y)
        if ($c.R -gt 70 -or $c.G -gt 70 -or $c.B -gt 90) {
            Write-Host "Non-navy at ($x, $y): R=$($c.R) G=$($c.G) B=$($c.B)"
        }
    }
}

$img.Dispose()
