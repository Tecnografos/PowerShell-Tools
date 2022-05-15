<#

.DESCRIPTION
  Este script muestra la gestión de contraseñas con SecureString

.PARAMETER <Parameter_Name>
  No requiere

.INPUTS
  No requiere

.OUTPUTS
  Solo hay salida por pantalla

.NOTES
  Version:        1.0
  Author:         Antonio Felix Sanchez-Oro Portillo
  Creation Date:  15/05/2022
  Purpose/Change: Version inicial

#>

$TestFile = "C:\temp\pass.txt"
$TestUser = "TestUser"
$TestComputer = "TestComputer"

#EJEMPLO 1: Guardar, leer y desencriptar la contraseña en un archivo de texto

    #Crear un string seguro y leerlo
    #NOTA: el usuario que ejectute el script tiene que ser el mismo que ejecute este comando, si no da error
    Read-Host -AsSecureString "Introduce la contraseña" | ConvertFrom-SecureString | Out-File $TestFile

    #Leer una contraseña segura
    $Pass = Get-Content $TestFile | ConvertTo-SecureString

    #Para desencriptar un securestring
    [System.Net.NetworkCredential]::new("", $Pass).Password

#EJEMPLO 2: Guardar en memoria y desencriptar la contraseña desde código

    #Tener en una variable dentro del código
    #NOTA: ¡Es inseguro! porque va escrita en texto plano dentro del código.
    $Pass = ConvertTo-SecureString -String "lacontraseñainsegura" -AsPlainText -Force

    #Para desencriptar un securestring
    [System.Net.NetworkCredential]::new("", $Pass).Password

#EJEMPLO 3: Establecer una sesión con la contraseña y el usuario

    #Crear un objeto con las credenciales para establecer una sesión con otro host posteriormente
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $TestUser, $Pass
    $Session = New-PSSession -ComputerName $TestComputer -Credential $Credential



