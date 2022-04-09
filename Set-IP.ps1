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
$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "Set-IP"

$startDate = Get-Date

Write-Host "

HERRAMIENTA DE CAMBIO DE IP
_________________________________________________________"

Write-Host "`nFecha ejecución: $startDate"

Get-NetAdapter | Select-Object InterfaceAlias, InterfaceIndex | Format-Table -Property *
$interfaceIndex = Read-Host "Introduce el InterfaceIndex de la tarjeta que quieres cambiar la IP: "
$netAdapter = Get-NetAdapter -InterfaceIndex $interfaceIndex | Select-Object InterfaceAlias -ErrorAction Stop
$netIPAddress = Get-NetIPAddress -InterfaceIndex $interfaceIndex -AddressFamily "IPv4"
#$dnsClientServerAddress = Get-DnsClientServerAddress -InterfaceIndex  $interfaceIndex 
$oldGW = Get-NetIPConfiguration -ifIndex $interfaceIndex | ForEach-Object IPv4DefaultGateway

$ip = Read-Host "Introduce la nueva IP: "
$netMask = Read-Host "Introduce la máscara de red: "
$gw = Read-Host "Introduce la puerta de enlace: "

$IPConf = @{
    InterfaceAlias = $netAdapter.InterfaceAlias
    PrefixLength   = $netMask
    IPAddress      = $ip
    DefaultGateway = $gw
   }

New-NetIPAddress @IPConf
Remove-NetIPAddress -IPAddress $netIPAddress.IPAddress -DefaultGateway $oldGW.NextHop
Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ("8.8.8.8","1.1.1.1")
Write-Host "Prueba de conectividad..."
Test-Connection google.es
