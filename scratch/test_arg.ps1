$modelPath = "D:\PHOTO DESIGNING\Kalibo_Project_model.skp"
$logPath = "D:/PHOTO DESIGNING/scratch/skp_arg_test.txt"
$rbPath = "C:\Users\MIRR\AppData\Roaming\SketchUp\SketchUp 2024\SketchUp\Plugins\test_arg.rb"

$rbCode = @"
File.open('$logPath', 'w') do |f|
  f.puts 'SUCCESS: Ruby executed!'
  f.puts 'Model: ' + Sketchup.active_model.title
  f.puts 'Entities count: ' + Sketchup.active_model.entities.count.to_s
end
Sketchup.quit
"@

Set-Content -Path $rbPath -Value $rbCode

# Pass quoted path
$proc = Start-Process "C:\Program Files\SketchUp\SketchUp 2024\SketchUp.exe" -ArgumentList "`"$modelPath`"" -PassThru
Start-Sleep -Seconds 6
if (!$proc.HasExited) {
    Stop-Process -Id $proc.Id -Force
}
Remove-Item $rbPath -Force -ErrorAction SilentlyContinue

if (Test-Path "D:\PHOTO DESIGNING\scratch\skp_arg_test.txt") {
    Get-Content "D:\PHOTO DESIGNING\scratch\skp_arg_test.txt"
} else {
    Write-Host "Log still not created"
}
