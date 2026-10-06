# perf_frame.ps1 -- godot-perf-profile / B 路（真机帧时间）· 一条命令完成「取回 + 解析 + 出报告」
#
# 为什么不是 gfxinfo：`dumpsys gfxinfo` 对 Godot 结构性无效（Godot 走原生 SurfaceView，不走 HWUI，
# 实测 Total frames rendered = 0）。也不再用 logcat 窗口当唯一口径 —— 华为私有管理器会在 6~9 s 后
# 停掉采样，拿不到"整局"分布。现在的权威数据是工程侧逐帧落的 CSV（见 systems/debug/PerfCsvWriter.gd）。
#
# 数据来源（二选一）：
#   · 默认走真机：run-as 读**内部** /data/data/<pkg>/files/perf_*.csv（外部专属目录实测是空的）
#   · -LocalCsvDir <目录>：直接分析本地 CSV（桌面 headless 跑 _measure_boot 时用，便于自证链路）
#
# 完成标志（M4 · 2026-10-06）：-WaitForDone 先等同名的 perf_<ts>.done 哨兵，而不是睡固定秒数 ——
#   系统挤占调度时引擎时间会明显慢于墙钟，固定秒数会在探针自退前就把数据取走（实测 60 s 只跑到 40.7 s）。
#   没有哨兵 = 样本被强杀 / 崩在半路 ⇒ **明确报**样本不完整，不当完整样本分析。
#
# 用法：
#   # 真机一条命令：启动 → 等完成标志 → 取回 → 解析（推荐）
#   & perf_frame.ps1 -Launch -WaitForDone -OutDir "D:\Godot4.7_Proj\_perf" -Scenario "固定场景 20v20 60s"
#   # 真机：已经跑完了，只取数
#   & perf_frame.ps1 -OutDir "D:\Godot4.7_Proj\_perf" -Scenario "Main 默认开局 → 20v20 打满 120s"
#   # 桌面自检（不需要真机）
#   & perf_frame.ps1 -LocalCsvDir "$env:APPDATA\Godot\app_userdata\JIEYU1" -OutDir .\_perf
#
# 退出码：0 = 解析成功；2 = 用法/设备问题；3 = 没找到 CSV；4 = 等完成标志超时 / 样本被中断

[CmdletBinding()]
param(
	[string]$Package = 'com.example.jieyu1',
	[string]$Serial,
	# ⚠ 默认**不写当前目录**：如果当前目录在 Godot 工程内，Godot 的导入器会把落下来的 .csv
	# 当成**翻译表**导入，生成 *.csv.import 与 *.delta.translation / *.fps.translation …
	# （2026-10-06 实测踩到，还把它们误提交了）。所以默认放工程外的临时目录，并在下面检测告警。
	[string]$OutDir = "$env:TEMP\godot-perf",
	[string]$Scenario = '（未填写：请写清可复现的操作串）',
	[string]$DeviceUserDir,
	[string]$LocalCsvDir,
	[string]$LogcatFile,
	[switch]$KeepDeviceCopy,
	[switch]$Json,
	# M4：启动应用后等 perf_<ts>.done 完成标志，而不是按固定秒数睡
	[switch]$WaitForDone,
	# 启动应用（monkey 起 LAUNCHER）；配合 -WaitForDone 就是「一条命令跑一轮」
	[switch]$Launch,
	# 等完成标志的上限（秒）。到点还没有哨兵 ⇒ 报「样本被中断」并退 4
	[int]$WaitTimeoutSec = 300,
	[string]$Adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
)

$ErrorActionPreference = 'Stop'

# 建议预算线（技能 SKILL.md 的建议值，不是工程既定标准；要改得写理由并交人拍板）
$BUDGET_50TH = 16.0
$BUDGET_90TH = 25.0
$BUDGET_99TH = 50.0
$BUDGET_JANK_PCT = 5.0
$VSYNC_60_MS = 16.7

function Invoke-Adb {
	param([string[]]$Arguments)
	$prev = $ErrorActionPreference
	$ErrorActionPreference = 'Continue'
	try { $out = & $Adb @Arguments 2>&1 | Out-String } finally { $ErrorActionPreference = $prev }
	return $out
}

## 输出目录是否落在某个 Godot 工程内（有 project.godot 的目录或其子目录）——是则返回该工程根
function Test-InsideGodotProject {
	param([string]$Dir)
	$d = Get-Item -LiteralPath $Dir -ErrorAction SilentlyContinue
	while ($d) {
		if (Test-Path -LiteralPath (Join-Path $d.FullName 'project.godot')) { return $d.FullName }
		$d = $d.Parent
	}
	return $null
}

