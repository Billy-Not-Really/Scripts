# Connect to Azure AD
#Connect-AzureAD

# Get all users from Azure AD (you may need to modify this to get the specific set of users)
$users = Get-AzureADUser -All $true | Where-Object {$_.UserType -like "Member" -and $_.UserPrincipalName -like "*@domain.com" -and $_.AccountEnabled -like "True"}

# Iterate through each user
foreach ($user in $users) {
    $licences = Get-AzureADUserLicenseDetail -ObjectId $user.ObjectId
    if ($licences.SkuPartNumber -eq "STANDARDPACK") {
        Write-Host " $($user.UserPrincipalName)"
        #Write-Host "`t $( $licences.SkuPartNumber)""`t $( $licences.SkuPartNumber)"
    }
 }
