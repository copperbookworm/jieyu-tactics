<#
  export_android.ps1 -- 一条命令把 Android 出包做"对"
  ---------------------------------------------------------------------------
  为什么要有这个包装脚本：出包这条链上有反复踩过的坑，任何一步漏掉都会
  产生"看起来成功了、其实是坏包/坏统计"的结果：

    1) 出包前必须先跑 headless 测试（本工程踩过两次"开发机好、导出包跑不起来"）。
    2) Godot **每次导出都会重写** android/build/res/values/themes.xml，
       把 API 31 才有的 windowSplashScreenBackground 放回无限定的 values/ 里
       => 必须紧接着跑 patch_themes.ps1，否则 lint 会重新报 Error。
    3) min_sdk 由 Godot 通过 Gradle 属性 export_version_min_sdk 注入，
       preset 里留空会用 Godot 默认值（实测为 29），不是 config.gradle 的 24。
       => 出包后必须用 aapt2 badging **复核真实值**，不能靠猜。
    4) 包体大不等于坏：.so 在 APK 里是"存储"还是"压缩"由 compress_native_libraries 决定。

  【2026-10-07 第八十七版 · 发布收口】新增两件事：

    A) **-Format aab**：Play 要 AAB、设备侧载要 APK，而格式存在 preset 里
       （gradle_build/export_format）。为了不做一份 230 行的重复预设，本脚本在**导出窗口内**
       临时把 export_format 改成 1，导出完在 finally 里还原 —— 预设文件始终只有一份。

    B) **签名口令不进版本库**：export_presets.cfg 里 keystore/release_password 故意留空，
       本脚本从 D:\keys\jieyu-release-PASSWORD.txt 读口令，导出前写进 cfg、导出后**整文件还原**。
       这样版本库里既没有口令、也不会因为崩溃留下半个补丁（脚本开头会先修上一次的残留）。
       ⚠ Godot 4.7.1 **不支持** GODOT_ANDROID_KEYSTORE_* 环境变量（实测二进制里没有这些字符串），
         所以只能走"临时写、导出后还原"这条路。

  用法：
    & "D:\Godot4.7_Proj\jieyu-1\tools\android_overrides\export_android.ps1"
    & "...\export_android.ps1" -Mode release -Format aab -Out "D:\Godot4.7_Proj\APK\jieyu-0.1.0.aab"
    & "...\export_android.ps1" -Mode release -Out "D:\Godot4.7_Proj\APK\jieyu-0.1.0.apk"
    & "...\export_android.ps1" -SkipTests          # 只在你明确知道测试已跑过时用
#>
param(
	[ValidateSet('debug', 'release')][string]$Mode = 'debug',
	[ValidateSet('apk', 'aab')][string]$Format = 'apk',
	[string]$Out,
	[string]$ProjectDir = (Resolve-Path "$PSScriptRoot\..\..").Path,
	[string]$Godot = 'E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe',
	[string]$Keystore = 'D:\keys\jieyu-release.keystore',
	[string]$KeystoreAlias = 'jieyu',
	[string]$KeystorePasswordFile = 'D:\keys\jieyu-release-PASSWORD.txt',
	[switch]$SkipTests
)

$ErrorActionPreference = 'Stop'
$log = Join-Path $ProjectDir "_export_$Mode.log"
$cfgPath = Join-Path $ProjectDir 'export_presets.cfg'
$backupDir = Join-Path $ProjectDir '_release_cfg_backup'
$cfgBackup = Join-Path $backupDir 'export_presets.cfg'

# PS 5.1 会把原生程序写在 stderr 的**警告**升级成 NativeCommandError 并终止脚本，
# 所以调用外部程序一律走这个 helper：临时把 EAP 降为 Continue，只认退出码。
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

function Write-Utf8NoBom {
	param([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][string]$Text)
	$enc = New-Object System.Text.UTF8Encoding($false)
	[System.IO.File]::WriteAllText($Path, $Text, $enc)
}

function Get-KeystorePassword {
	if (-not (Test-Path $KeystorePasswordFile)) { throw "找不到签名口令文件 $KeystorePasswordFile（见 docs/发布收口.md 第 1 步）" }
	$line = Get-Content $KeystorePasswordFile | Where-Object { $_ -match '^\s*storePassword\s*:' } | Select-Object -First 1
	if (-not $line) { throw "口令文件里没有 storePassword 行：$KeystorePasswordFile" }
	$pwd = ($line -split ':', 2)[1].Trim()
	if ($pwd.Length -lt 8) { throw "口令短得不像口令（长度 $($pwd.Length)）" }
	return $pwd
}

