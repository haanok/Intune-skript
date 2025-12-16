$logPath = "C:\Windows\Installer\ClearRunRegistry_Detection.txt"
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

Log-Output -message "Checking Run key: $registryKey"
$item = Get-Item $registryKey
$properties = $item.Property

if ($properties.Count -gt 0) {
     Log-Output -message "Registry key has properties. Exiting with code 1."
     exit 1
} else {
     Log-Output -message "Registry key is empty. Exiting with code 0."
     exit 0
}

Stop-transcript