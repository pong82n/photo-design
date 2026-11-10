$path = "C:\Users\MIRR\AppData\Local\SketchUp\SketchUp 2024\SketchUp\PrivatePreferences.json"
$content = Get-Content $path -Raw
$matches = [regex]::Matches($content, '"[^"]*Welcome[^"]*"\s*:\s*[^,\n\}]+')
foreach ($m in $matches) {
    Write-Host $m.Value
}

$path2 = "C:\Users\MIRR\AppData\Roaming\SketchUp\SketchUp 2024\SketchUp\SharedPreferences.json"
$content2 = Get-Content $path2 -Raw
$matches2 = [regex]::Matches($content2, '"[^"]*Welcome[^"]*"\s*:\s*[^,\n\}]+')
foreach ($m in $matches2) {
    Write-Host $m.Value
}
