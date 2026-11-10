$logPath = "D:/PHOTO DESIGNING/scratch/skp_startup_log.txt"
$rbPath = "D:/PHOTO DESIGNING/scratch/run_test.rb"

$rbCode = @"
File.open('$logPath', 'w') do |f|
  f.puts 'Hello from SketchUp RubyStartup!'
  f.puts 'Sketchup version: ' + Sketchup.version
  f.puts 'Active model: ' + Sketchup.active_model.to_s
end
Sketchup.quit
"@

Set-Content -Path "d:\PHOTO DESIGNING\scratch\run_test.rb" -Value $rbCode
$proc = Start-Process "C:\Program Files\SketchUp\SketchUp 2024\SketchUp.exe" -ArgumentList "-RubyStartup `"$rbPath`"" -PassThru
Start-Sleep -Seconds 6
if (!$proc.HasExited) {
    Stop-Process -Id $proc.Id -Force
}

if (Test-Path "D:\PHOTO DESIGNING\scratch\skp_startup_log.txt") {
    Get-Content "D:\PHOTO DESIGNING\scratch\skp_startup_log.txt"
} else {
    Write-Host "RubyStartup Log not created"
}
