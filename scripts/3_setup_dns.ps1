# Variables
$netInfos = Get-NetIPAddress | Where-Object { $_.IPAddress -like "*192.168.0*" }

$serverInfos = [ordered]@{
    serverName        = "srvdc01"
    dns1          = $netInfos.IPAddress
    dns2          = "1.1.1.1"
    domainName    = "oscorp.com"
}

Write-Host "Add Primary Zone..." -ForegroundColor Red -BackgroundColor White
Add-DnsServerPrimaryZone -Name "$($serverInfos.serverName).$($serverInfos.domainName)" -ReplicationScope "Domain" -PassThru
Start-Sleep 3

# Create a file-backed primary zone
# Add-DnsServerPrimaryZone -Name "west02.contoso.com" -ZoneFile "west02.contoso.com.dns"

Write-Host "Create a reverse lookup zone..." -ForegroundColor Red -BackgroundColor White
Add-DnsServerPrimaryZone -NetworkID "192.168.0.0/24" -ReplicationScope "Domain"

Write-Host "Adding Reverse Lookup Records (PTR)..." -ForegroundColor Red -BackgroundColor White
Add-DnsServerResourceRecordPtr `
    -Name "142" `
    -PtrDomainName "srvdc01.oscorp.com" `
    -ZoneName "0.168.192.in-addr.arpa" `
    -computerName srvdc01
Get-DnsServerResourceRecord -ComputerName srvdc01 -ZoneName "0.168.192.in-addr.arpa"

Write-Host " Test DNS Server..." -ForegroundColor Red -BackgroundColor White
Test-DnsServer -IPAddress $serverInfos.dns1 -ZoneName $serverInfos.domainName

Write-Host "Set DNS..." -ForegroundColor Red -BackgroundColor White
Set-DNSClientServerAddress –InterfaceIndex $netInfos.InterfaceIndex –ServerAddresses $serverInfos.dns1, $serverInfos.dns2

Write-Host "Restart server..." -ForegroundColor Red -BackgroundColor White
Restart-Computer -Force