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
Write-Host '[android] 导出前设 JAVA_HOME 到 JDK 17，然后 --export-debug Android <apk>'
