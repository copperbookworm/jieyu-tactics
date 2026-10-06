# deveco.ps1 - DevEco Studio unattended CLI entry (hvigor / ohpm / hdc / hap-sign-tool)
#
# DevEco Studio itself is an IntelliJ-platform IDE with no "drive the GUI" script API.
# The real automation surface is the CLI bundle it ships, which is the SAME
# hvigor/SDK chain the IDE uses when you press Run. This script only orchestrates;
# every action can be previewed with -DryRun.
#
# Usage:  & deveco.ps1 <action> [options]
#
#   env                                  print env vars + tool paths
#   doctor                               check tools exist + versions
#   new    -Path <dir> [-Bundle b]       scaffold a project from the DevEco template
#   build  -Project <dir> [-Mode debug|release] [-Product default] [-Module entry]
#   sign   -Hap <f.hap> | -Project <dir> [-Udid u] [-Bundle b] [-Out x.hap]
#   verify -Hap <signed.hap> [-OutDir d]
#   devices                              list connected HarmonyOS devices (with udid)
#   install -Hap <f.hap> [-Target t]
#   run    -Bundle b [-Ability a] [-Target t]
#   stop   -Bundle b [-Target t]
#   log    [-Bundle b] [-Seconds n] [-Filter regex] [-Target t]
#   shell  -Cmd "<remote command>" [-Target t]
#   screenshot -Out <png> [-Target t]
#
# NOTE (PS 5.1): keep this file UTF-8 without BOM. Do NOT rewrite it with
#   Get-Content -Raw -Encoding UTF8 | Set-Content -Encoding UTF8
# which strips the BOM and makes PS 5.1 read it back as GBK, corrupting any
# non-ASCII text in the file.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Action,

    [string]$Path,
    [string]$Project,
    [string]$Bundle,
    [string]$Hap,
    [string]$Udid,
    [string]$Out,
    [string]$OutDir,
    [string]$Target,
    [string]$Ability,
    [string]$Cmd,
    [string]$Filter,
    [string]$Mode = 'debug',
    [string]$Product = 'default',
    [string]$Module = 'entry',
    [int]$Seconds = 10,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# ---------------------------------------------------------------- environment
$script:DevecoHome = if ($env:DEVECO_HOME) { $env:DEVECO_HOME } else { 'E:\Huawei\DevEco Studio' }
$script:DevecoSdk  = if ($env:DEVECO_SDK_HOME) { $env:DEVECO_SDK_HOME } else { Join-Path $script:DevecoHome 'sdk' }
$script:NodeExe    = Join-Path $script:DevecoHome 'tools\node\node.exe'
$script:HvigorJs   = Join-Path $script:DevecoHome 'tools\hvigor\bin\hvigorw.js'
$script:OhpmJs     = Join-Path $script:DevecoHome 'tools\ohpm\bin\pm-cli.js'
$script:Toolchains = Join-Path $script:DevecoSdk 'default\openharmony\toolchains'
$script:Hdc        = Join-Path $script:Toolchains 'hdc.exe'
$script:SignLib    = Join-Path $script:Toolchains 'lib'
$script:JavaHome   = if ($env:DEVECO_JAVA_HOME -and (Test-Path (Join-Path $env:DEVECO_JAVA_HOME 'bin\java.exe'))) {
    $env:DEVECO_JAVA_HOME
} elseif (Test-Path 'C:\Program Files\Java\jdk-17') {
    'C:\Program Files\Java\jdk-17'
} elseif ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME 'bin\java.exe'))) {
    $env:JAVA_HOME
} else {
    (Get-ChildItem 'C:\Program Files\Java' -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending | Select-Object -First 1).FullName
}
$script:JavaExe    = Join-Path $script:JavaHome 'bin\java.exe'
$script:KeyTool    = Join-Path $script:JavaHome 'bin\keytool.exe'
$script:StorePwd   = '123456'
$env:DEVECO_SDK_HOME = $script:DevecoSdk
$env:NODE_HOME = Split-Path $script:NodeExe -Parent

