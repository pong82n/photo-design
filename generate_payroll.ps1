Get-Process excel -ErrorAction SilentlyContinue | Stop-Process -Force

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

$wb = $excel.Workbooks.Add()

# Create 4 worksheets
while ($wb.Sheets.Count -lt 4) { $wb.Sheets.Add() | Out-Null }
while ($wb.Sheets.Count -gt 4) { $wb.Sheets.Item(4).Delete() }

$ws1 = $wb.Sheets.Item(1); $ws1.Name = "Payroll Register"
$ws2 = $wb.Sheets.Item(2); $ws2.Name = "Biometric DTR"
$ws3 = $wb.Sheets.Item(3); $ws3.Name = "Individual Payslip"
$ws4 = $wb.Sheets.Item(4); $ws4.Name = "All Payslips (Print Batch)"

function Get-OleColor($r, $g, $b) {
    return ($b * 65536) + ($g * 256) + $r
}

$colorNavy        = Get-OleColor 18 43 82     # #122B52 - Deep Navy
$colorBlueHeader  = Get-OleColor 32 74 135    # #204A87 - Primary Blue
$colorSubHeader   = Get-OleColor 225 235 248  # Soft Ice Blue
$colorYellowEdit  = Get-OleColor 255 255 204  # Soft Yellow
$colorGreen       = Get-OleColor 34 139 34    # Dark Green
$colorLightGreen  = Get-OleColor 230 245 230  # Soft Green
$colorLightRed    = Get-OleColor 255 235 235  # Soft Red
$colorLightGray   = Get-OleColor 248 249 250  # Soft Row Tint
$colorBorder      = Get-OleColor 180 180 180  # Border Gray

# ==============================================================================
# SHEET 2: BIOMETRIC DTR
# ==============================================================================
$ws2.Select()
$excel.ActiveWindow.DisplayGridlines = $true

$ws2.Range("B2:L2").Merge()
$ws2.Range("B2").Value2 = "MIRR CONSTRUCTION SERVICES - BIOMETRIC DAILY TIME RECORD (DTR)"
$ws2.Range("B2").Font.Size = 16
$ws2.Range("B2").Font.Bold = $true
$ws2.Range("B2").Font.Color = $colorNavy

$ws2.Range("B3:L3").Merge()
$ws2.Range("B3").Value2 = "Shift: 08:00 AM - 05:00 PM (1 Hr Lunch Break) | Rule: ₱50 Meal Allowance requires 8.0 Full Hours Completed (No Late / Undertime)"
$ws2.Range("B3").Font.Italic = $true
$ws2.Range("B3").Font.Color = Get-OleColor 100 100 100

# Summary KPI Table on DTR (Rows 5-7)
$ws2.Range("B5:C5").Merge(); $ws2.Range("B5").Value2 = "TOTAL EMPLOYEES"
$ws2.Range("B5").Interior.Color = $colorNavy; $ws2.Range("B5").Font.Color = Get-OleColor 255 255 255; $ws2.Range("B5").Font.Bold = $true; $ws2.Range("B5").HorizontalAlignment = -4108
$ws2.Range("B6:C7").Merge(); $ws2.Range("B6").Value2 = 10; $ws2.Range("B6").Font.Size = 18; $ws2.Range("B6").Font.Bold = $true; $ws2.Range("B6").HorizontalAlignment = -4108; $ws2.Range("B6").VerticalAlignment = -4108
$ws2.Range("B5:C7").BorderAround(1, 2)

$ws2.Range("D5:E5").Merge(); $ws2.Range("D5").Value2 = "TOTAL DAYS WORKED"
$ws2.Range("D5").Interior.Color = $colorBlueHeader; $ws2.Range("D5").Font.Color = Get-OleColor 255 255 255; $ws2.Range("D5").Font.Bold = $true; $ws2.Range("D5").HorizontalAlignment = -4108
$ws2.Range("D6:E7").Merge(); $ws2.Range("D6").Formula = "=SUM(G28:G37)"; $ws2.Range("D6").Font.Size = 18; $ws2.Range("D6").Font.Bold = $true; $ws2.Range("D6").HorizontalAlignment = -4108; $ws2.Range("D6").VerticalAlignment = -4108
$ws2.Range("D5:E7").BorderAround(1, 2)

$ws2.Range("F5:G5").Merge(); $ws2.Range("F5").Value2 = "TOTAL LATE DEDUCTION MINS"
$ws2.Range("F5").Interior.Color = Get-OleColor 180 50 40; $ws2.Range("F5").Font.Color = Get-OleColor 255 255 255; $ws2.Range("F5").Font.Bold = $true; $ws2.Range("F5").HorizontalAlignment = -4108
$ws2.Range("F6:G7").Merge(); $ws2.Range("F6").Formula = "=SUM(I28:I37)"; $ws2.Range("F6").Font.Size = 18; $ws2.Range("F6").Font.Bold = $true; $ws2.Range("F6").HorizontalAlignment = -4108; $ws2.Range("F6").VerticalAlignment = -4108
$ws2.Range("F5:G7").BorderAround(1, 2)

$ws2.Range("H5:I5").Merge(); $ws2.Range("H5").Value2 = "QUALIFIED 8-HR MEAL ALLOWANCES"
$ws2.Range("H5").Interior.Color = Get-OleColor 24 100 60; $ws2.Range("H5").Font.Color = Get-OleColor 255 255 255; $ws2.Range("H5").Font.Bold = $true; $ws2.Range("H5").HorizontalAlignment = -4108
$ws2.Range("H6:I7").Merge(); $ws2.Range("H6").Formula = "=SUM(K28:K37)"; $ws2.Range("H6").Font.Size = 18; $ws2.Range("H6").Font.Bold = $true; $ws2.Range("H6").HorizontalAlignment = -4108; $ws2.Range("H6").VerticalAlignment = -4108
$ws2.Range("H5:I7").BorderAround(1, 2)

$ws2.Range("J5:L5").Merge(); $ws2.Range("J5").Value2 = "TOTAL OVERTIME HOURS"
$ws2.Range("J5").Interior.Color = Get-OleColor 210 100 20; $ws2.Range("J5").Font.Color = Get-OleColor 255 255 255; $ws2.Range("J5").Font.Bold = $true; $ws2.Range("J5").HorizontalAlignment = -4108
$ws2.Range("J6:L7").Merge(); $ws2.Range("J6").Formula = "=SUM(J28:J37)"; $ws2.Range("J6").Font.Size = 18; $ws2.Range("J6").Font.Bold = $true; $ws2.Range("J6").HorizontalAlignment = -4108; $ws2.Range("J6").VerticalAlignment = -4108
$ws2.Range("J5:L7").BorderAround(1, 2)

# Section A: Daily Biometric Log (Detailed Sample Log for Cut-off Period: Nov 01 - 15)
$ws2.Range("B9:L9").Merge()
$ws2.Range("B9").Value2 = "SECTION 1: DAILY BIOMETRIC TIME LOG & 8-HOUR WORK AUDIT (Sample 15-Day Cut-off)"
$ws2.Range("B9").Font.Bold = $true; $ws2.Range("B9").Interior.Color = $colorSubHeader; $ws2.Range("B9").Font.Color = $colorNavy

