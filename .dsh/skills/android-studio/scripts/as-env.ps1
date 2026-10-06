# as-env.ps1 — resolve the Android Studio / Android SDK / Gradle JDK environment.
#
# Dot-source it to populate the current scope:
#     . .\as-env.ps1 -AsProjectRoot C:\path\to\proj
#     $AsEnv.GradleExe
# Or ask for JSON (as-lib.ps1 does exactly this, in a child scope):
#     .\as-env.ps1 -AsJson
#
# Why this file exists: Android Studio ships a JDK 25 ("jbr") that the IDE needs,
# but AGP 8.x + Gradle 8.x cannot run on it. Gradle therefore needs a separate
# JDK 17-23, while the IDE keeps its own. This script keeps those two apart.
#
# Parameter names carry the `As` prefix on purpose. When this file is dot-sourced,
# its parameters are bound into the CALLER's scope, so a plain `-Json` or `-Quiet`
# would silently overwrite the caller's own `$Json`/`$Quiet` parameters. The friendly
# aliases below are for direct invocations (`& as-env.ps1 -Json`); as-lib.ps1 always
# calls this script in a child scope with the prefixed names.

[CmdletBinding()]
param(
    [Alias('ProjectRoot')][string]$AsProjectRoot,
    [Alias('Json')][switch]$AsJson,
    [Alias('Quiet')][switch]$AsQuiet
)

$ErrorActionPreference = 'Continue'

function Get-JavaMajor {
    param([string]$JavaHome)
    $release = Join-Path $JavaHome 'release'
    if (-not (Test-Path $release)) { return $null }
    $line = Select-String -Path $release -Pattern '^JAVA_VERSION="([^"]+)"' -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $line) { return $null }
    $v = $line.Matches[0].Groups[1].Value
    if ($v -match '^1\.(\d+)') { return [int]$Matches[1] }
    if ($v -match '^(\d+)') { return [int]$Matches[1] }
    return $null
}

function Get-FirstExistingPath {
    param([string[]]$Candidates)
    foreach ($c in $Candidates) {
        if ($c -and (Test-Path -LiteralPath $c)) { return $c }
    }
    return $null
}

# --------------------------------------------------------------------------
# Android Studio installation
# --------------------------------------------------------------------------
$studioCandidates = @(
    'F:\AndroidStudio',
    "$env:ProgramFiles\Android\Android Studio",
    "${env:ProgramFiles(x86)}\Android\Android Studio",
    "$env:LOCALAPPDATA\Programs\Android Studio"
)
# Also honour a STUDIO_HOME style override if the user set one.
if ($env:ANDROID_STUDIO_HOME) { $studioCandidates = @($env:ANDROID_STUDIO_HOME) + $studioCandidates }

$studioHome = $null
foreach ($c in $studioCandidates) {
    if ($c -and (Test-Path -LiteralPath (Join-Path $c 'bin\studio64.exe'))) { $studioHome = (Resolve-Path -LiteralPath $c).Path; break }
}

$studioExe = if ($studioHome) { Join-Path $studioHome 'bin\studio64.exe' } else { $null }
$ideJdk    = if ($studioHome) { Join-Path $studioHome 'jbr' } else { $null }

# --------------------------------------------------------------------------
# Android SDK root
# --------------------------------------------------------------------------
$sdkCandidates = @()
if ($AsProjectRoot) {
    $lp = Join-Path $AsProjectRoot 'local.properties'
    if (Test-Path -LiteralPath $lp) {
        $sdkLine = Select-String -Path $lp -Pattern '^sdk\.dir=(.+)$' -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($sdkLine) {
            $raw = $sdkLine.Matches[0].Groups[1].Value.Trim()
            # local.properties escapes the drive colon and backslashes for Java properties
            $raw = $raw -replace '\\:', ':' -replace '\\\\', '\' -replace '\\$', ''
            $sdkCandidates += $raw
        }
    }
}
$sdkCandidates += @($env:ANDROID_HOME, $env:ANDROID_SDK_ROOT, "$env:LOCALAPPDATA\Android\Sdk", "$env:USERPROFILE\AppData\Local\Android\Sdk", 'F:\Android\Sdk')
$sdkRoot = $null
foreach ($c in $sdkCandidates) {
    if ($c -and (Test-Path -LiteralPath (Join-Path $c 'platform-tools'))) { $sdkRoot = (Resolve-Path -LiteralPath $c).Path; break }
}
if (-not $sdkRoot) {
    foreach ($c in $sdkCandidates) {
        if ($c -and (Test-Path -LiteralPath $c)) { $sdkRoot = (Resolve-Path -LiteralPath $c).Path; break }
    }
}

