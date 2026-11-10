$logPath = "D:/PHOTO DESIGNING/scratch/skp_test_log.txt"
$rbPath = "C:\Users\MIRR\AppData\Roaming\SketchUp\SketchUp 2024\SketchUp\Plugins\test_startup.rb"

$rbCode = @"
begin
  log = File.open('$logPath', 'w')
  log.puts 'SketchUp Ruby Version: ' + RUBY_VERSION
  log.puts 'Sketchup Version: ' + Sketchup.version
  model = Sketchup.active_model
  log.puts 'Active model: ' + (model ? model.title : 'nil')
  log.close
rescue => e
  File.open('$logPath', 'w') { |f| f.puts 'Error: ' + e.message }
ensure
  Sketchup.quit
end
"@

Set-Content -Path $rbPath -Value $rbCode
$proc = Start-Process "C:\Program Files\SketchUp\SketchUp 2024\SketchUp.exe" -ArgumentList "D:\PHOTO DESIGNING\Kalibo_Project_model.skp" -PassThru
Start-Sleep -Seconds 8
if (!$proc.HasExited) {
    Stop-Process -Id $proc.Id -Force
}
Remove-Item $rbPath -Force -ErrorAction SilentlyContinue

if (Test-Path "D:\PHOTO DESIGNING\scratch\skp_test_log.txt") {
    Get-Content "D:\PHOTO DESIGNING\scratch\skp_test_log.txt"
} else {
    Write-Host "Log not created"
}
