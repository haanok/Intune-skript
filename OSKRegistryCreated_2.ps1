# Define the registry paths and values to check and update
$registryKeys = @(
    @{Path = "HKLM:\Software\Microsoft\TabletTip\1.7"; Name = "EnableDesktopModeAutoInvoke"; Value = 1},
    @{Path = "HKLM:\Software\Microsoft\TabletTip\1.7"; Name = "DisableNewKeyboardExperience"; Value = 1},    
    @{Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell"; Name = "TabletMode"; Value = 1}
)


# Iterate through each key and check/update its value
foreach ($key in $registryKeys) {
    if (Test-Path $key.Path) {
        $currentValue = Get-ItemProperty -Path $key.Path -Name $key.Name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $key.Name -ErrorAction SilentlyContinue
        if ($currentValue -ne $key.Value) {
            Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value -Type DWord
            Write-Output "Updated registry key $($key.Path)\$($key.Name) to $($key.Value)."
        } else {
            Write-Output "Registry key $($key.Path)\$($key.Name) is already set to $($key.Value)."
        }
    } else {
        New-Item -Path $key.Path -Force | Out-Null
        Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value -Type DWord
        Write-Output "Created registry key $($key.Path)\$($key.Name) and set it to $($key.Value)."
    }
}