function Info($m) { Write-Host "[deveco] $m" }
function Die($m) { throw "[deveco] $m" }

function Invoke-Tool {
    param([string]$Exe, [string[]]$Arguments, [string]$WorkDir, [switch]$AllowFail)
    $preview = "$Exe " + (($Arguments | ForEach-Object { if ($_ -match '\s') { '"' + $_ + '"' } else { $_ } }) -join ' ')
    if ($DryRun) { Write-Host "[dry-run] $preview" -ForegroundColor DarkGray; return @{ ExitCode = 0; Output = @() } }
    $oldDir = Get-Location
    $oldEap = $ErrorActionPreference
    if ($WorkDir) { Set-Location $WorkDir }
    try {
        # PS 5.1 turns a native program's stderr into a terminating NativeCommandError.
        # We only care about the exit code here.
        $ErrorActionPreference = 'Continue'
        $out = & $Exe @Arguments 2>&1
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldEap
        Set-Location $oldDir
    }
    if ($code -ne 0 -and -not $AllowFail) {
        $out | Select-Object -Last 30 | ForEach-Object { Write-Host $_ }
        Die "command failed (exit=$code): $preview"
    }
    return @{ ExitCode = $code; Output = $out }
}

function Need([string]$p, [string]$what) {
    if (-not (Test-Path -LiteralPath $p)) { Die "missing $what : $p" }
}

# hap-sign-tool wants LF-only, BOM-free PEM. PS 5.1's Set-Content -Encoding UTF8
# writes a BOM, which the tool rejects ("Illegal header"), so write bytes directly.
function Write-Utf8NoBom([string]$file, [string]$text) {
    [System.IO.File]::WriteAllText($file, $text, (New-Object System.Text.UTF8Encoding($false)))
}

# Assemble a certificate chain file in issuer order (root -> sub CA -> leaf).
function Write-CertChain([string]$outFile, [string[]]$pemFiles) {
    $blocks = foreach ($f in $pemFiles) {
        ((Get-Content $f -Raw -Encoding UTF8) -replace "`r`n", "`n").Trim()
    }
    Write-Utf8NoBom $outFile (($blocks -join "`n") + "`n")
}

# ---------------------------------------------------------------- actions
function Do-Env {
    $table = [ordered]@{
        DEVECO_HOME          = $script:DevecoHome
        DEVECO_SDK_HOME      = $script:DevecoSdk
        NODE_HOME            = $env:NODE_HOME
        hvigor               = $script:HvigorJs
        ohpm                 = $script:OhpmJs
        hdc                  = $script:Hdc
        hap_sign_tool        = Join-Path $script:SignLib 'hap-sign-tool.jar'
        java                 = $script:JavaExe
        keytool              = $script:KeyTool
        OpenHarmony_keystore = Join-Path $script:SignLib 'OpenHarmony.p12'
    }
    $table.GetEnumerator() | ForEach-Object { Write-Host ("{0,-22} {1}" -f $_.Key, $_.Value) }
    Write-Host ''
    Write-Host '# paste into the current pwsh session to get hdc/hvigor/ohpm on PATH:'
    Write-Host "`$env:DEVECO_SDK_HOME = '$script:DevecoSdk'"
    Write-Host "`$env:NODE_HOME = '$env:NODE_HOME'"
    Write-Host "`$env:Path = '$(Join-Path $script:DevecoHome 'tools\node');$(Join-Path $script:DevecoHome 'tools\ohpm\bin');$(Join-Path $script:DevecoHome 'tools\hvigor\bin');$script:Toolchains;' + `$env:Path"
}

