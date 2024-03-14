if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell.exe -Verb runAs -ArgumentList $arguments
  Break
}

Install-Module PSWindowsUpdate -Force


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
$Contador = 0

$Prefetch_Path = 'C:\Windows\Prefetch'
$Software_Distribution = 'C:\Windows\SoftwareDistribution'
$Directorio_Temporal = [System.IO.Path]::GetTempPath()
$Directorio_Temporal2 = 'C:\Windows\Temp'
$Printers_Temp = 'C:\Windows\System32\spool\PRINTERS'

# Función para contar archivos eliminados
function LimpiarDirectorio ($ruta) {
    $archivosEliminados = Remove-Item -Path $ruta -Recurse -ErrorAction SilentlyContinue
    $Contador += $archivosEliminados.Count
    Write-host "Directorio $ruta se ha limpiado correctamente!" -ForegroundColor Green
    Write-Host " "
}

# Contar archivos eliminados de cada directorio
LimpiarDirectorio $Prefetch_Path
LimpiarDirectorio $Software_Distribution
LimpiarDirectorio $Directorio_Temporal
LimpiarDirectorio $Printers_Temp
LimpiarDirectorio $Directorio_Temporal2

wevtutil el | Foreach-Object {wevtutil cl "$_"} -ErrorAction SilentlyContinue
Write-Host " "
Write-Host "El visor de eventos se ha limpiado correctamente!" -ForegroundColor Green
Write-Host " "

Write-host "El proceso de cleanmgr ha comenzado correctamente en segundo plano!" -ForegroundColor Green
Start-Process cleanmgr -ArgumentList "/verylowdisk /autoclean" -NoNewWindow
Start-Sleep -Seconds 15
Stop-Process -Name cleanmgr -ErrorAction SilentlyContinue
Write-Host " "
Write-Host "Se ha limpiado todo el cache de tu ordenador!" -BackgroundColor Green -ForegroundColor Black
Write-Host " "
$Bloatware = Read-Host "Quieres actualizar aplicaciones de tu ordenador? (Y/N)"
if ($Bloatware.ToLower() -eq "y") {
    if (Get-Command "winget" -ErrorAction SilentlyContinue) {
        Write-Host " "
        Write-Host "Winget está instalado en este ordenador, continuando..." -ForegroundColor Green
	
	winget upgrade --all --include-unknown --accept-package-agreements

    } else {
        Write-Host " "
        Write-Host "Winget está instalado en este ordenador, instalalo si quiere continuar..." -ForegroundColor Red
        exit
    }
}
elseif ($Bloatware.ToLower() -eq "n") {
    Write-Host " "
    Write-Host "Se ha cancelado la limpieza de programas basura..." -ForegroundColor Yellow
}
else {
    Write-Host " "
    Write-Host "Selección inválida, saliendo..." -ForegroundColor Red
    exit
}

$WindowsUpdate = Read-Host "Quieres actualizar Windows Update? (Y/N)"

if ($WindowsUpdate.ToLower() -eq "y") {
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