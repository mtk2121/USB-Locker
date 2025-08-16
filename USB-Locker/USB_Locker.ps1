# USB Locker - Main Script
Add-Type -AssemblyName System.Windows.Forms

# ===== CONFIGURABLE SETTINGS =====
$password = "12345"        # Default password
$lockTimeout = 60         # Activation time in seconds

# ===== FUNCTIONS =====
function Disable-USB {
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 4
        Write-Host "USB ports disabled." -ForegroundColor Red
        return $true
    }
    catch {
        Write-Host "Failed to disable USB: $_" -ForegroundColor Red
        return $false
    }
}

function Enable-USB {
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 3
        Write-Host "USB ports enabled temporarily." -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Failed to enable USB: $_" -ForegroundColor Red
        return $false
    }
}

function Show-PasswordDialog {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "USB Access Control"
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

    # Password Label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Enter USB Access Password:"
    $label.Location = New-Object System.Drawing.Point(20,20)
    $form.Controls.Add($label)

    # Password TextBox
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(20,50)
    $textBox.Size = New-Object System.Drawing.Size(240,20)
    $textBox.UseSystemPasswordChar = $true
    $form.Controls.Add($textBox)

    # OK Button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(20,80)
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    # Show dialog and return result
    $result = $form.ShowDialog()
    return ($textBox.Text -eq $password)
}

function Start-USBLocker {
    Write-Host "USB Locker started. Monitoring USB devices..." -ForegroundColor Cyan
    
    while ($true) {
        try {
            $usbDevices = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
            
            if ($usbDevices) {
                Write-Host "USB device detected: $($usbDevices.DeviceID)" -ForegroundColor Yellow
                
                if (Show-PasswordDialog) {
                    Write-Host "Password accepted. Enabling USB ports..." -ForegroundColor Green
                    Enable-USB
                    Write-Host "USB will auto-disable after $lockTimeout seconds." -ForegroundColor Yellow
                    Start-Sleep -Seconds $lockTimeout
                    Disable-USB
                }
                else {
                    Write-Host "Access denied! Invalid password." -ForegroundColor Red
                    Disable-USB
                }
            }
        }
        catch {
            Write-Host "Error monitoring USB: $_" -ForegroundColor Red
        }
        Start-Sleep -Seconds 5
    }
}

# ===== EXECUTION =====
Disable-USB
Start-USBLocker