function Do-Doctor {
    $checks = @(
        @{ n = 'node';            p = $script:NodeExe },
        @{ n = 'hvigorw.js';      p = $script:HvigorJs },
        @{ n = 'ohpm pm-cli.js';  p = $script:OhpmJs },
        @{ n = 'hdc';             p = $script:Hdc },
        @{ n = 'hap-sign-tool';   p = (Join-Path $script:SignLib 'hap-sign-tool.jar') },
        @{ n = 'OpenHarmony.p12'; p = (Join-Path $script:SignLib 'OpenHarmony.p12') },
        @{ n = 'java';            p = $script:JavaExe },
        @{ n = 'keytool';         p = $script:KeyTool },
        @{ n = 'SDK ets';         p = (Join-Path $script:DevecoSdk 'default\openharmony\ets') }
    )
    $bad = 0
    foreach ($c in $checks) {
        $ok = Test-Path -LiteralPath $c.p
        if (-not $ok) { $bad++ }
        Write-Host ("{0,-18} {1}  {2}" -f $c.n, $(if ($ok) { 'OK  ' } else { 'MISS' }), $c.p)
    }
    if (Test-Path $script:NodeExe) {
        Write-Host "hvigor version : $((& $script:NodeExe $script:HvigorJs --version 2>&1 | Select-Object -Last 1))"
        Write-Host "ohpm version   : $((& $script:NodeExe $script:OhpmJs -v 2>&1 | Select-Object -Last 1))"
    }
    if (Test-Path $script:Hdc) { Write-Host "hdc version    : $((& $script:Hdc -v 2>&1 | Select-Object -Last 1))" }
    $appCheck = Get-ChildItem $script:SignLib -Filter app_check_tool.jar -ErrorAction SilentlyContinue
    Write-Host "app_check_tool : $(if ($appCheck) { 'OK' } else { 'MISS (optional)' })"
    if ($bad -gt 0) { Die "doctor failed: $bad missing item(s)" }
    Info 'doctor passed'
}

