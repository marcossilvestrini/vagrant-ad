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
    -DomainMode "7" `
    -DomainName $serverInfos.domainName `
    -DomainNetbiosName $serverInfos.domainNetbiosName `
    -ForestMode "7" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SkipPreChecks:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

    Write-Host "Restart server..." -ForegroundColor Red -BackgroundColor White
# Start-Sleep 180
Start-Sleep 10