$dtrHeaders = @("Date", "Day", "Worker Name", "Biometric IN", "Biometric OUT", "Late (Mins)", "Reg Hours", "OT Hours", "8-Hrs Done?", "Meal Allow.", "Status")
for ($c = 0; $c -lt $dtrHeaders.Length; $c++) {
    $cell = $ws2.Cells.Item(10, 2 + $c)
    $cell.Value2 = $dtrHeaders[$c]
    $cell.Font.Bold = $true
    $cell.Interior.Color = $colorBlueHeader
    $cell.Font.Color = Get-OleColor 255 255 255
    $cell.HorizontalAlignment = -4108
}

$sampleDays = @(
    @("Nov 01, 2026", "Sun", "Eduardo Mendoza", "",         "",         0,  0.0, 0.0, "No",  0,  "Rest Day"),
    @("Nov 02, 2026", "Mon", "Eduardo Mendoza", "07:55 AM", "05:00 PM", 0,  8.0, 0.0, "YES", 50, "Present"),
    @("Nov 03, 2026", "Tue", "Eduardo Mendoza", "08:15 AM", "07:00 PM", 15, 7.75,2.0, "No",  0,  "Present (Late 15m)"), # Late! <8 hrs reg work time completed -> No Meal Allowance!
    @("Nov 04, 2026", "Wed", "Eduardo Mendoza", "07:50 AM", "06:00 PM", 0,  8.0, 1.0, "YES", 50, "Present"),
    @("Nov 05, 2026", "Thu", "Eduardo Mendoza", "08:00 AM", "07:00 PM", 0,  8.0, 2.0, "YES", 50, "Present"),
    @("Nov 06, 2026", "Fri", "Eduardo Mendoza", "08:20 AM", "06:00 PM", 20, 7.67,1.0, "No",  0,  "Present (Late 20m)"), # Late! No Meal Allowance
    @("Nov 07, 2026", "Sat", "Eduardo Mendoza", "07:48 AM", "05:00 PM", 0,  8.0, 0.0, "YES", 50, "Present"),
    @("Nov 08, 2026", "Sun", "Eduardo Mendoza", "",         "",         0,  0.0, 0.0, "No",  0,  "Rest Day"),
    @("Nov 09, 2026", "Mon", "Eduardo Mendoza", "07:50 AM", "07:00 PM", 0,  8.0, 2.0, "YES", 50, "Present"),
    @("Nov 10, 2026", "Tue", "Eduardo Mendoza", "07:55 AM", "06:00 PM", 0,  8.0, 1.0, "YES", 50, "Present"),
    @("Nov 11, 2026", "Wed", "Eduardo Mendoza", "08:00 AM", "07:00 PM", 0,  8.0, 2.0, "YES", 50, "Present"),
    @("Nov 12, 2026", "Thu", "Eduardo Mendoza", "",         "",         0,  0.0, 0.0, "No",  0,  "Absent"),
    @("Nov 13, 2026", "Fri", "Eduardo Mendoza", "07:45 AM", "05:00 PM", 0,  8.0, 0.0, "YES", 50, "Present"),
    @("Nov 14, 2026", "Sat", "Eduardo Mendoza", "07:50 AM", "06:00 PM", 0,  8.0, 1.0, "YES", 50, "Present"),
    @("Nov 15, 2026", "Sun", "Eduardo Mendoza", "",         "",         0,  0.0, 0.0, "No",  0,  "Rest Day")
)

for ($i = 0; $i -lt $sampleDays.Length; $i++) {
    $r = 11 + $i
    $d = $sampleDays[$i]
    $ws2.Cells.Item($r, 2).Value2 = [string]$d[0]
    $ws2.Cells.Item($r, 3).Value2 = [string]$d[1]
    $ws2.Cells.Item($r, 4).Value2 = [string]$d[2]
    $ws2.Cells.Item($r, 5).Value2 = [string]$d[3]
    $ws2.Cells.Item($r, 6).Value2 = [string]$d[4]
    
    $ws2.Cells.Item($r, 7).Value2 = [double]$d[5]
    $ws2.Cells.Item($r, 8).Value2 = [double]$d[6]
    $ws2.Cells.Item($r, 9).Value2 = [double]$d[7]
    $ws2.Cells.Item($r, 10).Formula = "=IF(H$r>=8.0, ""YES"", ""NO"")"
    $ws2.Cells.Item($r, 11).Formula = "=IF(J$r=""YES"", 50, 0)"
    $ws2.Cells.Item($r, 12).Value2 = [string]$d[10]
    
    $ws2.Range("B${r}:C$r").HorizontalAlignment = -4108
    $ws2.Range("E${r}:L$r").HorizontalAlignment = -4108
    $ws2.Cells.Item($r, 11).NumberFormat = "₱#,##0.00"
    
    if ($d[10] -eq "Absent") {
        $ws2.Range("B${r}:L$r").Interior.Color = $colorLightRed
    } elseif ($d[5] -gt 0) {
        $ws2.Range("G$r").Interior.Color = Get-OleColor 255 220 220
        $ws2.Range("J${r}:K$r").Interior.Color = Get-OleColor 255 240 200
    }
}
$ws2.Range("B10:L25").Borders.LineStyle = 1

# Section B: Summary Matrix per Worker for the Payroll Cut-off (Rows 27-37)
$ws2.Range("B26:L26").Merge()
$ws2.Range("B26").Value2 = "SECTION 2: WORKER ATTENDANCE, BIOMETRIC LATE & MEAL ALLOWANCE AGGREGATE SUMMARY"
$ws2.Range("B26").Font.Bold = $true; $ws2.Range("B26").Interior.Color = $colorNavy; $ws2.Range("B26").Font.Color = Get-OleColor 255 255 255

$matHeaders = @("Emp ID", "Worker Name", "Position / Trade", "Daily Rate", "Days Sched.", "Days Present", "Days Absent", "Late (Mins)", "OT Hours", "8-Hr Days (₱50)", "Total Meal Allow.")
for ($c = 0; $c -lt $matHeaders.Length; $c++) {
    $cell = $ws2.Cells.Item(27, 2 + $c)
    $cell.Value2 = $matHeaders[$c]
    $cell.Font.Bold = $true; $cell.Interior.Color = $colorBlueHeader; $cell.Font.Color = Get-OleColor 255 255 255; $cell.HorizontalAlignment = -4108
}

