# Variables for client name and tenant ID
$ClientName = "ClientName"
$TenantID = "tenantid"

# Check if the script has already been executed by checking a registry key
$ScriptExecutedKey = "HKCU:\Software\$ClientName"
$ValueName = 'OneDriveReset25032024'
if ((Get-ItemPropertyValue -Path $ScriptExecutedKey -Name $ValueName -ErrorAction SilentlyContinue) -ne $null) {
    Write-Output "Script has already been executed. Exiting."
    exit
}

# Stop OneDrive process
Get-Process onedrive | Stop-Process -Force
Start-Sleep 5

# Remove OneDrive registry keys
$RegPath = Join-Path -Path 'HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts' -ChildPath 'Business*' -Resolve
if($RegPath){
    Remove-Item -Path "$RegPath" -Recurse -Force
}

# Define the folder path
$FolderPath = "$env:USERPROFILE\Sharepoint Folder"

# Attempt to delete the folder
try {
    Remove-Item -Path $FolderPath -Recurse -Force -ErrorAction Stop
    Write-Output "Folder deleted: $FolderPath"
} catch {
    Write-Output "Failed to delete folder. Attempting to move it instead."
    
    # Move the folder to a temporary location
    $TempFolderPath = Join-Path -Path $env:TEMP -ChildPath "Temp$ClientName"
    Move-Item -Path $FolderPath -Destination $TempFolderPath -Force
    Write-Output "Folder moved to temporary location: $TempFolderPath"
}

# Reset OneDrive registry values
Set-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive" -Name 'ClientEverSignedIn' -Value 0 -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive" -Name 'SilentBusinessConfigCompleted' -Value 0 -Force | Out-Null

# Set the flag indicating that the script has been executed
New-Item -Path 'HKCU:\Software\' -Name $ClientName -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\$ClientName\" -Name $ValueName -Value 1 -Force | Out-Null

# Check for OneDrive executable path
if (Test-Path "${env:ProgramFiles}\Microsoft OneDrive\OneDrive.exe") {
    $OneDrive = "${env:ProgramFiles}\Microsoft OneDrive\OneDrive.exe"
} elseif (Test-Path "${env:ProgramFiles(x86)}\Microsoft OneDrive\OneDrive.exe") {
    $OneDrive = "${env:ProgramFiles(x86)}\Microsoft OneDrive\OneDrive.exe"
} elseif (Test-Path "${env:LOCALAPPDATA}\Microsoft\OneDrive\OneDrive.exe") {
    $OneDrive = "${env:LOCALAPPDATA}\Microsoft\OneDrive\OneDrive.exe"
}

# Start OneDrive with silent configuration for business
Start-Process $OneDrive -ArgumentList "/silentConfig /configure_business:$TenantID"