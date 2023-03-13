# add id to skip the update
$skipUpdate = @(
    'EaseUS.TodoBackup',
    'VMware.WorkstationPro'
)

# object to be used basically for view only
class Software {
    [string]$Nombre
    [string]$Id
    [string]$Version
    [string]$VersionDisponible
}

# get the available upgrades
$upgradeResult = winget upgrade -u

# run through the list and get the app data
$upgrades = @()
$idStart = -1
$isStartList = 0
$upgradeResult | ForEach-Object -Process {

    if ($isStartList -lt 1 -and -not $_.StartsWith("Nombre") -or $_.StartsWith("---") -or $_.StartsWith("The following packages") -or $_.Contains("ª") ) {
        return
    }

    if ($_.StartsWith("Nombre")) {
        $idStart = $_.toLower().IndexOf("id")
        $isStartList = 1
        return
    }

    if ($_.Length -lt $idStart) {
        return
    }

    $Software = [Software]::new()
    $Software.Nombre = $_.Substring(0, $idStart - 1)
    $info = $_.Substring($idStart) -split '\s+'
    $Software.Id = $info[0]
    $Software.Version = $info[1]
    $Software.VersionDisponible = $info[2]

    $upgrades += $Software
}

# view the list
$upgrades | Format-Table

if (!$upgrades) {
    Write-Host "Nada que actualizar" -ForegroundColor Green
}
else {

    # run through the list, compare with the skip list and execute the upgrade (could be done in the upper foreach as well)
    $upgrades | ForEach-Object -Process {

        if ($skipUpdate -contains $_.Id) {
            Write-Host "No se actualizará el paquete $($_.id)" -ForegroundColor Red
            return
        }
  
        Write-Host "Para actualizar $($_.Id)" -ForegroundColor Yellow
        winget upgrade -u $_.Id
    }
}