$platformTools = if ($sdkRoot) { Join-Path $sdkRoot 'platform-tools' } else { $null }
$adb           = if ($platformTools) { Join-Path $platformTools 'adb.exe' } else { $null }
if ($adb -and -not (Test-Path -LiteralPath $adb)) { $adb = $null }
$emulator      = if ($sdkRoot) { Join-Path $sdkRoot 'emulator\emulator.exe' } else { $null }
if ($emulator -and -not (Test-Path -LiteralPath $emulator)) { $emulator = $null }

# build-tools: newest by version sort
$buildToolsDir = $null; $buildToolsVersion = $null
if ($sdkRoot) {
    $btRoot = Join-Path $sdkRoot 'build-tools'
    if (Test-Path -LiteralPath $btRoot) {
        $bt = Get-ChildItem -LiteralPath $btRoot -Directory -ErrorAction SilentlyContinue |
              Sort-Object { try { [version]($_.Name -replace '[^0-9.].*$','') } catch { [version]'0.0' } } -Descending |
              Select-Object -First 1
        if ($bt) { $buildToolsDir = $bt.FullName; $buildToolsVersion = $bt.Name }
    }
}
$platforms = @()
if ($sdkRoot) {
    $pRoot = Join-Path $sdkRoot 'platforms'
    if (Test-Path -LiteralPath $pRoot) {
        $platforms = @(Get-ChildItem -LiteralPath $pRoot -Directory -ErrorAction SilentlyContinue |
                       Where-Object { $_.Name -match '^android-(\d+)$' } |
                       Sort-Object { [int]($_.Name -replace '^android-','') } |
                       ForEach-Object { $_.Name })
    }
}
$cmdlineTools = $null
if ($sdkRoot) {
    $ctRoot = Join-Path $sdkRoot 'cmdline-tools'
    if (Test-Path -LiteralPath $ctRoot) {
        # Prefer the conventional "latest" slot; otherwise take the highest Pkg.Revision.
        $ctDirs = @(Get-ChildItem -LiteralPath $ctRoot -Directory -ErrorAction SilentlyContinue |
                    Where-Object { Test-Path (Join-Path $_.FullName 'bin\avdmanager.bat') })
        $picked = $ctDirs | Where-Object { $_.Name -eq 'latest' } | Select-Object -First 1
        if (-not $picked) {
            $picked = $ctDirs | Sort-Object {
                $rev = 0
                $sp = Join-Path $_.FullName 'source.properties'
                if (Test-Path -LiteralPath $sp) {
                    $m = Select-String -Path $sp -Pattern '^Pkg\.Revision=(.+)$' -ErrorAction SilentlyContinue | Select-Object -First 1
                    if ($m) { [void][double]::TryParse(($m.Matches[0].Groups[1].Value.Trim()), [ref]$rev) }
                }
                $rev
            } -Descending | Select-Object -First 1
        }
        if ($picked) { $cmdlineTools = $picked.FullName }
    }
}
$sdkManager = if ($cmdlineTools) { Join-Path $cmdlineTools 'bin\sdkmanager.bat' } else { $null }
$avdManager = if ($cmdlineTools) { Join-Path $cmdlineTools 'bin\avdmanager.bat' } else { $null }

