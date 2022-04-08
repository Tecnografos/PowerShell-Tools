<#

.DESCRIPTION
    Este script muestra los usuarios que iniciaron sesión en tu equipo

.PARAMETER <Límite de eventos a analizar>
    OPCIONAL: Introduce el número de eventos que quieres analizar. Por defecto 1000. Con 0 el análisis de todos los eventos registrados en el sistema.
    Ejemplos:

    .\Logon.ps1
    .\Logon.ps1 0
    .\Logon.ps1 2000
    .\Logon.ps1 5000

.INPUTS
  No requiere

.OUTPUTS
  Solo hay salida por pantalla de los usuarios que han iniciado sesión en el equipo

.NOTES
  Version:        1.0
  Author:         Antonio Felix Sanchez-Oro Portillo
  Creation Date:  02/04/2022
  Purpose/Change: Version inicial

#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [int] $logLimit = 1000
)

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
    Write-Error "Se necesitan permisos de administrador para poder ejecutar el script"
    Break
}


$Host.UI.RawUI.WindowTitle = "Análisis de inicio de sesión"

$startDate = Get-Date

Write-Host "

HERRAMIENTA DE ANÁLISIS DE INICIO Y CIERRE DE SESIÓN
_________________________________________________________"

Write-Host "`nFecha ejecución: $startDate"

function Get-LastLogonUsers {
    param (
        [int] $logLimit
    )

    $results = @()

    if ($logLimit -eq 0) {
        Write-Host "`nAnalizando los eventos del sistema (ponte un café, esto llevará un rato)..."
        $logs = Get-WinEvent -LogName Security | Where-Object { $_.ID -eq 4634 -or $_.ID -eq 4624 }
    }
    else {
        if ($logLimit -gt 0) {
            Write-Host "`nAnalizando los últimos $logLimit eventos del sistema..."
            $logs = Get-WinEvent -LogName Security | Where-Object { $_.ID -eq 4634 -or $_.ID -eq 4624 } | Select-Object -first $logLimit   
        }
        else {
            Write-Host "Entrada no válida. Indique el número de eventos a analizar o no especifíque parámetros" -ForegroundColor Red
            Break
        }
    }
    
    ForEach ($log in $logs) {
    
        if ($log.Id -eq 4634) {
            $msg = "Cierre de sesión"
            $usr = $log.Properties[1].Value
            $type = $log.Properties[8].Value
        }
        Else {
            $msg = "Inicio de sesión"
            $usr = $log.Properties[5].Value
            $type = $log.Properties[8].Value

            switch ($type) {
                2 { $typeMsg = "Interactivo" }
                3 { $typeMsg = "Red" }
                4 { $typeMsg = "Lote" }
                5 { $typeMsg = "Servicio" }
                7 { $typeMsg = "Desbloquear" }
                8 { $typeMsg = "NetworkCleartext" }
                9 { $typeMsg = "NewCredentials" }
                10 { $typeMsg = "RemoteInteractive" }
                11 { $typeMsg = "CachedInteractive" }
                Default { $typeMsg = "-" }
            }
        }
    
        #(($usr -ne "") -and ($usr -ne "SYSTEM")) You can add (or not) filters at this point
        if (($usr -ne "")) {
            $results += New-Object PSObject -Property @{ "Usuario" = $usr; "Fecha" = $log.TimeCreated; "Evento" = $msg; "Tipo" = $typeMsg };
        }
    
    }

    if ($results.count -eq 0) {
        Write-Host "No hay eventos que mostrar. Prueba aumentando el límite de eventos a analizar." -ForegroundColor Red
    }
    else {
        $results
    }
}

Get-LastLogonUsers $logLimit
