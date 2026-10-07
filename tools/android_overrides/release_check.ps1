<#
  release_check.ps1 -- 发布前置检查（不改工程、不出包，只回答「现在能不能发」）
  ---------------------------------------------------------------------------
  来源：skills/release-engineering-android 第 0 步与铁律 1
    「没改包名、没换 release keystore、没升 versionCode —— 不要点发布」

  它检查的是**工作区里的发布配置**（export_presets.cfg + keystore + 图标 + .gitignore），
  不是产物；产物本身用 skills/release-engineering-android/scripts/verify_artifact.ps1 验。

  用法：& "D:\Godot4.7_Proj\jieyu-1\tools\android_overrides\release_check.ps1"
  退出码：0 = 关键项全过；1 = 有关键项没过（次要项只提醒）
#>
param(
	[string]$ProjectDir = (Resolve-Path "$PSScriptRoot\..\..").Path,
	[string]$KeystorePasswordFile = 'D:\keys\jieyu-release-PASSWORD.txt'
)

$ErrorActionPreference = 'Stop'
$cfgPath = Join-Path $ProjectDir 'export_presets.cfg'
if (-not (Test-Path $cfgPath)) { Write-Error "找不到 $cfgPath"; exit 1 }
$cfg = [System.IO.File]::ReadAllText($cfgPath)

function Get-Value {
	param([string]$Key)
	$m = [regex]::Match($cfg, ('(?m)^' + [regex]::Escape($Key) + '=(.*)$'))
	if ($m.Success) { return $m.Groups[1].Value.Trim().Trim('"') }
	return $null
}

$critical = @()
$warn = @()
function Check([string]$Title, [bool]$Ok, [string]$Actual, [bool]$IsCritical) {
	if ($Ok) { Write-Host ("[OK]   {0}  ({1})" -f $Title, $Actual) }
	else {
		if ($IsCritical) { Write-Host ("[FAIL] {0}  ({1})" -f $Title, $Actual); $script:critical += $Title }
		else { Write-Host ("[WARN] {0}  ({1})" -f $Title, $Actual); $script:warn += $Title }
	}
}

$pkg = Get-Value 'package/unique_name'
$verName = Get-Value 'version/name'
$verCode = Get-Value 'version/code'
$minSdk = Get-Value 'gradle_build/min_sdk'
$fmt = Get-Value 'gradle_build/export_format'
$ksPath = Get-Value 'keystore/release'
$ksPwd = Get-Value 'keystore/release_password'
$iconMain = Get-Value 'launcher_icons/main_192x192'
$iconFg = Get-Value 'launcher_icons/adaptive_foreground_432x432'
$iconBg = Get-Value 'launcher_icons/adaptive_background_432x432'

Check '包名不是 com.example.*（Play 明确不接受）' ($pkg -and $pkg -notlike 'com.example.*') $pkg $true
Check 'version/name 是 主.次.修订' ($verName -match '^\d+\.\d+\.\d+$') $verName $true
Check 'version/code >= 1（每次上架严格递增）' ([int]$verCode -ge 1) $verCode $true
Check 'gradle_build/min_sdk 显式写 24（留空会拿到 Godot 默认 29）' ($minSdk -eq '24') $minSdk $true
Check 'gradle_build/export_format = 0（工作区保持 APK；AAB 由包装脚本临时切）' ($fmt -eq '0') $fmt $true
Check 'keystore/release_password 为空（口令不许进版本库）' ([string]::IsNullOrEmpty($ksPwd)) ("长度 " + $ksPwd.Length) $true
Check 'keystore/release 指向的文件存在' ($ksPath -and (Test-Path $ksPath)) $ksPath $true
Check '签名口令文件存在（出 release 包要用）' (Test-Path $KeystorePasswordFile) $KeystorePasswordFile $true

Add-Type -AssemblyName System.Drawing -ErrorAction SilentlyContinue
function Check-Icon([string]$Title, [string]$Rel, [int]$Expect) {
	$path = Join-Path $ProjectDir ($Rel -replace '^res://', '')
	if (-not (Test-Path $path)) { Check $Title $false "缺文件 $Rel" $true; return }
	try {
		$img = [System.Drawing.Image]::FromFile($path)
		$ok = ($img.Width -eq $Expect -and $img.Height -eq $Expect)
		$actual = "$($img.Width)x$($img.Height)"
		$img.Dispose()
		Check $Title $ok $actual $true
	} catch { Check $Title $false "读不出尺寸：$($_.Exception.Message)" $true }
}
Check-Icon '主图标 192x192' $iconMain 192
Check-Icon '自适应前景 432x432' $iconFg 432
Check-Icon '自适应背景 432x432' $iconBg 432

$perms = @()
foreach ($k in @('permissions/internet', 'permissions/access_network_state')) {
	if ((Get-Value $k) -eq 'true') { $perms += $k }
}
$expected = @('permissions/internet', 'permissions/access_network_state')
$permsJoined = ($perms | Sort-Object) -join ','
$expectedJoined = ($expected | Sort-Object) -join ','
Check '申请权限 = 隐私声明里的集合（INTERNET + ACCESS_NETWORK_STATE）' ($permsJoined -eq $expectedJoined) $permsJoined $true

$gi = Join-Path $ProjectDir '.gitignore'
$giText = if (Test-Path $gi) { [System.IO.File]::ReadAllText($gi) } else { '' }
Check '.gitignore 挡住 *.keystore 与 *-PASSWORD.txt' ($giText.Contains('*.keystore') -and $giText.Contains('*-PASSWORD.txt')) '已写' $true

Write-Host ''
if ($critical.Count -gt 0) {
	Write-Host ("===== 结论：{0} 个关键项没过 —— 现在不能发 =====" -f $critical.Count)
	$critical | ForEach-Object { Write-Host ("  - {0}" -f $_) }
	exit 1
}
Write-Host ("===== 结论：关键项全过（提醒 {0} 条）—— 可以出包 =====" -f $warn.Count)
exit 0