function Do-New {
    if (-not $Path) { Die 'new needs -Path <dir>' }
    $tpl = Join-Path $script:DevecoHome 'plugins\codegenie-plugin\previewProject'
    Need $tpl 'DevEco project template (previewProject)'
    if (Test-Path $Path) { Die "target already exists: $Path" }
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Copy-Item "$tpl\*" $Path -Recurse -Force
    Remove-Item (Join-Path $Path '.hvigor')           -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $Path 'entry\src\ohosTest') -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $Path 'entry\src\test')     -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $Path 'entry\src\mock')     -Recurse -Force -ErrorAction SilentlyContinue

    if ($Bundle) {
        $app = Join-Path $Path 'AppScope\app.json5'
        (Get-Content $app -Raw -Encoding UTF8) -replace '"bundleName":\s*"[^"]+"', ('"bundleName": "' + $Bundle + '"') |
            Set-Content $app -Encoding UTF8 -NoNewline
    }
    # drop the online-only test deps so `ohpm install` works offline
    $ohp = Join-Path $Path 'oh-package.json5'
    (Get-Content $ohp -Raw -Encoding UTF8) -replace '(?s)"devDependencies":\s*\{.*?\}', '"devDependencies": {}' |
        Set-Content $ohp -Encoding UTF8 -NoNewline

    Invoke-Tool $script:NodeExe @($script:OhpmJs, 'install') $Path | Out-Null
    Info "project created: $Path"
    Info "next: & deveco.ps1 build -Project `"$Path`""
}

function Resolve-Project([string]$p) {
    if (-not $p) { Die 'needs -Project <dir>' }
    if (-not (Test-Path -LiteralPath (Join-Path $p 'build-profile.json5'))) {
        Die "not a HarmonyOS project (no build-profile.json5): $p"
    }
    return (Resolve-Path $p).Path
}

function Do-Build {
    $proj = Resolve-Project $Project
    $hargs = @($script:HvigorJs, '--mode', 'module',
        '-p', "product=$Product", '-p', "module=$Module@$Product",
        '-p', "buildMode=$Mode", 'assembleHap')
    if ($env:DEVECO_DAEMON -ne '1') { $hargs += '--no-daemon' }
    $r = Invoke-Tool $script:NodeExe $hargs $proj
    $r.Output | Select-Object -Last 8 | ForEach-Object { Write-Host $_ }

    $hapDir = Join-Path $proj "$Module\build\default\outputs\$Product"
    $found = @(Get-ChildItem $hapDir -Filter *.hap -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending)
    if ($found.Count -eq 0) { Die "build reported success but no HAP found at: $hapDir" }
    foreach ($f in $found) {
        $tag = if ($f.Name -match 'unsigned') { '[unsigned]' } else { '[signed]' }
        Info ("artifact {0}  {1:N2} MB  {2}" -f $f.FullName, ($f.Length / 1MB), $tag)
    }
    return $found
}

function Get-SignCache {
    $dir = Join-Path $env:TEMP 'deveco-sign-cache'
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    return $dir
}

function Do-Sign {
    Need $script:KeyTool 'keytool'
    $keystore = Join-Path $script:SignLib 'OpenHarmony.p12'
    Need $keystore 'OpenHarmony.p12 (test signing material)'
    $cache = Get-SignCache

    # 1) unsigned HAP
    $inHap = $Hap
    if (-not $inHap) {
        $proj = Resolve-Project $Project
        $cand = Get-ChildItem (Join-Path $proj "$Module\build") -Recurse -Filter *.hap -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match 'unsigned' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if (-not $cand) { Die 'no unsigned HAP found; run build first or pass -Hap' }
        $inHap = $cand.FullName
    }
    Need $inHap 'HAP'
    $inHap = (Resolve-Path $inHap).Path

    # 2) test signing material from the SDK
    $signTool = Join-Path $script:SignLib 'hap-sign-tool.jar'
    Need $signTool 'hap-sign-tool.jar'
    $profCer = Join-Path $script:SignLib 'OpenHarmonyProfileDebug.pem'
    Need $profCer 'OpenHarmonyProfileDebug.pem (profile cert CHAIN: root -> sub CA -> profile debug)'
    # sign-profile refuses a bare leaf cert ("Profile cert must a cert chain"),
    # so the profile leg always uses the SDK's 3-cert chain, not a keytool export.

    # 3) developer keystore + CA-issued app certificate chain
    #
    # Why we cannot just reuse the OpenHarmony.p12 "application release" entry:
    # that entry is SELF-SIGNED, and sign-app rejects a bare leaf
    # ("Profile cert must a cert chain" / "verify certificate chain failed").
    # So we mint our own keypair and have the SDK's OpenHarmony Application CA
    # issue a cert for it - the same shape DevEco Studio creates for a developer.
    $devAlias  = 'jieyu-dev-key'
    $devStore  = Join-Path $cache 'jieyu-dev.p12'
    $devCer    = Join-Path $cache 'jieyu-dev.cer'
    $devChain  = Join-Path $cache 'jieyu-dev-chain.cer'
    $rootCer   = Join-Path $cache 'oh-root-ca.cer'
    $subCer    = Join-Path $cache 'oh-app-ca.cer'
    $subject   = 'C=CN,O=OpenHarmony,OU=OpenHarmony Team,CN=OpenHarmony Application Release'
    $issuer    = 'C=CN,O=OpenHarmony,OU=OpenHarmony Team,CN=OpenHarmony Application CA'
    if (-not (Test-Path $devStore)) {
        Info "generating developer keypair -> $devStore"
        Invoke-Tool $script:JavaExe @('-jar', $signTool, 'generate-keypair',
            '-keyAlias', $devAlias, '-keyPwd', $script:StorePwd,
            '-keyAlg', 'ECC', '-keySize', 'NIST-P-256',
            '-keystoreFile', $devStore, '-keystorePwd', $script:StorePwd) (Get-Location) | Out-Null
    }
    foreach ($pair in @(@($rootCer, 'openharmony application root ca'), @($subCer, 'openharmony application ca'))) {
        if (-not (Test-Path $pair[0])) {
            Invoke-Tool $script:KeyTool @('-exportcert', '-rfc', '-alias', $pair[1],
                '-keystore', $keystore, '-storetype', 'PKCS12', '-storepass', $script:StorePwd,
                '-file', $pair[0]) | Out-Null
        }
    }
    if (-not (Test-Path $devCer)) {
        Info 'issuing app certificate from the SDK OpenHarmony CA'
        Invoke-Tool $script:JavaExe @('-jar', $signTool, 'generate-app-cert',
            '-keyAlias', $devAlias, '-keyPwd', $script:StorePwd,
            '-issuer', $issuer,
            '-issuerKeyAlias', 'openharmony application ca', '-issuerKeyPwd', $script:StorePwd,
            '-subject', $subject,
            '-validity', '3650',
            '-signAlg', 'SHA256withECDSA',
            '-keystoreFile', $devStore, '-keystorePwd', $script:StorePwd,
            '-issuerKeystoreFile', $keystore, '-issuerKeystorePwd', $script:StorePwd,
            '-outForm', 'cert', '-outFile', $devCer) (Get-Location) | Out-Null
    }
    Need $devCer 'issued developer certificate'
    $devPem = (Get-Content $devCer -Raw -Encoding UTF8).Trim()
    Write-CertChain $devChain @($rootCer, $subCer, $devCer)

    # 4) debug profile: bundle name + udid + OUR development certificate
    $tpl = Join-Path $script:SignLib 'UnsgnedDebugProfileTemplate.json'
    Need $tpl 'UnsgnedDebugProfileTemplate.json'
    $profile = Get-Content $tpl -Raw -Encoding UTF8

    $bundleName = $Bundle
    if (-not $bundleName -and $Project) {
        $appJson = Join-Path (Resolve-Project $Project) 'AppScope\app.json5'
        if (Test-Path $appJson) {
            $m = [regex]::Match((Get-Content $appJson -Raw -Encoding UTF8), '"bundleName":\s*"([^"]+)"')
            if ($m.Success) { $bundleName = $m.Groups[1].Value }
        }
    }
    if (-not $bundleName) { $bundleName = 'com.example.myapplication' }
    $profile = $profile -replace '"bundle-name":\s*"[^"]*"', ('"bundle-name": "' + $bundleName + '"')

    $udid = $Udid
    if (-not $udid) {
        $devs = @(Do-Devices -Quiet)
        if ($devs.Count -ge 1 -and $devs[0].Udid) { $udid = $devs[0].Udid }
    }
    if (-not $udid) {
        Info 'WARN: no device and no -Udid; profile keeps the template placeholder udid'
        Info '      (self-sign verification still passes, real-device install will not)'
    } else {
        $profile = $profile -replace '"device-ids":\s*\[[^\]]*\]', ('"device-ids": ["' + $udid + '"]')
        Info "profile device-ids = $udid"
    }

    # the profile pins the certificate the HAP will be signed with
    $escaped = ($devPem -replace "`r`n", '\n') -replace "`n", '\n'
    $profile = [regex]::Replace($profile,
        '(?s)"development-certificate":\s*"-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----\\n"',
        ('"development-certificate": "' + $escaped + '\n"'))
    if ($profile -notmatch [regex]::Escape(($devPem -split "`n")[1])) {
        Die 'failed to inject the development certificate into the profile template'
    }

    $now = [DateTimeOffset]::UtcNow
    $profile = $profile -replace '"not-before":\s*\d+', ('"not-before": ' + $now.AddDays(-1).ToUnixTimeSeconds())
    $profile = $profile -replace '"not-after":\s*\d+',  ('"not-after": '  + $now.AddYears(10).ToUnixTimeSeconds())
    $profilePath = Join-Path $cache 'profile-debug.json'
    Write-Utf8NoBom $profilePath $profile
    Info "profile bundle-name = $bundleName"

    # 5) sign the profile -> .p7b
    $p7b = Join-Path $cache 'profile-debug.p7b'
    if (Test-Path $p7b) { Remove-Item $p7b -Force }
    Invoke-Tool $script:JavaExe @('-jar', $signTool, 'sign-profile',
        '-mode', 'localSign',
        '-keyAlias', 'openharmony application profile debug',
        '-profileCertFile', $profCer,
        '-inFile', $profilePath,
        '-signAlg', 'SHA256withECDSA',
        '-keystoreFile', $keystore,
        '-keystorePwd', $script:StorePwd,
        '-keyPwd', $script:StorePwd,
        '-outFile', $p7b) (Get-Location) | Out-Null
    Need $p7b 'signed profile'
    Info "profile signed: $p7b"

    # 6) sign the app
    if (-not $Out) {
        $dir = Split-Path $inHap -Parent
        $Out = Join-Path $dir ((Split-Path $inHap -Leaf) -replace 'unsigned', 'signed')
    }
    Invoke-Tool $script:JavaExe @('-jar', $signTool, 'sign-app',
        '-mode', 'localSign',
        '-keyAlias', $devAlias,
        '-keyPwd', $script:StorePwd,
        '-appCertFile', $devChain,
        '-profileFile', $p7b,
        '-inFile', $inHap,
        '-signAlg', 'SHA256withECDSA',
        '-keystoreFile', $devStore,
        '-keystorePwd', $script:StorePwd,
        '-outFile', $Out,
        '-compatibleVersion', '12') (Get-Location) | Out-Null
    $f = Get-Item $Out
    Info ("signed {0}  {1:N2} MB" -f $f.FullName, ($f.Length / 1MB))
    return $f.FullName
}