$workerSummary = @(
    @("MCS-001", "Engr. Ricardo Ramos",    "Project Site Engineer",        1100.0, 13, 13, 0,  0, 16.0, 13),
    @("MCS-002", "Danilo Santos",          "General Construction Foreman",  900.0, 13, 13, 0, 10, 14.0, 12),
    @("MCS-003", "Eduardo Mendoza",        "Lead Mason / Bricklayer",       750.0, 13, 12, 1, 35, 12.0, 10),
    @("MCS-004", "Ramon Bautista",         "Structural Welder / Fitter",    750.0, 13, 12, 1, 15, 10.0, 11),
    @("MCS-005", "Crisanto Dela Cruz",     "Master Carpenter (Roofing)",    700.0, 13, 13, 0, 25, 14.0, 11),
    @("MCS-006", "Joel Villareal",         "Electrician / Roughing-in",     700.0, 13, 12, 1,  0,  8.0, 12),
    @("MCS-007", "Nestor Alcantara",       "Backhoe / Equipment Operator",  800.0, 13, 13, 0, 10, 12.0, 12),
    @("MCS-008", "Bernardo Mercado",       "Construction Laborer 1",        570.0, 13, 13, 0, 40,  8.0, 10),
    @("MCS-009", "Arnel Gutierrez",        "Construction Laborer 2",        570.0, 13, 11, 2,  0,  6.0, 11),
    @("MCS-010", "Michael Soriano",        "Construction Laborer 3",        570.0, 13, 13, 0, 20, 10.0, 11)
)

for ($i = 0; $i -lt $workerSummary.Length; $i++) {
    $r = 28 + $i
    $w = $workerSummary[$i]
    $ws2.Cells.Item($r, 2).Value2 = [string]$w[0]  # ID
    $ws2.Cells.Item($r, 3).Value2 = [string]$w[1]  # Name
    $ws2.Cells.Item($r, 4).Value2 = [string]$w[2]  # Position
    $ws2.Cells.Item($r, 5).Value2 = [double]$w[3]  # Daily Rate
    $ws2.Cells.Item($r, 6).Value2 = [double]$w[4]  # Sched
    $ws2.Cells.Item($r, 7).Value2 = [double]$w[5]  # Present
    $ws2.Cells.Item($r, 8).Formula = "=F$r-G$r"    # Absent
    $ws2.Cells.Item($r, 9).Value2 = [double]$w[7]  # Late Mins
    $ws2.Cells.Item($r, 10).Value2 = [double]$w[8] # OT Hours
    $ws2.Cells.Item($r, 11).Value2 = [double]$w[9] # 8-Hr Days (Qualified for ₱50 meal)
    $ws2.Cells.Item($r, 12).Formula = "=K$r*50"    # Total Meal Allow
    
    $ws2.Cells.Item($r, 2).HorizontalAlignment = -4108
    $ws2.Range("F${r}:L$r").HorizontalAlignment = -4108
    $ws2.Cells.Item($r, 5).NumberFormat = "₱#,##0.00"
    $ws2.Cells.Item($r, 12).NumberFormat = "₱#,##0.00"
}
$ws2.Range("B27:L37").Borders.LineStyle = 1


# ==============================================================================
# SHEET 1: PAYROLL REGISTER
# ==============================================================================
$ws1.Select()
$excel.ActiveWindow.DisplayGridlines = $true

# Header Banner
$ws1.Range("B2:Z2").Merge()
$ws1.Range("B2").Value2 = "MIRR CONSTRUCTION SERVICES"
$ws1.Range("B2").Font.Size = 18; $ws1.Range("B2").Font.Bold = $true; $ws1.Range("B2").Font.Color = $colorNavy; $ws1.Range("B2").HorizontalAlignment = -4108

$ws1.Range("B3:Z3").Merge()
$ws1.Range("B3").Value2 = "MASTER PAYROLL SYSTEM WITH BIOMETRIC LATE DEDUCTIONS & 8-HR MEAL ALLOWANCE"
$ws1.Range("B3").Font.Size = 12; $ws1.Range("B3").Font.Bold = $true; $ws1.Range("B3").Font.Color = $colorBlueHeader; $ws1.Range("B3").HorizontalAlignment = -4108

$ws1.Range("B4:Z4").Merge()
$ws1.Range("B4").Value2 = "Period: November 01 - 15, 2026 | Biometric Schedule: 8:00 AM - 5:00 PM | Rate/Min = (Daily Rate / 8) / 60 | Meal Allowance: ₱50 if 8.0 hrs completed"
$ws1.Range("B4").Font.Italic = $true; $ws1.Range("B4").Font.Size = 9; $ws1.Range("B4").Font.Color = Get-OleColor 90 90 90; $ws1.Range("B4").HorizontalAlignment = -4108

# Super Headers (Row 6)
$ws1.Range("B6:D6").Merge(); $ws1.Range("B6").Value2 = "EMPLOYEE DETAILS"; $ws1.Range("B6").Interior.Color = $colorNavy; $ws1.Range("B6").Font.Color = Get-OleColor 255 255 255
$ws1.Range("E6:G6").Merge(); $ws1.Range("E6").Value2 = "RATES"; $ws1.Range("E6").Interior.Color = $colorBlueHeader; $ws1.Range("E6").Font.Color = Get-OleColor 255 255 255
$ws1.Range("H6:K6").Merge(); $ws1.Range("H6").Value2 = "ATTENDANCE & TIME-IN/OUT AUDIT"; $ws1.Range("H6").Interior.Color = Get-OleColor 40 90 150; $ws1.Range("H6").Font.Color = Get-OleColor 255 255 255
$ws1.Range("L6:P6").Merge(); $ws1.Range("L6").Value2 = "EARNINGS & ALLOWANCES"; $ws1.Range("L6").Interior.Color = Get-OleColor 24 100 60; $ws1.Range("L6").Font.Color = Get-OleColor 255 255 255
$ws1.Range("Q6:W6").Merge(); $ws1.Range("Q6").Value2 = "DEDUCTIONS (BIOMETRIC LATE + STATUTORY + OTHER)"; $ws1.Range("Q6").Interior.Color = Get-OleColor 160 50 40; $ws1.Range("Q6").Font.Color = Get-OleColor 255 255 255
$ws1.Range("X6:Z6").Merge(); $ws1.Range("X6").Value2 = "NET TAKE-HOME PAY"; $ws1.Range("X6").Interior.Color = $colorNavy; $ws1.Range("X6").Font.Color = Get-OleColor 255 255 255
$ws1.Range("B6:Z6").Font.Bold = $true; $ws1.Range("B6:Z6").HorizontalAlignment = -4108

# Column Headers (Row 7)
$regHeaders = @(
    "Emp ID", "Employee Name", "Position / Trade",
    "Daily Rate", "Hourly Rate", "Rate / Min",
    "Days Present", "Days Absent", "Late Mins", "OT Hours",
    "Basic Pay", "Overtime Pay", "Meal Allow. (₱50 if 8h)", "Other Allow.", "GROSS EARNINGS",
    "Late Deduction", "SSS Contrib", "PhilHealth", "Pag-IBIG", "W-Tax", "Cash Adv. (Vale)", "Uniform/PPE",
    "TOTAL DEDUCTIONS", "NET PAY", "Signature"
)

for ($c = 0; $c -lt $regHeaders.Length; $c++) {
    $cell = $ws1.Cells.Item(7, 2 + $c)
    $cell.Value2 = $regHeaders[$c]
    $cell.Font.Bold = $true; $cell.Interior.Color = $colorSubHeader; $cell.Font.Color = $colorNavy; $cell.HorizontalAlignment = -4108; $cell.WrapText = $true
}

