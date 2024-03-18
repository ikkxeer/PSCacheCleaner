Clear-Host # Limpiar ventana al iniciar

# Elevación a Administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell.exe -Verb runAs -ArgumentList $arguments
  Break
}

Write-Host @"
    ____  _____ ______           __         ________                          
   / __ \/ ___// ____/___ ______/ /_  ___  / ____/ /__  ____ _____  ___  _____
  / /_/ /\__ \/ /   / __ `/ ___/ __ \/ _ \/ /   / / _ \/ __ `/ __ \/ _ \/ ___/
 / ____/___/ / /___/ /_/ / /__/ / / /  __/ /___/ /  __/ /_/ / / / /  __/ /    
/_/    /____/\____/\__,_/\___/_/ /_/\___/\____/_/\___/\__,_/_/ /_/\___/_/     
                                                                           
"@ -ForegroundColor Yellow
Write-Host " "

# Instalación de modulos
$IsInstalled = Get-InstalledModule PSWindowsUpdate
if ($IsInstalled) {
    Write-Host "PSWindowsUpdate ya está instalado en el sistema!" -ForegroundColor Green
    Write-Host " "
}
else {
    try {
        Install-Module PSWindowsUpdate -Force
        Write-Host "El modulo PSWindowsUpdate se ha instalado correctamente en el sistema!" -ForegroundColor Green
        Write-Host " "
    }
    catch {
        Write-Host "EL modulo PSWindowsUpdate no se ha podido instalar correctamente..." -ForegroundColor Red
        Write-Host " "
    }
}


# Optimizar y defragmentar disco C
try {
    Optimize-Volume -DriveLetter C -Defrag -ReTrim -SlabConsolidate -TierOptimize
    Write-Host "Se ha optimizado de forma exitosa el disco C:\!" -ForegroundColor Green
    Write-Host " "
}
catch {
    Write-Host "Ha ocurrido un error optimizando el disco C:\..." -ForegroundColor Red
    Write-Host " "
}

# Contador de archivos
$global:Contador = 0

# Usuario Actual
$Usuario = $Env:USERNAME

# Directorios a vaciar
$Prefetch_Path = 'C:\Windows\Prefetch'
$Software_Distribution = 'C:\Windows\SoftwareDistribution'
$Directorio_Temporal = [System.IO.Path]::GetTempPath()
$Directorio_Temporal2 = 'C:\Windows\Temp'
$Printers_Temp = 'C:\Windows\System32\spool\PRINTERS'
$Nvidia_Temp = 'C:\Users\' + $Usuario + '\AppData\LocalLow\NVIDIA\PerDriverVersion\DXCache'
$Chrome_Temp1 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*"
$Chrome_Temp2 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache2\entries\*"
$Chrome_Temp3 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies"
$Chrome_Temp4 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Media Cache"
$Chrome_Temp5 =  "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies-Journal"
$Mozilla_Firefox_Temp1 = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache\*" 
$Mozilla_Firefox_Temp2 = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache\*.*"
$Mozilla_Firefox_Temp3 = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache2\entries\*.*"
$Mozilla_Firefox_Temp4 = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\thumbnails\*"
$Mozilla_Firefox_Temp5 = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cookies.sqlite"
$Mozilla_Firefox_Temp6 = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\webappsstore.sqlite"
$Mozilla_Firefox_Temp7 = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\chromeappsstore.sqlite"
$Mozilla_Firefox_Temp8 = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\chromeappsstore.sqlite"
$Discord_Temp1 = "C:\Users " + $Usuario + "AppData\Roaming\discord\Code Cache"
$Discord_Temp2 = "C:\Users " + $Usuario + "AppData\Roaming\discord\Cache"
$Discord_Temp3 = "C:\Users " + $Usuario + "AppData\Roaming\discord\GPUCache"
$Spotify_Temp = "$env:LOCALAPPDATA\Spotify\Storage"
$Edge_Temp = "$env:LOCALAPPDATA\Packages\Microsoft.MicrosoftEdge*\AC\MicrosoftEdge\Cache\*"

# Función para contar archivos eliminados
function LimpiarDirectorio ($ruta) {
    $carpeta = Get-ChildItem -Path $Ruta
    foreach ($elemento in $carpeta) {
        # Si es un archivo, lo eliminamos y mostramos un mensaje
        if ($elemento.PSIsContainer -eq $false) {
            try {
                Remove-Item -Path $elemento.FullName -Force -ErrorAction SilentlyContinue
                Write-Host "Archivo eliminado: $($elemento.FullName)" -ForegroundColor Green
                $global:Contador += 1
            }
            catch {
            }
        }
        # Si es una carpeta, llamamos a la función recursivamente para eliminar archivos dentro de la carpeta
        else {
            LimpiarDirectorio -Ruta $elemento.FullName
        }
    }
}

Write-Host "--- ARCHIVOS ELIMINADOS ---" -BackgroundColor Yellow -ForegroundColor Black
Write-Host " "

