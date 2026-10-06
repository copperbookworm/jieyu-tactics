# build_aab.ps1 —— jieyu-1 出 Android 发布包（前置检查 → 测试 → 导出包验收 → 导出 → 校验）
#
# 为什么要有这个脚本：顺序错一步就会出「假绿」——
#   ① 没跑测试就导出 → 逻辑 bug 被当成「导出成功」
#   ② 没跑导出包验收 → 开发机跑得好、包里缺资源（本项目踩过两次：高度图、数据表）
#   ③ 没校验签名 → debug 证书签出来的包 apksigner 一样「Verifies」
#
# 用法：
#   # 先看会做什么，不实际出包（推荐第一次这么跑）
#   & build_aab.ps1 -Project "D:\Godot4.7_Proj\jieyu-1" -OutDir "D:\Godot4.7_Proj\APK" -DryRun
#   # 真出包
#   & build_aab.ps1 -Project "D:\Godot4.7_Proj\jieyu-1" -OutDir "D:\Godot4.7_Proj\APK" -VersionTag "0.1.0"
#   # 只想出调试 APK 装真机
#   & build_aab.ps1 -Project "..." -OutDir "..." -DebugBuild
#
# 退出码：0 = 全流程通过；2 = 前置检查不过；3 = 测试/验收不过；4 = 导出失败；5 = 产物校验不过

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Project,
    [Parameter(Mandatory = $true)][string]$OutDir,
    [string]$VersionTag = "",
    [switch]$DebugBuild,
    [switch]$DryRun,
    [switch]$SkipTests,
    [string]$GodotExe = "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe"
)

$ErrorActionPreference = "Stop"

function Step($m) { Write-Host "`n=== $m" -ForegroundColor Cyan }
function Hint($m) { Write-Host "    $m" -ForegroundColor DarkGray }
function Good($m) { Write-Host "  [OK] $m" -ForegroundColor Green }
function Bad($m)  { Write-Host "  [!!] $m" -ForegroundColor Red }

if (-not (Test-Path -LiteralPath $Project)) { Bad "工程目录不存在：$Project"; exit 2 }
$Project = (Resolve-Path -LiteralPath $Project).Path
$cfgPath = Join-Path $Project "export_presets.cfg"
if (-not (Test-Path -LiteralPath $cfgPath)) { Bad "找不到 export_presets.cfg"; exit 2 }
if (-not (Test-Path -LiteralPath $GodotExe)) { Bad "找不到 Godot 控制台版：$GodotExe"; exit 2 }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$OutDir = (Resolve-Path -LiteralPath $OutDir).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$tmpDir = Join-Path $env:TEMP "jieyu_build_$stamp"
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null

