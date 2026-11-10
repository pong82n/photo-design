$lines = Get-Content "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\.system_generated\logs\transcript.jsonl"
for ($idx = 0; $idx -lt $lines.Count; $idx++) {
    if ($lines[$idx] -match '"type":"USER_INPUT"') {
        $json = $lines[$idx] | ConvertFrom-Json
        $c = $json.content
        if ($c -match "(?i)address|street|kalibo|aklan|poblacion|city|office|manila") {
            Write-Host "Index $idx :"
            Write-Host $c
        }
    }
}
