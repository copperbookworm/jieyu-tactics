# as-device.ps1 — device and emulator control.
#
#   .\as-device.ps1 status
#   .\as-device.ps1 wait -TimeoutSec 60
#   .\as-device.ps1 screenshot -Out shots\now.png
#   .\as-device.ps1 shell -Command "pm list packages | grep myapp"
#   .\as-device.ps1 install -Apk app-debug.apk
#   .\as-device.ps1 uninstall -Package com.example.app
#   .\as-device.ps1 tcpip -Port 5555          # switch USB device to wireless adb
#   .\as-device.ps1 connect -Address 192.168.1.5:5555
#   .\as-device.ps1 avd-list
#   .\as-device.ps1 avd-create -Avd pixel33 -Api 33 -Tag google_apis -Abi x86_64
#   .\as-device.ps1 emulator-start -Avd pixel33
#   .\as-device.ps1 emulator-stop

# Deliberately a SIMPLE (non-advanced) script: [CmdletBinding()] or any [Parameter()]
# attribute would add the common parameters, making this script's own -Out ambiguous
# with -OutVariable/-OutBuffer when called directly (`as-device.ps1 screenshot -Out x.png`).
param(
    [string]$Action = 'status',
    [string]$Serial,
    [string]$Out,
    [string]$Command,
    [string]$Apk,
    [string]$Package,
    [string]$Address,
    [int]$Port = 5555,
    [string]$Avd,
    [int]$Api = 33,
    [string]$Tag = 'google_apis',
    [string]$Abi = 'x86_64',
    [int]$TimeoutSec = 60
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'as-lib.ps1') -AsProjectRoot $null -AsQuiet

function Show-Devices {
    $devs = @(Get-AdbDevice)
    if (-not $devs.Count) { Write-Host 'No devices attached.' -ForegroundColor Yellow; return }
    foreach ($d in $devs) {
        $color = switch ($d.State) { 'device' { 'Green' } 'unauthorized' { 'Yellow' } default { 'Red' } }
        Write-Host ("{0,-22} {1,-14} {2,-16} {3}" -f $d.Serial, $d.State, $d.Model, $d.Device) -ForegroundColor $color
    }
    $unauth = @($devs | Where-Object { $_.State -eq 'unauthorized' })
    if ($unauth.Count) {
        Write-Host ''
        Write-Host 'A device is UNAUTHORIZED: unlock the phone, then tap "Allow USB debugging".' -ForegroundColor Yellow
        Write-Host 'If no dialog appears, enable Developer options and revoke/re-allow USB debugging authorisations.' -ForegroundColor Yellow
    }
}

