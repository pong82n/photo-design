Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg")
$w = $img.Width
$y = 480

for ($x = 150; $x -le 700; $x += 10) {
    $c = $img.GetPixel($x, $y)
    Write-Host "X=$x R=$($c.R) G=$($c.G) B=$($c.B)"
}

$img.Dispose()
