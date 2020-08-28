# Variables
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$interfaceIndex = (Get-NetIPAddress | Where-Object { $_.IPAddress -like "*192.168.0*" }).InterfaceIndex
$dns1          = "192.168.0.132"
$dns2          = "1.1.1.1"
$domainName    = "oscorp.com"


Write-Host "Create a reverse lookup zone..." -ForegroundColor Red -BackgroundColor White
Add-DnsServerPrimaryZone -NetworkID "192.168.0.0/24" -ReplicationScope "Domain"

Write-Host " Test DNS Server..." -ForegroundColor Red -BackgroundColor White
Test-DnsServer -IPAddress $dns1 -ZoneName $domainName

Write-Host "Set DNS..." -ForegroundColor Red -BackgroundColor White
Set-DNSClientServerAddress –InterfaceIndex $interfaceIndex –ServerAddresses $dns1, $dns2