# Limpiar los directorios especificados
# Prefetch
$Exists = Test-Path -Path $Prefetch_Path
if ($Exists) {
    LimpiarDirectorio $Prefetch_Path
}
else {
}

# Software Distribution
$Exists = Test-Path -Path $Software_Distribution
if ($Exists) {
    LimpiarDirectorio $Software_Distribution
}
else {
}

# Nvidia Temp
$Exists = Test-Path -Path $Nvidia_Temp
if ($Exists) {
    LimpiarDirectorio $Nvidia_Temp
}
else {
}

# Edge Temp
$Exists = Test-Path -Path $Edge_Temp
if ($Exists) {
    LimpiarDirectorio $Edge_Temp
}
else {
}

#Temp
$Exists = Test-Path -Path $Directorio_Temporal
if ($Exists) {
    LimpiarDirectorio $Directorio_Temporal
}
else {
}

# Printers temp
$Exists = Test-Path -Path $Printers_Temp
if ($Exists) {
    LimpiarDirectorio $Printers_Temp
}
else {
}

# Temp
$Exists = Test-Path -Path $Directorio_Temporal2
if ($Exists) {
    LimpiarDirectorio $Directorio_Temporal2
}
else {
}

# Discord
$DiscordIsInstalled = Get-Package Discord
$Exists1 = Test-Path -Path $Discord_Temp1
$Exists2 = Test-Path -Path $Discord_Temp2
$Exists3 = Test-Path -Path $Discord_Temp3
if ($DiscordIsInstalled) {
    if ($Exists1) {
        LimpiarDirectorio $Discord_Temp1
    }
    if ($Exists2) {
        LimpiarDirectorio $Discord_Temp1
    }
    if ($Exists3) {
        LimpiarDirectorio $Discord_Temp1
    }
}
else {
}

# Spotify
$SpotifyIsInstalled = Get-Package "Spotify*"
$Exists = Test-Path -Path $Spotify_Temp
if ($SpotifyIsInstalled) {
    if ($Exists) {
        LimpiarDirectorio $Spotify_Temp
    }
}
else {
} 

# Google Chrome
$GoogleChromeIsInstalled = Get-Package "Google Chrome*"
$Exists1 = Test-Path -Path $Chrome_Temp1
$Exists2 = Test-Path -Path $Chrome_Temp2
$Exists3 = Test-Path -Path $Chrome_Temp3
$Exists4 = Test-Path -Path $Chrome_Temp4
$Exists5 = Test-Path -Path $Chrome_Temp5
if ($GoogleChromeIsInstalled) {
    if ($Exists1) {
        LimpiarDirectorio Chrome_Temp1
    }
    if ($Exists2) {
        LimpiarDirectorio Chrome_Temp2
    }
    if ($Exists3) {
        LimpiarDirectorio Chrome_Temp3
    }
    if ($Exists4) {
        LimpiarDirectorio Chrome_Temp4
    }
    if ($Exists5) {
        LimpiarDirectorio Chrome_Temp5
    }
    } 
else {
}

# Mozilla Firefox
$MozillaFirefoxIsInstalled = Get-Package "Mozilla Firefox*"
$Exists1 = Test-Path -Path $Mozilla_Firefox_Temp1
$Exists2 = Test-Path -Path $Mozilla_Firefox_Temp2
$Exists3 = Test-Path -Path $Mozilla_Firefox_Temp3
$Exists4 = Test-Path -Path $Mozilla_Firefox_Temp4
$Exists5 = Test-Path -Path $Mozilla_Firefox_Temp5
$Exists6 = Test-Path -Path $Mozilla_Firefox_Temp6
$Exists7 = Test-Path -Path $Mozilla_Firefox_Temp7
$Exists8 = Test-Path -Path $Mozilla_Firefox_Temp8
if ($MozillaFirefoxIsInstalled) {
    if ($Exists1) {
        LimpiarDirectorio $Mozilla_Firefox_Temp1
    }
    if ($Exists2) {
        LimpiarDirectorio $Mozilla_Firefox_Temp2
    }
    if ($Exists3) {
        LimpiarDirectorio $Mozilla_Firefox_Temp3
    }
    if ($Exists4) {
        LimpiarDirectorio $Mozilla_Firefox_Temp4
    }
    if ($Exists5) {
        LimpiarDirectorio $Mozilla_Firefox_Temp5
    }
    if ($Exists6) {
        LimpiarDirectorio $Mozilla_Firefox_Temp6
    }
    if ($Exists7) {
        LimpiarDirectorio $Mozilla_Firefox_Temp7
    }
    if ($Exists8) {
        LimpiarDirectorio $Mozilla_Firefox_Temp8
    }
}

Write-Host " "
Write-Host "Se han eliminado un total de $Contador archivos!" -BackgroundColor Green -ForegroundColor Black
Write-Host " "

Write-Host "---------------------------------------------------------------------------" -BackgroundColor Yellow -ForegroundColor Black
Write-Host " "