$deductData = @(
    @(950.0, 450.0, 100.0, 0.0,  1500.0, 0.0,   500.0),
    @(800.0, 380.0, 100.0, 0.0,  1000.0, 0.0,   300.0),
    @(680.0, 320.0, 100.0, 0.0,   800.0, 200.0,   0.0),
    @(680.0, 320.0, 100.0, 0.0,   500.0, 0.0,     0.0),
    @(620.0, 300.0, 100.0, 0.0,   600.0, 150.0,   0.0),
    @(620.0, 300.0, 100.0, 0.0,   500.0, 0.0,     0.0),
    @(720.0, 340.0, 100.0, 0.0,   800.0, 0.0,   200.0),
    @(500.0, 250.0, 100.0, 0.0,   300.0, 100.0,   0.0),
    @(500.0, 250.0, 100.0, 0.0,   400.0, 0.0,     0.0),
    @(500.0, 250.0, 100.0, 0.0,   500.0, 100.0,   0.0)
)

for ($i = 0; $i -lt 10; $i++) {
    $r = 8 + $i
    $dtrRow = 28 + $i
    $dd = $deductData[$i]
    
    # Employee Info from DTR sheet
    $ws1.Cells.Item($r, 2).Formula = "='Biometric DTR'!B$dtrRow"
    $ws1.Cells.Item($r, 3).Formula = "='Biometric DTR'!C$dtrRow"
    $ws1.Cells.Item($r, 4).Formula = "='Biometric DTR'!D$dtrRow"
    
    # Rates
    $ws1.Cells.Item($r, 5).Formula = "='Biometric DTR'!E$dtrRow"
    $ws1.Cells.Item($r, 6).Formula = "=E$r/8"
    $ws1.Cells.Item($r, 7).Formula = "=F$r/60"
    
    # Attendance linked from DTR
    $ws1.Cells.Item($r, 8).Formula = "='Biometric DTR'!G$dtrRow"
    $ws1.Cells.Item($r, 9).Formula = "='Biometric DTR'!H$dtrRow"
    $ws1.Cells.Item($r, 10).Formula = "='Biometric DTR'!I$dtrRow"
    $ws1.Cells.Item($r, 11).Formula = "='Biometric DTR'!J$dtrRow"
    
    # Earnings Formulas
    $ws1.Cells.Item($r, 12).Formula = "=E${r}*H${r}"                # Basic Pay = Daily Rate * Days Present
    $ws1.Cells.Item($r, 13).Formula = "=K${r}*(F${r}*1.25)"         # OT Pay = OT Hours * (Hourly * 1.25)
    $ws1.Cells.Item($r, 14).Formula = "='Biometric DTR'!L${dtrRow}" # Meal Allowance = 8-Hour Days * 50
    $ws1.Cells.Item($r, 15).Value2  = [double]$dd[6]                # Other Allowance
    $ws1.Cells.Item($r, 16).Formula = "=SUM(L${r}:O${r})"           # GROSS EARNINGS = Basic + OT + Meal + Other
    
    # Deductions Formulas
    $ws1.Cells.Item($r, 17).Formula = "=J${r}*G${r}"                # Biometric Late Deduction = Late Mins * Rate/Min!
    $ws1.Cells.Item($r, 18).Value2  = [double]$dd[0]                # SSS
    $ws1.Cells.Item($r, 19).Value2  = [double]$dd[1]                # PhilHealth
    $ws1.Cells.Item($r, 20).Value2  = [double]$dd[2]                # Pag-IBIG
    $ws1.Cells.Item($r, 21).Value2  = [double]$dd[3]                # W-Tax
    $ws1.Cells.Item($r, 22).Value2  = [double]$dd[4]                # Cash Advance (Vale)
    $ws1.Cells.Item($r, 23).Value2  = [double]$dd[5]                # Uniform/PPE
    $ws1.Cells.Item($r, 24).Formula = "=SUM(Q${r}:W${r})"           # TOTAL DEDUCTIONS (Late + Stat + Other)
    
    # Net Take-Home Pay
    $ws1.Cells.Item($r, 25).Formula = "=P${r}-X${r}"                # NET PAY = Gross Earnings - Total Deductions
    $ws1.Cells.Item($r, 26).Value2  = ""
    
    $ws1.Cells.Item($r, 2).HorizontalAlignment = -4108
    $ws1.Range("E${r}:G$r").NumberFormat = "₱#,##0.00"
    $ws1.Range("H${r}:J$r").HorizontalAlignment = -4108
    $ws1.Range("H${r}:I$r").NumberFormat = "0"
    $ws1.Cells.Item($r, 10).NumberFormat = "0"
    $ws1.Cells.Item($r, 11).NumberFormat = "0.0"
    $ws1.Cells.Item($r, 11).HorizontalAlignment = -4108
    $ws1.Range("L${r}:P$r").NumberFormat = "₱#,##0.00"
    $ws1.Range("Q${r}:Y$r").NumberFormat = "₱#,##0.00"
    
    $ws1.Cells.Item($r, 17).Interior.Color = Get-OleColor 255 240 240
    $ws1.Cells.Item($r, 25).Font.Bold = $true
    $ws1.Cells.Item($r, 25).Interior.Color = $colorLightGreen
}

# Grand Total Row
$totR = 18
$ws1.Cells.Item($totR, 2).Value2 = "GRAND TOTAL"
$ws1.Range("B${totR}:D$totR").Merge()
$ws1.Range("B$totR").HorizontalAlignment = -4108
$ws1.Range("B$totR").Font.Bold = $true

$ws1.Cells.Item($totR, 8).Formula  = "=SUM(H8:H17)"
$ws1.Cells.Item($totR, 9).Formula  = "=SUM(I8:I17)"
$ws1.Cells.Item($totR, 10).Formula = "=SUM(J8:J17)"
$ws1.Cells.Item($totR, 11).Formula = "=SUM(K8:K17)"
$ws1.Cells.Item($totR, 12).Formula = "=SUM(L8:L17)"
$ws1.Cells.Item($totR, 13).Formula = "=SUM(M8:M17)"
$ws1.Cells.Item($totR, 14).Formula = "=SUM(N8:N17)"
$ws1.Cells.Item($totR, 15).Formula = "=SUM(O8:O17)"
$ws1.Cells.Item($totR, 16).Formula = "=SUM(P8:P17)"
$ws1.Cells.Item($totR, 17).Formula = "=SUM(Q8:Q17)"
$ws1.Cells.Item($totR, 18).Formula = "=SUM(R8:R17)"
$ws1.Cells.Item($totR, 19).Formula = "=SUM(S8:S17)"
$ws1.Cells.Item($totR, 20).Formula = "=SUM(T8:T17)"
$ws1.Cells.Item($totR, 21).Formula = "=SUM(U8:U17)"
$ws1.Cells.Item($totR, 22).Formula = "=SUM(V8:V17)"
$ws1.Cells.Item($totR, 23).Formula = "=SUM(W8:W17)"
$ws1.Cells.Item($totR, 24).Formula = "=SUM(X8:X17)"
$ws1.Cells.Item($totR, 25).Formula = "=SUM(Y8:Y17)"

