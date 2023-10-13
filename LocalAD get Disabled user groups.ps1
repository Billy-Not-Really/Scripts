$disabledUsers = Get-ADUser -Filter {Enabled -eq $False}

ForEach ($disabledUser in $disabledUsers) {
    $groupstoRemove = Get-ADPrincipalGroupMembership -Identity $disabledUser
    Write-Host "$($disabledUser.SamAccountName) remove from groups:"
    foreach ($group in $groupstoRemove) {
        if ($group.SamAccountName -ne "Domain Users") {
            Write-Host $group.SamAccountName
            # Add the removal logic here, e.g., Remove-ADGroupMember
        }
    }
}