function Do-Verify {
    if (-not $Hap) { Die 'verify needs -Hap <signed.hap>' }
    Need $Hap 'HAP'
    $signTool = Join-Path $script:SignLib 'hap-sign-tool.jar'
    $od = if ($OutDir) { $OutDir } else { Get-SignCache }
    New-Item -ItemType Directory -Force -Path $od | Out-Null
    $chain = Join-Path $od 'verify-certchain.cer'
    $prof  = Join-Path $od 'verify-profile.p7b'
    $r = Invoke-Tool $script:JavaExe @('-jar', $signTool, 'verify-app',
        '-inFile', (Resolve-Path $Hap).Path,
        '-outCertChain', $chain,
        '-outProfile', $prof) (Get-Location)
    $r.Output | Select-Object -Last 4 | ForEach-Object { Write-Host $_ }
    Need $chain 'exported certificate chain'
    Info "verify passed; certChain=$chain profile=$prof"
}

function Do-Devices {
    param([switch]$Quiet)
    Need $script:Hdc 'hdc'
    $raw = & $script:Hdc list targets -v 2>&1
    $list = @()
    $cur = $null
    foreach ($line in $raw) {
        $s = "$line".Trim()
        if ($s -eq '' -or $s -eq '[Empty]') { continue }
        if ($s -match '^([0-9A-Fa-f]{6,})\s*$') {
            $cur = @{ Target = $Matches[1]; Udid = $null }
            $list += , $cur
            continue
        }
        if ($cur -and $s -match '^([\w\-\.]+)\s+(.+)$') {
            $k = $Matches[1]; $v = $Matches[2].Trim()
            if ($k -eq 'udid') { $cur.Udid = $v }
        }
    }
    if (-not $Quiet) {
        if ($list.Count -eq 0) { Write-Host '(no device connected)' }
        foreach ($d in $list) { Write-Host ("  target = {0}" -f $d.Target); Write-Host ("  udid   = {0}" -f $d.Udid); Write-Host '' }
    }
    return @($list | ForEach-Object { [pscustomobject]@{ Target = $_.Target; Udid = $_.Udid } })
}

