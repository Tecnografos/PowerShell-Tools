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

Get-NetAdapter | Select-Object InterfaceAlias, InterfaceIndex
Get-NetIPAddress -InterfaceIndex <número de la tarjeta> -AddressFamily "IPv4"
Get-DnsClientServerAddress -InterfaceIndex <número de la tarjeta>

$IPConf = @{
    InterfaceAlias = 'Wi-Fi'
    PrefixLength   = 24               #255.255.255.0
    IPAddress      = '192.168.1.67'
    DefaultGateway = '192.168.1.1'
   }
New-NetIPAddress @IPConf

Remove-NetIPAddress -IPAddress 192.168.1.67 -DefaultGateway 192.168.1.1

Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses ("8.8.8.8","1.1.1.1")

Test-Connection google.es
