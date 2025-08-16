# Disable USB Ports Script
Write-Host "Disabling USB ports..." -ForegroundColor Yellow

# Disable USBSTOR service
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 4

# Disable related USB services
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\usbhub" -Name "Start" -Value 4
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\usbuhci" -Name "Start" -Value 4
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\usbehci" -Name "Start" -Value 4

Write-Host "USB ports disabled successfully!" -ForegroundColor Red
Write-Host "Please restart your system to apply changes." -ForegroundColor Yellow