function Get-BuildToolExe {
    param([string]$Dir, [string]$Name)
    if (-not $Dir) { return $null }
    $p = Join-Path $Dir $Name
    if (Test-Path -LiteralPath $p) { return $p }
    return $null
}
$aapt2     = Get-BuildToolExe $buildToolsDir 'aapt2.exe'
$apksigner = Get-BuildToolExe $buildToolsDir 'apksigner.bat'
$zipalign  = Get-BuildToolExe $buildToolsDir 'zipalign.exe'
$aapt      = Get-BuildToolExe $buildToolsDir 'aapt.exe'

# --------------------------------------------------------------------------
# JDK for Gradle: AGP 8.x needs 17+; Gradle 8.11 tops out at 23.
# Prefer 17 (the verified combination), then 21, then anything in 17..23.
# --------------------------------------------------------------------------
$jdkRoots = @(
    "$env:ProgramFiles\Java",
    "$env:ProgramFiles\Eclipse Adoptium",
    "$env:ProgramFiles\Microsoft",
    "$env:ProgramFiles\Amazon Corretto",
    "$env:ProgramFiles\Zulu",
    "$env:USERPROFILE\.jdks",
    "$env:LOCALAPPDATA\Programs\Eclipse Adoptium"
)
$jdkFound = @{}
foreach ($root in $jdkRoots) {
    if (-not (Test-Path -LiteralPath $root)) { continue }
    foreach ($d in (Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue)) {
        if (-not (Test-Path -LiteralPath (Join-Path $d.FullName 'bin\java.exe'))) { continue }
        $maj = Get-JavaMajor $d.FullName
        if ($maj -and -not $jdkFound.ContainsKey($maj)) { $jdkFound[$maj] = $d.FullName }
    }
}
$gradleJdk = $null
foreach ($want in @(17, 21, 23, 22, 20, 19, 18)) {
    if ($jdkFound.ContainsKey($want)) { $gradleJdk = $jdkFound[$want]; break }
}
$gradleJdkMajor = if ($gradleJdk) { Get-JavaMajor $gradleJdk } else { $null }
if (-not $gradleJdk -and $env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME 'bin\java.exe'))) {
    $m = Get-JavaMajor $env:JAVA_HOME
    if ($m -and $m -ge 17 -and $m -le 23) { $gradleJdk = $env:JAVA_HOME; $gradleJdkMajor = $m }
}

# --------------------------------------------------------------------------
# Gradle launcher: project wrapper first, else the cached distribution.
# --------------------------------------------------------------------------
$gradleExe = $null; $gradleSource = $null
if ($ProjectRoot) {
    $gw = Join-Path $ProjectRoot 'gradlew.bat'
    if (Test-Path -LiteralPath $gw) { $gradleExe = $gw; $gradleSource = 'wrapper' }
}
if (-not $gradleExe) {
    $distsRoot = "$env:USERPROFILE\.gradle\wrapper\dists"
    if (Test-Path -LiteralPath $distsRoot) {
        # Layout: dists/gradle-<ver>-<kind>/<hash>/gradle-<ver>/bin/gradle.bat
        $cand = Get-ChildItem -LiteralPath $distsRoot -Recurse -Depth 4 -Filter 'gradle.bat' -ErrorAction SilentlyContinue |
                Where-Object { $_.DirectoryName -like '*\bin' } |
                ForEach-Object {
                    $ver = $null
                    if ($_.FullName -match '\\gradle-([0-9][0-9.]*)\\bin\\gradle\.bat$') { try { $ver = [version]$Matches[1] } catch { $ver = $null } }
                    [pscustomobject]@{ Path = $_.FullName; Version = $ver }
                } | Where-Object { $_ -and $_.Version } | Sort-Object Version -Descending
        if ($cand) { $gradleExe = $cand[0].Path; $gradleVersion = $cand[0].Version.ToString(); $gradleSource = 'cached-dist' }
    }
}
if (-not $gradleVersion) { $gradleVersion = $null }
if (-not $gradleExe) {
    $onPath = Get-Command gradle -ErrorAction SilentlyContinue
    if ($onPath) { $gradleExe = $onPath.Source; $gradleSource = 'path' }
}

