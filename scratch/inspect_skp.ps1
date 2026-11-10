$proc = Start-Process "C:\Program Files\SketchUp\SketchUp 2024\SketchUp.exe" -PassThru
Start-Sleep -Seconds 4
Get-Process | Where-Object { $_.ProcessName -like "*sketch*" } | Select-Object Id, ProcessName, MainWindowTitle, Responding
Stop-Process -Id $proc.Id -Force
