# fix_ps1_bom.ps1 -- add the UTF-8 BOM back to .ps1 files that need it.
#
# WHY THIS EXISTS
#   PowerShell 5.1 (this machine's only shell) decodes a BOM-less file as ANSI/GBK.
#   Any .ps1 whose text contains non-ASCII (Chinese comments/strings) will then fail to
#   PARSE -- the error looks like "MissingArrayIndexExpression" or "unexpected token".
#   The `edit`/`write` style tools strip the BOM on every save (measured 2026-10-06:
#   header went EF BB BF -> 3C 23 0A), so this happens over and over.
#
#   Deliberately ASCII-only messages: if this script itself lacked a BOM it could not run
#   to fix itself. Same reason it avoids Chinese in its own source.
#
# USAGE
#   & "D:\Godot4.7_Proj\jieyu-1\tools\android_overrides\fix_ps1_bom.ps1"
#   & "...\fix_ps1_bom.ps1" -WhatIfOnly     # report only, change nothing
#
# EXIT  0 = everything fine (or fixed) ; 1 = some file could not be fixed ; 2 = usage/IO

param(
	[string]$Root = (Resolve-Path "$PSScriptRoot\..\..").Path,
	[switch]$WhatIfOnly
)

$ErrorActionPreference = 'Continue'
$utf8Bom = New-Object System.Text.UTF8Encoding($true)
$strict  = New-Object System.Text.UTF8Encoding($false, $true)   # throwOnInvalidBytes

# android/build is a 200+ MB extracted Godot template -- not ours, skip it.
$skipDirs = @('android\build', 'android\build\build', '.godot', '.git', 'addons', 'gdtoolkit')

$fixed = 0; $ok = 0; $bad = @()
$files = Get-ChildItem -LiteralPath $Root -Recurse -File -Filter '*.ps1' -ErrorAction SilentlyContinue
foreach ($f in $files) {
	$rel = $f.FullName.Substring($Root.Length).TrimStart('\')
	$skip = $false
	foreach ($d in $skipDirs) { if ($rel.StartsWith($d, [StringComparison]::OrdinalIgnoreCase)) { $skip = $true; break } }
	if ($skip) { continue }

	$bytes = [System.IO.File]::ReadAllBytes($f.FullName)
	if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { $ok++; continue }

	$hasNonAscii = $false
	foreach ($b in $bytes) { if ($b -ge 0x80) { $hasNonAscii = $true; break } }
	if (-not $hasNonAscii) { $ok++; continue }   # pure ASCII: BOM irrelevant

	try { $text = $strict.GetString($bytes) }
	catch { $bad += "$rel (not valid UTF-8 -- NOT touched, inspect by hand)"; continue }

	if ($WhatIfOnly) { Write-Host "[would fix] $rel"; $fixed++; continue }

	[System.IO.File]::WriteAllText($f.FullName, $text, $utf8Bom)
	# read back and re-parse to prove the file is now usable
	$b2 = [System.IO.File]::ReadAllBytes($f.FullName)
	$errs = $null
	[void][System.Management.Automation.Language.Parser]::ParseFile($f.FullName, [ref]$null, [ref]$errs)
	if ($b2[0] -ne 0xEF -or ($errs -and $errs.Count)) {
		$bad += "$rel (BOM added but still not parsing)"
	} else {
		Write-Host "[fixed] $rel"
		$fixed++
	}
}

Write-Host ""
Write-Host ("scanned={0}  already-ok={1}  fixed={2}  problems={3}" -f $files.Count, $ok, $fixed, $bad.Count)
foreach ($b in $bad) { Write-Host "  [!!] $b" }
if ($bad.Count -gt 0) { exit 1 }
exit 0
