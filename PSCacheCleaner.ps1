Clear-Host # Limpiar ventana al iniciar

# Elevación a Administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell.exe -Verb runAs -ArgumentList $arguments
  Break
}

# Banner principal del programa
Write-Host @"
    ____  _____ ______           __         ________                          
   / __ \/ ___// ____/___ ______/ /_  ___  / ____/ /__  ____ _____  ___  _____
  / /_/ /\__ \/ /   / __ `/ ___/  __ \/ _ \/ /   / / _ \/ __ `/ __ \/ _ \/ ___/
 / ____/___/ / /___/ /_/ / /__/ / / /  __/ /___/ /  __/ /_/ / / / /  __/ /    
/_/    /____/\____/\__,_/\___/_/ /_/\___/\____/_/\___/\__,_/_/ /_/\___/_/     
                                                                           
"@ -ForegroundColor Yellow
Write-Host " "

function Show-ProgressSimple {
    param(
        [string]$Activity,
        [string]$Status,
        [int]$PercentComplete
    )
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
}

# Instalación de modulos
Show-ProgressSimple -Activity "Instalación de módulos" -Status "Verificando PSWindowsUpdate" -PercentComplete 0
$IsInstalled = Get-InstalledModule PSWindowsUpdate
if ($IsInstalled) {
    Show-ProgressSimple -Activity "Instalación de módulos" -Status "PSWindowsUpdate ya está instalado" -PercentComplete 100
    Write-Host "PSWindowsUpdate ya está instalado en el sistema!" -ForegroundColor Green
    Write-Host " "
    Write-Progress -Activity "Instalación de módulos" -Completed
}
else {
    try {
        Show-ProgressSimple -Activity "Instalación de módulos" -Status "Instalando PSWindowsUpdate" -PercentComplete 25
        Install-Module PSWindowsUpdate -Force
        Show-ProgressSimple -Activity "Instalación de módulos" -Status "Instalación completada" -PercentComplete 100
        Write-Host "El modulo PSWindowsUpdate se ha instalado correctamente en el sistema!" -ForegroundColor Green
        Write-Host " "
        Write-Progress -Activity "Instalación de módulos" -Completed
    }
    catch {
        Write-Host "EL modulo PSWindowsUpdate no se ha podido instalar correctamente..." -ForegroundColor Red
        Write-Host " "
    }
}


# Optimizar y defragmentar disco C
try {
    Show-ProgressSimple -Activity "Optimización de disco" -Status "Optimizando disco C:\" -PercentComplete 0
    Optimize-Volume -DriveLetter C -Defrag -ReTrim -SlabConsolidate -TierOptimize
    Show-ProgressSimple -Activity "Optimización de disco" -Status "Optimización completada" -PercentComplete 100
    Write-Progress -Activity "Optimización de disco" -Completed
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
$UserProfile = $Env:USERPROFILE

function Remove-PathFiles {
    param(
        [Parameter(Mandatory = $true)][string]$Path
    )
    Get-ChildItem -Path $Path -Force -Recurse -ErrorAction SilentlyContinue -File | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
            Write-Host "Archivo eliminado: $($_.FullName)" -ForegroundColor Green
            $global:Contador += 1
        }
        catch {
        }
    }
}

function CleanPathIfExists {
    param(
        [Parameter(Mandatory = $true)][string]$Path
    )
    if (Test-Path -Path $Path) {
        Remove-PathFiles -Path $Path
    }
}

function CleanAppPaths {
    param(
        [Parameter(Mandatory = $true)][string]$PackageName,
        [Parameter(Mandatory = $true)][string[]]$Paths
    )
    if (Get-Package $PackageName -ErrorAction SilentlyContinue) {
        foreach ($Path in $Paths) {
            CleanPathIfExists -Path $Path
        }
    }
}