$ws1.Range("B${totR}:Z$totR").Font.Bold = $true
$ws1.Range("B${totR}:Z$totR").Interior.Color = $colorSubHeader
$ws1.Range("L${totR}:Y$totR").NumberFormat = "₱#,##0.00"
$ws1.Range("H${totR}:J$totR").NumberFormat = "0"
$ws1.Cells.Item($totR, 11).NumberFormat = "0.0"
$ws1.Range("B6:Z$totR").Borders.LineStyle = 1

$signRow = 21
$ws1.Range("B${signRow}:E$signRow").Merge(); $ws1.Range("B$signRow").Value2 = "Prepared by:"
$ws1.Range("H${signRow}:L$signRow").Merge(); $ws1.Range("H$signRow").Value2 = "Audited & Verified by:"
$ws1.Range("O${signRow}:T$signRow").Merge(); $ws1.Range("O$signRow").Value2 = "Approved for Disbursement by:"

$sigNameRow = 24
$ws1.Range("B${sigNameRow}:E$sigNameRow").Merge(); $ws1.Range("B$sigNameRow").Value2 = "PAYROLL IN-CHARGE"
$ws1.Range("B$($sigNameRow+1):E$($sigNameRow+1)").Merge(); $ws1.Range("B$($sigNameRow+1)").Value2 = "MIRR Construction Services"

$ws1.Range("H${sigNameRow}:L$sigNameRow").Merge(); $ws1.Range("H$sigNameRow").Value2 = "HR & TIMEKEEPING OFFICER"
$ws1.Range("H$($sigNameRow+1):L$($sigNameRow+1)").Merge(); $ws1.Range("H$($sigNameRow+1)").Value2 = "MIRR Construction Services"

$ws1.Range("O${sigNameRow}:T$sigNameRow").Merge(); $ws1.Range("O$sigNameRow").Value2 = "GENERAL MANAGER / PROPRIETOR"
$ws1.Range("O$($sigNameRow+1):T$($sigNameRow+1)").Merge(); $ws1.Range("O$($sigNameRow+1)").Value2 = "MIRR Construction Services"

$ws1.Range("B${sigNameRow}:T$sigNameRow").Font.Bold = $true
$ws1.Range("B${sigNameRow}:E$sigNameRow").Borders.Item(8).LineStyle = 1
$ws1.Range("H${sigNameRow}:L$sigNameRow").Borders.Item(8).LineStyle = 1
$ws1.Range("O${sigNameRow}:T$sigNameRow").Borders.Item(8).LineStyle = 1


# ==============================================================================
# SHEET 3: INDIVIDUAL PAYSLIP GENERATOR
# ==============================================================================
$ws3.Select()
$excel.ActiveWindow.DisplayGridlines = $true

$logoPath = "D:\PHOTO DESIGNING\MIRR_Construction_Logo.jpg"
if (Test-Path $logoPath) {
    $ws3.Shapes.AddPicture($logoPath, 0, 1, 35, 18, 90, 65) | Out-Null
}

$ws3.Range("D2:G2").Merge(); $ws3.Range("D2").Value2 = "MIRR CONSTRUCTION SERVICES"
$ws3.Range("D2").Font.Size = 16; $ws3.Range("D2").Font.Bold = $true; $ws3.Range("D2").Font.Color = $colorNavy

$ws3.Range("D3:G3").Merge(); $ws3.Range("D3").Value2 = "Building & Civil Engineering Contractor • Site Development"
$ws3.Range("D3").Font.Size = 9; $ws3.Range("D3").Font.Color = Get-OleColor 100 100 100

$ws3.Range("D4:G4").Merge(); $ws3.Range("D4").Value2 = "Head Office: Metro Manila, Philippines | Contact: (02) 8800-MIRR | TIN: 456-789-012-000"
$ws3.Range("D4").Font.Size = 8; $ws3.Range("D4").Font.Color = Get-OleColor 120 120 120

$ws3.Range("B6:G6").Merge()
$ws3.Range("B6").Value2 = "EMPLOYEE CONFIDENTIAL PAYSLIP"
$ws3.Range("B6").Font.Size = 12; $ws3.Range("B6").Font.Bold = $true; $ws3.Range("B6").Font.Color = Get-OleColor 255 255 255; $ws3.Range("B6").Interior.Color = $colorNavy; $ws3.Range("B6").HorizontalAlignment = -4108

# Interactive Employee Selector (Cell C8)
$ws3.Range("B8").Value2 = "SELECT EMPLOYEE ID:"
$ws3.Range("B8").Font.Bold = $true; $ws3.Range("B8").Font.Color = $colorBlueHeader
$ws3.Range("C8").Value2 = "MCS-003"
$ws3.Range("C8").Font.Bold = $true; $ws3.Range("C8").Font.Size = 12; $ws3.Range("C8").Interior.Color = $colorYellowEdit; $ws3.Range("C8").HorizontalAlignment = -4108
$ws3.Range("D8:G8").Merge()
$ws3.Range("D8").Value2 = "← (Enter ID from MCS-001 to MCS-010 to dynamically view each payslip)"
$ws3.Range("D8").Font.Italic = $true; $ws3.Range("D8").Font.Size = 9; $ws3.Range("D8").Font.Color = Get-OleColor 120 120 120

# Employee Meta Info Block
$ws3.Range("B10").Value2 = "Employee Name:"
$ws3.Range("C10:D10").Merge(); $ws3.Range("C10").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 2, FALSE)"; $ws3.Range("C10").Font.Bold = $true

$ws3.Range("E10").Value2 = "Payroll Cut-off:"
$ws3.Range("F10:G10").Merge(); $ws3.Range("F10").Value2 = "November 01 - 15, 2026"; $ws3.Range("F10").Font.Bold = $true

$ws3.Range("B11").Value2 = "Designation / Trade:"
$ws3.Range("C11:D11").Merge(); $ws3.Range("C11").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 3, FALSE)"

$ws3.Range("E11").Value2 = "Payout Date:"
$ws3.Range("F11:G11").Merge(); $ws3.Range("F11").Value2 = "November 16, 2026"

$ws3.Range("B12").Value2 = "Daily Rate:"
$ws3.Range("C12").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 4, FALSE)"; $ws3.Range("C12").NumberFormat = "₱#,##0.00"

$ws3.Range("D12").Value2 = "Hourly Rate:"
$ws3.Range("D12").HorizontalAlignment = -4152; $ws3.Range("D12").Font.Color = Get-OleColor 100 100 100
$ws3.Range("E12").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 5, FALSE)"; $ws3.Range("E12").NumberFormat = "₱#,##0.00"

