<#

.DESCRIPTION
    Este script muestra los usuarios que iniciaron sesión en tu equipo

.PARAMETER <Límite de eventos a analizar>
    OPCIONAL: Introduce el número de eventos que quieres analizar. Por defecto 1000. Con 0 el análisis de todos los eventos registrados en el sistema.
    Ejemplos:

    .\Get-LastUsers.ps1
    .\Get-LastUsers.ps1 0
    .\Get-LastUsers.ps1 2000
    .\Get-LastUsers.ps1 5000

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

$Protocolo = 'IPv4'

((Get-NetAdapter | Where-Object Status -eq 'up') | Get-NetIPInterface -Addressfamily $Protocolo) | Select-Object ifIndex, InterfaceAlias | Format-Table -Property *

$interfaceIndex = Read-Host "Introduce el InterfaceIndex de la tarjeta que quieres cambiar la IP: "

Set-NetIPInterface -InterfaceIndex $interfaceIndex -DHCP Enabled
