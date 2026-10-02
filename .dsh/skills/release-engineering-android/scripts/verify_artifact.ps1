# verify_artifact.ps1 —— 校验 Android 产物（APK/AAB）：签名 + 包内实际关键字段
#
# 为什么需要：`--export-release` 报「导出成功」**不代表**包里是对的（本项目踩过两次：
# 高度图、数据表）。而且 debug 签名与 release 签名肉眼分不出，必须验。
#
# 用法：
#   pwsh -File verify_artifact.ps1 -Artifact "<apk或aab路径>" [-ExpectCode 2] [-ExpectName 0.2.0] [-ExpectPackage "com.xxx.jieyu"]
#
# 退出码：0 = 全部通过；1 = 有关键项不通过；2 = 用法/工具问题

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Artifact,
    [int]$ExpectCode = -1,
    [string]$ExpectName = "",
    [string]$ExpectPackage = "",
    [string]$ExpectCertSha256 = "",
    [string]$Sdk = "C:\Users\feiyun\AppData\Local\Android\Sdk",
    [string]$BuildTools = "36.0.0"
)

# 已知的「调试用」证书指纹。按**指纹**判而不是按 DN 判 —— 因为 Godot 自带的 debug.keystore
# 用的是 CN=Godot（不是 CN=Android Debug），靠名字比对会漏判，签出来的包 apksigner 一样「Verifies」。
# 这些指纹出现在发布包里 = 一定不能发。
#
# 本机实测（2026-10-02，用 keytool -list -v -keystore <ks> -storepass android 读出）：
#   %APPDATA%\Godot\keystores\debug.keystore
#     SHA256 76:5C:59:B6:...:B9775F  →  "765c59b6114cb8d1a2e7017fc6f635acb86638fc74813163b0447600e5b9775f"
#   本机**没有** ~/.android/debug.keystore（Android SDK 经典 debug 证书），所以不预置它的指纹。
#   如果你后来生成了它，用上面的 keytool 命令读出 SHA256 再补进这里。
#
# 下面的 $KnownDebugCertSha256 还会在运行时**自动**把 Godot 的 debug.keystore 指纹加进来，
# 这样即使你换了机器/换了 Godot 附带的 keystore 也仍然能判对。
$KnownDebugCertSha256 = @(
    "765c59b6114cb8d1a2e7017fc6f635acb86638fc74813163b0447600e5b9775f"
)

# 自动补充：读出 Godot debug keystore 的真实指纹（读不到就跳过，不报错）
$godotDebugKs = Join-Path $env:APPDATA "Godot\keystores\debug.keystore"
$keytool = "C:\Program Files\Java\jdk-17\bin\keytool.exe"
if ((Test-Path -LiteralPath $godotDebugKs) -and (Test-Path -LiteralPath $keytool)) {
    $prevEap0 = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    $ksOut = & $keytool -list -v -keystore $godotDebugKs -storepass android 2>&1 | Out-String
    $ErrorActionPreference = $prevEap0
    $m = [regex]::Match($ksOut, "SHA256:\s*([0-9A-Fa-f:]{60,})")
    if ($m.Success) {
        $fp = ($m.Groups[1].Value -replace ":", "").ToLower()
        if ($KnownDebugCertSha256 -notcontains $fp) { $KnownDebugCertSha256 += $fp }
    }
}

$ErrorActionPreference = "Stop"
$failed = 0
$warned = 0

function Fail($m) { Write-Host "[FAIL] $m" -ForegroundColor Red; $script:failed++ }
function Warn($m) { Write-Host "[WARN] $m" -ForegroundColor Yellow; $script:warned++ }
function Pass($m) { Write-Host "[OK]   $m" -ForegroundColor Green }

if (-not (Test-Path -LiteralPath $Artifact)) { Write-Error "产物不存在：$Artifact"; exit 2 }
$Artifact = (Resolve-Path -LiteralPath $Artifact).Path
$size = (Get-Item -LiteralPath $Artifact).Length

