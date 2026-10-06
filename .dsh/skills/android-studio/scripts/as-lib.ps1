# as-lib.ps1 — shared helpers for the android-studio toolkit.
# Dot-source this from the other scripts:
#     . "$PSScriptRoot\as-lib.ps1" -AsProjectRoot $Project
# It resolves $AsEnv (via as-env.ps1) and adds adb helpers on top.

[CmdletBinding()]
param(
    [string]$AsProjectRoot,
    [switch]$AsQuiet
)

$ErrorActionPreference = 'Continue'

# Resolve the environment in a CHILD scope and import only the resulting object.
# Dot-sourcing as-env.ps1 here would bind its parameters (and leak its locals) into
# every caller's scope, silently resetting caller parameters such as $Json or $Quiet.
$asEnvJson = & (Join-Path $PSScriptRoot 'as-env.ps1') -AsProjectRoot $AsProjectRoot -AsJson -AsQuiet
try { $AsEnv = $asEnvJson | ConvertFrom-Json } catch { throw "as-env.ps1 did not return usable JSON: $($_.Exception.Message)" }
if (-not $AsEnv) { throw 'as-env.ps1 returned no environment object.' }

function Invoke-Native {
    <#
      Run an external program and capture combined stdout+stderr.
      Native tools (adb, gradle) routinely write progress to stderr; under
      $ErrorActionPreference='Stop' that would become a terminating error, so this
      helper forces 'Continue' for the duration of the call and restores it after.
    #>
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [string[]]$Arguments = @(),
        [string]$WorkingDirectory,
        [switch]$PassThru
    )
    if (-not $FilePath) { throw 'Invoke-Native: FilePath is empty.' }
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $code = 0
    try {
        if ($WorkingDirectory) {
            Push-Location -LiteralPath $WorkingDirectory
            try { $out = & $FilePath @Arguments 2>&1 | Out-String } finally { Pop-Location }
        } else {
            $out = & $FilePath @Arguments 2>&1 | Out-String
        }
        $code = $LASTEXITCODE
        if ($null -eq $code) { $code = 0 }
    } finally {
        $ErrorActionPreference = $prev
    }
    if ($PassThru) { return $out }
    return [pscustomobject]@{ Output = $out; ExitCode = $code }
}

function Invoke-Adb {
    <#
      Run adb with the given argument array. Returns combined output as a string array.
      Using an argument ARRAY (not a string) keeps quoting correct for values with spaces.
    #>
    param(
        [Parameter(Mandatory)][string[]]$Arguments,
        [string]$Serial
    )
    if (-not $AsEnv.Adb) { throw 'adb not found. Set ANDROID_HOME or install platform-tools.' }
    $full = @()
    if ($Serial) { $full += @('-s', $Serial) }
    $full += $Arguments
    return (Invoke-Native -FilePath $AsEnv.Adb -Arguments $full).Output
}

function Get-AdbDevice {
    <# List attached devices as objects: Serial, State, Model, Product, Device. #>
    $raw = Invoke-Adb -Arguments @('devices', '-l')
    $devices = @()
    foreach ($line in ($raw -split "`r?`n")) {
        if ($line -notmatch '^\s*(\S+)\s+(device|unauthorized|offline|bootloader|recovery|sideload)\b') { continue }
        $serial = $Matches[1]
        $state = $Matches[2]
        $model = $null; $product = $null; $dev = $null
        if ($line -match 'model:(\S+)') { $model = $Matches[1] }
        if ($line -match 'product:(\S+)') { $product = $Matches[1] }
        if ($line -match 'device:(\S+)') { $dev = $Matches[1] }
        $devices += [pscustomobject]@{ Serial = $serial; State = $state; Model = $model; Product = $product; Device = $dev }
    }
    return $devices
}

