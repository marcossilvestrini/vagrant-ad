# Variables
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$serverInfos = [ordered]@{
    domainName        = "oscorp.com"
    domainNetbiosName = "oscorp"
    plainPassword     = "server@123"
}
$securePassword = $serverInfos.plainPassword | ConvertTo-SecureString -AsPlainText -Force

Write-Host "Install Feature Active Directory..." -ForegroundColor Red -BackgroundColor White
install-windowsfeature AD-Domain-Services

Write-Host "Import Module Active Directory..." -ForegroundColor Red -BackgroundColor White
Import-Module ADDSDeployment

Write-Host "Installing the First Domain Controller in Forest..." -ForegroundColor Red -BackgroundColor White
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -SafeModeAdministratorPassword: $securePassword `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $serverInfos.domainName `
    -DomainNetbiosName $serverInfos.domainNetbiosName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SkipPreChecks:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

Write-Host "Confirme the  Instalation Services..." -ForegroundColor Red -BackgroundColor White
Get-Service adws, kdc, netlogon, dns

Write-Host "Confirme the  Instalation Ad Controler..." -ForegroundColor Red -BackgroundColor White
Get-ADDomainController

Write-Host "List Domain..." -ForegroundColor Red -BackgroundColor White
Get-ADDomain $serverInfos.domainName


# Get-smbshare SYSVOL will show if the domain controller sharing the SYSVOL folder.
# Check if DC Sharing The SYSVOL Folder

Write-Host "Restart server..." -ForegroundColor Red -BackgroundColor White
Start-Sleep 10
Restart-Computer -Force