$TargetVersion = "4.5.1.4455"
$InstallerPath = "\\server\2440\Open-EID-24.4.0.1947.exe"
$VersionFound = $false

# Define paths for both 32-bit and 64-bit versions
$File32 = "C:\Program Files (x86)\Open-EID\qdigidoc4.exe"
$File64 = "C:\Program Files\Open-EID\qdigidoc4.exe"

# Function to check the version of the file
function Check-Version {
    param (
        [string]$FilePath
    )
    if (Test-Path $FilePath) {
        $FileVersionInfo = (Get-ItemProperty -Path $FilePath).VersionInfo
        $FileVersion = $FileVersionInfo.ProductVersion
        if ($FileVersion -eq $Global:TargetVersion) {
            $Global:VersionFound = $true
        }
    }
}

# Check versions for both potential file paths
Check-Version -FilePath $File32
Check-Version -FilePath $File64

# Conditionally install the software if the version wasn't found
if (-not $VersionFound) {
    Write-Host "Installing version $TargetVersion..."
    Start-Process -FilePath $InstallerPath -ArgumentList "/quiet AutoUpdate=0 IconsDesktop=0 ForceChromeExtensionActivation2=1 ForceEdgeExtensionActivation2=1" -Wait
}