function Get-UsableDevice {
    <# Return the first device in state 'device', or $null. -Serial forces one. #>
    param([string]$Serial)
    $all = @(Get-AdbDevice)
    if ($Serial) {
        $hit = $all | Where-Object { $_.Serial -eq $Serial } | Select-Object -First 1
        if (-not $hit) { throw "Device '$Serial' is not attached." }
        if ($hit.State -ne 'device') { throw "Device '$Serial' is in state '$($hit.State)' (needs on-device USB-debugging authorisation)." }
        return $hit
    }
    $ok = $all | Where-Object { $_.State -eq 'device' } | Select-Object -First 1
    if (-not $ok) {
        $detail = if ($all.Count) { ($all | ForEach-Object { "$($_.Serial)=$($_.State)" }) -join ', ' } else { 'none attached' }
        throw "No usable device. Detected: $detail. If a phone shows 'unauthorized', unlock it and tap 'Allow USB debugging'."
    }
    return $ok
}

function Start-AdbServer {
    Invoke-Adb -Arguments @('start-server') | Out-Null
}

function Save-AdbScreenshot {
    <#
      Pull a PNG screenshot. Uses screencap-to-file + pull instead of `exec-out >`
      because PowerShell 5.1 redirection would corrupt binary output.
    #>
    param(
        [Parameter(Mandatory)][string]$Path,
        [string]$Serial
    )
    $dev = Get-UsableDevice -Serial $Serial
    $remote = '/sdcard/dsh_screencap.png'
    Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'screencap', '-p', $remote) | Out-Null
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $out = (Invoke-Native -FilePath $AsEnv.Adb -Arguments @('-s', $dev.Serial, 'pull', $remote, $Path)).Output
    Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'rm', '-f', $remote) | Out-Null
    if (-not (Test-Path -LiteralPath $Path)) { throw "Screenshot failed: $out" }
    return (Resolve-Path -LiteralPath $Path).Path
}

function Get-AsProjectApk {
    <# Locate the newest built APK for a project. #>
    param([Parameter(Mandatory)][string]$Project, [string]$Variant = 'debug')
    $root = Join-Path $Project "app\build\outputs\apk\$Variant"
    if (-not (Test-Path -LiteralPath $root)) { return $null }
    $apk = Get-ChildItem -LiteralPath $root -Filter '*.apk' -Recurse -ErrorAction SilentlyContinue |
           Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($apk) { return $apk.FullName }
    return $null
}

function Get-AsPackageId {
    <# Read applicationId from app/build.gradle(.kts) without running Gradle. #>
    param([Parameter(Mandatory)][string]$Project)
    foreach ($f in @('app\build.gradle', 'app\build.gradle.kts')) {
        $p = Join-Path $Project $f
        if (-not (Test-Path -LiteralPath $p)) { continue }
        $m = Select-String -Path $p -Pattern 'applicationId\s*=?\s*["'']([^"'']+)["'']' -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($m) { return $m.Matches[0].Groups[1].Value }
    }
    foreach ($f in @('app\build.gradle', 'app\build.gradle.kts')) {
        $p = Join-Path $Project $f
        if (-not (Test-Path -LiteralPath $p)) { continue }
        $m = Select-String -Path $p -Pattern 'namespace\s*=?\s*["'']([^"'']+)["'']' -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($m) { return $m.Matches[0].Groups[1].Value }
    }
    return $null
}

function Write-TextNoBom {
    <#
      Write UTF-8 WITHOUT a byte-order mark.
      PowerShell 5.1's `Set-Content -Encoding UTF8` emits a BOM, and both Gradle's
      Groovy parser and Java's .properties reader choke on it ("Unexpected character: '?'").
    #>
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Content
    )
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $full = [System.IO.Path]::GetFullPath($Path)
    try {
        $enc = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($full, $Content, $enc)
    } catch {
        Set-Content -LiteralPath $full -Value $Content -Encoding ASCII
    }
    return $full
}

function Write-AsHeader {
    param([string]$Text)
    Write-Host ''
    Write-Host ("=== $Text ===") -ForegroundColor Cyan
}
