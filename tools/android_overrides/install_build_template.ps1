<#
  install_build_template.ps1 -- 安装 / 刷新 Android 构建模板（jieyu-1 专用）

  为什么：华为 FrameRateManager 把本包钉在 60 Hz，而 Godot 4.7 在 Android 上没有高刷开关
  ⇒ 只能走自定义 Android 构建，由 GodotApp.java 主动向系统请求 120 Hz。
  背景与真机验收见 docs/性能预算.md 第十五节。

  做什么：
    1) 把 <export_templates>\4.7.1.stable\android_source.zip 解到 <工程>\android\build\（约 206 MB，gitignore 已忽略）
    2) 写 <工程>\android\.build_version          —— Godot 导出自检找的是**这里**，不是 android/build/ 里
    3) 写 <工程>\android\build\.gdignore          —— 别让 206 MB 进文件扫描器
    4) 用 tools\android_overrides\GodotApp.java 覆盖模板里的同名文件（带 120 Hz 请求）
    5) 装入 jieyu_splash_fix.gradle 并在 build.gradle 追加 apply from（Gradle 级 splash 主题钩子；
       让 API31 属性归位**进 APK**，而不只是让 lint 干净）

  什么时候重跑：换 Godot 版本、导出模板更新、android/build/ 被删掉之后。
  用法：pwsh -File tools\android_overrides\install_build_template.ps1
#>
param(
	[string]$ProjectDir = (Resolve-Path "$PSScriptRoot\..\..").Path,
	[string]$TemplateDir = "$env:APPDATA\Godot\export_templates\4.7.1.stable",
	[string]$EngineVersion = "4.7.1.stable"
)

$ErrorActionPreference = "Stop"

$zip = Join-Path $TemplateDir "android_source.zip"
if (-not (Test-Path $zip)) {
	throw "找不到导出模板：$zip（先确认 Godot 版本与 export_templates 目录）"
}

$dest = Join-Path $ProjectDir "android\build"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dest, $true)
Write-Host "[android] 模板已解到 $dest"

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$marker = Join-Path $ProjectDir "android\.build_version"
[System.IO.File]::WriteAllText($marker, $EngineVersion + [char]10, $utf8NoBom)
Write-Host "[android] 版本标记已写：$marker（$EngineVersion）"

[System.IO.File]::WriteAllText((Join-Path $dest ".gdignore"), [char]10, $utf8NoBom)

$override = Join-Path $PSScriptRoot "GodotApp.java"
$target = Join-Path $dest "src\main\java\com\godot\game\GodotApp.java"
if (-not (Test-Path $override)) {
	throw "找不到覆盖文件：$override"
}
Copy-Item $override $target -Force
Write-Host "[android] 已覆盖 GodotApp.java（请求 120 Hz）"

# 5) Gradle 级 splash 主题钩子：让「API31 属性归位」也进 APK（导出后打补丁只能让 lint 干净）
$hookSrc = Join-Path $PSScriptRoot "jieyu_splash_fix.gradle"
if (-not (Test-Path $hookSrc)) { throw "找不到钩子文件：$hookSrc" }
$hookText = [System.IO.File]::ReadAllText($hookSrc, [Text.Encoding]::UTF8)
# ⚠ Groovy 解析器不认 BOM ⇒ 这个文件必须**无 BOM**（与同目录 .ps1 必须带 BOM 正好相反）
[System.IO.File]::WriteAllText((Join-Path $dest "jieyu_splash_fix.gradle"), $hookText, $utf8NoBom)
Write-Host "[android] 已装入 jieyu_splash_fix.gradle"

$gradleFile = Join-Path $dest "build.gradle"
$gradleText = [System.IO.File]::ReadAllText($gradleFile, [Text.Encoding]::UTF8)
if ($gradleText -notmatch "jieyu_splash_fix\.gradle") {
	$append = "`n`n// jieyu-1：splash 主题 API31 属性归位（缘由见 jieyu_splash_fix.gradle 头部注释）`napply from: 'jieyu_splash_fix.gradle'`n"
	[System.IO.File]::WriteAllText($gradleFile, $gradleText.TrimEnd() + $append, $utf8NoBom)
	Write-Host "[android] 已在 build.gradle 追加 apply from: 'jieyu_splash_fix.gradle'"
} else {
	Write-Host "[android] build.gradle 已含该 apply from，跳过"
}

Write-Host '[android] 导出前设 JAVA_HOME 到 JDK 17；推荐直接用 tools\android_overrides\export_android.ps1'