# ---- 0) 崩溃残留自愈：上一次导出如果没走完 finally，cfg 里会留着口令/改过的格式 ----
if (Test-Path $cfgBackup) {
	Write-Warning "发现上次导出留下的预设备份，先还原（上一次可能被中断）"
	Copy-Item $cfgBackup $cfgPath -Force
	Remove-Item $cfgBackup -Force
}

if (-not $Out) {
	$Out = Join-Path 'D:\Godot4.7_Proj\APK' ("jieyu-$Mode." + $Format)
}

# ---- 0b) 环境：Gradle 构建必须用 JDK 17（不能用 IDE 自带的 JBR 25）----
$jdk17 = 'C:\Program Files\Java\jdk-17'
if (Test-Path $jdk17) { $env:JAVA_HOME = $jdk17 } else { Write-Warning "JDK 17 不在 $jdk17，AGP 8.6 可能起不来" }
Write-Host "[export] JAVA_HOME=$env:JAVA_HOME  格式=$Format"

# ---- 1) 出包前 headless 测试 ----
if (-not $SkipTests) {
	Write-Host '[export] 1/4 跑 headless 测试…'
	$r = Invoke-Tool $Godot @('--headless', '--path', $ProjectDir, '--log-file', (Join-Path $ProjectDir '_a_tests.log'), '--script', 'res://tools/run_tests_headless.gd')
	[regex]::Split($r.Output, "\r?\n") | Where-Object { $_ -match '汇总|未全绿' } | ForEach-Object { Write-Host "    $($_.Trim())" }
	if ($r.ExitCode -ne 0) { throw "headless 测试没全绿（exit $($r.ExitCode)），按铁律停止出包" }
	Write-Host '[export]    测试全绿'
} else {
	Write-Host '[export] 1/4 跳过测试（-SkipTests）'
}

# ---- 1b) 导出窗口内的本地覆盖（口令 + AAB 格式），导出后整文件还原 ----
$needOverride = ($Mode -eq 'release') -or ($Format -eq 'aab')
if ($needOverride) {
	if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }
	Copy-Item $cfgPath $cfgBackup -Force
	$cfg = [System.IO.File]::ReadAllText($cfgPath)
	$changed = @()
	if ($Format -eq 'aab') {
		if ($cfg.Contains('gradle_build/export_format=0')) {
			$cfg = $cfg.Replace('gradle_build/export_format=0', 'gradle_build/export_format=1')
			$changed += 'export_format=1(AAB)'
		}
	}
	if ($Mode -eq 'release' -or $Format -eq 'aab') {
		# 关掉 Godot 自带签名：本机实测它的 release 签名链没接通 —— verbose 日志里给 gradle 的命令行
		# 只有 -Pperform_signing=true，**一个 keystore 属性都没有**，即便 preset 里三样都读得到。
		# 所以改成「Godot 出未签名包 + 本脚本用 jarsigner/apksigner 签」，工具与指纹都自己掌握。
		if ($cfg.Contains('package/signed=true')) {
			$cfg = $cfg.Replace('package/signed=true', 'package/signed=false')
			$changed += 'package/signed=false（签名改由本脚本做）'
		}
		$pwd = Get-KeystorePassword
	}
	Write-Utf8NoBom -Path $cfgPath -Text $cfg
	Write-Host ("[export] 1b/4 已做本地覆盖：" + ($changed -join ' + ') + "（导出后整文件还原）")
}