# 与 GDScript 侧同一套分位数取法：sorted[int(n*p)] 截断，保证 CSV 与同轮 logcat 可比
function Get-Percentile {
	param([double[]]$Sorted, [double]$P)
	if ($Sorted.Count -eq 0) { return $null }
	$i = [Math]::Min([int]($Sorted.Count * $P), $Sorted.Count - 1)
	return $Sorted[$i]
}

function Convert-CsvFile {
	param([string]$Path, [hashtable]$DoneMap = @{})
	$rows = Import-Csv -LiteralPath $Path
	$leaf = Split-Path $Path -Leaf
	$groups = @{}
	foreach ($r in $rows) {
		$t = if ($r.tag) { $r.tag } else { 'match' }
		if (-not $groups.ContainsKey($t)) { $groups[$t] = New-Object System.Collections.ArrayList }
		[void]$groups[$t].Add($r)
	}
	$result = @()
	foreach ($t in $groups.Keys) {
		$ms = @($groups[$t] | ForEach-Object { [double]$_.delta_ms })
		$sorted = $ms | Sort-Object
		$spanMs = ($ms | Measure-Object -Sum).Sum
		$jank = @($ms | Where-Object { $_ -gt $VSYNC_60_MS }).Count
		# 最长连续超预算（logcat 窗口看不到这个量）
		$run = 0; $worstRun = 0
		foreach ($v in $ms) { if ($v -gt $VSYNC_60_MS) { $run++; if ($run -gt $worstRun) { $worstRun = $run } } else { $run = 0 } }
		$result += [pscustomobject]@{
			tag           = $t
			frames        = $ms.Count
			span_s        = [Math]::Round($spanMs / 1000.0, 2)
			fps           = if ($spanMs -gt 0) { [Math]::Round($ms.Count * 1000.0 / $spanMs, 1) } else { $null }
			p50           = [Math]::Round((Get-Percentile $sorted 0.50), 1)
			p90           = [Math]::Round((Get-Percentile $sorted 0.90), 1)
			p99           = [Math]::Round((Get-Percentile $sorted 0.99), 1)
			max           = [Math]::Round($sorted[$sorted.Count - 1], 1)
			jank_pct      = [Math]::Round(100.0 * $jank / [Math]::Max($ms.Count, 1), 2)
			worst_run     = $worstRun
			steps_per_frm = [Math]::Round((($groups[$t] | Measure-Object -Property physics_steps_delta -Average).Average), 2)
			csv           = $leaf
			complete      = [bool]$DoneMap.ContainsKey($leaf)
		}
	}
	return $result
}

