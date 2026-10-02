# bump_version.ps1 —— 升 jieyu-1 的 Android 版本号（export_presets.cfg 的 version/code + version/name）
#
# 为什么用脚本而不是手改：这两行分处不同位置、格式不同，手改容易漏一边或改错行；
# 而且 versionCode 忘了涨会被商店直接拒。本脚本：先备份 → 只改这两行 → 回读校验。
#
# 用法：
#   # versionCode +1，versionName 不动
#   pwsh -File bump_version.ps1 -Project "D:\Godot4.7_Proj\jieyu-1"
#   # versionCode +1，同时把 versionName 设成 0.2.0
#   pwsh -File bump_version.ps1 -Project "..." -VersionName "0.2.0"
#   # 只查看当前值
#   pwsh -File bump_version.ps1 -Project "..." -Show
#
# 退出码：0 = 成功（或 -Show）；2 = 前置检查失败；3 = 写入后校验不一致（已回滚）

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Project,
    [string]$VersionName = "",
    [int]$Bump = 1,
    [switch]$Show
)

$ErrorActionPreference = "Stop"

$cfg = Join-Path $Project "export_presets.cfg"
if (-not (Test-Path -LiteralPath $cfg)) { Write-Error "找不到 $cfg"; exit 2 }

$raw = [System.IO.File]::ReadAllText($cfg)
$eol = if ($raw -match "`r`n") { "`r`n" } else { "`n" }
$lines = $raw -split "`r?`n"

$codeIdx = -1
$nameIdx = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*version/code\s*=') { $codeIdx = $i }
    if ($lines[$i] -match '^\s*version/name\s*=') { $nameIdx = $i }
}

if ($codeIdx -lt 0 -or $nameIdx -lt 0) {
    Write-Error "在 $cfg 里找不到 version/code 或 version/name 行（count=$($lines.Count)）。拒绝猜测，先人工确认格式。"
    exit 2
}

$curCode = [int]([regex]::Match($lines[$codeIdx], '=\s*(\d+)').Groups[1].Value)
$curName = [regex]::Match($lines[$nameIdx], '=\s*"([^"]*)"').Groups[1].Value

Write-Host "当前：version/code = $curCode   version/name = `"$curName`""

if ($Show) { exit 0 }

$newCode = $curCode + $Bump
if ($newCode -lt 1) { Write-Error "versionCode 不能小于 1（算出来是 $newCode）"; exit 2 }
if ($newCode -le $curCode -and $Bump -le 0) {
    Write-Host "提醒：versionCode 没有增加（$curCode → $newCode）。商店会拒绝重复的 versionCode。" -ForegroundColor Yellow
}

$newName = if ([string]::IsNullOrWhiteSpace($VersionName)) { $curName } else { $VersionName }
if ($newName -notmatch '^\d+\.\d+\.\d+') {
    Write-Host "提醒：versionName `"$newName`" 不是 主.次.修订 形式。建议用语义化版本（如 0.2.0）。" -ForegroundColor Yellow
}

# 备份
$bak = "$cfg.bak-" + (Get-Date -Format "yyyyMMdd-HHmmss")
Copy-Item -LiteralPath $cfg -Destination $bak -Force
Write-Host "已备份：$bak"

$lines[$codeIdx] = "version/code=$newCode"
$lines[$nameIdx] = "version/name=`"$newName`""

[System.IO.File]::WriteAllText($cfg, ($lines -join $eol))

# 回读校验
$check = [System.IO.File]::ReadAllText($cfg)
$gotCode = [int]([regex]::Match($check, '(?m)^\s*version/code\s*=\s*(\d+)').Groups[1].Value)
$gotName = [regex]::Match($check, '(?m)^\s*version/name\s*=\s*"([^"]*)"').Groups[1].Value

if ($gotCode -ne $newCode -or $gotName -ne $newName) {
    Write-Error "写入后校验不一致（期望 code=$newCode name=$newName，实得 code=$gotCode name=$gotName）—— 从 $bak 回滚。"
    Copy-Item -LiteralPath $bak -Destination $cfg -Force
    exit 3
}

Write-Host "新值：version/code = $gotCode   version/name = `"$gotName`"" -ForegroundColor Green
Write-Host "下一步：跑 build_aab.ps1 出包（它会再核对一次包内实际版本号）。" -ForegroundColor Cyan
exit 0