$ws3.Range("F12").Value2 = "Rate / Min:"
$ws3.Range("F12").HorizontalAlignment = -4152; $ws3.Range("F12").Font.Color = Get-OleColor 100 100 100
$ws3.Range("G12").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 6, FALSE)"; $ws3.Range("G12").NumberFormat = "₱#,##0.00"

$ws3.Range("B13").Value2 = "Days Present:"
$ws3.Range("C13").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 7, FALSE)"; $ws3.Range("C13").HorizontalAlignment = -4108

$ws3.Range("D13").Value2 = "Late Minutes:"
$ws3.Range("E13").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 9, FALSE)"; $ws3.Range("E13").HorizontalAlignment = -4108; $ws3.Range("E13").Font.Color = Get-OleColor 180 50 40; $ws3.Range("E13").Font.Bold = $true

$ws3.Range("F13").Value2 = "OT Hours:"
$ws3.Range("G13").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 10, FALSE)"; $ws3.Range("G13").HorizontalAlignment = -4108; $ws3.Range("G13").Font.Bold = $true

$ws3.Range("B10:B13").Font.Bold = $true; $ws3.Range("D10:D13").Font.Bold = $true; $ws3.Range("F10:F13").Font.Bold = $true
$ws3.Range("B10:G13").Interior.Color = $colorLightGray; $ws3.Range("B10:G13").Borders.LineStyle = 1

# Side-by-Side Tables Header
$ws3.Range("B15:D15").Merge(); $ws3.Range("B15").Value2 = "EARNINGS & ALLOWANCES"; $ws3.Range("B15").Font.Bold = $true; $ws3.Range("B15").Interior.Color = Get-OleColor 24 100 60; $ws3.Range("B15").Font.Color = Get-OleColor 255 255 255; $ws3.Range("B15").HorizontalAlignment = -4108
$ws3.Range("E15:G15").Merge(); $ws3.Range("E15").Value2 = "DEDUCTIONS (BIOMETRIC LATE + STATUTORY + OTHER)"; $ws3.Range("E15").Font.Bold = $true; $ws3.Range("E15").Interior.Color = Get-OleColor 160 50 40; $ws3.Range("E15").Font.Color = Get-OleColor 255 255 255; $ws3.Range("E15").HorizontalAlignment = -4108

# Earnings Breakdown
$ws3.Range("B16:C16").Merge(); $ws3.Range("B16").Value2 = "Basic Pay (Days Worked)"
$ws3.Range("D16").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 11, FALSE)"

$ws3.Range("B17:C17").Merge(); $ws3.Range("B17").Value2 = "Overtime Pay (125% OT Rate)"
$ws3.Range("D17").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 12, FALSE)"

$ws3.Range("B18:C18").Merge(); $ws3.Range("B18").Value2 = "Meal Allowance (₱50 if 8h completed)"
$ws3.Range("D18").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 13, FALSE)"; $ws3.Range("D18").Font.Bold = $true

$ws3.Range("B19:C19").Merge(); $ws3.Range("B19").Value2 = "Other Allowance / Hazard"
$ws3.Range("D19").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 14, FALSE)"

$ws3.Range("B20:C20").Merge(); $ws3.Range("B20").Value2 = "Special Performance Incentive"
$ws3.Range("D20").Value2 = 0.0

$ws3.Range("B21:C21").Merge(); $ws3.Range("B21").Value2 = "-"
$ws3.Range("D21").Value2 = 0.0

$ws3.Range("B22:C22").Merge(); $ws3.Range("B22").Value2 = "-"
$ws3.Range("D22").Value2 = 0.0

# Deductions Breakdown
$ws3.Range("E16:F16").Merge(); $ws3.Range("E16").Value2 = "Biometric Late Deduction (Tardiness)"
$ws3.Range("G16").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 16, FALSE)"; $ws3.Range("G16").Font.Bold = $true; $ws3.Range("G16").Font.Color = Get-OleColor 180 50 40

$ws3.Range("E17:F17").Merge(); $ws3.Range("E17").Value2 = "SSS Contribution"
$ws3.Range("G17").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 17, FALSE)"

$ws3.Range("E18:F18").Merge(); $ws3.Range("E18").Value2 = "PhilHealth Contribution"
$ws3.Range("G18").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 18, FALSE)"

$ws3.Range("E19:F19").Merge(); $ws3.Range("E19").Value2 = "Pag-IBIG / HDMF Contribution"
$ws3.Range("G19").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 19, FALSE)"

$ws3.Range("E20:F20").Merge(); $ws3.Range("E20").Value2 = "Withholding Tax (W-Tax)"
$ws3.Range("G20").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 20, FALSE)"

$ws3.Range("E21:F21").Merge(); $ws3.Range("E21").Value2 = "Cash Advance (Vale)"
$ws3.Range("G21").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 21, FALSE)"

$ws3.Range("E22:F22").Merge(); $ws3.Range("E22").Value2 = "Uniform / PPE / Tools Deposit"
$ws3.Range("G22").Formula = "=VLOOKUP(C8, 'Payroll Register'!B8:Y17, 22, FALSE)"

$ws3.Range("D16:D22").NumberFormat = "₱#,##0.00"
$ws3.Range("G16:G22").NumberFormat = "₱#,##0.00"

# Subtotals
$ws3.Range("B23:C23").Merge(); $ws3.Range("B23").Value2 = "TOTAL GROSS EARNINGS"; $ws3.Range("B23").Font.Bold = $true
$ws3.Range("D23").Formula = "=SUM(D16:D22)"; $ws3.Range("D23").Font.Bold = $true; $ws3.Range("D23").NumberFormat = "₱#,##0.00"
$ws3.Range("B23:D23").Interior.Color = $colorLightGreen

$ws3.Range("E23:F23").Merge(); $ws3.Range("E23").Value2 = "TOTAL DEDUCTIONS"; $ws3.Range("E23").Font.Bold = $true
$ws3.Range("G23").Formula = "=SUM(G16:G22)"; $ws3.Range("G23").Font.Bold = $true; $ws3.Range("G23").NumberFormat = "₱#,##0.00"
$ws3.Range("E23:G23").Interior.Color = $colorLightRed

$ws3.Range("B15:G23").Borders.LineStyle = 1

# NET TAKE-HOME PAY HIGHLIGHT BANNER
$ws3.Range("B25:D26").Merge(); $ws3.Range("B25").Value2 = "NET TAKE-HOME PAY:"
$ws3.Range("B25").Font.Size = 13; $ws3.Range("B25").Font.Bold = $true; $ws3.Range("B25").Font.Color = Get-OleColor 255 255 255
$ws3.Range("B25").Interior.Color = $colorNavy; $ws3.Range("B25").HorizontalAlignment = -4108; $ws3.Range("B25").VerticalAlignment = -4108

$ws3.Range("E25:G26").Merge(); $ws3.Range("E25").Formula = "=D23-G23"
$ws3.Range("E25").Font.Size = 20; $ws3.Range("E25").Font.Bold = $true; $ws3.Range("E25").Font.Color = $colorNavy
$ws3.Range("E25").NumberFormat = "₱#,##0.00"; $ws3.Range("E25").Interior.Color = $colorYellowEdit; $ws3.Range("E25").HorizontalAlignment = -4108; $ws3.Range("E25").VerticalAlignment = -4108
$ws3.Range("B25:G26").BorderAround(1, 2)

