

# Define the username for which you want to retrieve permissions
$Username = "ENTER USERNAME HERE"

# Define the folder path for which you want to check permissions
$RootFolderPath  = "D:\Shares\public\public"

# Function to get user permissions for a folder
function Get-UserPermissions {
    param (
        [string]$FolderPath,
        [string]$Username
    )
    
    # Get the ACL for the folder
    $FolderACL = Get-Acl -Path $FolderPath

    # Get the user's permissions
    $UserPermissions = $FolderACL.Access | Where-Object { $_.IdentityReference -match $Username }

    # Display the permissions
    if ($UserPermissions) {
        Write-Host "Permissions for user $Username on folder $FolderPath"
        foreach ($Permission in $UserPermissions) {
            Write-Host "   Access: $($Permission.FileSystemRights)"
            Write-Host "   Type: $($Permission.AccessControlType)"
            Write-Host "   Inherited: $($Permission.IsInherited)"
            Write-Host "   Identity: $($Permission.IdentityReference)"
            Write-Host "   "
        }
    } 
}

# Recursively process folders and subfolders
function Get-UserPermissionsRecursive {
    param (
        [string]$FolderPath,
        [string]$Username
    )
    
    # Get permissions for the current folder
    Get-UserPermissions -FolderPath $FolderPath -Username $Username

    # Get subfolders
    $Subfolders = Get-ChildItem -Path $FolderPath -Directory

    # Recursively process subfolders
    foreach ($Subfolder in $Subfolders) {
        Get-UserPermissionsRecursive -FolderPath $Subfolder.FullName -Username $Username
    }
}

# Start the recursive process from the root folder
Get-UserPermissionsRecursive -FolderPath $RootFolderPath -Username $Username
