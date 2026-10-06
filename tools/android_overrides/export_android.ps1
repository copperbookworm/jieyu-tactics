<#
  export_android.ps1 -- 一条命令把 Android 出包做"对"
  ---------------------------------------------------------------------------
  为什么要有这个包装脚本：出包这条链上有四个反复踩过的坑，任何一步漏掉都会
  产生"看起来成功了、其实是坏包/坏统计"的结果：

    1) 出包前必须先跑 headless 测试（本工程踩过两次"开发机好、导出包跑不起来"）。
    2) Godot **每次导出都会重写** android/build/res/values/themes.xml，
       把 API 31 才有的 windowSplashScreenBackground 放回无限定的 values/ 里
       => 必须紧接着跑 patch_themes.ps1，否则 lint 会重新报 Error。
    3) min_sdk 由 Godot 通过 Gradle 属性 export_version_min_sdk 注入，
       preset 里留空会用 Godot 默认值（实测为 29），不是 config.gradle 的 24。
       => 出包后必须用 aapt2 badging **复核真实值**，不能靠猜。
    4) 包里 libgodot_android.so 只有在 NDK 存在时才会被 strip
       （debug 模板未 strip 是 72.65 MB，strip 后约 24 MB）。
       => 复核包体，体积异常大就说明 NDK 没被找到。

  用法：
    & "D:\Godot4.7_Proj\jieyu-1\tools\android_overrides\export_android.ps1"
    & "...\export_android.ps1" -Mode release -Out "D:\Godot4.7_Proj\APK\jieyu.aab"
    & "...\export_android.ps1" -SkipTests          # 只在你明确知道测试已跑过时用
#>
param(
	[ValidateSet('debug', 'release')][string]$Mode = 'debug',
	[string]$Out,
	[string]$ProjectDir = (Resolve-Path "$PSScriptRoot\..\..").Path,
	[string]$Godot = 'E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe',
	[switch]$SkipTests
)

$ErrorActionPreference = 'Stop'
$log = Join-Path $ProjectDir "_export_$Mode.log"

# PS 5.1 会把原生程序写在 stderr 的**警告**升级成 NativeCommandError 并终止脚本
# （Godot 在 headless 测试里就会往 stderr 打 "ERROR: Playback can only happen when
#  a node is inside the scene tree" 这类行），所以调用外部程序一律走这个 helper：
# 临时把 EAP 降为 Continue，只认退出码。（同 deveco-studio-automation 技能坑 #1。）
function Invoke-Tool {
	param([Parameter(Mandatory)][string]$File, [string[]]$Arguments = @())
	$prev = $ErrorActionPreference
	$ErrorActionPreference = 'Continue'
	$code = 0
	try {
		$out = & $File @Arguments 2>&1 | Out-String
		$code = $LASTEXITCODE
		if ($null -eq $code) { $code = 0 }
	} finally { $ErrorActionPreference = $prev }
	return [pscustomobject]@{ Output = $out; ExitCode = $code }
}

if (-not $Out) {
	$Out = Join-Path 'D:\Godot4.7_Proj\APK' ("jieyu-$Mode.apk")
}

# ---- 0) 环境：Gradle 构建必须用 JDK 17（不能用 IDE 自带的 JBR 25）----
$jdk17 = 'C:\Program Files\Java\jdk-17'
if (Test-Path $jdk17) { $env:JAVA_HOME = $jdk17 } else { Write-Warning "JDK 17 不在 $jdk17，AGP 8.6 可能起不来" }
Write-Host "[export] JAVA_HOME=$env:JAVA_HOME"

# ---- 1) 出包前 headless 测试 ----
if (-not $SkipTests) {
	Write-Host '[export] 1/4 跑 headless 测试…'
	$r = Invoke-Tool $Godot @('--headless', '--path', $ProjectDir, '--log-file', (Join-Path $ProjectDir '_a_tests.log'), '--script', 'res://tools/run_tests_headless.gd')
	($r.Output -split "`r?`n") | Where-Object { $_ -match '汇总|未全绿' } | ForEach-Object { Write-Host "    $($_.Trim())" }
	if ($r.ExitCode -ne 0) { throw "headless 测试没全绿（exit $($r.ExitCode)），按铁律停止出包" }
	Write-Host '[export]    测试全绿'
} else {
	Write-Host '[export] 1/4 跳过测试（-SkipTests）'
}