# Directorios a vaciar
$CleanupPaths = @(
    'C:\Windows\Prefetch',
    'C:\Windows\SoftwareDistribution',
    [System.IO.Path]::GetTempPath(),
    'C:\Windows\Temp',
    'C:\Windows\System32\spool\PRINTERS',
    "$UserProfile\AppData\LocalLow\NVIDIA\PerDriverVersion\DXCache",
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
    "$env:LOCALAPPDATA\Packages\Microsoft.MicrosoftEdge*\AC\MicrosoftEdge\Cache\*",
    'C:\Windows\SoftwareDistribution\Download',
    "$env:LOCALAPPDATA\CrashDumps",
    "$env:LOCALAPPDATA\Microsoft\Outlook\RoamCache",
    "$UserProfile\AppData\Roaming\Adobe\Common\Media Cache Files",
    "$UserProfile\AppData\Roaming\Adobe\Adobe Photoshop*\Logs"
)

$DiscordPaths = @(
    "$UserProfile\AppData\Roaming\discord\Code Cache",
    "$UserProfile\AppData\Roaming\discord\Cache",
    "$UserProfile\AppData\Roaming\discord\GPUCache"
)

$SpotifyPaths = @(
    "$env:LOCALAPPDATA\Spotify\Storage"
)

$EpicGamesPaths = @(
    "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache",
    "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache_4147",
    "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache_4430"
)

$OperaPaths = @(
    "$UserProfile\AppData\Roaming\Opera Software\Opera Stable",
    "$env:LOCALAPPDATA\Opera Software\Opera Stable\Default\Cache\Cache_Data"
)

$ChromePaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache2\entries\*",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Media Cache",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies-Journal"
)

$MozillaFirefoxPaths = @(
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache\*",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache\*.*",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache2\entries\*.*",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\thumbnails\*",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cookies.sqlite",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\webappsstore.sqlite",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\chromeappsstore.sqlite",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\chromeappsstore.sqlite"
)

$Prefetch_Path = 'C:\Windows\Prefetch'
$Software_Distribution = 'C:\Windows\SoftwareDistribution'
$Directorio_Temporal = [System.IO.Path]::GetTempPath()
$Directorio_Temporal2 = 'C:\Windows\Temp'
$Printers_Temp = 'C:\Windows\System32\spool\PRINTERS'
$Nvidia_Temp = "C:\Users\" + $Usuario + "\AppData\LocalLow\NVIDIA\PerDriverVersion\DXCache"
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
$Discord_Temp1 = "C:\Users\" + $Usuario + "AppData\Roaming\discord\Code Cache"
$Discord_Temp2 = "C:\Users\" + $Usuario + "AppData\Roaming\discord\Cache"
$Discord_Temp3 = "C:\Users\" + $Usuario + "AppData\Roaming\discord\GPUCache"
$Spotify_Temp = "$env:LOCALAPPDATA\Spotify\Storage"
$Edge_Temp = "$env:LOCALAPPDATA\Packages\Microsoft.MicrosoftEdge*\AC\MicrosoftEdge\Cache\*"
$Outlook_Temp = "$env:LOCALAPPDATA\Microsoft\Outlook\RoamCache"
$Epic_Games_Temp1 = "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache"
$Epic_Games_Temp2 = "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache_4147"
$Epic_Games_Temp3 = "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache_4430"
$Adobe_Premiere_Pro_Temp = "C:\Users\$Usuario\AppData\Roaming\Adobe\Common\Media Cache Files"
$Photoshop_Logs_Temp = "C:\Users\$Usuario\AppData\Roaming\Adobe\Adobe Photoshop*\Logs"
$Opera_Temp1 = "C:\Users\" + $Usuario +"\AppData\Roaming\Opera Software\Opera Stable"
$Opera_Temp2 = "$env:LOCALAPPDATA\Opera Software\Opera Stable\Default\Cache\Cache_Data"
$Net_Temp = "$env:LOCALAPPDATA\\Microsoft\Windows\INetCache"
$SystemRoot_Temp = "C:\Windows\Temp"
$WindowsUpdate_Downloads_Temp = "C:\Windows\SoftwareDistribution\Download"
$CrashDump_Temp = "$env:LOCALAPPDATA\CrashDumps"

Write-Host "--- ARCHIVOS ELIMINADOS ---" -BackgroundColor Yellow -ForegroundColor Black
Write-Host " "

for ($i = 0; $i -lt $CleanupPaths.Count; $i++) {
    $currentPath = $CleanupPaths[$i]
    $percent = [int](($i + 1) / $CleanupPaths.Count * 100)
    Show-ProgressSimple -Activity "Eliminando archivos temporales" -Status "Procesando $currentPath" -PercentComplete $percent
    CleanPathIfExists -Path $currentPath
}
Write-Progress -Activity "Eliminando archivos temporales" -Completed

