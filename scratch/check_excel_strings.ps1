Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-ExcelStrings($path) {
    Write-Host "Checking: $path"
    $zip = [System.IO.Compression.ZipFile]::OpenRead($path)
    $entry = $zip.GetEntry('xl/sharedStrings.xml')
    if ($entry) {
        $stream = $entry.Open()
        $reader = New-Object System.IO.StreamReader($stream)
        $xml = $reader.ReadToEnd()
        $reader.Close()
        $stream.Close()
        [regex]::Matches($xml, '<t>(.*?)</t>') | ForEach-Object {
            $val = $_.Groups[1].Value
            if ($val -match "Address|Street|Brgy|Barangay|City|Kalibo|Aklan|Quezon|Manila|Bulacan|Cavite|Rizal|Laguna|Novaliches|Bagbag") {
                Write-Host "Found: $val"
            }
        }
    }
    $zip.Dispose()
}

Get-ExcelStrings "D:\PHOTO DESIGNING\MIRR_Construction_Services_Payroll_System.xlsx"
Get-ExcelStrings "D:\PHOTO DESIGNING\Bagbag_Integrated_School_Progress_Report.xlsx"
