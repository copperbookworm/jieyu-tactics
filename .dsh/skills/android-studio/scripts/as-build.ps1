# as-build.ps1 — run a Gradle build for an Android project with the right JDK.
#   .\as-build.ps1 -Project <dir>                        # assembleDebug
#   .\as-build.ps1 -Project <dir> -Task testDebugUnitTest
#   .\as-build.ps1 -Project <dir> -Task assembleRelease -Variant release
#   .\as-build.ps1 -Project <dir> -Offline -NoDaemon
#   .\as-build.ps1 -Project <dir> -Task installDebug
#
# Exit code mirrors Gradle. On success, prints the produced APK path.

[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Project,
    [string]$Task = 'assembleDebug',
    [string]$Variant = 'debug',
    [switch]$Offline,
    [switch]$NoDaemon,
    [switch]$Clean,
    [string[]]$ExtraArgs,
    [int]$TimeoutSec = 0
)

$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot 'as-lib.ps1') -AsProjectRoot $Project -AsQuiet

if (-not (Test-Path -LiteralPath $Project)) { throw "Project not found: $Project" }
$Project = (Resolve-Path -LiteralPath $Project).Path
if (-not $AsEnv.GradleExe) { throw 'No Gradle launcher found (no gradlew.bat and no cached distribution).' }
if (-not $AsEnv.GradleJdk) { throw "No Gradle-capable JDK (17-23) found. AGP 8.x cannot run on the IDE's JDK $($AsEnv.IdeJdkMajor)." }

$gradleArgs = @()
if ($Clean) { $gradleArgs += 'clean' }
$gradleArgs += $Task
$gradleArgs += '--console=plain'
if ($Offline) { $gradleArgs += '--offline' }
if ($NoDaemon) { $gradleArgs += '--no-daemon' }
if ($ExtraArgs) { $gradleArgs += $ExtraArgs }

Write-Host ("gradle {0}" -f ($gradleArgs -join ' ')) -ForegroundColor DarkGray
Write-Host ("  JAVA_HOME   = {0}" -f $env:JAVA_HOME) -ForegroundColor DarkGray
Write-Host ("  ANDROID_HOME= {0}" -f $env:ANDROID_HOME) -ForegroundColor DarkGray
Write-Host ("  cwd         = {0}" -f $Project) -ForegroundColor DarkGray
Write-Host ''

$sw = [System.Diagnostics.Stopwatch]::StartNew()
Push-Location $Project
try {
    if ($TimeoutSec -gt 0) {
        $job = Start-Job -ScriptBlock {
            param($gradle, $args_, $wd, $javaHome, $androidHome)
            Set-Location $wd
            $env:JAVA_HOME = $javaHome
            $env:ANDROID_HOME = $androidHome
            $env:ANDROID_SDK_ROOT = $androidHome
            & $gradle @args_ 2>&1 | Out-String
        } -ArgumentList $AsEnv.GradleExe, $gradleArgs, $Project, $env:JAVA_HOME, $env:ANDROID_HOME
        if (-not (Wait-Job $job -Timeout $TimeoutSec)) {
            Stop-Job $job; Remove-Job $job -Force
            Write-Host "TIMEOUT after ${TimeoutSec}s" -ForegroundColor Red
            exit 124
        }
        $output = Receive-Job $job; Remove-Job $job -Force
        Write-Host $output
        $code = if ($output -match 'BUILD SUCCESSFUL') { 0 } else { 1 }
    } else {
        $run = Invoke-Native -FilePath $AsEnv.GradleExe -Arguments $gradleArgs -WorkingDirectory $Project
        $output = $run.Output
        Write-Host $output
        $code = $run.ExitCode
    }
} finally {
    Pop-Location
}
$sw.Stop()

Write-Host ''
if ($code -eq 0) {
    Write-Host ("BUILD OK in {0:n1}s" -f $sw.Elapsed.TotalSeconds) -ForegroundColor Green
    $apk = Get-AsProjectApk -Project $Project -Variant $Variant
    if ($apk) {
        $len = (Get-Item -LiteralPath $apk).Length
        Write-Host ("APK: {0} ({1:n0} bytes)" -f $apk, $len) -ForegroundColor Green
        Write-Output $apk
    }
} else {
    Write-Host ("BUILD FAILED (exit {0}) in {1:n1}s" -f $code, $sw.Elapsed.TotalSeconds) -ForegroundColor Red
    # Surface the most useful failure lines so a caller need not re-read all output.
    $errs = ($output -split "`r?`n") | Where-Object { $_ -match '^\s*(e:|\*) What went wrong|error:|FAILURE:|Execution failed|Caused by:|> Task .* FAILED' } | Select-Object -First 25
    if ($errs) { Write-Host '--- highlights ---' -ForegroundColor Yellow; $errs | ForEach-Object { Write-Host $_ } }
}
exit $code
