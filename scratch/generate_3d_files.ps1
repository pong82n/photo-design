# Generate Wavefront OBJ and MTL 3D Model for SketchUp, D5 Render & AutoCAD
$objPath = "D:\PHOTO DESIGNING\Modern_60sqm_House_Model.obj"
$mtlPath = "D:\PHOTO DESIGNING\Modern_60sqm_House_Model.mtl"

# 1. Write MTL (Material Library)
$mtlContent = @"
# MIRR Construction Services Material Library
newmtl Mat_Stucco_OffWhite
Kd 0.94 0.96 0.98
Ka 0.2 0.2 0.2
Ks 0.1 0.1 0.1
d 1.0

newmtl Mat_Charcoal_Accent
Kd 0.12 0.16 0.23
Ka 0.1 0.1 0.1
Ks 0.2 0.2 0.2
d 1.0

newmtl Mat_Firewall_Stucco
Kd 0.82 0.85 0.88
Ka 0.2 0.2 0.2
Ks 0.1 0.1 0.1
d 1.0

newmtl Mat_Teak_Wood
Kd 0.72 0.35 0.05
Ka 0.2 0.1 0.05
Ks 0.15 0.15 0.15
d 1.0

newmtl Mat_Glass_Balustrade
Kd 0.22 0.74 0.97
Ka 0.1 0.2 0.3
Ks 0.9 0.9 0.9
d 0.35

newmtl Mat_Black_Aluminum
Kd 0.06 0.09 0.16
Ka 0.05 0.05 0.05
Ks 0.5 0.5 0.5
d 1.0

newmtl Mat_Carport_Pavers
Kd 0.28 0.33 0.41
Ka 0.1 0.1 0.1
Ks 0.1 0.1 0.1
d 1.0

newmtl Mat_Garden_Grass
Kd 0.09 0.40 0.20
Ka 0.1 0.2 0.1
Ks 0.05 0.05 0.05
d 1.0

newmtl Mat_Champagne_Gold
Kd 0.83 0.69 0.22
Ka 0.3 0.25 0.1
Ks 0.8 0.7 0.3
d 1.0
"@
Set-Content -Path $mtlPath -Value $mtlContent -Encoding UTF8

# 2. Write OBJ File
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# MIRR Construction Services - Modern 2-Storey House Model")
[void]$sb.AppendLine("# Lot: 60 sqm (6m x 10m) | Footprint: ~40 sqm | Left Firewall & Terrace")
[void]$sb.AppendLine("mtllib Modern_60sqm_House_Model.mtl")
[void]$sb.AppendLine("")

$vCount = 0

function Add-Box([string]$groupName, [string]$matName, [double]$minX, [double]$maxX, [double]$minY, [double]$maxY, [double]$minZ, [double]$maxZ) {
    [void]$script:sb.AppendLine("o $groupName")
    [void]$script:sb.AppendLine("g $groupName")
    [void]$script:sb.AppendLine("usemtl $matName")

    [void]$script:sb.AppendLine("v $minX $minZ $minY")
    [void]$script:sb.AppendLine("v $maxX $minZ $minY")
    [void]$script:sb.AppendLine("v $maxX $minZ $maxY")
    [void]$script:sb.AppendLine("v $minX $minZ $maxY")
    [void]$script:sb.AppendLine("v $minX $maxZ $minY")
    [void]$script:sb.AppendLine("v $maxX $maxZ $minY")
    [void]$script:sb.AppendLine("v $maxX $maxZ $maxY")
    [void]$script:sb.AppendLine("v $minX $maxZ $maxY")

    $b = $script:vCount
    [void]$script:sb.AppendLine("f $($b+1) $($b+4) $($b+3) $($b+2)")
    [void]$script:sb.AppendLine("f $($b+5) $($b+6) $($b+7) $($b+8)")
    [void]$script:sb.AppendLine("f $($b+4) $($b+8) $($b+7) $($b+3)")
    [void]$script:sb.AppendLine("f $($b+1) $($b+2) $($b+6) $($b+5)")
    [void]$script:sb.AppendLine("f $($b+1) $($b+5) $($b+8) $($b+4)")
    [void]$script:sb.AppendLine("f $($b+2) $($b+3) $($b+7) $($b+6)")
    [void]$script:sb.AppendLine("")

    $script:vCount += 8
}