# --------------------------------------------------------------------------
# Package into one object
# --------------------------------------------------------------------------
$AsEnv = [pscustomobject]@{
    StudioHome       = $studioHome
    StudioExe        = $studioExe
    IdeJdk           = $ideJdk
    IdeJdkMajor      = if ($ideJdk) { Get-JavaMajor $ideJdk } else { $null }
    SdkRoot          = $sdkRoot
    PlatformTools    = $platformTools
    Adb              = $adb
    Emulator         = $emulator
    BuildToolsDir    = $buildToolsDir
    BuildTools       = $buildToolsVersion
    Platforms        = $platforms
    CmdlineTools     = $cmdlineTools
    SdkManager       = $sdkManager
    AvdManager       = $avdManager
    Aapt2            = $aapt2
    Aapt             = $aapt
    ApkSigner        = $apksigner
    Zipalign         = $zipalign
    GradleJdk        = $gradleJdk
    GradleJdkMajor   = $gradleJdkMajor
    JdksByMajor      = $jdkFound
    GradleExe        = $gradleExe
    GradleVersion    = $gradleVersion
    GradleSource     = $gradleSource
    ProjectRoot      = $AsProjectRoot
    Ready            = [bool]($sdkRoot -and $adb -and $gradleExe -and $gradleJdk)
}

# Export into the process so child processes (gradle, adb) inherit the right homes.
# This happens BEFORE the JSON early-return: as-lib.ps1 calls this script in a child
# scope and only consumes the JSON, so the env export must not depend on that path.
if ($AsEnv.GradleJdk)      { $env:JAVA_HOME = $AsEnv.GradleJdk }
if ($AsEnv.SdkRoot)        { $env:ANDROID_HOME = $AsEnv.SdkRoot; $env:ANDROID_SDK_ROOT = $AsEnv.SdkRoot }
if ($AsEnv.StudioHome)     { $env:ANDROID_STUDIO_HOME = $AsEnv.StudioHome }
if ($AsEnv.SdkRoot)        { $env:ANDROID_USER_HOME = "$env:USERPROFILE\.android" }
$pathAdd = @()
if ($AsEnv.PlatformTools) { $pathAdd += $AsEnv.PlatformTools }
if ($AsEnv.Emulator)      { $pathAdd += (Split-Path $AsEnv.Emulator -Parent) }
if ($AsEnv.BuildToolsDir) { $pathAdd += $AsEnv.BuildToolsDir }
if ($pathAdd.Count) {
    foreach ($p in $pathAdd) { if ($env:PATH -notlike "*$p*") { $env:PATH = "$p;$env:PATH" } }
}

if ($AsJson) {
    # ConvertTo-Json rejects a Hashtable whose keys are not strings, so project the
    # per-major JDK map with string keys before serializing.
    $jdkMap = [ordered]@{}
    foreach ($k in ($jdkFound.Keys | Sort-Object)) { $jdkMap["$k"] = $jdkFound[$k] }
    $AsEnv.JdksByMajor = $jdkMap
    $AsEnv | ConvertTo-Json -Depth 5
    return
}

if (-not $AsQuiet) {
    $studioShown = if ($AsEnv.StudioHome) { $AsEnv.StudioHome } else { '<not found>' }
    Write-Host ("Android Studio : {0}" -f $studioShown)
    Write-Host ("  IDE JDK      : {0} (major {1})" -f $AsEnv.IdeJdk, $AsEnv.IdeJdkMajor)
    Write-Host ("Android SDK    : {0}" -f $AsEnv.SdkRoot)
    Write-Host ("  build-tools  : {0}" -f $AsEnv.BuildTools)
    Write-Host ("  platforms    : {0}" -f ($AsEnv.Platforms -join ', '))
    Write-Host ("  adb          : {0}" -f $AsEnv.Adb)
    Write-Host ("Gradle JDK     : {0} (major {1})" -f $AsEnv.GradleJdk, $AsEnv.GradleJdkMajor)
    Write-Host ("Gradle         : {0} [{1}]" -f $AsEnv.GradleExe, $AsEnv.GradleSource)
    Write-Host ("Ready          : {0}" -f $AsEnv.Ready)
}
