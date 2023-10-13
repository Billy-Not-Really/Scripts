$disabledUsers = Get-ADUser -Filter {Enabled -eq $False}

ForEach ($disabledUser in $disabledUsers) {
    [array]$groupstoRemove = Get-ADPrincipalGroupMembership -Identity $disabledUser
    if (!($groupstoRemove.Count -eq 1 -and $groupstoRemove[0].SamAccountName -eq "Domain Users")) {
        Write-Host "$($disabledUser.SamAccountName) remove from groups:"
        foreach ($group in $groupstoRemove) {
            if ($group.SamAccountName -ne "Domain Users") {
                Write-Host "`t $( $group.SamAccountName)"
                # Add the removal logic here, e.g., Remove-ADGroupMember
            }
        }
    }
}
