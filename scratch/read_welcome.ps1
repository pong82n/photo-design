$path = "C:\Users\MIRR\AppData\Local\SketchUp\SketchUp 2024\SketchUp\PrivatePreferences.json"
$content = Get-Content $path -Raw
$pos = $content.IndexOf("BlendtecWelcomeDialog")
if ($pos -ge 0) {
    Write-Host $content.Substring($pos, [Math]::Min(300, $content.Length - $pos))
}
