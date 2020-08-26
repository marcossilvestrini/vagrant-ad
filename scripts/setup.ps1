# Network Infos
$publicInfos = Get-NetIPAddress | Where-Object { $_.IPAddress -like "*192.168.0*"}
$natInfos = Get-NetIPAddress | Where-Object { $_.IPAddress -like "*10.0.2*" }

# Server Infos
$serverInfos = [ordered]@{
    user          = "marcos.silvestrini"
    plainPassword = "server@123"
}

# Disable IPV6 in Public Network
Disable-NetAdapterBinding -Name $publicInfos.InterfaceAlias -ComponentID ms_tcpip6 -PassThru

# Disable IPV6 in Nat Network
Disable-NetAdapterBinding -Name $natInfos.InterfaceAlias -ComponentID ms_tcpip6 -PassThru

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

# Create Local User
$securePassword =  $serverInfos.plainPassword | ConvertTo-SecureString -AsPlainText -Force
New-LocalUser $serverInfos.user -Password $securePassword -FullName $serverInfos.user -Description "Local User for Managment and Maintenance"

# Add Local  User in Groups:
Add-LocalGroupMember -Group "Administrators"  -Member $serverInfos.user
Add-LocalGroupMember -Group "Distributed COM Users"  -Member $serverInfos.user
Add-LocalGroupMember -Group "Remote Management Users" -Member $serverInfos.user
Add-LocalGroupMember -Group "Remote Desktop Users" -Member $serverInfos.user

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