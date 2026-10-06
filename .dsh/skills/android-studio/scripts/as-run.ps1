# as-run.ps1 — install an APK on the device, launch it, and report what happened.
# This is the "close the loop" step: it tells you the PID, whether the app crashed,
# and (optionally) captures a screenshot and logcat.
#
#   .\as-run.ps1 -Project <dir>                      # install newest debug APK + launch
#   .\as-run.ps1 -Project <dir> -Build               # build first, then install+launch
#   .\as-run.ps1 -Project <dir> -Apk path\to.apk -Screenshot shot.png -LogcatSec 5
#   .\as-run.ps1 -Project <dir> -Activity .OtherActivity
#   .\as-run.ps1 -Project <dir> -Serial 5JB0224412000317

[CmdletBinding()]
param(
    [string]$Project,
    [string]$Apk,
    [string]$Package,
    [string]$Activity,
    [string]$Serial,
    [string]$Screenshot,
    [int]$WaitSec = 4,
    [int]$LogcatSec = 0,
    [switch]$Build,
    [switch]$NoLaunch,
    [switch]$ClearData,
    [switch]$Quiet
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'as-lib.ps1') -AsProjectRoot $Project -AsQuiet

if ($Build -and $Project) {
    & (Join-Path $PSScriptRoot 'as-build.ps1') -Project $Project -Task 'assembleDebug' | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'Build failed; not installing.' }
}

if (-not $Apk) {
    if (-not $Project) { throw 'Provide -Project or -Apk.' }
    $Apk = Get-AsProjectApk -Project $Project
    if (-not $Apk) { throw "No APK found under $Project\app\build\outputs\apk\debug. Run as-build.ps1 first." }
}
if (-not (Test-Path -LiteralPath $Apk)) { throw "APK not found: $Apk" }

if (-not $Package -and $Project) { $Package = Get-AsPackageId -Project $Project }
if (-not $Package) { throw 'Cannot determine package id; pass -Package.' }

$dev = Get-UsableDevice -Serial $Serial
Write-Host ("Device: {0} {1} [{2}]" -f $dev.Serial, $dev.Model, $dev.State) -ForegroundColor Cyan

# --- install ---------------------------------------------------------------
if ($ClearData) {
    Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'pm', 'clear', $Package) | Out-Null
}
$installOut = Invoke-Adb -Serial $dev.Serial -Arguments @('install', '-r', '-t', $Apk)
if ($installOut -notmatch 'Success') {
    throw ("Install failed:`n" + $installOut)
}
Write-Host 'Installed.' -ForegroundColor Green

if ($NoLaunch) { return }

# --- launch ----------------------------------------------------------------
Invoke-Adb -Serial $dev.Serial -Arguments @('logcat', '-c') | Out-Null

$launched = $null
if ($Activity) {
    $component = if ($Activity -like '*/*') { $Activity } else { "$Package/$Activity" }
    $out = Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'am', 'start', '-n', $component)
    if ($out -match 'Error|Exception') { throw "am start failed: $out" }
    $launched = $component
} else {
    # monkey resolves the launcher activity for us when none was given.
    $out = Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'monkey', '-p', $Package, '-c', 'android.intent.category.LAUNCHER', '1')
    if ($out -match 'No activities found') { throw "No launcher activity found for $Package." }
    $m = [regex]::Match($out, 'cmp=([^\s}]+)')
    if ($m.Success) { $launched = $m.Groups[1].Value }
    if (-not $launched) {
        # monkey omits the component on some OEM builds; ask the package manager.
        $r = Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'cmd', 'package', 'resolve-activity', '--brief', $Package)
        $line = ($r -split "`r?`n") | Where-Object { $_ -match '/' } | Select-Object -Last 1
        if ($line) { $launched = $line.Trim() }
    }
}
Write-Host ("Launched: {0}" -f $(if ($launched) { $launched } else { '(via monkey)' })) -ForegroundColor Green

# --- observe ---------------------------------------------------------------
Start-Sleep -Seconds $WaitSec

$pid_ = (Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'pidof', $Package)).Trim()
$alive = [bool]($pid_ -and $pid_ -match '^\d+')

$logText = ''
if ($LogcatSec -gt 0) {
    Invoke-Adb -Serial $dev.Serial -Arguments @('logcat', '-c') | Out-Null
    Start-Sleep -Seconds $LogcatSec
}
$dump = Invoke-Adb -Serial $dev.Serial -Arguments @('logcat', '-d', '-v', 'brief', '-t', '400')
$crashLines = @()
if ($alive) {
    $dump = Invoke-Adb -Serial $dev.Serial -Arguments @('logcat', '-d', '-v', 'brief', '--pid', $pid_)
}
$crashLines = @(($dump -split "`r?`n") | Where-Object { $_ -match 'FATAL EXCEPTION|AndroidRuntime: |E ActivityManager:.*(crash|ANR)|Process: ' })

$result = [pscustomobject]@{
    Serial    = $dev.Serial
    Package   = $Package
    Apk       = $Apk
    Launched  = $launched
    Pid       = if ($alive) { [int]$pid_ } else { $null }
    Running   = $alive
    Crashed   = ($crashLines.Count -gt 0)
    Screenshot= $null
    Logcat    = $dump.Trim()
}

if (-not $Quiet) {
    Write-Host ''
    Write-Host ("Running : {0}" -f $alive) -ForegroundColor $(if ($alive) { 'Green' } else { 'Red' })
    if ($alive) { Write-Host ("PID     : {0}" -f $pid_) }
    if ($crashLines.Count) {
        Write-Host 'CRASH DETECTED:' -ForegroundColor Red
        $crashLines | Select-Object -First 20 | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    }
}

if ($Screenshot) {
    $path = Save-AdbScreenshot -Path $Screenshot -Serial $dev.Serial
    $result.Screenshot = $path
    Write-Host ("Screenshot: {0}" -f $path) -ForegroundColor Green
}

if (-not $Quiet -and $dump.Trim() -and -not $crashLines.Count) {
    Write-Host '--- logcat (tail) ---' -ForegroundColor DarkGray
    ($dump -split "`r?`n") | Select-Object -Last 15 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
}

Write-Output $result
