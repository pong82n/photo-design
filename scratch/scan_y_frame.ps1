Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg")
$cx = 424

for ($y = 330; $y -le 660; $y += 5) {
    $c = $img.GetPixel($cx, $y)
    Write-Host "Y=$y R=$($c.R) G=$($c.G) B=$($c.B)"
}

$img.Dispose()
