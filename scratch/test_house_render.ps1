$p = New-Object System.Diagnostics.Process
$p.StartInfo.FileName = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$p.StartInfo.Arguments = "--headless=new --no-sandbox --allow-file-access-from-files --window-size=1920,1080 --virtual-time-budget=5000 --screenshot=`"D:\PHOTO DESIGNING\scratch\house_3d_render.png`" `"file:///D:/PHOTO DESIGNING/Modern_60sqm_House_3D_Model.html`""
$p.StartInfo.RedirectStandardError = $true
$p.StartInfo.UseShellExecute = $false
$p.Start() | Out-Null
$err = $p.StandardError.ReadToEnd()
$p.WaitForExit()
Write-Output "ExitCode: $($p.ExitCode)"
Write-Output "Stderr: $err"
Write-Output "Exists: $(Test-Path 'D:\PHOTO DESIGNING\scratch\house_3d_render.png')"
if (Test-Path 'D:\PHOTO DESIGNING\scratch\house_3d_render.png') {
    $item = Get-Item 'D:\PHOTO DESIGNING\scratch\house_3d_render.png'
    Write-Output "Size: $($item.Length) bytes"
}
