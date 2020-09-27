# Antes de correr el script ejecutar
# Set-ExecutionPolicy Bypass
# Solo en entornos controlados

# Desactivando UAC
Write-Host "[!!] Desactivando UAC" -ForegroundColor "yellow"
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d "0x00000000" /f
Write-Output ''

# Desactivando seguridad mejorada
Write-Host "[!!] Desactivando seguridad mejorada" -ForegroundColor "yellow"
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v FilterAdministratorToken /t REG_DWORD /d "0x00000001" /f
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\UIPI /ve /t REG_SZ /d "0x00000001" /f
Write-Output ''

# Activando acceso remoto
Write-Host "[!!] Activando acceso remoto y creando regla en el Firewall" -ForegroundColor "yellow"
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
netsh advfirewall firewall add rule name="Acceso Remoto" dir=in protocol=TCP localport=3389 action=allow
Write-Output ''

# Activando y configurando WINRM
Write-Host "[!!] Activando y configurando WINRM" -ForegroundColor "yellow"
winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
Set-Service -Name WinRM -StartupType Automatic
netsh advfirewall firewall add rule name="Acceso WinRM HTTP" dir=in protocol=TCP localport=5985 action=allow
netsh advfirewall firewall add rule name="Acceso WinRM HTTPS" dir=in protocol=TCP localport=5986 action=allow
Write-Output ''

# Desactivando System Restore
Write-Host "[!!] Desactivando System Restore en C:" -ForegroundColor "yellow"
Disable-ComputerRestore C:
Write-Output ''

# Desactivando Hibernacion
Write-Host "[!!] Desactivando Hibernacion" -ForegroundColor "yellow"
powercfg -h off
Write-Output ''

Write-Host "[!!] Limpiando Disco C:" -ForegroundColor "yellow"
cleanmgr.exe /autoclean /d C:
Write-Output ''

# Descargar el programa SDelete y descomprimirlo
Write-Host "[!!] Descargando y descomprimiendo SDELETE" -ForegroundColor "yellow"
mkdir C:\temp
Invoke-WebRequest -URI "https://download.sysinternals.com/files/SDelete.zip" -OutFile "C:\temp\SDelete.zip"
Expand-Archive C:\temp\SDelete.zip -DestinationPath C:\temp\
Write-Output ''

# Llenando el espacio libre del disco con Zeros
Write-Host "[!!] LLenando el espacio libre del disco con Zeros" -ForegroundColor "yellow"
C:\temp\sdelete64.exe /accepteula -z C:
Write-Output ''

Write-Host "[++] Todos los procesos terminaron exitosamente [++]" -ForegroundColor "green"
Write-Output ''

# Apagando el equipo
Write-Host "[!!] Apagando el equipo" -ForegroundColor "red"
shutdown.exe /s /t 0
Write-Output ''
