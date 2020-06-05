param (
    [Parameter(Mandatory=$true)][string]$adminUsername
)

# Create the service principal for Azure AD Domain Services.
If (-not(Get-AzureRmADServicePrincipal -ApplicationId "2565bd9d-da50-47d4-8b85-4c97f669dc36")) {
	New-AzureRmADServicePrincipal -ApplicationId "2565bd9d-da50-47d4-8b85-4c97f669dc36"
}
Else {
	Get-AzureRmADServicePrincipal -ApplicationId "2565bd9d-da50-47d4-8b85-4c97f669dc36"
}

# Create the delegated administration group for AAD Domain Services.

If (-not(Get-AzureADGroup -SearchString "AAD DC Administrators")) {
	New-AzureADGroup -DisplayName "AAD DC Administrators" `
                 -Description "Delegated group to administer Azure AD Domain Services" `
                 -SecurityEnabled $true -MailEnabled $false `
                 -MailNickName "AADDCAdministrators"
} ElseIf ((Get-AzureADGroup -SearchString "AAD DC Administrators").length -gt 0) {
	Get-AzureADGroup -SearchString "AAD DC Administrators" | Remove-AzureADGroup
	New-AzureADGroup -DisplayName "AAD DC Administrators" `
                 -Description "Delegated group to administer Azure AD Domain Services" `
                 -SecurityEnabled $true -MailEnabled $false `
                 -MailNickName "AADDCAdministrators"
}

# Add user to "AAD DC Administrators" group

# First, retrieve the object ID of the newly created 'AAD DC Administrators' group.
$Group = (Get-AzureADGroup -SearchString "AAD DC Administrators")

# Now, retrieve the object ID of the user you'd like to add to the group.
$User = Get-AzureADUser -ObjectId $adminUsername

# Add the user to the 'AAD DC Administrators' group.
Add-AzureADGroupMember -ObjectId $Group.ObjectId -RefObjectId $User.ObjectId

# Register the resource provider for Azure AD Domain Services with Resource Manager.
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.AAD