# Employee Acknowledgment and Signature
$ws3.Range("B28:G28").Merge()
$ws3.Range("B28").Value2 = "I hereby acknowledge receipt of the full payment as stated above with no outstanding claims for this pay period."
$ws3.Range("B28").Font.Italic = $true; $ws3.Range("B28").Font.Size = 8; $ws3.Range("B28").Font.Color = Get-OleColor 100 100 100; $ws3.Range("B28").HorizontalAlignment = -4108

$ws3.Range("B31:C31").Merge(); $ws3.Range("B31").Value2 = "Prepared & Released by:"
$ws3.Range("E31:G31").Merge(); $ws3.Range("E31").Value2 = "Employee Signature over Printed Name / Date:"

$ws3.Range("B34:C34").Merge(); $ws3.Range("B34").Value2 = "MIRR PAYROLL OFFICER"; $ws3.Range("B34").Font.Bold = $true; $ws3.Range("B34").Borders.Item(8).LineStyle = 1
$ws3.Range("E34:G34").Merge(); $ws3.Range("E34").Formula = "=C10"; $ws3.Range("E34").Font.Bold = $true; $ws3.Range("E34").HorizontalAlignment = -4108; $ws3.Range("E34:G34").Borders.Item(8).LineStyle = 1

$ws3.Range("B1:G36").BorderAround(1, 2)


# ==============================================================================
# SHEET 4: ALL PAYSLIPS BATCH PRINT
# ==============================================================================
$ws4.Select()
$excel.ActiveWindow.DisplayGridlines = $true

$ws4.Range("B2:I2").Merge(); $ws4.Range("B2").Value2 = "MIRR CONSTRUCTION SERVICES - ALL WORKERS PAYSLIP DIRECTORY (PRINT BATCH)"
$ws4.Range("B2").Font.Size = 15; $ws4.Range("B2").Font.Bold = $true; $ws4.Range("B2").Font.Color = $colorNavy

$ws4.Range("B3:I3").Merge(); $ws4.Range("B3").Value2 = "Individual printable summary slips generated for every worker with logo, rate audit, biometric deductions, and net payout"
$ws4.Range("B3").Font.Italic = $true; $ws4.Range("B3").Font.Color = Get-OleColor 100 100 100

for ($k = 0; $k -lt 10; $k++) {
    $empId = "MCS-" + ("{0:D3}" -f ($k + 1))
    $topRow = 5 + ($k * 14)
    $botRow = $topRow + 12
    $regR = 8 + $k
    
    if (Test-Path $logoPath) {
        $ws4.Shapes.AddPicture($logoPath, 0, 1, 35, (18 + ($k * 225)), 60, 45) | Out-Null
    }
    
    $ws4.Range("C${topRow}:G$topRow").Merge(); $ws4.Range("C$topRow").Value2 = "MIRR CONSTRUCTION SERVICES - PAYSLIP ($empId)"
    $ws4.Range("C$topRow").Font.Bold = $true; $ws4.Range("C$topRow").Font.Size = 11; $ws4.Range("C$topRow").Font.Color = $colorNavy
    
    $r1 = $topRow + 1
    $ws4.Range("C$r1").Value2 = "Employee Name:"
    $ws4.Range("D$r1").Formula = "='Payroll Register'!C$regR"; $ws4.Range("D$r1").Font.Bold = $true
    $ws4.Range("E$r1").Value2 = "Designation:"
    $ws4.Range("F${r1}:G$r1").Merge(); $ws4.Range("F$r1").Formula = "='Payroll Register'!D$regR"
    
    $r2 = $topRow + 2
    $ws4.Range("C$r2").Value2 = "Daily Rate:"
    $ws4.Range("D$r2").Formula = "='Payroll Register'!E$regR"; $ws4.Range("D$r2").NumberFormat = "₱#,##0.00"
    $ws4.Range("E$r2").Value2 = "Days Worked:"
    $ws4.Range("F$r2").Formula = "='Payroll Register'!H$regR"; $ws4.Range("F$r2").HorizontalAlignment = -4108
    $ws4.Range("G$r2").Value2 = "Nov 01-15, 2026"; $ws4.Range("G$r2").HorizontalAlignment = -4108
    
    $r3 = $topRow + 3
    $ws4.Range("C$r3").Value2 = "Late Mins:"
    $ws4.Range("D$r3").Formula = "='Payroll Register'!J$regR"; $ws4.Range("D$r3").HorizontalAlignment = -4108; $ws4.Range("D$r3").Font.Color = Get-OleColor 180 50 40
    $ws4.Range("E$r3").Value2 = "OT Hours:"
    $ws4.Range("F$r3").Formula = "='Payroll Register'!K$regR"; $ws4.Range("F$r3").HorizontalAlignment = -4108
    $ws4.Range("G$r3").Formula = "='Payroll Register'!M$regR"; $ws4.Range("G$r3").NumberFormat = "₱#,##0.00"
    
    $r4 = $topRow + 5
    $ws4.Range("B${r4}:D$r4").Merge(); $ws4.Range("B$r4").Value2 = "EARNINGS"; $ws4.Range("B$r4").Font.Bold = $true; $ws4.Range("B$r4").Interior.Color = Get-OleColor 24 100 60; $ws4.Range("B$r4").Font.Color = Get-OleColor 255 255 255; $ws4.Range("B$r4").HorizontalAlignment = -4108
    $ws4.Range("E${r4}:G$r4").Merge(); $ws4.Range("E$r4").Value2 = "DEDUCTIONS"; $ws4.Range("E$r4").Font.Bold = $true; $ws4.Range("E$r4").Interior.Color = Get-OleColor 160 50 40; $ws4.Range("E$r4").Font.Color = Get-OleColor 255 255 255; $ws4.Range("E$r4").HorizontalAlignment = -4108
    
    $r5 = $topRow + 6
    $ws4.Range("B${r5}:C$r5").Merge(); $ws4.Range("B$r5").Value2 = "Basic Pay"
    $ws4.Range("D$r5").Formula = "='Payroll Register'!L$regR"; $ws4.Range("D$r5").NumberFormat = "₱#,##0.00"
    $ws4.Range("E${r5}:F$r5").Merge(); $ws4.Range("E$r5").Value2 = "Late Deduction"
    $ws4.Range("G$r5").Formula = "='Payroll Register'!Q$regR"; $ws4.Range("G$r5").NumberFormat = "₱#,##0.00"; $ws4.Range("G$r5").Font.Color = Get-OleColor 180 50 40
    
    $r6 = $topRow + 7
    $ws4.Range("B${r6}:C$r6").Merge(); $ws4.Range("B$r6").Value2 = "Overtime Pay"
    $ws4.Range("D$r6").Formula = "='Payroll Register'!M$regR"; $ws4.Range("D$r6").NumberFormat = "₱#,##0.00"
    $ws4.Range("E${r6}:F$r6").Merge(); $ws4.Range("E$r6").Value2 = "SSS / PhilHealth / PagIBIG"
    $ws4.Range("G$r6").Formula = "='Payroll Register'!R$regR+'Payroll Register'!S$regR+'Payroll Register'!T$regR"; $ws4.Range("G$r6").NumberFormat = "₱#,##0.00"
    
    $r7 = $topRow + 8
    $ws4.Range("B${r7}:C$r7").Merge(); $ws4.Range("B$r7").Value2 = "Meal Allow. (₱50 if 8h)"
    $ws4.Range("D$r7").Formula = "='Payroll Register'!N$regR"; $ws4.Range("D$r7").NumberFormat = "₱#,##0.00"; $ws4.Range("D$r7").Font.Bold = $true
    $ws4.Range("E${r7}:F$r7").Merge(); $ws4.Range("E$r7").Value2 = "Cash Advance / PPE"
    $ws4.Range("G$r7").Formula = "='Payroll Register'!V$regR+'Payroll Register'!W$regR"; $ws4.Range("G$r7").NumberFormat = "₱#,##0.00"
    
    $r8 = $topRow + 9
    $ws4.Range("B${r8}:C$r8").Merge(); $ws4.Range("B$r8").Value2 = "Other Allowance"
    $ws4.Range("D$r8").Formula = "='Payroll Register'!O$regR"; $ws4.Range("D$r8").NumberFormat = "₱#,##0.00"
    $ws4.Range("E${r8}:F$r8").Merge(); $ws4.Range("E$r8").Value2 = "TOTAL DEDUCTIONS"
    $ws4.Range("G$r8").Formula = "='Payroll Register'!X$regR"; $ws4.Range("G$r8").NumberFormat = "₱#,##0.00"; $ws4.Range("G$r8").Font.Bold = $true
    
    $r9 = $topRow + 10
    $ws4.Range("B${r9}:C$r9").Merge(); $ws4.Range("B$r9").Value2 = "TOTAL GROSS"
    $ws4.Range("D$r9").Formula = "='Payroll Register'!P$regR"; $ws4.Range("D$r9").NumberFormat = "₱#,##0.00"; $ws4.Range("D$r9").Font.Bold = $true
    $ws4.Range("E${r9}:F$r9").Merge(); $ws4.Range("E$r9").Value2 = "NET TAKE-HOME PAY"
    $ws4.Range("G$r9").Formula = "='Payroll Register'!Y$regR"; $ws4.Range("G$r9").NumberFormat = "₱#,##0.00"; $ws4.Range("G$r9").Font.Bold = $true; $ws4.Range("G$r9").Interior.Color = $colorYellowEdit
    
    $r10 = $topRow + 11
    $ws4.Range("B${r10}:D$r10").Merge(); $ws4.Range("B$r10").Value2 = "Released by: MIRR Payroll Officer"
    $ws4.Range("E${r10}:G$r10").Merge(); $ws4.Range("E$r10").Value2 = "Received by: _____________________"
    $ws4.Range("B${r10}:G$r10").Font.Italic = $true; $ws4.Range("B${r10}:G$r10").Font.Size = 8
    
    $ws4.Range("B${topRow}:G$botRow").BorderAround(1, 2)
    $ws4.Range("B${r4}:G$r9").Borders.LineStyle = 1
}

