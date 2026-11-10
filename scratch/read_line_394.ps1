$line = (Get-Content "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\.system_generated\logs\transcript_full.jsonl")[394]
$matches = [regex]::Matches($line, '(Office|Address|Station|Location|Kalibo|Metro Manila|Aklan)[^<\\"\n]{0,80}')
foreach ($m in $matches) {
    Write-Host $m.Value
}
