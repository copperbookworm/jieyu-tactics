# perf_gfxinfo.ps1 —— godot-perf-profile / B 路 · 真机帧时间与卡顿采集（Android 权威口径）
#
# 流程：gfxinfo reset（清统计）→ 留给你做操作 → 抓取 → 解析帧时间分布 / jank 占比 / 建议线判定
#
# 用法：
#   pwsh -File perf_gfxinfo.ps1 -OutDir <输出目录> [-Package com.example.jieyu1] [-DoSeconds 30]
#
# 退出码：0 = 采到并解析成功；2 = 无设备/用法问题；3 = 抓取到但解析不出帧统计

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$OutDir,
    [string]$Package = "com.example.jieyu1",
    [string]$Adb = "C:\Users\feiyun\AppData\Local\Android\Sdk\platform-tools\adb.exe",
    [int]$DoSeconds = 30
)

$ErrorActionPreference = "Stop"

# 建议预算线（技能 SKILL.md 里的建议值；不是工程既定标准）
$BUDGET_50TH = 16.0
$BUDGET_90TH = 25.0
$BUDGET_99TH = 50.0
$BUDGET_JANK_PCT = 5.0

if (-not (Test-Path -LiteralPath $Adb)) { Write-Error "adb 不存在：$Adb"; exit 2 }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$OutDir = (Resolve-Path -LiteralPath $OutDir).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

$devices = & $Adb devices 2>&1 | Out-String
if ($devices -notmatch '(?m)^\s*\S+\s+device\s*$') {
    Write-Error "没有 online 的设备。先按 android-device-verify 第 0 步接好设备，再跑本脚本。"
    exit 2
}

Write-Host "=== 1/4 清 gfxinfo 统计（必须在测之前）" -ForegroundColor Cyan
& $Adb shell dumpsys gfxinfo $Package reset 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Error "gfxinfo reset 失败：包名 $Package 可能不存在或应用没跑过。先装包并启动一次。"
    exit 3
}

Write-Host @"
=== 2/4 现在去设备上做要测的操作（$DoSeconds 秒）
    要求：把「能复现的一串动作」做完，并记下来（进载具 → 三档相机 → 开火 20 发 …）
    脚本会等 $DoSeconds 秒再抓取。
"@ -ForegroundColor Yellow
for ($i = $DoSeconds; $i -gt 0; $i--) {
    Write-Progress -Activity "等待操作" -Status "剩余 $i 秒" -PercentComplete (100 * ($DoSeconds - $i) / $DoSeconds)
    Start-Sleep -Seconds 1
}
Write-Progress -Activity "等待操作" -Completed

Write-Host "=== 3/4 抓取 dumpsys gfxinfo" -ForegroundColor Cyan
$txt = Join-Path $OutDir "perf_gfxinfo_$stamp.txt"
& $Adb shell dumpsys gfxinfo $Package > $txt
Write-Host "原始输出：$txt"

$raw = [System.IO.File]::ReadAllText($txt)
if ([string]::IsNullOrWhiteSpace($raw)) { Write-Error "抓到的输出为空。"; exit 3 }

function Get-Num([string]$pattern, [string]$text) {
    $m = [regex]::Match($text, $pattern)
    if ($m.Success) { return [double]$m.Groups[1].Value }
    return $null
}

Write-Host "`n=== 4/4 解析结果 ===" -ForegroundColor Cyan

$total = Get-Num 'Total frames rendered:\s*(\d+)' $raw
$janky = Get-Num 'Janky frames:\s*(\d+)' $raw
$jankyPct = Get-Num 'Janky frames:\s*\d+\s*\(([\d.]+)%\)' $raw
$p50 = Get-Num '50th percentile:\s*(\d+)ms' $raw
$p90 = Get-Num '90th percentile:\s*(\d+)ms' $raw
$p95 = Get-Num '95th percentile:\s*(\d+)ms' $raw
$p99 = Get-Num '99th percentile:\s*(\d+)ms' $raw

if ($null -eq $total -and $null -eq $p50) {
    Write-Error "解析不出帧统计。可能：① 应用没在前台渲染 ② 该 Android 版本输出格式不同。请人工看 $txt"
    exit 3
}

$model = (& $Adb shell getprop ro.product.model 2>&1 | Out-String).Trim()
$rel   = (& $Adb shell getprop ro.build.version.release 2>&1 | Out-String).Trim()

$lines = @()
$lines += "设备      : $model / Android $rel"
$lines += "包名      : $Package"
$lines += "采样      : 抓取前 reset，人工操作 $DoSeconds 秒后抓取"
$lines += "总帧数    : $(if ($null -ne $total) { $total } else { '取不到' })"
$lines += "50th/90th/95th/99th : $(if ($null -ne $p50) { $p50 } else { '?' }) / $(if ($null -ne $p90) { $p90 } else { '?' }) / $(if ($null -ne $p95) { $p95 } else { '?' }) / $(if ($null -ne $p99) { $p99 } else { '?' }) ms"
$lines += "Janky     : $(if ($null -ne $janky) { $janky } else { '?' }) 帧$(if ($null -ne $jankyPct) { "（$jankyPct%）" } else { "" })"

$verdicts = @()
function Judge([string]$name, $value, [double]$budget, [string]$unit) {
    if ($null -eq $value) { return "$name : 取不到 —— 不作判定" }
    if ($value -le $budget) { return "$name : $value$unit ≤ 建议线 $budget$unit  ✅" }
    return "$name : $value$unit > 建议线 $budget$unit  ⚠ 超线"
}
$verdicts += Judge "50th" $p50 $BUDGET_50TH "ms"
$verdicts += Judge "90th" $p90 $BUDGET_90TH "ms"
$verdicts += Judge "99th" $p99 $BUDGET_99TH "ms"
$verdicts += Judge "Janky%" $jankyPct $BUDGET_JANK_PCT "%"

$lines += ""
$lines += "— 建议预算线判定（建议值，非工程既定标准；首次实数要登记并交人拍板）"
$lines += $verdicts

$summaryPath = Join-Path $OutDir "perf_summary_$stamp.txt"
$lines -join "`r`n" | Set-Content -LiteralPath $summaryPath -Encoding utf8

$lines | ForEach-Object { Write-Host $_ }
Write-Host "`n摘要已落盘：$summaryPath" -ForegroundColor Green
Write-Host "提醒：报告必须带上「能复现的那串操作」；没有操作描述的帧时间数字不可复现。" -ForegroundColor Cyan
exit 0
