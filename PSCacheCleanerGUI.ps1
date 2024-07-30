Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$base64Image  = "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"
$imageBytes = [System.Convert]::FromBase64String($base64Image)
$memoryStream = New-Object System.IO.MemoryStream
$memoryStream.Write($imageBytes, 0, $imageBytes.Length)
$memoryStream.Position = 0
$image = [System.Drawing.Image]::FromStream($memoryStream)
$iconHandle = $image.GetHicon()
$icon = [System.Drawing.Icon]::FromHandle($iconHandle)

$form = New-Object System.Windows.Forms.Form
$form.Text = "PSCacheCleaner - User Interface"
$form.Width = 1000
$form.Height = 700 
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.Icon = $icon

$menuStrip = New-Object System.Windows.Forms.MenuStrip
$menuStrip.BackColor = [System.Drawing.Color]::Purple
$menuStrip.ForeColor = [System.Drawing.Color]::White
$fileMenu = New-Object System.Windows.Forms.ToolStripMenuItem -ArgumentList "File"
$saveMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem -ArgumentList "Save Log"
$closeMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem -ArgumentList "Close"

$saveMenuItem.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Log files (*.log)|*.log|All files (*.*)|*.*"
    $saveFileDialog.Title = "Save Log File"
    $saveFileDialog.FileName = "cleanup-log.log"
    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $logFilePath = $saveFileDialog.FileName
        $txtOutput.Text | Out-File -FilePath $logFilePath -Encoding UTF8
        [System.Windows.Forms.MessageBox]::Show("Log guardado exitosamente en: $logFilePath", "Información", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

$closeMenuItem.Add_Click({
    $form.Close()
})

$fileMenu.DropDownItems.Add($saveMenuItem)
$fileMenu.DropDownItems.Add($closeMenuItem)
$menuStrip.Items.Add($fileMenu)

$form.MainMenuStrip = $menuStrip
$form.Controls.Add($menuStrip)

$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = [System.Windows.Forms.DockStyle]::Fill
$panel.BackColor = [System.Drawing.Color]::LightGray
$form.Controls.Add($panel)

$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "Start Process"
$btnStart.Width = 200
$btnStart.Height = 50
$btnStart.Location = New-Object System.Drawing.Point(20, 70)
$btnStart.BackColor = [System.Drawing.Color]::Purple
$btnStart.ForeColor = [System.Drawing.Color]::White
$btnStart.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnStart.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$panel.Controls.Add($btnStart)

$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "Exit"
$btnExit.Width = 200
$btnExit.Height = 50
$btnExit.Location = New-Object System.Drawing.Point(240, 70)
$btnExit.BackColor = [System.Drawing.Color]::LightGray
$btnExit.ForeColor = [System.Drawing.Color]::White
$btnExit.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnExit.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnExit.Enabled = $false
$panel.Controls.Add($btnExit)

$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Multiline = $true
$txtOutput.Dock = [System.Windows.Forms.DockStyle]::Bottom
$txtOutput.Height = 500
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

function Install-Winget {
    Update-Output "Instalando winget..."
    $webClient = New-Object System.Net.WebClient
    $downloadUrl = "https://aka.ms/getwinget"
    $installerPath = "$env:TEMP\winget-installer.exe"
    $webClient.DownloadFile($downloadUrl, $installerPath)
    Start-Process -FilePath $installerPath -ArgumentList "/quiet" -NoNewWindow -Wait
    Remove-Item -Path $installerPath
    Update-Output "Winget instalado correctamente!"
}

function Run-WingetCommand {
    param ([string]$arguments)
    $process = Start-Process -FilePath "winget" -ArgumentList $arguments -NoNewWindow -RedirectStandardOutput "$env:TEMP\winget-output.txt" -RedirectStandardError "$env:TEMP\winget-error.txt" -PassThru
    $process.WaitForExit()
    
    if (Test-Path "$env:TEMP\winget-output.txt") {
        Get-Content "$env:TEMP\winget-output.txt" | ForEach-Object { Update-Output $_ }
        Remove-Item "$env:TEMP\winget-output.txt"
    }

    if (Test-Path "$env:TEMP\winget-error.txt") {
        Get-Content "$env:TEMP\winget-error.txt" | ForEach-Object { Update-Output "ERROR: $_" }
        Remove-Item "$env:TEMP\winget-error.txt"
    }
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

    $Usuario = $Env:USERNAME

    $directories = @(
        'C:\Windows\Prefetch',
        'C:\Windows\SoftwareDistribution',
        [System.IO.Path]::GetTempPath(),
        'C:\Windows\Temp',
        'C:\Windows\System32\spool\PRINTERS',
        "C:\Users\" + $Usuario + "\AppData\LocalLow\NVIDIA\PerDriverVersion\DXCache",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache2\entries\*",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Media Cache",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies-Journal",
        "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache\*",
        "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache\*.*",
        "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cache2\entries\*.*",
        "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\thumbnails\*",
        "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\cookies.sqlite",
        "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\webappsstore.sqlite",
        "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\chromeappsstore.sqlite",
        "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default*\chromeappsstore.sqlite",
        "C:\Users\" + $Usuario + "AppData\Roaming\discord\Code Cache",
        "C:\Users\" + $Usuario + "AppData\Roaming\discord\Cache",
        "C:\Users\" + $Usuario + "AppData\Roaming\discord\GPUCache",
        "$env:LOCALAPPDATA\Spotify\Storage",
        "$env:LOCALAPPDATA\Packages\Microsoft.MicrosoftEdge*\AC\MicrosoftEdge\Cache\*",
        "$env:LOCALAPPDATA\Microsoft\Outlook\RoamCache",
        "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache",
        "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache_4147",
        "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache_4430",
        "C:\Users\$Usuario\AppData\Roaming\Adobe\Common\Media Cache Files",
        "C:\Users\$Usuario\AppData\Roaming\Adobe\Adobe Photoshop*\Logs",
        "C:\Users\" + $Usuario +"\AppData\Roaming\Opera Software\Opera Stable",
        "$env:LOCALAPPDATA\Opera Software\Opera Stable\Default\Cache\Cache_Data",
        "$env:LOCALAPPDATA\\Microsoft\Windows\INetCache",
        "C:\Windows\Temp",
        "C:\Windows\SoftwareDistribution\Download",
        "$env:LOCALAPPDATA\CrashDumps"
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
        Start-Sleep -Seconds 10
        Update-Output "Caché de Microsoft Store limpiada!"
    } catch {
        Update-Output "No se pudo limpiar caché de Microsoft Store..."
    }

    $namespaceName = "root\CIMv2\MDM"
    $className = "M_DeviceManagement"
    $query = "SELECT * FROM $className"
    try {
        $searcher = Get-WmiObject -Namespace $namespaceName -Query $query
        if ($searcher) {
            $searcher | ForEach-Object { $_.Delete() }
            Update-Output "Datos MDM eliminados!"
        }
    } catch {
        Update-Output "No se pudo eliminar datos MDM..."
    }

    if (Get-Command "winget" -ErrorAction SilentlyContinue) {
        Run-WingetCommand "upgrade --all"
        Update-Output "Actualización de aplicaciones completada!"
    } else {
        $DecisionInstallWinget = [System.Windows.Forms.MessageBox]::Show("Winget no encontrado. ¿Deseas instalarlo?", "Confirmación", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($DecisionInstallWinget -eq [System.Windows.Forms.DialogResult]::Yes) {
            Install-Winget
            Run-WingetCommand "upgrade --all"
            Update-Output "Actualización de aplicaciones completada!"
        } else {
            Update-Output "No se actualizó ninguna aplicación..."
        }
    }

    $btnExit.Enabled = $true
    $btnExit.BackColor = [System.Drawing.Color]::Red
    Update-Output "Proceso completado!"
}

$btnStart.Add_Click({ CleanUp })
$btnExit.Add_Click({ $form.Close() })

$form.ResumeLayout()
$panel.ResumeLayout()
$form.ShowDialog() | Out-Null
