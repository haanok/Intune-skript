$CsvFilePath= "./EntraIDGroups.csv"
$EntraIDGroups = import-csv -path $CsvFilePath -delimiter ";"

foreach ($Group in $EntraIDGroups) {
    $GroupName = $Group.Group
    $GroupDescription = $Group.Description

    $GroupExists = Get-MgGroup -Filter "DisplayName eq '$GroupName'" -ErrorAction SilentlyContinue
    if (-not $GroupExists) {
        Write-Host "Creating Group $GroupName with description: $GroupDescription..."
        New-MgGroup -DisplayName "$GroupName" -Description "$GroupDescription" -MailEnabled:$False -MailNickname "$GroupName" -SecurityEnabled
    }
    elseif ($GroupExists) {
        Write-Host "Group $GroupName exists...skipping.."
    }
}