function HdcTarget([string]$t) { if ($t) { @('-t', $t) } else { @() } }

function Do-Install {
    if (-not $Hap) { Die 'install needs -Hap <f.hap>' }
    Need $Hap 'HAP'
    $r = Invoke-Tool $script:Hdc ((HdcTarget $Target) + @('install', '-r', (Resolve-Path $Hap).Path))
    $r.Output | Select-Object -Last 5 | ForEach-Object { Write-Host $_ }
    if (($r.Output -join "`n") -notmatch 'success') { Die 'install did not report success' }
    Info 'installed'
}

function Do-Run {
    if (-not $Bundle) { Die 'run needs -Bundle <bundleName>' }
    $a = if ($Ability) {
        (HdcTarget $Target) + @('shell', 'aa', 'start', '-a', $Ability, '-b', $Bundle)
    } else {
        (HdcTarget $Target) + @('shell', 'aa', 'start', '-b', $Bundle)
    }
    $r = Invoke-Tool $script:Hdc $a
    $r.Output | Select-Object -Last 6 | ForEach-Object { Write-Host $_ }
    Info 'launch dispatched'
}

function Do-Stop {
    if (-not $Bundle) { Die 'stop needs -Bundle <bundleName>' }
    Invoke-Tool $script:Hdc ((HdcTarget $Target) + @('shell', 'aa', 'force-stop', $Bundle)) | Out-Null
    Info 'stopped'
}