$aapt2 = Join-Path $Sdk "build-tools\$BuildTools\aapt2.exe"
$apksigner = Join-Path $Sdk "build-tools\$BuildTools\apksigner.bat"
if (-not (Test-Path -LiteralPath $aapt2)) { Write-Error "找不到 aapt2：$aapt2"; exit 2 }

Write-Host "=== 产物信息 ===" -ForegroundColor Cyan
Write-Host "路径 : $Artifact"
Write-Host ("大小 : {0:N0} 字节 ({1:N2} MiB)" -f $size, ($size / 1MB))
Write-Host "SHA256: $((Get-FileHash -LiteralPath $Artifact -Algorithm SHA256).Hash)"

# ---------- 1) 包内关键字段 ----------
Write-Host "`n=== 1/2 aapt2 dump badging（包内实际情况）===" -ForegroundColor Cyan
# aapt2 / apksigner 会往 stderr 写 warn 行；在 $ErrorActionPreference='Stop' 下那会被当成终止错误，
# 所以这里局部降级为 SilentlyContinue，只取文本。
$prevEap = $ErrorActionPreference
$ErrorActionPreference = "SilentlyContinue"
$badging = & $aapt2 dump badging $Artifact 2>&1 | Out-String
$ErrorActionPreference = $prevEap

$pkg = [regex]::Match($badging, "package:\s*name='([^']+)'").Groups[1].Value
$vcode = [regex]::Match($badging, "versionCode='(\d+)'").Groups[1].Value
$vname = [regex]::Match($badging, "versionName='([^']*)'").Groups[1].Value
$label = [regex]::Match($badging, "application-label:'([^']*)'").Groups[1].Value
$minSdk = [regex]::Match($badging, "minSdkVersion:'(\d+)'").Groups[1].Value
$tgtSdk = [regex]::Match($badging, "targetSdkVersion:'(\d+)'").Groups[1].Value
$abis = ([regex]::Matches($badging, "native-code:\s*'([^']+)'") | ForEach-Object { $_.Groups[1].Value }) -join " "
$perms = [regex]::Matches($badging, "uses-permission:\s*name='([^']+)'") | ForEach-Object { $_.Groups[1].Value }

Write-Host "包名     : $pkg"
Write-Host "版本     : versionCode=$vcode  versionName='$vname'"
Write-Host "标签     : $label"
Write-Host "SDK      : min=$minSdk  target=$tgtSdk"
Write-Host "原生架构 : $(if ($abis) { $abis } else { '(无 native-code 行)' })"
Write-Host "申请权限 : $(if ($perms) { $perms -join ', ' } else { '（无）' })"

# ---------- 2) 签名 ----------
Write-Host "`n=== 2/2 签名校验 ===" -ForegroundColor Cyan
$signedOk = $false
$certInfo = ""
if (Test-Path -LiteralPath $apksigner) {
    $prevEap2 = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    $sig = & $apksigner verify --verbose --print-certs $Artifact 2>&1 | Out-String
    $sigExit = $LASTEXITCODE
    $ErrorActionPreference = $prevEap2
    if ($sigExit -eq 0) { $signedOk = $true }
    $certInfo = $sig
    Write-Host $sig.Trim()
} else {
    Warn "找不到 apksigner（$apksigner）—— 跳过签名校验"
}

# ---------- 断言 ----------
Write-Host "`n=== 断言 ===" -ForegroundColor Cyan

if ([string]::IsNullOrWhiteSpace($pkg)) {
    Fail "读不出包名（badging 输出异常）"
} elseif ($pkg -like "com.example.*") {
    Fail "包名是 $pkg —— Play 明确不接受 com.example.*，上架前必须改成自有域名反写"
} else {
    Pass "包名 $pkg 不是 com.example.*"
}

if ($ExpectPackage -ne "" -and $pkg -ne $ExpectPackage) { Fail "包名不符：期望 $ExpectPackage 实得 $pkg" }
elseif ($ExpectPackage -ne "") { Pass "包名与期望一致" }

