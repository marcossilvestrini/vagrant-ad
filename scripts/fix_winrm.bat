sc config winrm start= disabled
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce /v StartWinRM /t REG_SZ /f /d "cmd.exe /c \"sc config winrm start= auto ^& sc start winrm\""
reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /d 0 /t REG_DWORD /f /reg:64