# Limpiar visor de eventos
wevtutil el | Foreach-Object {wevtutil cl "$_"} -ErrorAction SilentlyContinue
Write-Host " "
Write-Host "El visor de eventos se ha limpiado correctamente!" -ForegroundColor Green
Write-Host " "

# Ejecutar y limpiar Disk Clean up tool
Write-host "El proceso de cleanmgr ha comenzado correctamente en segundo plano!" -ForegroundColor Green
Start-Process cleanmgr -ArgumentList "/verylowdisk /autoclean" -NoNewWindow
Start-Sleep -Seconds 15
Stop-Process -Name cleanmgr -ErrorAction SilentlyContinue
Write-Host " "
Write-Host "Se ha ejecutado con exito la herramienta de Disk Clean de Windows!" -BackgroundColor Green -ForegroundColor Black
Write-Host " "

# Limpiar caché Microsoft Store
Write-Host "Limpiando caché de Microsoft Store..." -ForegroundColor Yellow
Write-Host " "
try {
    Start-Process -FilePath "WSReset.exe"
    Write-Host "En 5 segundos se cerrará la ventana de Microsoft Store..." -ForegroundColor Yellow
    Write-Host " "
    Start-Sleep -Seconds 8
    try {
        Stop-Process -name "WinStore.App" -Force
        Write-Host "Se ha cerrado la ventana de la Microsoft Store correctamente!" -ForegroundColor Green
        Write-Host " "
    }
    catch {
        Write-Host "No se ha podido cerrar correctamente la ventana de la Microsoft Store o no se ha abierto..." -ForegroundColor Red

    }
}
catch {
    Write-Host "No se ha podido limpiar el caché de Microsoft Store correctamente..." -ForegroundColor Red
}

# Limpiar caché DNS
Write-Host "Limpiando caché de DNS..." -ForegroundColor Yellow
Write-Host " "
Start-Sleep -Seconds 2
try {
    ipconfig /flushdns
    Write-Host " "
    Write-Host "Se ha limpiado el caché DNS correctamente!" -ForegroundColor Green
    Write-Host " "
}
catch {
    Write-Host "No se ha podido limpiar correctamente el caché DNS..." -ForegroundColor Red
    Write-Host " "
}

# Actualizar Microsoft Store
$namespaceName = "root\cimv2\mdm\dmmap"
$className = "MDM_EnterpriseModernAppManagement_AppManagement01"
$wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className
$result = $wmiObj.UpdateScanMethod()
Write-Host "Se ha comenzado a actualizar las aplicaciones de Microsoft Store!" -ForegroundColor Green
Write-Host " "

# Vaciar Papelera de reciclaje
$DecisionPapelera = "Quieres vaciar la papelera de reciclaje? (Y/N)"
Write-Host " "

if ($DecisionPapelera.ToLower() -eq "y") {
    try {
        Clear-RecycleBin -Force
        Write-Host "La papelera de reciclaje se ha limpiado correctamente!" -ForegroundColor Green
        Write-Host " "
    }
    catch {
        Write-Host "La papelera no se ha podido vaciar correctamente..." -ForegroundColor Red
        Write-Host " "
    }
}
else {
    Write-Host "La papelera de reciclaje no se va a vaciar..." -ForegroundColor Yellow
    Write-Host " "
}

# Actualizar apps
$DecisionActualizarApps = Read-Host "Quieres actualizar aplicaciones de tu ordenador? (Y/N)"
Write-Host " "

if ($DecisionActualizarApps.ToLower() -eq "y") {
    if (Get-Command "winget" -ErrorAction SilentlyContinue) {
        Write-Host "Winget está instalado en este ordenador, continuando..." -ForegroundColor Green
	    Write-Host " "
	    winget upgrade --all --include-unknown --accept-package-agreements
    } else {
        Write-Host "Winget está instalado en este ordenador, instalalo si quiere continuar..." -ForegroundColor Red
        Write-Host " "
        exit
    }
}
elseif ($DecisionActualizarApps.ToLower() -eq "n") {
    Write-Host "Se ha cancelado la limpieza de programas basura..." -ForegroundColor Yellow
    Write-Host " "
}
else {
    Write-Host "Selección inválida, saliendo..." -ForegroundColor Red
    Write-Host " "
    exit
}

# Actualizar Windows Update
$WindowsUpdate = Read-Host "Quieres actualizar Windows Update? (Y/N)"
Write-Host " "

if ($WindowsUpdate.ToLower() -eq "y") {
    Write-Host "Comenzando actualizaciones de Windows Update..." -ForegroundColor Yellow
    Write-Host " "
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot
    Write-Host " "
    Pause
}
elseif ($WindowsUpdate.ToLower() -eq "n") {
    Write-Host "Se ha cancelado la actualización de Windows Update" -ForegroundColor Yellow
    Write-Host " "
}
else {
    Write-Host "Opción inválida..." -ForegroundColor Red
    Write-host " "
}


Pause
Clear-Host