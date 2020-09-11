# Variables

# Network Infos
$netInfos = Get-NetIPAddress | Where-Object { $_.IPAddress -like "*192.168.0*" }

# Server Infos
$serverInfos = [ordered]@{
    serverName = "srvdc01"
    ip         = $netInfos.IPAddress
    gateway    = "192.168.0.1"
    cidr       = $netInfos.PrefixLength
    user          = "marcos.silvestrini"
    plainPassword = "server@123"
}

# Setup Network
## - Set ip address for static
New-NetIPAddress –IPAddress $serverInfos.ip -DefaultGateway $serverInfos.gateway -PrefixLength $serverInfos.cidr -InterfaceIndex (Get-NetAdapter).InterfaceIndex

## Disable IPV6
Disable-NetAdapterBinding -Name $netInfos.InterfaceAlias -ComponentID ms_tcpip6 -PassThru

# Disable Firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

# Enable Remote Access
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

# Setup Powershell

## Enable remotly execution
Enable-PSRemoting -force
Set-ExecutionPolicy -Scope process -ExecutionPolicy RemoteSigned -force

## Set TrustedHosts
Set-Item WSMan:\localhost\Client\TrustedHosts * -force
Get-Item WSMan:\localhost\Client\TrustedHosts

## Set WMI
winrm quickconfig -force
#Set-PSSessionConfiguration Microsoft.PowerShell -ShowSecurityDescriptorUI

# Create Local User
$securePassword =  $serverInfos.plainPassword | ConvertTo-SecureString -AsPlainText -Force
New-LocalUser $serverInfos.user -Password $securePassword -FullName $serverInfos.user -Description "Local User for Managment and Maintenance"

# Add Local  User in Groups:
Add-LocalGroupMember -Group "Administrators"  -Member $serverInfos.user
Add-LocalGroupMember -Group "Distributed COM Users"  -Member $serverInfos.user
Add-LocalGroupMember -Group "Remote Management Users" -Member $serverInfos.user
Add-LocalGroupMember -Group "Remote Desktop Users" -Member $serverInfos.user

# Setup ComputerName
$name = hostname; $newName = $serverInfos.serverName
Rename-Computer -ComputerName $name -NewName $newName

# Setup Disk \ Drivers

## List all disks
Get-Disk

## List disks that are not system disks , to avoid accidently formatting your system drive
Get-Disk | Where-Object IsSystem -eq $False

## List disks that are offline
Get-Disk | Where-Object IsOffline –Eq $True

## Set Disk for Online
$diskNumber = (Get-Disk | Where-Object { ($_.IsSystem -eq $False) -and ($_.IsOffline -eq $True) }).Number
Set-Disk -Number $diskNumber -IsOffline $False

## Formatting a disk using PowerShell without prompting for confirmation
$disk = Get-Disk | where-object PartitionStyle -eq "RAW"
$disk | Initialize-Disk -PartitionStyle GPT
$partition = $disk | New-Partition -UseMaximumSize -DriveLetter D
$partition | Format-Volume -Confirm:$false -Force

## Alter CDRom Driver Letter
# $drive = Get-WmiObject -Class win32_volume | Where-Object { $_.FileSystem -eq $null }
# Set-WmiInstance -input $drive -Arguments @{DriveLetter = ”G:”; Label = ”CD-Rom” }

# - Alter  DriveLetter
# $driveLetter = (Get-Partition | Where-Object { $_.DriveLetter -ne "C" -and $_.Type -eq "Basic" }).DriveLetter
# Set-Partition -DriveLetter $driveLetter  -NewDriveLetter D

# Install Packages \ Programs

## Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

## Install Packages
choco install notepadplusplus -y
choco install 7zip -y

## Install Java with Powershell
$URL = (Invoke-WebRequest -UseBasicParsing https://www.java.com/en/download/manual.jsp).Content |
ForEach-Object { [regex]::matches($_, '(?:<a title="Download Java software for Windows Online" href=")(.*)(?:">)').Groups[1].Value }
Invoke-WebRequest -UseBasicParsing -OutFile jre8.exe $URL
Start-Process .\jre8.exe '/s REBOOT=0 SPONSORS=0 AUTO_UPDATE=0' -wait
Write-Output $?

# Windows Update

## Install Nuget ( Pre req for use powershell module PSWindowsUpdate)
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

## Install Module PSWindowsUpdate
Install-Module -Name PSWindowsUpdate -Force

## Check Module
Get-Package -Name PSWindowsUpdate

## Install Windows Update and Reboot server
$log = "c:\$(get-date -f yyyy-MM-dd)-WindowsUpdate.log"
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot | Out-File $log -Force

Start-Sleep 20

# Restart server
Restart-Computer -Force