# 1. 60 sqm Lot Foundation (6m x 10m)
Add-Box "Lot_Base" "Mat_Charcoal_Accent" -3.0 3.0 -5.0 5.0 -0.15 0.0

# 2. Carport Pavers
Add-Box "Carport_Pavement" "Mat_Carport_Pavers" -3.0 1.5 0.5 4.8 0.0 0.02

# 3. Right Garden Strip
Add-Box "Right_Garden_Strip" "Mat_Garden_Grass" 1.5 3.0 -5.0 5.0 0.0 0.02

# 4. Left-Side Firewall (Flush on left property boundary X = -3.0m, Height = 6.4m, Depth = 8.5m)
Add-Box "Left_Side_Firewall" "Mat_Firewall_Stucco" -3.0 -2.78 -4.5 3.8 0.0 6.4

# Firewall Top Capping Cap
Add-Box "Firewall_Coping_Cap" "Mat_Black_Aluminum" -3.05 -2.73 -4.55 3.85 6.4 6.48

# 5. Ground Floor Enclosed Living/Dining/Kitchen
Add-Box "Ground_Floor_Main" "Mat_Stucco_OffWhite" -2.78 1.5 -4.5 0.7 0.0 3.0

# Ground Floor Front Oak Pivot Door
Add-Box "Front_Pivot_Door" "Mat_Teak_Wood" -2.5 -1.4 0.7 0.76 0.0 2.4

# Ground Floor Picture Window
Add-Box "Ground_Picture_Window" "Mat_Glass_Balustrade" -0.7 1.2 0.7 0.74 0.8 2.3

# 6. Second Floor Enclosed Residence
Add-Box "Second_Floor_Main" "Mat_Stucco_OffWhite" -2.78 1.5 -4.5 0.7 3.0 6.0

# 7. Cantilevered Second-Floor Terrace Balcony (Extends forward over carport)
Add-Box "Terrace_Balcony_Slab" "Mat_Charcoal_Accent" -2.78 1.5 0.7 3.8 2.75 3.0

# Teak Ceiling Soffit Under Terrace
Add-Box "Carport_Teak_Soffit" "Mat_Teak_Wood" -2.75 1.48 0.72 3.78 2.73 2.75

# Terrace Slender Steel Support Column
Add-Box "Terrace_Support_Column" "Mat_Black_Aluminum" 1.35 1.5 3.65 3.8 0.0 2.75

# Terrace Front Glass Balustrade (1.05m high)
Add-Box "Terrace_Glass_Railing_Front" "Mat_Glass_Balustrade" -2.75 1.48 3.72 3.76 3.0 4.05

# Terrace Right Glass Balustrade
Add-Box "Terrace_Glass_Railing_Right" "Mat_Glass_Balustrade" 1.46 1.5 0.75 3.75 3.0 4.05

# Second Floor Sliding Glass Wall to Terrace
Add-Box "Terrace_Sliding_Glass_Door" "Mat_Glass_Balustrade" -2.5 0.3 0.7 0.74 3.0 5.4

# Architectural Vertical Teak Louvers
$lx = 0.5
while ($lx -le 1.4) {
    Add-Box "Facade_Teak_Louver" "Mat_Teak_Wood" $lx ($lx + 0.05) 0.72 0.78 3.0 5.7
    $lx += 0.12
}

# 8. Modern Parapet Roof Overhang
Add-Box "Modern_Parapet_Roof" "Mat_Charcoal_Accent" -2.9 1.6 -4.6 1.8 6.0 6.35

# Roof Eave Teak Soffit Trim
Add-Box "Roof_Teak_Soffit" "Mat_Teak_Wood" -2.85 1.55 0.7 1.78 5.96 6.0

# Gold Accent Line on Roof Fascia
Add-Box "Roof_Gold_Accent" "Mat_Champagne_Gold" -2.9 1.6 1.79 1.81 6.1 6.15

[System.IO.File]::WriteAllText($objPath, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host "Successfully generated 3D Model: $objPath ($vCount vertices)"