Show-ProgressSimple -Activity "Eliminando caché de aplicaciones" -Status "Verificando Discord" -PercentComplete 0
CleanAppPaths -PackageName 'Discord' -Paths $DiscordPaths
Show-ProgressSimple -Activity "Eliminando caché de aplicaciones" -Status "Verificando Spotify" -PercentComplete 20
CleanAppPaths -PackageName 'Spotify*' -Paths $SpotifyPaths
Show-ProgressSimple -Activity "Eliminando caché de aplicaciones" -Status "Verificando Epic Games" -PercentComplete 40
CleanAppPaths -PackageName 'Epic Games*' -Paths $EpicGamesPaths
Show-ProgressSimple -Activity "Eliminando caché de aplicaciones" -Status "Verificando Opera" -PercentComplete 60
CleanAppPaths -PackageName 'Opera*' -Paths $OperaPaths
Show-ProgressSimple -Activity "Eliminando caché de aplicaciones" -Status "Verificando Google Chrome" -PercentComplete 80
CleanAppPaths -PackageName 'Google Chrome*' -Paths $ChromePaths
Show-ProgressSimple -Activity "Eliminando caché de aplicaciones" -Status "Verificando Mozilla Firefox" -PercentComplete 100
CleanAppPaths -PackageName 'Mozilla Firefox*' -Paths $MozillaFirefoxPaths
Write-Progress -Activity "Eliminando caché de aplicaciones" -Completed

Write-Host " "
Write-Host "Se han eliminado un total de $Contador archivos!" -BackgroundColor Green -ForegroundColor Black
Write-Host " "

Write-Host "---------------------------------------------------------------------------" -BackgroundColor Yellow -ForegroundColor Black
Write-Host " "

# Ejecutar y limpiar Disk Clean up tool
Show-ProgressSimple -Activity "Disk Cleanup" -Status "Iniciando cleanmgr" -PercentComplete 0
Write-host "El proceso de cleanmgr ha comenzado correctamente en segundo plano!" -ForegroundColor Green
Start-Process cleanmgr -ArgumentList "/verylowdisk /autoclean" -NoNewWindow
Show-ProgressSimple -Activity "Disk Cleanup" -Status "Esperando a que termine cleanmgr" -PercentComplete 50
Start-Sleep -Seconds 15
Stop-Process -Name cleanmgr -ErrorAction SilentlyContinue
Show-ProgressSimple -Activity "Disk Cleanup" -Status "Tarea completada" -PercentComplete 100
Write-Progress -Activity "Disk Cleanup" -Completed
Write-Host " "
Write-Host "Se ha ejecutado con exito la herramienta de Disk Clean de Windows!" -BackgroundColor Green -ForegroundColor Black
Write-Host " "

# Limpiar caché Microsoft Store
Show-ProgressSimple -Activity "Microsoft Store" -Status "Iniciando limpieza de caché" -PercentComplete 0
Write-Host "Limpiando caché de Microsoft Store..." -ForegroundColor Yellow
Write-Host " "
try {
    Start-Process -FilePath "WSReset.exe"
    Show-ProgressSimple -Activity "Microsoft Store" -Status "Esperando cierre de Store" -PercentComplete 50
    Write-Host "En 5 segundos se cerrará la ventana de Microsoft Store..." -ForegroundColor Yellow
    Write-Host " "
    Start-Sleep -Seconds 8
    try {
        Stop-Process -name "WinStore.App" -Force
        Show-ProgressSimple -Activity "Microsoft Store" -Status "Limpieza completada" -PercentComplete 100
        Write-Progress -Activity "Microsoft Store" -Completed
        Write-Host "Se ha cerrado la ventana de la Microsoft Store correctamente!" -ForegroundColor Green
        Write-Host " "
    }
    catch {
        Write-Progress -Activity "Microsoft Store" -Completed
        Write-Host "No se ha podido cerrar correctamente la ventana de la Microsoft Store o no se ha abierto..." -ForegroundColor Red

    }
}
catch {
    Write-Progress -Activity "Microsoft Store" -Completed
    Write-Host "No se ha podido limpiar el caché de Microsoft Store correctamente..." -ForegroundColor Red
}

