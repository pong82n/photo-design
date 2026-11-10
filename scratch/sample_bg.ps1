Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\Professional_ID_Photo.jpg")
Write-Host "Width: $($img.Width), Height: $($img.Height)"

# Sample corners and top edges where background is
$corners = @(
    [System.Drawing.Point]::new(20, 20),
    [System.Drawing.Point]::new($img.Width - 20, 20),
    [System.Drawing.Point]::new(50, 100),
    [System.Drawing.Point]::new($img.Width - 50, 100),
    [System.Drawing.Point]::new(50, 300),
    [System.Drawing.Point]::new($img.Width - 50, 300),
    [System.Drawing.Point]::new(50, 500),
    [System.Drawing.Point]::new($img.Width - 50, 500)
)

foreach ($pt in $corners) {
    $c = $img.GetPixel($pt.X, $pt.Y)
    Write-Host "Pt ($($pt.X), $($pt.Y)): R=$($c.R) G=$($c.G) B=$($c.B)"
}

$img.Dispose()
