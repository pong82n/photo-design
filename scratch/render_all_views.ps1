# Automated High-Resolution 3D Architectural Renderer
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$workDir = "D:\PHOTO DESIGNING"
$artifactDir = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd"

$views = @(
    @{ Name = "Modern_60sqm_House_Render_Daytime_Street"; View = "street"; Desc = "01 Daytime Street Perspective" },
    @{ Name = "Modern_60sqm_House_Render_Terrace_Closeup"; View = "terrace"; Desc = "02 Cantilevered Terrace Close-Up" },
    @{ Name = "Modern_60sqm_House_Render_Left_Firewall"; View = "firewall"; Desc = "03 Left Firewall Elevation" },
    @{ Name = "Modern_60sqm_House_Render_Evening_Dusk"; View = "dusk"; Desc = "04 Twilight Dusk Architectural Illumination" },
    @{ Name = "Modern_60sqm_House_Render_Birdseye"; View = "aerial"; Desc = "05 Aerial Axonometric Overview" }
)

foreach ($v in $views) {
    $outPng = "$workDir\$($v.Name).png"
    $outJpg = "$workDir\$($v.Name).jpg"
    $artJpg = "$artifactDir\$($v.Name).jpg"
    $url = "file:///$($workDir -replace '\\','/')/Render_Clean_Views.html?view=$($v.View)"

    Write-Output "Rendering $($v.Desc)..."

    $p = New-Object System.Diagnostics.Process
    $p.StartInfo.FileName = $chromePath
    $p.StartInfo.Arguments = "--headless=new --no-sandbox --allow-file-access-from-files --window-size=1920,1080 --virtual-time-budget=4000 --screenshot=`"$outPng`" `"$url`""
    $p.StartInfo.RedirectStandardError = $true
    $p.StartInfo.UseShellExecute = $false
    $p.Start() | Out-Null
    $p.WaitForExit()

    if (Test-Path $outPng) {
        # Convert PNG to high-quality JPG via System.Drawing
        Add-Type -AssemblyName System.Drawing
        $img = [System.Drawing.Image]::FromFile($outPng)
        $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
        $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 96L)
        
        $img.Save($outJpg, $codec, $encoderParams)
        $img.Save($artJpg, $codec, $encoderParams)
        $img.Dispose()
        Remove-Item $outPng -Force -ErrorAction SilentlyContinue

        $fi = Get-Item $outJpg
        Write-Output "  -> Saved: $outJpg ($([math]::Round($fi.Length / 1KB, 1)) KB)"
    } else {
        Write-Warning "  -> Failed to capture $outPng"
    }
}

# Also save the primary default render
Copy-Item "$workDir\Modern_60sqm_House_Render_Daytime_Street.jpg" "$workDir\Modern_60sqm_House_Renovation_Render.jpg" -Force
Copy-Item "$workDir\Modern_60sqm_House_Render_Daytime_Street.jpg" "$artifactDir\Modern_60sqm_House_Renovation_Render.jpg" -Force
Write-Output "ALL RENDERS COMPLETED SUCCESSFULLY!"