# Limpiar caché DNS
Show-ProgressSimple -Activity "Limpiar DNS" -Status "Iniciando vaciado de caché DNS" -PercentComplete 0
Write-Host "Limpiando caché de DNS..." -ForegroundColor Yellow
Write-Host " "
Start-Sleep -Seconds 2
try {
    ipconfig /flushdns
    Show-ProgressSimple -Activity "Limpiar DNS" -Status "Caché DNS vaciado" -PercentComplete 100
    Write-Progress -Activity "Limpiar DNS" -Completed
    Write-Host " "
    Write-Host "Se ha limpiado el caché DNS correctamente!" -ForegroundColor Green
    Write-Host " "
}
catch {
    Write-Progress -Activity "Limpiar DNS" -Completed
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
$DecisionPapelera = Read-Host "Quieres vaciar la papelera de reciclaje? (Y/N)"
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

Show-ProgressSimple -Activity "Programas de inicio" -Status "Revisando programas de arranque" -PercentComplete 0
Write-Host "Revisando programas de arrancada de inicio de Windows..." -ForegroundColor Yellow
Write-Host ""

while ($true) {

    # Lista de programas de arrancada de inicio de Windows habilitados
    $programasActivos = @()

    # Claves de registro de Windows de programas de arrancada de inicio
    $claves = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
    )

    # Recorrer las claves de registro de Windows de programas de arrancada de inicio
    foreach ($clave in $claves) {

        # Comprobar si la clave de registro existe
        if (Test-Path $clave) {

            # Obtener las propiedades de la clave de registro
            $propiedades = (Get-ItemProperty $clave).PSObject.Properties |
                Where-Object {
                    $_.Name -notmatch '^PS' -and
                    $_.Value -is [byte[]]
                }

            # Recorrer las propiedades de la clave de registro
            foreach ($propiedad in $propiedades) {

                # Si el valor de la propiedad es 0x02 = Habilitado
                if ($propiedad.Value[0] -eq 2) {

                    # Añadir el programa de arrancada de inicio a la lista de programas activos
                    $programasActivos += [PSCustomObject]@{
                        Nombre = $propiedad.Name
                        Ruta   = $clave
                    }
                }
            }
        }
    }

    # Comprobar si hay programas de arrancada de inicio de Windows habilitados
    if ($programasActivos.Count -eq 0) {
        Write-Host "No hay programas de inicio habilitados." -ForegroundColor Yellow
        break
    }

    Write-Host "PROGRAMAS DE INICIO" -ForegroundColor Cyan
    Write-Host ""

    # Recorrer la lista de programas de arrancada de inicio de Windows habilitados
    for ($i = 0; $i -lt $programasActivos.Count; $i++) {
        Write-Host "$($i + 1). $($programasActivos[$i].Nombre)"
    }

    Write-Host "0. Salir"
    Write-Host ""

    # Leer la opción seleccionada por el usuario
    $opcion = Read-Host "Seleccione un programa para deshabilitar"

    # Comprobar si la opción seleccionada es 0
    if ($opcion -eq "0") {
        break
    }

    # Comprobar si la opción seleccionada es un número
    if (-not ($opcion -as [int])) {
        continue
    }

    $indice = [int]$opcion - 1

    if ($indice -lt 0 -or $indice -ge $programasActivos.Count) {
        continue
    }

    $programa = $programasActivos[$indice]

    Write-Host ""
    $confirmacion = Read-Host "¿Deshabilitar '$($programa.Nombre)'? (S/N)"

    if ($confirmacion -match '^[Ss]$') {

        $valorDeshabilitado = [byte[]](
            0x03,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00
        )

        Set-ItemProperty `
            -Path $programa.Ruta `
            -Name $programa.Nombre `
            -Value $valorDeshabilitado

        Write-Host ""
        Write-Host "Programa deshabilitado correctamente." -ForegroundColor Green
    }

    Write-Host ""
    Read-Host "Pulse ENTER para continuar"
}

Write-Progress -Activity "Programas de inicio" -Completed

Write-Host " "

# Actualizar apps
$DecisionActualizarApps = Read-Host "Quieres actualizar aplicaciones de tu ordenador? (Winget) (Y/N)"
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