# Column widths
$ws1.Columns.Item(1).ColumnWidth = 3
$ws1.Columns.Item(2).ColumnWidth = 11
$ws1.Columns.Item(3).ColumnWidth = 24
$ws1.Columns.Item(4).ColumnWidth = 26
$ws1.Columns.Item(5).ColumnWidth = 12
$ws1.Columns.Item(6).ColumnWidth = 12
$ws1.Columns.Item(7).ColumnWidth = 12
$ws1.Columns.Item(8).ColumnWidth = 12
$ws1.Columns.Item(9).ColumnWidth = 12
$ws1.Columns.Item(10).ColumnWidth = 11
$ws1.Columns.Item(11).ColumnWidth = 11
$ws1.Columns.Item(12).ColumnWidth = 14
$ws1.Columns.Item(13).ColumnWidth = 14
$ws1.Columns.Item(14).ColumnWidth = 16
$ws1.Columns.Item(15).ColumnWidth = 13
$ws1.Columns.Item(16).ColumnWidth = 16
$ws1.Columns.Item(17).ColumnWidth = 14
$ws1.Columns.Item(18).ColumnWidth = 12
$ws1.Columns.Item(19).ColumnWidth = 12
$ws1.Columns.Item(20).ColumnWidth = 12
$ws1.Columns.Item(21).ColumnWidth = 12
$ws1.Columns.Item(22).ColumnWidth = 14
$ws1.Columns.Item(23).ColumnWidth = 13
$ws1.Columns.Item(24).ColumnWidth = 16
$ws1.Columns.Item(25).ColumnWidth = 18
$ws1.Columns.Item(26).ColumnWidth = 18

$ws2.Columns.Item(1).ColumnWidth = 3
$ws2.Columns.Item(2).ColumnWidth = 14
$ws2.Columns.Item(3).ColumnWidth = 10
$ws2.Columns.Item(4).ColumnWidth = 24
$ws2.Columns.Item(5).ColumnWidth = 14
$ws2.Columns.Item(6).ColumnWidth = 14
$ws2.Columns.Item(7).ColumnWidth = 12
$ws2.Columns.Item(8).ColumnWidth = 12
$ws2.Columns.Item(9).ColumnWidth = 11
$ws2.Columns.Item(10).ColumnWidth = 13
$ws2.Columns.Item(11).ColumnWidth = 14
$ws2.Columns.Item(12).ColumnWidth = 18

$ws3.Columns.Item(1).ColumnWidth = 3
$ws3.Columns.Item(2).ColumnWidth = 18
$ws3.Columns.Item(3).ColumnWidth = 16
$ws3.Columns.Item(4).ColumnWidth = 16
$ws3.Columns.Item(5).ColumnWidth = 18
$ws3.Columns.Item(6).ColumnWidth = 16
$ws3.Columns.Item(7).ColumnWidth = 16

$ws4.Columns.Item(1).ColumnWidth = 3
$ws4.Columns.Item(2).ColumnWidth = 16
$ws4.Columns.Item(3).ColumnWidth = 16
$ws4.Columns.Item(4).ColumnWidth = 16
$ws4.Columns.Item(5).ColumnWidth = 16
$ws4.Columns.Item(6).ColumnWidth = 16
$ws4.Columns.Item(7).ColumnWidth = 16
$ws4.Columns.Item(8).ColumnWidth = 16

$ws3.Select()

$filePath = "D:\PHOTO DESIGNING\MIRR_Construction_Services_Payroll_System.xlsx"
$wb.SaveAs($filePath, 51)
$wb.Close($false)
$excel.Quit()

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ws1) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ws2) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ws3) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ws4) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($wb) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

Write-Output "Successfully updated: $filePath"

