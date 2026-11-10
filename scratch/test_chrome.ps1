$p = New-Object System.Diagnostics.Process
$p.StartInfo.FileName = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$p.StartInfo.Arguments = "--headless=new --no-sandbox --screenshot=`"D:\PHOTO DESIGNING\scratch\chrome_test.png`" https://example.com"
$p.StartInfo.RedirectStandardError = $true
$p.StartInfo.UseShellExecute = $false
$p.Start() | Out-Null
$err = $p.StandardError.ReadToEnd()
$p.WaitForExit()
Write-Output "ExitCode: $($p.ExitCode)"
Write-Output "Stderr: $err"
Write-Output "Exists: $(Test-Path 'D:\PHOTO DESIGNING\scratch\chrome_test.png')"
