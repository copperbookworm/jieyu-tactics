# as-doctor.ps1 — readiness report for autonomous Android work.
#   .\as-doctor.ps1                 # human-readable
#   .\as-doctor.ps1 -Json           # machine-readable
#   .\as-doctor.ps1 -Project <dir>  # also validate one project

[CmdletBinding()]
param(
    [string]$Project,
    [switch]$Json
)

$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot 'as-lib.ps1') -AsProjectRoot $Project -AsQuiet

$checks = @()
function Add-Check {
    param([string]$Name, [bool]$Ok, [string]$Detail, [string]$Severity = 'required')
    $script:checks += [pscustomobject]@{ Name = $Name; Ok = $Ok; Detail = $Detail; Severity = $Severity }
}

# --- Toolchain -------------------------------------------------------------
Add-Check 'Android Studio' ([bool]$AsEnv.StudioHome) $AsEnv.StudioHome
Add-Check 'IDE JDK (jbr)'  ([bool]$AsEnv.IdeJdk)     ("{0} (major {1})" -f $AsEnv.IdeJdk, $AsEnv.IdeJdkMajor)
Add-Check 'Android SDK'    ([bool]$AsEnv.SdkRoot)    $AsEnv.SdkRoot
Add-Check 'platform-tools/adb' ([bool]$AsEnv.Adb)    $AsEnv.Adb
Add-Check 'build-tools'    ([bool]$AsEnv.BuildToolsDir) ("{0} -> {1}" -f $AsEnv.BuildTools, $AsEnv.BuildToolsDir)
Add-Check 'aapt2'          ([bool]$AsEnv.Aapt2)      $AsEnv.Aapt2
Add-Check 'gradle JDK (17-23)' ([bool]$AsEnv.GradleJdk) ("{0} (major {1})" -f $AsEnv.GradleJdk, $AsEnv.GradleJdkMajor) 'required'
Add-Check 'gradle launcher' ([bool]$AsEnv.GradleExe) ("{0} [{1} {2}]" -f $AsEnv.GradleExe, $AsEnv.GradleSource, $AsEnv.GradleVersion)
Add-Check 'platforms installed' ($AsEnv.Platforms.Count -gt 0) ($AsEnv.Platforms -join ', ')
Add-Check 'emulator binary' ([bool]$AsEnv.Emulator) $AsEnv.Emulator 'optional'
Add-Check 'cmdline-tools (sdkmanager/avdmanager)' ([bool]$AsEnv.CmdlineTools) $AsEnv.CmdlineTools 'optional'

# JdksByMajor arrives as a JSON object (PSCustomObject) because as-lib.ps1 imports
# the environment via as-env.ps1 -AsJson; only its numeric property names are majors.
$jdkProps = @($AsEnv.JdksByMajor.PSObject.Properties | Where-Object { $_.Name -match '^\d+$' } | Sort-Object { [int]$_.Name })
$jdkList = (($jdkProps | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join '; ')
Add-Check 'JDKs discovered' ($jdkProps.Count -gt 0) $jdkList 'optional'

# --- Devices ---------------------------------------------------------------
$devices = @()
try { $devices = @(Get-AdbDevice) } catch { $devices = @() }
$usable = @($devices | Where-Object { $_.State -eq 'device' })
$unauth = @($devices | Where-Object { $_.State -eq 'unauthorized' })
$devDetail = if ($devices.Count) { ($devices | ForEach-Object { "$($_.Serial)[$($_.State)]$($_.Model)" }) -join ', ' } else { 'none attached' }
Add-Check 'adb reachable' ([bool]$AsEnv.Adb) $(if ($AsEnv.Adb) { 'adb present' } else { 'no adb' })
Add-Check 'usable device/emulator' ($usable.Count -gt 0) $devDetail ($(if ($unauth.Count) { 'blocked' } else { 'optional' }))
if ($unauth.Count) {
    Add-Check 'device authorisation' $false ("$($unauth.Count) device(s) UNAUTHORIZED - unlock the phone and tap 'Allow USB debugging'" ) 'action-needed'
}

# --- Project ---------------------------------------------------------------
if ($Project) {
    $exists = Test-Path -LiteralPath $Project
    Add-Check 'project path' $exists $Project
    if ($exists) {
        $hasSettings = (Test-Path (Join-Path $Project 'settings.gradle')) -or (Test-Path (Join-Path $Project 'settings.gradle.kts'))
        Add-Check 'gradle settings' $hasSettings 'settings.gradle[.kts]'
        $hasApp = Test-Path (Join-Path $Project 'app')
        Add-Check 'app module' $hasApp 'app/'
        $pkg = Get-AsPackageId -Project $Project
        Add-Check 'applicationId/namespace' ([bool]$pkg) $pkg
        $apk = Get-AsProjectApk -Project $Project
        Add-Check 'built APK' ([bool]$apk) $apk 'optional'
    }
}

$ready = -not ($checks | Where-Object { $_.Severity -eq 'required' -and -not $_.Ok })
$blockers = @($checks | Where-Object { $_.Severity -eq 'required' -and -not $_.Ok })
$actions  = @($checks | Where-Object { $_.Severity -eq 'action-needed' })

$report = [pscustomobject]@{
    Ready    = $ready
    Checks   = $checks
    Blockers = @($blockers | ForEach-Object { $_.Name })
    Actions  = @($actions | ForEach-Object { $_.Detail })
    Env      = $AsEnv
}

if ($Json) {
    $report | ConvertTo-Json -Depth 6
    return
}

Write-AsHeader 'Android toolchain doctor'
foreach ($c in $checks) {
    $mark = if ($c.Ok) { '[ ok ]' } else { if ($c.Severity -eq 'required') { '[FAIL]' } else { '[warn]' } }
    $color = if ($c.Ok) { 'Green' } elseif ($c.Severity -eq 'required') { 'Red' } else { 'Yellow' }
    Write-Host ("{0} {1,-42} {2}" -f $mark, $c.Name, $c.Detail) -ForegroundColor $color
}
Write-Host ''
if ($ready) { Write-Host 'READY: autonomous build/install is possible.' -ForegroundColor Green }
else {
    Write-Host 'NOT READY. Blockers:' -ForegroundColor Red
    $blockers | ForEach-Object { Write-Host ("  - {0}: {1}" -f $_.Name, $_.Detail) }
}
if ($actions.Count) {
    Write-Host 'Needs a human action:' -ForegroundColor Yellow
    $actions | ForEach-Object { Write-Host ("  * {0}" -f $_.Detail) }
}