function Do-Log {
    $hdcArgs = (HdcTarget $Target) + @('hilog')
    $job = Start-Job -ScriptBlock {
        param($hdc, $a)
        & $hdc @a 2>&1
    } -ArgumentList $script:Hdc, $hdcArgs
    Start-Sleep -Seconds $Seconds
    Stop-Job $job -ErrorAction SilentlyContinue
    $out = @(Receive-Job $job -ErrorAction SilentlyContinue)
    Remove-Job $job -Force -ErrorAction SilentlyContinue
    if ($Bundle) { $out = @($out | Where-Object { $_ -match [regex]::Escape($Bundle) }) }
    if ($Filter) { $out = @($out | Where-Object { $_ -match $Filter }) }
    $out | Select-Object -Last 200 | ForEach-Object { Write-Host $_ }
    Info "captured $($out.Count) line(s)"
}

function Do-Shell {
    if (-not $Cmd) { Die 'shell needs -Cmd "<remote command>"' }
    $r = Invoke-Tool $script:Hdc ((HdcTarget $Target) + @('shell', $Cmd))
    $r.Output | ForEach-Object { Write-Host $_ }
}

function Do-Screenshot {
    if (-not $Out) { Die 'screenshot needs -Out <png>' }
    $remote = '/data/local/tmp/_deveco_shot.jpeg'
    Invoke-Tool $script:Hdc ((HdcTarget $Target) + @('shell', "snapshot_display -f $remote")) | Out-Null
    Invoke-Tool $script:Hdc ((HdcTarget $Target) + @('file', 'recv', $remote, $Out)) | Out-Null
    if (Test-Path $Out) { Info "screenshot: $Out" } else { Die 'screenshot failed (device may not support snapshot_display)' }
}

# ---------------------------------------------------------------- dispatch
switch ($Action.ToLower()) {
    'env'        { Do-Env }
    'doctor'     { Do-Doctor }
    'new'        { Do-New }
    'build'      { Do-Build | Out-Null }
    'sign'       { Do-Sign }
    'verify'     { Do-Verify }
    'devices'    { Do-Devices | Out-Null }
    'install'    { Do-Install }
    'run'        { Do-Run }
    'stop'       { Do-Stop }
    'log'        { Do-Log }
    'shell'      { Do-Shell }
    'screenshot' { Do-Screenshot }
    default      { Die "unknown action: $Action (see header)" }
}