# ---- 取数 ----
$files = @()
if ($LocalCsvDir) {
	if (-not (Test-Path -LiteralPath $LocalCsvDir)) { Write-Host "本地目录不存在：$LocalCsvDir"; exit 2 }
	$files = @(Get-ChildItem -LiteralPath $LocalCsvDir -Filter 'perf_*.csv' | Sort-Object LastWriteTime -Descending | Select-Object -First 5)
	if ($files.Count -eq 0) { Write-Host "在 $LocalCsvDir 下没找到 perf_*.csv"; exit 3 }
	Write-Host "[perf] 本地分析 $($files.Count) 个 CSV（$LocalCsvDir）"
	# 允许离线做「CSV vs logcat」交叉验证：-LogcatFile 给一份含 [测帧] 行的日志即可
	if ($LogcatFile -and (Test-Path -LiteralPath $LogcatFile)) {
		$logcatText = Get-Content -LiteralPath $LogcatFile -Raw -Encoding UTF8
		Write-Host "[perf] 已载入 logcat 交叉验证源：$LogcatFile"
	} else { $logcatText = '' }
} else {
	if (-not (Test-Path -LiteralPath $Adb)) { Write-Host "adb 不存在：$Adb"; exit 2 }
	if ($Serial) { $dev = @($Serial) } else {
		$lines = Invoke-Adb @('devices')
		$dev = @(($lines -split "`r?`n") | ForEach-Object { if ($_ -match '^\s*(\S+)\s+device$') { $Matches[1] } })
	}
	if ($dev.Count -eq 0) { Write-Host '没有可用设备（先看 android-device-verify 第 0 步）'; exit 2 }
	$Serial = $dev[0]
	New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
	$OutDir = (Resolve-Path -LiteralPath $OutDir).Path
	$proj = Test-InsideGodotProject $OutDir
	if ($proj) {
		Write-Host "[perf] ⚠ 输出目录在 Godot 工程内（$proj）"
		Write-Host '[perf]   Godot 的导入器会把 .csv 当**翻译表**导入，生成 *.csv.import / *.delta.translation …'
		Write-Host '[perf]   请改到工程外，例如 -OutDir "D:\Godot4.7_Proj\_perf"'
	}

	# ---- M4：启动 + 等完成标志（替代「睡固定秒数再取」）----
	if ($Launch) {
		# 清掉上一轮遗留的样本，保证「等到的完成标志」一定是这一轮的
		[void](Invoke-Adb @('-s', $Serial, 'shell', "run-as $Package sh -c 'rm -f files/perf_*.csv files/perf_*.done'"))
		[void](Invoke-Adb @('-s', $Serial, 'logcat', '-c'))
		[void](Invoke-Adb @('-s', $Serial, 'shell', 'monkey', '-p', $Package, '-c', 'android.intent.category.LAUNCHER', '1'))
		Write-Host "[perf] 已清旧样本并启动 $Package（logcat 已清）"
	}
	$waitIncomplete = $false
	if ($WaitForDone) {
		Write-Host "[perf] 等完成标志 files/perf_*.done（上限 $WaitTimeoutSec s；引擎时间慢于墙钟是正常的）…"
		$deadline = (Get-Date).AddSeconds($WaitTimeoutSec)
		$waited = 0
		$found = @()
		while ((Get-Date) -lt $deadline) {
			$listing = Invoke-Adb @('-s', $Serial, 'shell', "run-as $Package sh -c 'ls files/perf_*.done 2>/dev/null'")
			$found = @(($listing -split "`r?`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ -match 'perf_\d.*\.done$' })
			if ($found.Count -gt 0) { Write-Host "[perf] 收到完成标志：$($found[-1])（等了 $waited s）"; break }
			$alive = (Invoke-Adb @('-s', $Serial, 'shell', 'pidof', $Package)).Trim()
			if ([string]::IsNullOrWhiteSpace($alive)) {
				Write-Host '[perf] ⚠ 进程已退出但没有完成标志 ⇒ 这一轮多半被系统强杀 / 崩在半路'
				$waitIncomplete = $true
				break
			}
			Start-Sleep -Seconds 2
			$waited += 2
		}
		if (-not $waitIncomplete -and $found.Count -eq 0) {
			Write-Host "[perf] ⚠ 等完成标志超时（$WaitTimeoutSec s）⇒ 样本可能被截断"
			$waitIncomplete = $true
		}
	}

	# ⚠ user:// 在 Android 上是**内部**目录：/data/data/<pkg>/files（2026-10-06 实测：
	#   /sdcard/Android/data/<pkg>/files 是**空的**）。所以要走 run-as（debug 包可用），
	#   `adb pull` 读不到内部目录。取文件用 `exec-out run-as ... cat` + cmd 重定向（PS 的 `>` 会改写字节）。
	$viaRunAs = $true
	$listing = Invoke-Adb @('-s', $Serial, 'shell', "run-as $Package sh -c 'ls files/perf_*.csv 2>/dev/null'")
	$remote = @(($listing -split "`r?`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ -match 'perf_\d.*\.csv$' })
	if ($remote.Count -eq 0) {
		# 退路：外部专属目录（某些设备/导出组合会落在这里）
		$viaRunAs = $false
		if (-not $DeviceUserDir) { $DeviceUserDir = "/sdcard/Android/data/$Package/files" }
		$listing = Invoke-Adb @('-s', $Serial, 'shell', "ls $DeviceUserDir/perf_*.csv 2>/dev/null")
		$remote = @(($listing -split "`r?`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ -match 'perf_\d.*\.csv$' })
	}
	if ($remote.Count -eq 0) {
		Write-Host "设备上没有 perf_*.csv（内部 files/ 与外部专属目录都查过了）"
		Write-Host '  ⇒ 先跑一局：调试包才会落盘；注意华为 iaware 会冻结/强停本包（见施工单 §4 M1 的人工放行步骤）'
		exit 3
	}
	$viaText = if ($viaRunAs) { '内部 files/（run-as）' } else { '外部专属目录（pull）' }
	Write-Host "[perf] 设备 $Serial 上有 $($remote.Count) 个 CSV，来源：$viaText"
	$localDir = Join-Path $OutDir ('perf_' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
	New-Item -ItemType Directory -Force -Path $localDir | Out-Null
	foreach ($r in $remote) {
		$name = Split-Path $r -Leaf
		if ($viaRunAs) {
			$dest = Join-Path $localDir $name
			$prev = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
			try { & $env:ComSpec /c "`"$Adb`" -s $Serial exec-out run-as $Package cat `"$r`" > `"$dest`"" | Out-Null }
			finally { $ErrorActionPreference = $prev }
		} else {
			[void](Invoke-Adb @('-s', $Serial, 'pull', $r, $localDir))
		}
	}
	$files = @(Get-ChildItem -LiteralPath $localDir -Filter 'perf_*.csv')
	# 完成标志也一起取回：报告里逐文件标「完整 / 不完整」
	$listingDone = if ($viaRunAs) {
		Invoke-Adb @('-s', $Serial, 'shell', "run-as $Package sh -c 'ls files/perf_*.done 2>/dev/null'")
	} else {
		Invoke-Adb @('-s', $Serial, 'shell', "ls $DeviceUserDir/perf_*.done 2>/dev/null")
	}
	$remoteDone = @(($listingDone -split "`r?`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ -match 'perf_\d.*\.done$' })
	foreach ($r in $remoteDone) {
		$name = Split-Path $r -Leaf
		if ($viaRunAs) {
			$dest = Join-Path $localDir $name
			$prev = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
			try { & $env:ComSpec /c "`"$Adb`" -s $Serial exec-out run-as $Package cat `"$r`" > `"$dest`"" | Out-Null }
			finally { $ErrorActionPreference = $prev }
		} else {
			[void](Invoke-Adb @('-s', $Serial, 'pull', $r, $localDir))
		}
	}
	if ($remoteDone.Count -gt 0) { Write-Host "[perf] 完成标志 $($remoteDone.Count) 个已取回" }
	# 同轮 logcat 的 [测帧] 行：用于自证 CSV 与 logcat 分位数一致
	$logcatText = Invoke-Adb @('-s', $Serial, 'logcat', '-d', '-v', 'brief')
	$logcatText = ($logcatText -split "`r?`n" | Where-Object { $_ -match '\[测帧\]|\[perf-csv\]' }) -join "`n"
	Set-Content -LiteralPath (Join-Path $localDir 'logcat_frame_lines.txt') -Value $logcatText -Encoding UTF8
	if (-not $KeepDeviceCopy) {
		if ($viaRunAs) {
			[void](Invoke-Adb @('-s', $Serial, 'shell', "run-as $Package sh -c 'rm -f files/perf_*.csv files/perf_*.done'"))
		} else {
			[void](Invoke-Adb @('-s', $Serial, 'shell', 'rm', '-f', "$DeviceUserDir/perf_*.csv", "$DeviceUserDir/perf_*.done"))
		}
		Write-Host '[perf] 已删除设备侧 CSV 与完成标志（-KeepDeviceCopy 可保留）'
	}
	Write-Host "[perf] 已取回到 $localDir"
}

# ---- 完成标志（M4）：csv 文件名 → {frames, span_s, tag, driver} ----
$doneMap = @{}
$csvDir = if ($files.Count -gt 0) { Split-Path $files[0].FullName -Parent } else { $null }
if ($csvDir) {
	foreach ($df in @(Get-ChildItem -LiteralPath $csvDir -Filter 'perf_*.done' -ErrorAction SilentlyContinue)) {
		$csvLeaf = $df.Name -replace '\.done$', '.csv'
		$info = @{}
		foreach ($line in @(Get-Content -LiteralPath $df.FullName -Encoding UTF8)) {
			if ($line -match '^(\w+)=(.*)$') { $info[$Matches[1]] = $Matches[2] }
		}
		$doneMap[$csvLeaf] = [pscustomobject]@{
			file   = $df.Name
			tag    = if ($info.ContainsKey('tag')) { [string]$info['tag'] } else { '?' }
			driver = if ($info.ContainsKey('driver')) { [string]$info['driver'] } else { '?' }
			frames = if ($info.ContainsKey('frames')) { [int]$info['frames'] } else { $null }
			span_s = if ($info.ContainsKey('span_ms')) { [Math]::Round([double]$info['span_ms'] / 1000.0, 2) } else { $null }
		}
	}
}

# ---- 解析 ----
$all = @()
foreach ($f in $files) { $all += Convert-CsvFile $f.FullName $doneMap }
$all = @($all | Sort-Object tag)

# ---- 与同轮 logcat 分位数交叉验证（施工单 M1 的验收：两者在噪声内一致）----
$cross = @()
if ($logcatText) {
	foreach ($line in ($logcatText -split "`r?`n")) {
		if ($line -notmatch '\[测帧\]') { continue }
		$m = [regex]::Match($line, '\[测帧\]\s+(\S+)\s+\|.*p50=([\d.]+)\s+p90=([\d.]+)\s+p99=([\d.]+)')
		if (-not $m.Success) { continue }
		$tag = $m.Groups[1].Value
		$csvRow = $all | Where-Object { $_.tag -eq $tag } | Select-Object -First 1
		if (-not $csvRow) { continue }
		$cross += [pscustomobject]@{
			tag = $tag
			logcat = "$($m.Groups[2].Value)/$($m.Groups[3].Value)/$($m.Groups[4].Value)"
			csv    = "$($csvRow.p50)/$($csvRow.p90)/$($csvRow.p99)"
			dp50   = [Math]::Round([double]$csvRow.p50 - [double]$m.Groups[2].Value, 1)
		}
	}
}

if ($Json) {
	[pscustomobject]@{ scenario = $Scenario; rows = $all; crosscheck = $cross } | ConvertTo-Json -Depth 5
	exit 0
}

# ---- 报告（固定格式，便于逐轮对比）----
Write-Host ''
Write-Host ('=' * 96)
Write-Host "轮次/日期  : $(Get-Date -Format 'yyyy-MM-dd')"
Write-Host "场景与操作 : $Scenario"
Write-Host "采样口径   : 工程侧逐帧 CSV（systems/debug/PerfCsvWriter.gd）· 60 Hz FIFO 下帧时间量化到 16.7/33.3/50.0 ms"
Write-Host ('=' * 96)
$fmt = "{0,-34} {1,7} {2,7} {3,7} {4,7} {5,7} {6,7} {7,8} {8,8} {9,7} {10,5}"
Write-Host ($fmt -f 'tag', '帧数', '时长s', 'fps', 'p50', 'p90', 'p99', 'max', 'jank%', '最长连击', '完整')
foreach ($r in $all) {
	$flag = ''
	if ($r.p99 -gt $BUDGET_99TH) { $flag += ' p99超线' }
	if ($r.jank_pct -gt $BUDGET_JANK_PCT) { $flag += ' jank超线' }
	if (-not $r.complete) { $flag += ' 样本不完整' }
	Write-Host (($fmt -f $r.tag, $r.frames, $r.span_s, $r.fps, $r.p50, $r.p90, $r.p99, $r.max, $r.jank_pct, $r.worst_run, $(if ($r.complete) { 'yes' } else { 'NO' })) + $flag)
	# ⚠ 必须打印来源文件：本脚本会把设备上最多 5 个 CSV 都拉回来合并成一张表，而**不同 CSV 的 tag 会重名**
	# （例如每轮扫描都有一份 01_base）。2026-10-06 我就因此拿"变体扫描那一轮"的数据去分析固定场景那一轮，
	# 结论全错、还得回头重算。**分析前先按这一列核对文件。**
	Write-Host ("      └ 来源: {0}" -f $r.csv)
}
Write-Host ''
Write-Host ("建议线：p50 ≤ {0} / p90 ≤ {1} / p99 ≤ {2} / jank ≤ {3}%（建议值，非既定标准）" -f $BUDGET_50TH, $BUDGET_90TH, $BUDGET_99TH, $BUDGET_JANK_PCT)
if ($cross.Count -gt 0) {
	Write-Host ''
	Write-Host '同轮 logcat vs CSV 分位数（自证落盘链路没写错）:'
	foreach ($c in $cross) { Write-Host ("  {0,-34} logcat {1,-18} CSV {2,-18} Δp50={3} ms" -f $c.tag, $c.logcat, $c.csv, $c.dp50) }
}
if ($doneMap.Count -gt 0) {
	Write-Host ''
	Write-Host '完成标志（perf_*.done · 只有干净跑完才会写）:'
	foreach ($k in ($doneMap.Keys | Sort-Object)) {
		$d = $doneMap[$k]
		Write-Host ("  {0,-30} tag={1,-24} frames={2,-7} span={3}s driver={4}" -f $d.file, $d.tag, $d.frames, $d.span_s, $d.driver)
	}
} else {
	Write-Host ''
	Write-Host '完成标志 : 无（没有 perf_*.done）⇒ 这批样本都不是干净跑完的，按「被中断」解读'
}
Write-Host ''
Write-Host '说明：`最长连击` = 连续超 16.7 ms 的最大帧数（logcat 窗口看不到这个量）。'
if ($WaitForDone -and ($waitIncomplete -or $doneMap.Count -eq 0)) {
	Write-Host '[perf] 退出码 4：等完成标志失败 / 样本被中断 —— 别拿这批数当完整分布。'
	exit 4
}
exit 0
