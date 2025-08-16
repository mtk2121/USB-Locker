# Enable USB Ports Script
Write-Host "Enabling USB ports..." -ForegroundColor Yellow

# Enable USBSTOR service
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 3

# Enable related USB services
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\usbhub" -Name "Start" -Value 3
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\usbuhci" -Name "Start" -Value 3
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\usbehci" -Name "Start" -Value 3

Write-Host "USB ports enabled successfully!" -ForegroundColor Green
Write-Host "Please restart your system to apply changes." -ForegroundColor Yellow