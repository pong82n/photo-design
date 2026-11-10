$content = Get-Content "C:\Users\MIRR\AppData\Local\SketchUp\SketchUp 2024\SketchUp\PrivatePreferences.json" -Raw
$matches = [regex]::Matches($content, '"[^"]*(?:Startup|Template|Welcome|ShowDialog)[^"]*"\s*:\s*[^,\n\}]+')
foreach ($m in $matches) {
    Write-Host $m.Value
}
