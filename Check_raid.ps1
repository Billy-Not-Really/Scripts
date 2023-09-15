# Martti Tõldsepp
# 15.09.2023


# Define the paths
$arcconfPath = "C:\Program Files\Adaptec\maxView Storage Manager\arcconf.exe"
$resultPath = "C:\Program Files\Adaptec\maxView Storage Manager\raid.log"

# Run the command
& "$arcconfPath" getconfig 1 > "$resultPath"

# Read the file line by line
$lines = Get-Content -Path $resultPath

# Check specific lines for expected values
if ($lines[4] -notmatch "Controller Status                          : Optimal") {
    Write-Host "Error: Controller Status is not Optimal"
    $LASTEXITCODE = 2
}

if ($lines[15] -notmatch "Normal") {
    Write-Host "Error: Temperature is not Normal"
    $LASTEXITCODE = 2
} 

if ($lines[69] -notmatch "Backup Power Status                        : Ok") {
    Write-Host "Error: Backup Power Status is no OK"
    $LASTEXITCODE = 2
} 

if ($lines[71] -notmatch "Hardware Error                             : No Error") {
    Write-Host "Error: Hardware Errors"
    $LASTEXITCODE = 2
} 

if ($lines[79] -notmatch "Health Status                              : 100 percent") {
    Write-Host "Error: Health Status Degraded"
    $LASTEXITCODE = 2
} 

if ($lines[95] -notmatch "Logical devices/Failed/Degraded            : 1/0/0") {
    Write-Host "Error: Logical devices failed or degraded"
    $LASTEXITCODE = 2
} 

if ($lines[254] -notmatch "Status of Logical Device                   : Optimal") {
    Write-Host "Error: Logical devices failed or degraded"
    $LASTEXITCODE = 2
} else {
    Write-Host "OK: Status of Logical Device: Optimal"
    exit 0
}