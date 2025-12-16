$logPath = "C:\Windows\Installer\ClearRunRegistry_Remediation.txt"
$UserSID = (Get-WmiObject Win32_UserAccount -Filter "Name='kioskuser0' and LocalAccount=True").SID

Start-transcript -Path $logPath

Function Log-Output {
    Param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Write-Host
}


$registryKey = @("Registry::HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Run", "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run")
Log-Output -message "Cleaning up Run key: $registryKey"
$item = Get-Item $registryKey
$item.Property | ForEach-Object {
    $ValueName = $_
    Log-Output -message "Remove Item: $($ValueName)"
    Remove-ItemProperty -Path $registryKey -Name $ValueName -ErrorAction SilentlyContinue
}

Stop-transcript