# ---- 2) 导出 ----
Write-Host "[export] 2/4 Godot --export-$Mode Android -> $Out"
$r = Invoke-Tool $Godot @('--headless', '--path', $ProjectDir, "--export-$Mode", 'Android', $Out, '--log-file', $log)
if ($r.ExitCode -ne 0) { throw "Godot 导出失败（exit $($r.ExitCode)），见 $log" }
if (-not (Test-Path $Out)) { throw "导出命令成功但没有产物：$Out" }

# ---- 3) 导出后补丁（Godot 刚把 themes.xml 重写了）----
Write-Host '[export] 3/4 打 splash 主题补丁（values -> values-v31）…'
# ⚠ 不要写成 @('-ProjectDir', $ProjectDir)：数组 splat 会把 '-ProjectDir' 当**位置参数**送进去，
# 于是 $ProjectDir 变成字面量 "-ProjectDir"（踩过）。patch_themes.ps1 的默认值就从 $PSScriptRoot
# 推工程根，不传参即可。
$r = Invoke-Tool (Join-Path $PSScriptRoot 'patch_themes.ps1')
if ($r.ExitCode -ne 0) { throw "补丁失败（exit $($r.ExitCode)）：$($r.Output)" }
Write-Host '[export]    补丁完成'

# ---- 4) 产物复核（不看数字不算完）----
Write-Host '[export] 4/4 复核产物'
$sdk = Join-Path $env:LOCALAPPDATA 'Android\Sdk'
$aapt2 = Join-Path $sdk 'build-tools\36.1.0\aapt2.exe'
$badging = (Invoke-Tool $aapt2 @('dump', 'badging', $Out)).Output
# aapt2 的输出里 "minSdkVersion:'24'" 与 "targetSdkVersion:'36'" 只有首字母大小写不同，
# 用小写 sdkVersion 去匹配会同时踩到 target 那条（或一条都匹配不上）。两种写法都兜。
$minSdk = ([regex]::Match($badging, "minSdkVersion:'(\d+)'")).Groups[1].Value
if (-not $minSdk) { $minSdk = ([regex]::Match($badging, "sdkVersion:'(\d+)'")).Groups[1].Value }
$targetSdk = ([regex]::Match($badging, "targetSdkVersion:'(\d+)'")).Groups[1].Value
$abis = ([regex]::Match($badging, "native-code: '([^']+)'")).Groups[1].Value
$debuggable = if ($badging -match 'application-debuggable') { 'yes' } else { 'no' }
$sizeMB = (Get-Item $Out).Length / 1MB
# .so 在 APK 里是"存储"还是"压缩"（决定体积，与 strip 无关）
$soStored = $null
try {
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	$zip = [System.IO.Compression.ZipFile]::OpenRead($Out)
	try {
		$e = $zip.Entries | Where-Object { $_.FullName -like 'lib/*/libgodot_android.so' } | Select-Object -First 1
		if ($e) { $soStored = ($e.CompressedLength -lt $e.Length * 0.95) }
	} finally { $zip.Dispose() }
} catch { }

Write-Host ''
Write-Host ("  产物     : {0}" -f $Out)
Write-Host ("  体积     : {0:N1} MB" -f $sizeMB)
Write-Host ("  minSdk   : {0}" -f $minSdk)
Write-Host ("  targetSdk: {0}" -f $targetSdk)
Write-Host ("  ABI      : {0}" -f $abis)
Write-Host ("  debuggable: {0}" -f $debuggable)
if ($null -ne $soStored) {
	Write-Host ("  .so 在包内 : {0}" -f $(if ($soStored) { '压缩' } else { '存储' }))
}
if ([int]$minSdk -ne 24) {
	Write-Warning "minSdk=$minSdk，预期 24。检查 export_presets.cfg 的 gradle_build/min_sdk（空串会得到 Godot 默认 29），以及 preset 是否被编辑器重写。"
}
if ($Mode -eq 'debug' -and $sizeMB -gt 60 -and $soStored -eq $false) {
	# 2026-10-06 更正：体积差**不是** strip 造成的。两个 APK 里的 .so 都是 72.65 MB 且都已 strip
	# （llvm-readelf 无 .symtab）；差的是"存储 vs 压缩"。旋钮 = gradle_build/compress_native_libraries
	# （false = 存储 = 包大但安装/启动更快），本工程**有意**保持 false。别再往 NDK/strip 方向查。
	Write-Host ("  [说明] 包体 {0:N1} MB 属预期：.so 以存储方式打包（compress_native_libraries=false，有意为之）。" -f $sizeMB)
}
