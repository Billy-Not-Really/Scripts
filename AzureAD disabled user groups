# Connect to Azure AD
Connect-AzureAD

# Get all users from Azure AD (you may need to modify this to get the specific set of users)
$users = Get-AzureADUser -All $true | Where-Object {$_.UserType -like "Member" -and $_.UserPrincipalName -like "*@ee.gt.com" -and $_.AccountEnabled -like "False"}

# Iterate through each user
foreach ($user in $users) {
    # Get the user's group memberships
    $userGroups = Get-AzureADUserMembership -ObjectId $user.ObjectId
    Write-Host " $($user.UserPrincipalName) Remove from groups: "
    # Remove the user from all groups
    foreach ($group in $userGroups) {
        if ($group.DisplayName -ne "All Users") {
            Write-Host "`t $($group.DisplayName), LokaalneAD: $($group.DirSyncEnabled), meiligrupp: $($group.Mail)"
            #Remove-AzureADGroupMember -ObjectId $group.ObjectId -Members $user.ObjectId
        }
    }
}