switch ($Action.ToLower()) {
    'status' {
        Write-Host 'adb devices:' -ForegroundColor Cyan
        Show-Devices
    }
    'list' { Show-Devices }
    'wait' {
        Write-Host "Waiting up to ${TimeoutSec}s for a usable device..." -ForegroundColor Cyan
        $deadline = (Get-Date).AddSeconds($TimeoutSec)
        $found = $null
        while ((Get-Date) -lt $deadline) {
            $found = @(Get-AdbDevice) | Where-Object { $_.State -eq 'device' } | Select-Object -First 1
            if ($found) { break }
            Start-Sleep -Milliseconds 1500
        }
        if ($found) { Write-Host ("Ready: {0} {1}" -f $found.Serial, $found.Model) -ForegroundColor Green; Write-Output $found }
        else { Show-Devices; throw "No usable device within ${TimeoutSec}s." }
    }
    'screenshot' {
        if (-not $Out) { throw '-Out is required for screenshot.' }
        $p = Save-AdbScreenshot -Path $Out -Serial $Serial
        Write-Host "Saved: $p" -ForegroundColor Green
        Write-Output $p
    }
    'shell' {
        if (-not $Command) { throw '-Command is required for shell.' }
        Invoke-Adb -Serial $Serial -Arguments @('shell', $Command)
    }
    'install' {
        if (-not $Apk) { throw '-Apk is required for install.' }
        Invoke-Adb -Serial $Serial -Arguments @('install', '-r', '-t', $Apk)
    }
    'uninstall' {
        if (-not $Package) { throw '-Package is required for uninstall.' }
        Invoke-Adb -Serial $Serial -Arguments @('uninstall', $Package)
    }
    'tcpip' {
        $dev = Get-UsableDevice -Serial $Serial
        Invoke-Adb -Serial $dev.Serial -Arguments @('tcpip', "$Port")
        $ip = (Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'ip', 'route')).Trim()
        Write-Host "Switched $($dev.Serial) to tcpip:$Port. Find the phone IP with: adb shell ip route" -ForegroundColor Green
        Write-Host $ip
    }
    'connect' {
        if (-not $Address) { throw '-Address is required for connect (host:port).' }
        Invoke-Adb -Arguments @('connect', $Address)
        Show-Devices
    }
    'disconnect' {
        if ($Address) { Invoke-Adb -Arguments @('disconnect', $Address) } else { Invoke-Adb -Arguments @('disconnect') }
    }
    'avd-list' {
        $avdDir = "$env:USERPROFILE\.android\avd"
        if (-not (Test-Path -LiteralPath $avdDir)) { Write-Host 'No AVDs (no ~/.android/avd directory).' -ForegroundColor Yellow; return }
        $ini = Get-ChildItem -LiteralPath $avdDir -Filter '*.ini' -ErrorAction SilentlyContinue
        if (-not $ini) { Write-Host 'No AVDs defined.' -ForegroundColor Yellow; return }
        $ini | ForEach-Object { Write-Host ("  {0}" -f ($_.BaseName)) }
    }
    'avd-create' {
        if (-not $Avd) { throw '-Avd <name> is required.' }
        if (-not $AsEnv.SdkRoot) { throw 'Android SDK not found.' }
        # Prefer the official avdmanager (available once cmdline-tools is installed);
        # fall back to writing the two AVD INI files by hand when it is missing.
        $pkgId = "system-images;android-$Api;$Tag;$Abi"
        $created = $false
        if ($AsEnv.AvdManager) {
            if ($AsEnv.GradleJdk) { $env:JAVA_HOME = $AsEnv.GradleJdk }
            # avdmanager asks "create a custom hardware profile? [no]"; answer it via a pipe
            # so the call never blocks on stdin.
            $inner = 'echo no| "{0}" create avd -n "{1}" -k "{2}" --abi {3} --force --device pixel_5' -f $AsEnv.AvdManager, $Avd, $pkgId, $Abi
            Write-Host "avdmanager: $inner" -ForegroundColor DarkGray
            $res = Invoke-Native -FilePath $env:ComSpec -Arguments @('/c', $inner)
            Write-Host $res.Output
            if ((Test-Path -LiteralPath (Join-Path "$env:USERPROFILE\.android\avd" "$Avd.ini"))) { $created = $true }
        }
        if (-not $created) {
        Write-Host 'avdmanager unavailable or failed; writing AVD INI files directly.' -ForegroundColor Yellow
        $imgRel = "system-images\android-$Api\$Tag\$Abi"
        $imgDir = Join-Path $AsEnv.SdkRoot $imgRel
        if (-not (Test-Path -LiteralPath $imgDir)) {
            $avail = @(Get-ChildItem -LiteralPath (Join-Path $AsEnv.SdkRoot 'system-images') -Recurse -Depth 2 -Directory -ErrorAction SilentlyContinue |
                       Where-Object { Test-Path (Join-Path $_.FullName 'system.img') -or (Test-Path (Join-Path $_.FullName 'system.img.qcow2')) })
            throw "System image not installed: $imgDir`nInstalled images:`n$($avail.FullName -join "`n")"
        }
        $avdHome = "$env:USERPROFILE\.android\avd"
        $avdDirAbs = Join-Path $avdHome "$Avd.avd"
        New-Item -ItemType Directory -Path $avdDirAbs -Force | Out-Null
        $iniPath = Join-Path $avdHome "$Avd.ini"
        Set-Content -LiteralPath $iniPath -Encoding ASCII -Value @"
avd.ini.encoding=UTF-8
path=$avdDirAbs
path.rel=avd\$Avd.avd
target=android-$Api
"@
        $configPath = Join-Path $avdDirAbs 'config.ini'
        Set-Content -LiteralPath $configPath -Encoding ASCII -Value @"
AvdId=$Avd
avd.ini.displayname=$Avd
avd.ini.encoding=UTF-8
abi.type=$Abi
hw.cpu.arch=$Abi
hw.cpu.ncore=4
image.sysdir.1=$($imgRel -replace '\\','/')/
tag.id=$Tag
tag.display=$Tag
hw.device.manufacturer=Google
hw.device.name=pixel_5
hw.lcd.density=440
hw.lcd.width=1080
hw.lcd.height=2340
hw.ramSize=2048
vm.heapSize=256
disk.dataPartition.size=6G
hw.keyboard=yes
hw.gpu.enabled=yes
hw.gpu.mode=auto
"@
        }
        Write-Host "Created AVD '$Avd'." -ForegroundColor Green
        Write-Host "Start it with: .\as-device.ps1 emulator-start -Avd $Avd" -ForegroundColor DarkGray
    }
    'emulator-start' {
        if (-not $AsEnv.Emulator) { throw 'emulator.exe not found (SDK emulator package missing).' }
        if (-not $Avd) { throw '-Avd <name> is required.' }
        $emuArgs = @('-avd', $Avd, '-netdelay', 'none', '-netspeed', 'full', '-no-boot-anim')
        Start-Process -FilePath $AsEnv.Emulator -ArgumentList $emuArgs -WindowStyle Minimized
        $budget = [Math]::Max($TimeoutSec, 300)
        Write-Host "Emulator '$Avd' starting; waiting up to ${budget}s for boot..." -ForegroundColor Cyan
        $deadline = (Get-Date).AddSeconds($budget)
        $emu = $null
        while ((Get-Date) -lt $deadline) {
            $emu = @(Get-AdbDevice) | Where-Object { $_.Serial -like 'emulator-*' -and $_.State -eq 'device' } | Select-Object -First 1
            if ($emu) { break }
            Start-Sleep -Seconds 3
        }
        if (-not $emu) { throw "Emulator did not appear within ${budget}s; check the emulator window for errors." }
        Write-Host ("adb sees {0}; waiting for sys.boot_completed..." -f $emu.Serial) -ForegroundColor DarkGray
        $booted = $false
        while ((Get-Date) -lt $deadline) {
            $b = (Invoke-Adb -Serial $emu.Serial -Arguments @('shell', 'getprop', 'sys.boot_completed')).Trim()
            if ($b -eq '1') { $booted = $true; break }
            Start-Sleep -Seconds 3
        }
        if ($booted) { Write-Host ("Emulator ready: {0}" -f $emu.Serial) -ForegroundColor Green }
        else { Write-Host ("Emulator {0} is up but sys.boot_completed never became 1." -f $emu.Serial) -ForegroundColor Yellow }
        Write-Output $emu
    }
    'emulator-stop' {
        Invoke-Adb -Serial $Serial -Arguments @('emu', 'kill') | Out-Null
        Write-Host 'Emulator kill requested.' -ForegroundColor Green
    }
    'back'    { Invoke-Adb -Serial $Serial -Arguments @('shell', 'input', 'keyevent', 'KEYCODE_BACK') }
    'home'    { Invoke-Adb -Serial $Serial -Arguments @('shell', 'input', 'keyevent', 'KEYCODE_HOME') }
    default { throw "Unknown action '$Action'. See the header of as-device.ps1 for the list." }
}
