<#
  patch_themes.ps1 -- 把 Godot 生成的 splash 主题里那条「API 31 才有的属性」挪到 values-v31/
  ---------------------------------------------------------------------------
  为什么需要它：
    Godot 每次导出都会**重新生成** android/build/res/values/themes.xml，并在注释里写明
    「Manual changes will be overwritten」。而它生成的 GodotAppSplashTheme 里含
        <item name="android:windowSplashScreenBackground">@mipmap/icon_background</item>
    这是 API 31 才有的属性，却放在**无版本限定**的 values/ 里。
    Android Lint 因此报 Error(NewApi)：在 API < 31 的设备上，厂商自定义属性 id
    可能与新属性冲突（lint 原文："maneuver ... manufacturers have added custom attributes
    whose ids conflict with the new ones on later platforms"）。
    本工程 minSdk 是 24，所以这条不是噪声。

  怎么办（真修，不是抑制）：
    * values/themes.xml            —— 去掉那条 item（低版本设备不加载它）
    * values-v31/themes.xml        —— 放**完整**的 GodotAppSplashTheme（含那条 item）
    注意：资源限定符是**整体替换**同名 style，所以 v31 那份必须是完整定义，
    不能只写一行，否则 API 31+ 的设备会丢掉其它 item（如 postSplashScreenTheme）。

  什么时候跑：
    **每次导出之后**都必须跑一次（因为导出会重写 themes.xml）。已做幂等。
    典型顺序：跑 headless 测试 -> --export-debug/-release -> 本脚本 -> aapt2 badging 复核。

  用法：
    pwsh -File tools\android_overrides\patch_themes.ps1
    （本机没有 pwsh，用 & 直接调）：
    & "D:\Godot4.7_Proj\jieyu-1\tools\android_overrides\patch_themes.ps1"
#>
param(
	[string]$ProjectDir = (Resolve-Path "$PSScriptRoot\..\..").Path,
	[switch]$Quiet
)

$ErrorActionPreference = "Stop"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$resDir   = Join-Path $ProjectDir "android\build\res"
$baseFile = Join-Path $resDir "values\themes.xml"
$v31Dir   = Join-Path $resDir "values-v31"
$v31File  = Join-Path $v31Dir "themes.xml"
$ITEM     = 'android:windowSplashScreenBackground'

if (-not (Test-Path $baseFile)) {
	throw "找不到 $baseFile（先跑一次 Godot 导出，让生成物存在）"
}

$base = Get-Content -LiteralPath $baseFile -Raw

# 已经是打过补丁的形态（base 里没有该 item 且 v31 存在）=> 幂等返回
if ($base -notmatch [regex]::Escape($ITEM)) {
	if (Test-Path $v31File) {
		if (-not $Quiet) { Write-Host "[patch_themes] 已打过补丁，无需改动（values/ 无该 item，values-v31/ 存在）" }
		exit 0
	}
	throw "values/ 里没有 $ITEM，但 values-v31/ 也不存在 —— 状态异常，请人工检查"
}

# 1) values-v31/themes.xml := 当前完整内容（含该 item）
if (-not (Test-Path $v31Dir)) { New-Item -ItemType Directory -Force -Path $v31Dir | Out-Null }
[System.IO.File]::WriteAllText($v31File, $base, $utf8NoBom)
Write-Host "[patch_themes] 已写 $(($v31File.Substring($ProjectDir.Length)))  （完整 splash 主题，含 API31 属性）"

# 2) values/themes.xml := 删掉那一整行 item（含其所在行与缩进）
$lines = $base -split "`r?`n"
$removed = 0
$kept = foreach ($ln in $lines) {
	if ($ln -match [regex]::Escape($ITEM)) { $removed++; continue }
	$ln
}
if ($removed -eq 0) { throw "预期能删掉含 $ITEM 的行，但一行都没匹配到" }
$newBase = ($kept -join "`n")
if (-not $newBase.EndsWith("`n")) { $newBase += "`n" }
[System.IO.File]::WriteAllText($baseFile, $newBase, $utf8NoBom)
Write-Host "[patch_themes] 已从 android\build\res\values\themes.xml 移除 $removed 行（$ITEM）"

# 3) 回读校验
$b2 = Get-Content -LiteralPath $baseFile -Raw
$v2 = Get-Content -LiteralPath $v31File  -Raw
if ($b2 -match [regex]::Escape($ITEM)) { throw "回读失败：values/ 里仍有该 item" }
if ($v2 -notmatch [regex]::Escape($ITEM)) { throw "回读失败：values-v31/ 里没有该 item" }
foreach ($keep in @('postSplashScreenTheme', 'windowSplashScreenAnimatedIcon', 'windowIsTranslucent')) {
	if ($v2 -notmatch [regex]::Escape($keep)) { throw "回读失败：values-v31/ 缺了 $keep（限定符是整体替换，v31 必须是完整定义）" }
}
Write-Host "[patch_themes] 回读校验通过（v31 为完整定义，base 已剔除该 item）"
