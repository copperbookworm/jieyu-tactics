# android_verify.ps1 —— jieyu-1 真机验证固定流程（装包 → 启动 → logcat → 截图）
#
# 只读式：不改工程、不卸载、不改 ACL。任何一步失败就地报错并保留现场。
#
# 用法：
#   pwsh -File android_verify.ps1 -Apk <apk路径> [-OutDir <输出目录>] [-Package <包名>] [-WaitSeconds 10]
#
# 退出码：0 = 全流程通过；2 = 没有设备/设备未授权；3 = 装包失败；4 = 进程未起来（可能崩了）

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Apk,
    [string]$OutDir = "",
    [string]$Package = "io.github.copperbookworm.jieyu",
    [string]$Adb = "C:\Users\feiyun\AppData\Local\Android\Sdk\platform-tools\adb.exe",
    [int]$WaitSeconds = 10
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Adb)) { Write-Error "adb 不存在：$Adb"; exit 2 }
if (-not (Test-Path -LiteralPath $Apk)) { Write-Error "APK 不存在：$Apk"; exit 3 }
$Apk = (Resolve-Path -LiteralPath $Apk).Path

if ([string]::IsNullOrWhiteSpace($OutDir)) {
    $OutDir = Join-Path (Split-Path -Parent $Apk) "_verify_android"
}
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$OutDir = (Resolve-Path -LiteralPath $OutDir).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

function Write-Step($msg) { Write-Host "`n=== $msg" -ForegroundColor Cyan }

# ---------- 第 0 步：设备 ----------
Write-Step "0/5 枚举设备"
$devicesRaw = & $Adb devices -l 2>&1 | Out-String
Write-Host $devicesRaw.Trim()

$serial = $null
foreach ($line in ($devicesRaw -split "`r?`n")) {
    if ($line -match '^\s*(\S+)\s+(device|unauthorized|offline)\b') {
        $state = $Matches[2]
        if ($state -eq "device") { $serial = $Matches[1]; break }
        if ($state -eq "unauthorized") { Write-Error "设备 $($Matches[1]) 未授权：请在手机上点「允许 USB 调试」"; exit 2 }
        if ($state -eq "offline") { Write-Error "设备 $($Matches[1]) 处于 offline：先 & `$adb kill-server; & `$adb start-server 重试"; exit 2 }
    }
}
if (-not $serial) { Write-Error "当前没有已授权且 online 的设备（adb devices 里没有 device 行）。流程在此停止——如实报告没设备。"; exit 2 }
if (($devicesRaw -split "`r?`n" | Where-Object { $_ -match '^\s*\S+\s+device\b' }).Count -gt 1) {
    Write-Warning "检测到多台设备，使用第一台：$serial（如需指定请改脚本加 -s）"
}
Write-Host "选中设备：$serial" -ForegroundColor Green

$model = (& $Adb -s $serial shell getprop ro.product.model 2>&1 | Out-String).Trim()
$rel   = (& $Adb -s $serial shell getprop ro.build.version.release 2>&1 | Out-String).Trim()
$wm    = (& $Adb -s $serial shell wm size 2>&1 | Out-String).Trim()
Write-Host "型号=$model  Android=$rel  $wm"

# ---------- 第 1 步：装包 ----------
Write-Step "1/5 安装 $([System.IO.Path]::GetFileName($Apk))"
$install = & $Adb -s $serial install -r $Apk 2>&1 | Out-String
Write-Host $install.Trim()
if ($install -notmatch "Success") {
    Write-Error "装包失败。常见原因：架构不匹配（本 APK 仅 arm64-v8a）、签名冲突（先 uninstall，会清 user://）、存储不足。"
    exit 3
}

# ---------- 第 2 步：清日志 → 启动 → 抓日志 ----------
Write-Step "2/5 清 logcat 缓冲并启动"
& $Adb -s $serial logcat -c | Out-Null
& $Adb -s $serial shell monkey -p $Package -c android.intent.category.LAUNCHER 1 2>&1 | Out-Null

Write-Host "等待 $WaitSeconds 秒让启动稳定…"
Start-Sleep -Seconds $WaitSeconds

$logPath = Join-Path $OutDir "logcat_$stamp.txt"
& $Adb -s $serial logcat -d -v time > $logPath
Write-Host "logcat 已落盘：$logPath"

Write-Step "3/5 扫描关键行"
$patterns = @("SCRIPT ERROR", "FATAL EXCEPTION", "Parse Error", "GodotEngine", "AndroidRuntime")
$hits = Select-String -Path $logPath -Pattern $patterns -SimpleMatch -ErrorAction SilentlyContinue
if ($hits) {
    Write-Host "命中 $($hits.Count) 行，以下为原文（最多 40 行）：" -ForegroundColor Yellow
    $hits | Select-Object -First 40 | ForEach-Object { Write-Host ("  [{0}] {1}" -f $_.LineNumber, $_.Line) }
} else {
    Write-Host "无 SCRIPT ERROR / FATAL EXCEPTION / Parse Error 命中。" -ForegroundColor Green
}

# ---------- 第 4 步：进程存活 ----------
Write-Step "4/5 进程存活检查"
$pidRaw = (& $Adb -s $serial shell pidof $Package 2>&1 | Out-String).Trim()
$alive = -not [string]::IsNullOrWhiteSpace($pidRaw)
if ($alive) { Write-Host "进程存活，pid=$pidRaw" -ForegroundColor Green }
else        { Write-Host "进程不存在 —— 很可能启动即崩，先看 logcat 的 FATAL / SCRIPT ERROR。" -ForegroundColor Red }

# ---------- 第 5 步：截图 ----------
Write-Step "5/5 截图"
$shots = Join-Path $OutDir "shots"
New-Item -ItemType Directory -Force -Path $shots | Out-Null
$png = Join-Path $shots "真机_${stamp}_启动后.png"
# 必须走 exec-out 且由 cmd 重定向，避免 PowerShell 文本管道破坏 PNG 二进制
& cmd.exe /c "`"$Adb`" -s $serial exec-out screencap -p > `"$png`""
if ((Test-Path $png) -and (Get-Item $png).Length -gt 0) {
    Write-Host "截图：$png（$((Get-Item $png).Length) 字节）" -ForegroundColor Green
} else {
    Write-Warning "截图失败或为空：$png"
    $png = $null
}

# ---------- 摘要 ----------
Write-Step "证据摘要（可直接粘进报告）"
Write-Host "设备    : $serial / $model / Android $rel / $wm"
Write-Host "APK     : $Apk"
Write-Host "包名    : $Package"
Write-Host "日志    : $logPath"
Write-Host "截图    : $(if ($png) { $png } else { '(失败)' })"
Write-Host "进程    : $(if ($alive) { "存活 pid=$pidRaw" } else { '不存在（疑似崩溃）' })"
Write-Host "关键字  : $(if ($hits) { "命中 $($hits.Count) 行" } else { '无命中' })"
Write-Host "`n下一步：把上面的日志原文与截图交给用户 / 自己 read_image 看图定性。" -ForegroundColor Cyan

if (-not $alive) { exit 4 }
exit 0