$cfg = [System.IO.File]::ReadAllText($cfgPath)
$fmt = [regex]::Match($cfg, "(?m)^\s*gradle_build/export_format\s*=\s*(\d+)").Groups[1].Value
$code = [regex]::Match($cfg, "(?m)^\s*version/code\s*=\s*(\d+)").Groups[1].Value
$name = [regex]::Match($cfg, "(?m)^\s*version/name\s*=\s*`"([^`"]*)`"").Groups[1].Value
$uniq = [regex]::Match($cfg, "(?m)^\s*package/unique_name\s*=\s*`"([^`"]*)`"").Groups[1].Value
$signed = [regex]::Match($cfg, "(?m)^\s*package/signed\s*=\s*(true|false)").Groups[1].Value
$ksRel = [regex]::Match($cfg, "(?m)^\s*keystore/release\s*=\s*`"([^`"]*)`"").Groups[1].Value

# ---------- 前置检查 ----------
Step "0/5 前置检查"
Hint "export_format=$fmt  versionCode=$code  versionName=`"$name`"  unique_name=`"$uniq`"  signed=$signed"
$preflightFail = 0

if ($uniq -like "*com.example.*") {
    Bad "package/unique_name = ``$uniq`` —— Play 不接受 com.example.*，也不能作为正式 App 身份。"
    Hint "改成你拥有的域名反写，例如 com.<yourdomain>.jieyu（改完等于换 App，旧包无法升级）"
    $preflightFail++
}
if ($uniq -like '*$genname*') {
    Bad "package/unique_name 仍是 Godot 的占位模板 ``com.example.`$genname`` —— 必须写死成真实包名再出发布包。"
    Hint "占位符会让包名依赖导出时的项目名，发布包不能这么干。"
    $preflightFail++
}
if (-not $DebugBuild) {
    if ($fmt -ne "1") {
        Bad "export_format=$fmt 是 **APK**；Play 要 **AAB**（把 gradle_build/export_format 改成 1）"
        $preflightFail++
    }
    if ([string]::IsNullOrWhiteSpace($ksRel)) {
        Bad "没有配置 release keystore（keystore/release 为空）—— 会用 debug 证书签出不能发布的包"
        $preflightFail++
    } elseif (-not (Test-Path -LiteralPath $ksRel)) {
        Bad "keystore/release 指向的文件不存在：$ksRel"
        $preflightFail++
    } else {
        Good "release keystore 已配置且存在"
    }
}
if ($signed -ne "true" -and -not $DebugBuild) {
    Bad "package/signed=$signed —— 发布包必须签名"
    $preflightFail++
}
if ($preflightFail -gt 0) {
    Bad "前置检查有 $preflightFail 项不过。先修，别急着出包。"
    exit 2
}
Good "前置检查通过"

$ext = if ($DebugBuild) { "apk" } else { "aab" }
$tag = if ([string]::IsNullOrWhiteSpace($VersionTag)) { $name } else { $VersionTag }
$artifact = Join-Path $OutDir "jieyu-$tag-$code.$ext"

if ($DryRun) {
    Step "DryRun：下面是要执行的步骤（没有真的跑）"
    Write-Host "  1) 单元测试      : $GodotExe --headless --path <proj> --script res://tools/run_tests_headless.gd"
    Write-Host "  2) 集成冒烟      : $GodotExe --headless --path <proj> --script res://tools/run_integration_headless.gd"
    Write-Host "  3) 导出包验收    : --export-pack Android $tmpDir\jieyu1.pck 然后 --main-pack <pck> --script res://tools/probe_export_pack.gd"
    Write-Host "  4) 导出产物      : --export-$(if ($DebugBuild) { 'debug' } else { 'release' }) Android $artifact"
    Write-Host "  5) 产物校验      : verify_artifact.ps1 -Artifact $artifact -ExpectCode $code"
    Write-Host "`n产物路径会是：$artifact"
    exit 0
}

# ---------- 1) 测试 ----------
if (-not $SkipTests) {
    Step "1/5 单元测试（没全绿就停）"
    & $GodotExe --headless --path $Project --log-file (Join-Path $Project "_rel_tests.log") `
        --script "res://tools/run_tests_headless.gd" | Out-Null
    $rc = $LASTEXITCODE
    if ($rc -ne 0) {
        # 失败项原文才是根因；把汇总行挑出来
        $log = Join-Path $Project "_rel_tests.log"
        if (Test-Path -LiteralPath $log) {
            $t = [System.IO.File]::ReadAllText($log)
            ($t -split "`r?`n" | Where-Object { $_ -match '汇总|FAIL' }) | Select-Object -Last 15 | ForEach-Object { Hint $_ }
        }
        Bad "单元测试没全绿（退出码 $rc）—— 停止出包。日志：$log"
        exit 3
    }
    Good "单元测试全绿"

    Step "2/5 集成冒烟"
    & $GodotExe --headless --path $Project --log-file (Join-Path $Project "_rel_integration.log") `
        --script "res://tools/run_integration_headless.gd" | Out-Null
    $rc2 = $LASTEXITCODE
    if ($rc2 -ne 0) {
        $log2 = Join-Path $Project "_rel_integration.log"
        if (Test-Path -LiteralPath $log2) {
            $t2 = [System.IO.File]::ReadAllText($log2)
            ($t2 -split "`r?`n" | Where-Object { $_ -match 'FAIL|SCRIPT ERROR' }) | Select-Object -Last 15 | ForEach-Object { Hint $_ }
        }
        Bad "集成冒烟没全绿（退出码 $rc2）—— 停止出包。日志：$log2"
        exit 3
    }
    Good "集成冒烟全绿"
} else {
    Step "1-2/5 测试：**已按要求跳过**（-SkipTests）"
    Hint "跳过测试等于放弃「导出成功 ≠ 包里对」的保护，风险自负。"
}

# ---------- 3) 导出包验收 ----------
Step "3/5 导出包内容验收（开发机好 ≠ 包里对）"
$pck = Join-Path $tmpDir "jieyu1.pck"
& $GodotExe --headless --path $Project --log-file (Join-Path $Project "_rel_pack.log") `
    --export-pack "Android" $pck | Out-Null
if (-not (Test-Path -LiteralPath $pck)) {
    Bad "export-pack 没产出 pck —— 见 $(Join-Path $Project '_rel_pack.log')"
    exit 4
}
& $GodotExe --headless --main-pack $pck --log-file (Join-Path $Project "_rel_probe.log") `
    --script "res://tools/probe_export_pack.gd" | Out-Null
$rc3 = $LASTEXITCODE
if ($rc3 -ne 0) {
    $log3 = Join-Path $Project "_rel_probe.log"
    if (Test-Path -LiteralPath $log3) {
        $t3 = [System.IO.File]::ReadAllText($log3)
        ($t3 -split "`r?`n" | Where-Object { $_ -match 'FAIL|导出包' }) | Select-Object -Last 15 | ForEach-Object { Hint $_ }
    }
    Bad "导出包验收没全过（退出码 $rc3）—— 停止出包。日志：$log3"
    exit 3
}
Good "导出包验收全过"

# ---------- 4) 导出 ----------
Step "4/5 导出 $ext"
$mode = if ($DebugBuild) { "--export-debug" } else { "--export-release" }
Hint "$GodotExe $mode Android $artifact"
& $GodotExe --headless --path $Project --log-file (Join-Path $Project "_rel_export.log") `
    $mode "Android" $artifact | Out-Null
$rc4 = $LASTEXITCODE
if (-not (Test-Path -LiteralPath $artifact)) {
    Bad "导出没有产出文件（退出码 $rc4）—— 见 $(Join-Path $Project '_rel_export.log')"
    Hint "release 导出需要 **release 导出模板**；只装了模板不带 release 会失败。"
    exit 4
}
$fi = Get-Item -LiteralPath $artifact
Good ("产物 {0}  {1:N0} 字节 ({2:N2} MiB)" -f $fi.Name, $fi.Length, ($fi.Length / 1MB))

# ---------- 5) 产物校验 ----------
Step "5/5 产物校验（签名 + 包内实际字段）"
$va = Join-Path $PSScriptRoot "verify_artifact.ps1"
if (-not (Test-Path -LiteralPath $va)) { Bad "找不到 verify_artifact.ps1 ($va)"; exit 2 }
$vaArgs = @{ Artifact = $artifact; ExpectCode = [int]$code }
if (-not [string]::IsNullOrWhiteSpace($name)) { $vaArgs.ExpectName = $name }
& $va $vaArgs
$rc5 = $LASTEXITCODE
if ($rc5 -ne 0 -and -not $DebugBuild) { Bad "产物校验没过 —— 不要发布"; exit 5 }
if ($rc5 -ne 0) { Hint "（调试包模式：校验不过只作提醒）" }

Step "完成"
Write-Host "产物 : $artifact"
Write-Host "SHA256: $((Get-FileHash -LiteralPath $artifact -Algorithm SHA256).Hash)"
Write-Host "备份 : export_presets.cfg.bak-* 请自行决定是否清理；_rel_*.log 可删（不该进 git）" -ForegroundColor DarkGray
exit 0
