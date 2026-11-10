Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg")
Write-Host "Width: $($img.Width), Height: $($img.Height)"
$img.Dispose()