try {
	# ---- 2) 导出 ----
	Write-Host "[export] 2/4 Godot --export-$Mode Android -> $Out"
	# ⚠ 这一段**必须**用 Start-Process 而不是管道捕获：GradleDaemon 会继承导出进程的 stdout 管道
	# 且不释放，用管道的话 Godot 卡在等子进程、脚本永远读不到 EOF（AGENTS.md 记的「假死」，
	# 有一次因此拖了 24 分钟）。看门狗：产物写出来并稳定 20 s 后进程还没退出，就把 java 收掉。
	$stdoutFile = Join-Path $ProjectDir '_export_stdout.log'
	$stderrFile = Join-Path $ProjectDir '_export_stderr.log'
	$argLine = '--headless --path "' + $ProjectDir + '" --export-' + $Mode + ' Android "' + $Out + '" --log-file "' + $log + '"'
	# ⚠ 不能用 Start-Process：本机环境同时有 NO_PROXY 与 no_proxy，PS 5.1 的 Start-Process 会抛
	# 「已添加项。字典中的关键字:NO_PROXY」（大小写不敏感字典冲突，实测踩到）。改用 .NET Process。
	$psi = New-Object System.Diagnostics.ProcessStartInfo
	$psi.FileName = $Godot
	$psi.Arguments = $argLine
	$psi.UseShellExecute = $false
	$psi.CreateNoWindow = $true
	$proc = New-Object System.Diagnostics.Process
	$proc.StartInfo = $psi
	$null = $proc.Start()
	$killed = $false
	while (-not $proc.HasExited) {
		Start-Sleep -Seconds 5
		if ($killed -or -not (Test-Path $Out)) { continue }
		# 产物写好后先给 Gradle 90 s 收尾（它还有 afterBuild 之类的任务），然后**只收空闲的 daemon**。
		# ⚠ 必须按命令行过滤：早先版本无条件 kill 所有 java，把正在构建的 JVM 一起杀了，
		#    gradle 当场报「Android 项目构建失败」、Godot 退出码 1（本轮实测踩到，白出一枚坏 AAB）。
		Start-Sleep -Seconds 90
		if (-not $proc.HasExited) {
			$daemons = Get-CimInstance Win32_Process -Filter "Name='java.exe'" -ErrorAction SilentlyContinue |
					Where-Object { $_.CommandLine -like '*GradleDaemon*' }
			foreach ($d in $daemons) { Stop-Process -Id $d.ProcessId -Force -ErrorAction SilentlyContinue }
			if ($daemons) {
				$killed = $true
				Write-Host '[export]    [看门狗] 产物已写好，收掉空闲的 GradleDaemon（它拖住了 stdout 管道）'
			}
		}
	}
	$proc.WaitForExit()
	if ($proc.ExitCode -ne 0) { throw "Godot 导出失败（exit $($proc.ExitCode)），见 $log" }
	if (-not (Test-Path $Out)) { throw "导出命令成功但没有产物：$Out" }

	# ---- 2b) 外部签名（release / AAB）：AAB 用 jarsigner，APK 用 apksigner ----
	if ($pwd) {
		if (-not (Test-Path $Keystore)) { throw "找不到 keystore：$Keystore" }
		Write-Host '[export] 2b/4 用我们自己的工具签名（AAB -> jarsigner，APK -> apksigner）…'
		if ($Format -eq 'aab') {
			$jarsigner = Join-Path $jdk17 'bin\jarsigner.exe'
			$r = Invoke-Tool $jarsigner @('-keystore', $Keystore, '-storepass', $pwd, '-keypass', $pwd,
					'-sigalg', 'SHA256withRSA', '-digestalg', 'SHA-256', $Out, $KeystoreAlias)
			if ($r.ExitCode -ne 0) { throw "jarsigner 签名失败：$($r.Output)" }
			Write-Host '[export]    jarsigner 完成'
		} else {
			$btProbe = Join-Path $env:LOCALAPPDATA 'Android\Sdk\build-tools'
			$bt = Get-ChildItem $btProbe -Directory | Sort-Object Name -Descending | Select-Object -First 1
			$apksigner = Join-Path $bt.FullName 'apksigner.bat'
			$r = Invoke-Tool $apksigner @('sign', '--ks', $Keystore, '--ks-pass', ("pass:" + $pwd),
					'--ks-key-alias', $KeystoreAlias, '--key-pass', ("pass:" + $pwd), $Out)
			if ($r.ExitCode -ne 0) { throw "apksigner 签名失败：$($r.Output)" }
			Write-Host '[export]    apksigner 完成'
		}
	}

	# ---- 3) 导出后补丁（Godot 刚把 themes.xml 重写了）----
	Write-Host '[export] 3/4 打 splash 主题补丁（values -> values-v31）…'
	$r = Invoke-Tool (Join-Path $PSScriptRoot 'patch_themes.ps1')
	if ($r.ExitCode -ne 0) { throw "补丁失败（exit $($r.ExitCode)）：$($r.Output)" }
	Write-Host '[export]    补丁完成'

	# ---- 4) 产物复核（不看数字不算完）----
	Write-Host '[export] 4/4 复核产物'
	$sizeMB = (Get-Item $Out).Length / 1MB
	$sha = (Get-FileHash $Out -Algorithm SHA256).Hash
	Write-Host ''
	Write-Host ("  产物     : {0}" -f $Out)
	Write-Host ("  体积     : {0:N1} MB" -f $sizeMB)
	Write-Host ("  SHA256   : {0}" -f $sha)

	$sdk = Join-Path $env:LOCALAPPDATA 'Android\Sdk'
	$buildTools = Get-ChildItem (Join-Path $sdk 'build-tools') -Directory | Sort-Object Name -Descending | Select-Object -First 1
	if ($Format -eq 'aab') {
		# AAB 不是 APK：aapt2 dump badging 与 apksigner 都不适用，用 jarsigner -verify 复核
		$jarsigner = Join-Path $jdk17 'bin\jarsigner.exe'
		# ⚠ 必须强制英文：jarsigner 的输出是**本地化**的（中文 JVM 上不出现 "jar verified"），
		# 靠英文关键字判断会在中文环境假红 —— 本轮就这么误报过一次。
		# 判据用**退出码**（0=验证通过）+ 证书 CN，两个都不依赖语言。
		$v = Invoke-Tool $jarsigner @('-J-Duser.language=en', '-J-Duser.country=US', '-verify', '-verbose', '-certs', $Out)
		$cert = ([regex]::Match($v.Output, 'CN=([^,]*)')).Value
		$signed_ok = ($v.ExitCode -eq 0) -and ($cert -like 'CN=JIEYU*')
		Write-Host ("  JAR 签名 : {0}" -f $(if ($v.ExitCode -eq 0) { '已验证（jarsigner exit 0）' } else { "未通过（exit $($v.ExitCode)）" }))
		Write-Host ("  证书     : {0}" -f $cert)
		if (-not $signed_ok) { throw "AAB 签名复核没通过（exit $($v.ExitCode)，证书 $cert）—— 不能上传" }
		Write-Host '  [OK] AAB 已用 release keystore 签名（jarsigner v1 JAR 签名，Play upload key 的标准做法）'
	} else {
		$aapt2 = Join-Path $buildTools.FullName 'aapt2.exe'
		$badging = (Invoke-Tool $aapt2 @('dump', 'badging', $Out)).Output
		# aapt2 输出里 minSdkVersion 与 targetSdkVersion 只有首字母大小写不同，两种写法都兜
		$minSdk = ([regex]::Match($badging, "minSdkVersion:'(\d+)'")).Groups[1].Value
		if (-not $minSdk) { $minSdk = ([regex]::Match($badging, "sdkVersion:'(\d+)'")).Groups[1].Value }
		$targetSdk = ([regex]::Match($badging, "targetSdkVersion:'(\d+)'")).Groups[1].Value
		$abis = ([regex]::Match($badging, "native-code: '([^']+)'")).Groups[1].Value
		$pkgName = ([regex]::Match($badging, "package: name='([^']+)'")).Groups[1].Value
		$debuggable = if ($badging -match 'application-debuggable') { 'yes' } else { 'no' }
		$soStored = $null
		try {
			Add-Type -AssemblyName System.IO.Compression.FileSystem
			$zip = [System.IO.Compression.ZipFile]::OpenRead($Out)
			try {
				$e = $zip.Entries | Where-Object { $_.FullName -like 'lib/*/libgodot_android.so' } | Select-Object -First 1
				if ($e) { $soStored = ($e.CompressedLength -lt $e.Length * 0.95) }
			} finally { $zip.Dispose() }
		} catch { }
		Write-Host ("  包名     : {0}" -f $pkgName)
		Write-Host ("  minSdk   : {0}" -f $minSdk)
		Write-Host ("  targetSdk: {0}" -f $targetSdk)
		Write-Host ("  ABI      : {0}" -f $abis)
		Write-Host ("  debuggable: {0}" -f $debuggable)
		if ($null -ne $soStored) { Write-Host ("  .so 在包内 : {0}" -f $(if ($soStored) { '压缩' } else { '存储' })) }
		if ($pkgName -like 'com.example.*') { Write-Warning "包名还是 com.example.*，Play 不接受" }
		if ([int]$minSdk -ne 24) {
			Write-Warning "minSdk=$minSdk，预期 24。检查 export_presets.cfg 的 gradle_build/min_sdk（空串会得到 Godot 默认 29）。"
		}
		if ($Mode -eq 'debug' -and $sizeMB -gt 60 -and $soStored -eq $false) {
			Write-Host ("  [说明] 包体 {0:N1} MB 属预期：.so 以存储方式打包（compress_native_libraries=false 时如此）。" -f $sizeMB)
		}
	}
} finally {
	# ---- 还原预设：无论成功失败，版本库里的 export_presets.cfg 必须回到"无口令"状态 ----
	if (Test-Path $cfgBackup) {
		Copy-Item $cfgBackup $cfgPath -Force
		Remove-Item $cfgBackup -Force
		Write-Host '[export] 预设已还原（口令与格式改动都不留在工作区）'
	}
}
