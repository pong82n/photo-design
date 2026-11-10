$path = "D:\PHOTO DESIGNING\Kalibo_Project_model.skp"
$stream = [System.IO.File]::OpenRead($path)
$buf = New-Object byte[] 32
$stream.Read($buf, 0, 32) | Out-Null
$stream.Close()
Write-Host "Hex:" ([BitConverter]::ToString($buf))
Write-Host "ASCII:" ([System.Text.Encoding]::ASCII.GetString($buf))
