Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Cleanup Tool"
$form.Width = 800
$form.Height = 600
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = [System.Windows.Forms.DockStyle]::Fill
$panel.BackColor = [System.Drawing.Color]::LightGray
$form.Controls.Add($panel)

$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "Start Cleanup"
$btnStart.Width = 200
$btnStart.Height = 40
$btnStart.Location = New-Object System.Drawing.Point(10, 10)
$btnStart.BackColor = [System.Drawing.Color]::SteelBlue
$btnStart.ForeColor = [System.Drawing.Color]::White
$btnStart.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnStart.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$panel.Controls.Add($btnStart)

$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "Exit"
$btnExit.Width = 200
$btnExit.Height = 40
$btnExit.Location = New-Object System.Drawing.Point(220, 10)
$btnExit.BackColor = [System.Drawing.Color]::Firebrick
$btnExit.ForeColor = [System.Drawing.Color]::White
$btnExit.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnExit.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$panel.Controls.Add($btnExit)

$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Multiline = $true
$txtOutput.Dock = [System.Windows.Forms.DockStyle]::Bottom
$txtOutput.Height = 450
$txtOutput.ScrollBars = "Vertical"
$txtOutput.ReadOnly = $true
$txtOutput.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$txtOutput.BackColor = [System.Drawing.Color]::White
$txtOutput.ForeColor = [System.Drawing.Color]::Black
$panel.Controls.Add($txtOutput)

$form.SuspendLayout()
$panel.SuspendLayout()

function Update-Output {
    param ([string]$message)
    if ($txtOutput.InvokeRequired) {
        $txtOutput.Invoke([Action]{$txtOutput.AppendText($message + "`r`n")})
    } else {
        $txtOutput.AppendText($message + "`r`n")
    }
    $txtOutput.ScrollToCaret()
}

function CleanUp {
    Update-Output "Iniciando el proceso de limpieza..."

    Update-Output "Instalando módulos..."
    if (-not (Get-InstalledModule PSWindowsUpdate -ErrorAction SilentlyContinue)) {
        try {
            Install-Module PSWindowsUpdate -Force
            Update-Output "PSWindowsUpdate instalado correctamente!"
        } catch {
            Update-Output "No se pudo instalar PSWindowsUpdate..."
        }
    } else {
        Update-Output "PSWindowsUpdate ya está instalado!"
    }

    try {
        Optimize-Volume -DriveLetter C -Defrag -ReTrim -SlabConsolidate -TierOptimize
        Update-Output "Optimización del disco C:\ completada!"
    } catch {
        Update-Output "Error al optimizar el disco C:\..."
    }

    $global:Contador = 0
    function LimpiarDirectorio ($ruta) {
        Get-ChildItem -Path $ruta | ForEach-Object {
            if (-not $_.PSIsContainer) {
                try {
                    Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
                    Update-Output "Archivo eliminado: $($_.FullName)"
                    $global:Contador++
                } catch {}
            } else {
                LimpiarDirectorio -ruta $_.FullName
            }
        }
    }

    $directories = @(
        'C:\Windows\Prefetch',
        'C:\Windows\SoftwareDistribution',
        [System.IO.Path]::GetTempPath(),
        'C:\Windows\Temp',
        'C:\Windows\System32\spool\PRINTERS',
        "C:\Users\$Env:USERNAME\AppData\LocalLow\NVIDIA\PerDriverVersion\DXCache",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache2\entries\*",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Media Cache",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies-Journal"
    )

    $directories | ForEach-Object { if (Test-Path -Path $_) { LimpiarDirectorio $_ } }

    Update-Output "Se han eliminado $Contador archivos!"

    Update-Output "Limpiando el visor de eventos..."
    wevtutil el | ForEach-Object { wevtutil cl "$_" } -ErrorAction SilentlyContinue
    Update-Output "Visor de eventos limpiado!"

    Update-Output "Iniciando Disk Cleanup..."
    Start-Process cleanmgr -ArgumentList "/verylowdisk /autoclean" -NoNewWindow
    Start-Sleep -Seconds 15
    Stop-Process -Name cleanmgr -ErrorAction SilentlyContinue
    Update-Output "Disk Cleanup ejecutado!"

    Update-Output "Limpiando caché de Microsoft Store..."
    try {
        Start-Process -FilePath "WSReset.exe"
        Start-Sleep -Seconds 8
        Stop-Process -Name "WinStore.App" -Force
        Update-Output "Caché de Microsoft Store limpiado!"
    } catch {
        Update-Output "No se pudo limpiar el caché de Microsoft Store..."
    }

    Update-Output "Limpiando caché DNS..."
    try {
        ipconfig /flushdns
        Update-Output "Caché DNS limpiado!"
    } catch {
        Update-Output "No se pudo limpiar el caché DNS..."
    }

    $namespaceName = "root\cimv2\mdm\dmmap"
    $className = "MDM_EnterpriseModernAppManagement_AppManagement01"
    $wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className
    $wmiObj.UpdateScanMethod()
    Update-Output "Actualización de aplicaciones de Microsoft Store iniciada!"

    $DecisionPapelera = [System.Windows.Forms.MessageBox]::Show("Vaciar la papelera de reciclaje?", "Confirmación", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($DecisionPapelera -eq [System.Windows.Forms.DialogResult]::Yes) {
        try {
            Clear-RecycleBin -Force
            Update-Output "Papelera de reciclaje vaciada!"
        } catch {
            Update-Output "No se pudo vaciar la papelera de reciclaje..."
        }
    } else {
        Update-Output "Papelera de reciclaje no vaciada..."
    }

    $DecisionActualizarApps = [System.Windows.Forms.MessageBox]::Show("Actualizar aplicaciones de tu ordenador?", "Confirmación", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($DecisionActualizarApps -eq [System.Windows.Forms.DialogResult]::Yes) {
        if (Get-Command "winget" -ErrorAction SilentlyContinue) {
            Start-Process "winget" -ArgumentList "upgrade --all" -NoNewWindow
            Update-Output "Actualización de aplicaciones iniciada!"
        } else {
            Update-Output "Winget no encontrado!"
        }
    } else {
        Update-Output "Aplicaciones no actualizadas..."
    }
}

$btnStart.Add_Click({ CleanUp })
$btnExit.Add_Click({ $form.Close() })

$panel.ResumeLayout()
$form.ResumeLayout()

$form.ShowDialog()
