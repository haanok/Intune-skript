$logPath = "C:\Windows\Installer\MobilityBloatRemovalLog.txt"


$UserSID = (Get-WmiObject Win32_UserAccount -Filter "Name='kioskuser0' and LocalAccount=True").SID

Start-transcript -Path $logPath

Function Log-Output {
    Param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Write-Host
}

Log-Output -message "Altering RestrictRun registry"

Set-ItemProperty -Path "Registry::HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Policies\explorer" -Name "RestrictRun" -Value "0"

Log-Output -message "Done"

Log-Output -message "Starting Appx removal process..."

Log-Output -message "Removing Microsoft.YourPhone..."
Get-AppxProvisionedPackage -online | Where-Object {$_.DisplayName -eq "Microsoft.YourPhone"} | Remove-AppxProvisionedPackage -online
Get-AppxPackage -AllUsers *Microsoft.YourPhone* | Remove-AppxPackage -AllUsers
Log-Output "Microsoft.YourPhone removal completed."


Log-Output -message "Removing MicrosoftWindows.CrossDevice..."
Get-AppxProvisionedPackage -online | Where-Object {$_.DisplayName -eq "MicrosoftWindows.CrossDevice"} | Remove-AppxProvisionedPackage -online 
Get-AppxPackage -AllUsers *MicrosoftWindows.CrossDevice* | Remove-AppxPackage -AllUsers
Log-Output -message "MicrosoftWindows.CrossDevice removal completed."

Log-Output -message "Removing Microsoft.Copilot"
Get-AppxProvisionedPackage -online | Where-Object {$_.DisplayName -eq "Microsoft.Copilot"} | Remove-AppxProvisionedPackage -online
Get-AppxPackage -AllUsers *Microsoft.Copilot* | Remove-AppxPackage -AllUsers
Log-Output "Microsoft.Copilot removal completed."

Log-Output -message "Application removal process finished."

Stop-Transcript