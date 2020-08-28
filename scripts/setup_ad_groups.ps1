# Variables
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$serverInfos = [ordered]@{
    domainNetbiosName = "oscorp"
    groups=@{
        dev="development"
        ha="preproduction"
        prod="production"
    }
}
Write-Host "Create an OU that is not protected from accidental deletion..." -ForegroundColor Red -BackgroundColor White
$serverInfos['groups'] | ForEach-Object{
    New-ADOrganizationalUnit -Name $_['prod'] -Path "DC=$($serverInfos.domainNetbiosName),DC=com" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name $_['ha'] -Path "DC=$($serverInfos.domainNetbiosName),DC=com" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name $_['dev'] -Path "DC=$($serverInfos.domainNetbiosName),DC=com" -ProtectedFromAccidentalDeletion $False
}

Write-Host "Get all of the OUs in a domain..." -ForegroundColor Red -BackgroundColor White
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A