if ($ExpectCode -ge 0) {
    if ([int]$vcode -eq $ExpectCode) { Pass "versionCode = $ExpectCode（与期望一致）" }
    else { Fail "versionCode 不符：期望 $ExpectCode 实得 $vcode" }
}
if ($ExpectName -ne "") {
    if ($vname -eq $ExpectName) { Pass "versionName = $ExpectName（与期望一致）" }
    else { Fail "versionName 不符：期望 $ExpectName 实得 $vname" }
}

if ($signedOk) {
    # 光看 DN 会漏：Godot 自带的 debug.keystore 用的是 CN=Godot（**不是** CN=Android Debug），
    # 用它签出来的包 apksigner 一样「Verifies」，但绝对不能发布。所以按**指纹**判，不按名字判。
    $certSha = [regex]::Match($certInfo, "certificate SHA-256 digest:\s*([0-9a-fA-F]+)").Groups[1].Value
    $certDn  = [regex]::Match($certInfo, "certificate DN:\s*(.+)").Groups[1].Value.Trim()

    if ($certSha -ne "") {
        Write-Host "签名证书 SHA-256 : $certSha"
        if ($certDn -ne "") { Write-Host "签名证书 DN      : $certDn" }
    }

    $tooShortKey = $false
    $keyBits = [regex]::Match($certInfo, "key size \(bits\):\s*(\d+)").Groups[1].Value
    if ($keyBits -ne "" -and [int]$keyBits -lt 2048) { $tooShortKey = $true }

    if ($KnownDebugCertSha256 -contains $certSha.ToLower()) {
        Fail "签名用的是**已知 debug 证书**（指纹 $($certSha.Substring(0,[Math]::Min(16,$certSha.Length)))…，DN=$certDn）—— 不能作为发布包。必须换 release keystore。"
    } elseif ($certDn -match "Android Debug") {
        Fail "签名是 debug 证书（DN 含 Android Debug）—— 不能作为发布包。"
    } elseif ($ExpectCertSha256 -ne "" -and $certSha.ToLower() -ne $ExpectCertSha256.ToLower()) {
        Fail "证书指纹与 -ExpectCertSha256 不符：期望 $ExpectCertSha256 实得 $certSha"
    } elseif ($tooShortKey) {
        Fail "签名密钥只有 $keyBits 位，低于 2048 —— 建议重新用 RSA 4096 生成 release keystore。"
    } elseif ($ExpectCertSha256 -ne "") {
        Pass "签名证书指纹与期望一致，且不是已知 debug 证书"
    } else {
        Pass "已签名且不是已知 debug 证书（DN=$certDn）"
        if ([regex]::Match($certInfo, "Number of signers:\s*(\d+)").Groups[1].Value -notin @("", "1")) {
            Warn "签名者不止一个 —— 确认这是你预期的签名链"
        }
    }
} elseif (Test-Path -LiteralPath $apksigner) {
    Fail "签名校验未通过（apksigner verify 非零退出）"
}

if ($perms.Count -eq 0) {
    Pass "未申请任何权限（与当前工程配置一致；若你已加联网/统计 SDK 却仍是 0，说明 SDK 没真进包）"
} else {
    Warn "包内申请了 $($perms.Count) 个权限：$($perms -join ', ')"
    Warn "→ 必须与隐私声明/数据安全表单逐条一致，多一个都算事故。"
}

if ([string]::IsNullOrWhiteSpace($abis)) {
    Warn "没有 native-code 行 —— 确认这是否是纯 GDScript 包（正常情况下 Godot 包会带 libgodot 的 ABI）"
}
if ($vname -notmatch '^\d+\.\d+\.\d+') { Warn "versionName '$vname' 不是 主.次.修订 形式" }

Write-Host "`n=== 结论 ===" -ForegroundColor Cyan
Write-Host "关键项不通过：$failed  提醒：$warned"
if ($failed -gt 0) { Write-Host "有 $failed 项不通过，不要发布。" -ForegroundColor Red; exit 1 }
Write-Host "关键项全部通过。（提醒项请人工确认）" -ForegroundColor Green
exit 0
