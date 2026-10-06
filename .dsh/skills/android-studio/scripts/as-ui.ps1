# as-ui.ps1 — drive the app UI on a device through uiautomator + adb input.
# This is how the agent "sees" and operates an app without a GUI of its own.
#
#   .\as-ui.ps1 describe                     # compact list of visible text + ids + centres
#   .\as-ui.ps1 dump -Out ui.xml             # raw uiautomator XML
#   .\as-ui.ps1 find -Text "Sign in"
#   .\as-ui.ps1 tap  -Text "Sign in"
#   .\as-ui.ps1 tap  -Id "com.app:id/ok"
#   .\as-ui.ps1 tap  -Xy "540 1200"
#   .\as-ui.ps1 text -Value "hello world"
#   .\as-ui.ps1 key  -Name BACK
#   .\as-ui.ps1 swipe -X1 540 -Y1 1800 -X2 540 -Y2 400
#   .\as-ui.ps1 wait -Text "Welcome" -TimeoutSec 20
#   .\as-ui.ps1 screenshot -Out shot.png

# Deliberately a SIMPLE (non-advanced) script: [CmdletBinding()] or any [Parameter()]
# attribute would add the common parameters, making this script's own -Out ambiguous
# with -OutVariable/-OutBuffer when called directly (`as-ui.ps1 dump -Out ui.xml`).
param(
    [string]$Action = 'describe',
    [string]$Serial,
    [string]$Text,
    [string]$Id,
    [string]$Desc,
    [string]$Class,
    [string]$Xy,
    [string]$Value,
    [string]$Name,
    [string]$Out,
    [int]$X1, [int]$Y1, [int]$X2, [int]$Y2,
    [int]$TimeoutSec = 15,
    [switch]$ClickableOnly,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'as-lib.ps1') -AsProjectRoot $null -AsQuiet

$dev = Get-UsableDevice -Serial $Serial

function Get-UiXml {
    param([string]$Serial)
    $remote = '/sdcard/dsh_ui.xml'
    $local = Join-Path $env:TEMP 'dsh_ui.xml'
    Invoke-Adb -Serial $Serial -Arguments @('shell', 'uiautomator', 'dump', $remote) | Out-Null
    $pull = (Invoke-Native -FilePath $AsEnv.Adb -Arguments @('-s', $Serial, 'pull', $remote, $local)).Output
    if (-not (Test-Path -LiteralPath $local)) { throw "uiautomator dump failed: $pull" }
    # Read as UTF-8 explicitly: PowerShell 5.1 defaults to the ANSI codepage (GBK here),
    # and mis-decoding multi-byte text can swallow the closing quote of an attribute,
    # which then makes the whole hierarchy unparseable.
    $raw = Get-Content -LiteralPath $local -Raw -Encoding UTF8
    Invoke-Adb -Serial $Serial -Arguments @('shell', 'rm', '-f', $remote) | Out-Null
    if (-not $raw -or $raw -notmatch '<hierarchy') { throw "uiautomator returned no hierarchy (screen may be off or a secure window is showing)." }
    return $raw
}

function ConvertTo-UiNodes {
    param([string]$Raw)
    [xml]$doc = $Raw
    $nodes = @()
    foreach ($n in $doc.SelectNodes('//node')) {
        $bounds = $n.GetAttribute('bounds')
        $x1 = 0; $y1 = 0; $x2 = 0; $y2 = 0
        if ($bounds -match '\[(\d+),(\d+)\]\[(\d+),(\d+)\]') {
            $x1 = [int]$Matches[1]; $y1 = [int]$Matches[2]; $x2 = [int]$Matches[3]; $y2 = [int]$Matches[4]
        }
        $nodes += [pscustomobject]@{
            Text      = $n.GetAttribute('text')
            Id        = $n.GetAttribute('resource-id')
            Desc      = $n.GetAttribute('content-desc')
            Class     = $n.GetAttribute('class')
            Package   = $n.GetAttribute('package')
            Clickable = ($n.GetAttribute('clickable') -eq 'true')
            Enabled   = ($n.GetAttribute('enabled') -eq 'true')
            Bounds    = $bounds
            CenterX   = [int](($x1 + $x2) / 2)
            CenterY   = [int](($y1 + $y2) / 2)
        }
    }
    return $nodes
}

function Select-UiNode {
    param($Nodes, [string]$Text, [string]$Id, [string]$Desc, [string]$Class, [switch]$ClickableOnly, [switch]$All)
    $hits = $Nodes | Where-Object {
        $ok = $true
        if ($Text) { $ok = $ok -and ($_.Text -and $_.Text -like "*$Text*") }
        if ($Id)   { $ok = $ok -and ($_.Id   -and $_.Id   -like "*$Id*") }
        if ($Desc) { $ok = $ok -and ($_.Desc -and $_.Desc -like "*$Desc*") }
        if ($Class) { $ok = $ok -and ($_.Class -and $_.Class -like "*$Class*") }
        if ($ClickableOnly) { $ok = $ok -and $_.Clickable }
        $ok
    }
    if ($All) { return @($hits) }
    return @($hits | Select-Object -First 1)
}

function Show-Nodes {
    param($Nodes)
    if (-not $Nodes -or $Nodes.Count -eq 0) { Write-Host '(no matching nodes)' -ForegroundColor Yellow; return }
    foreach ($n in $Nodes) {
        $label = @()
        if ($n.Text) { $label += "text='$($n.Text)'" }
        if ($n.Id)   { $label += "id='$($n.Id)'" }
        if ($n.Desc) { $label += "desc='$($n.Desc)'" }
        $short = ($n.Class -split '\.')[-1]
        Write-Host ("  [{0},{1}] {2,-14} {3} {4}" -f $n.CenterX, $n.CenterY, $short, ($label -join ' '), $(if ($n.Clickable) { '(clickable)' } else { '' }))
    }
}

switch ($Action.ToLower()) {
    'dump' {
        $raw = Get-UiXml -Serial $dev.Serial
        if ($Out) {
            Write-TextNoBom -Path $Out -Content $raw | Out-Null
            Write-Host "Saved: $Out" -ForegroundColor Green
        } else { Write-Output $raw }
    }
    'nodes' {
        $nodes = ConvertTo-UiNodes -Raw (Get-UiXml -Serial $dev.Serial)
        if ($Json) { $nodes | ConvertTo-Json -Depth 4; return }
        Show-Nodes $nodes
    }
    'describe' {
        $nodes = ConvertTo-UiNodes -Raw (Get-UiXml -Serial $dev.Serial)
        $interesting = @($nodes | Where-Object { ($_.Text -or $_.Desc -or $_.Id) -and $_.Bounds -ne '[0,0][0,0]' })
        Write-Host ("Visible elements on {0} ({1}):" -f $dev.Serial, $dev.Model) -ForegroundColor Cyan
        Show-Nodes $interesting
        Write-Host ''
        Write-Host ("Total nodes: {0}; with text/id/desc: {1}" -f $nodes.Count, $interesting.Count) -ForegroundColor DarkGray
    }
    'find' {
        $nodes = ConvertTo-UiNodes -Raw (Get-UiXml -Serial $dev.Serial)
        $hit = Select-UiNode -Nodes $nodes -Text $Text -Id $Id -Desc $Desc -Class $Class -ClickableOnly:$ClickableOnly -All
        if ($Json) { $hit | ConvertTo-Json -Depth 4; return }
        Show-Nodes $hit
    }
    'tap' {
        if ($Xy) {
            $parts = $Xy -split '[,\s]+' | Where-Object { $_ }
            if ($parts.Count -lt 2) { throw '-Xy needs "x y".' }
            $cx = [int]$parts[0]; $cy = [int]$parts[1]
        } else {
            $nodes = ConvertTo-UiNodes -Raw (Get-UiXml -Serial $dev.Serial)
            $hit = Select-UiNode -Nodes $nodes -Text $Text -Id $Id -Desc $Desc -Class $Class
            if (-not $hit) { throw "No node matched (Text='$Text' Id='$Id' Desc='$Desc')." }
            $cx = $hit.CenterX; $cy = $hit.CenterY
            Write-Host ("Tapping {0} at ({1},{2})" -f $(if ($hit.Text) { "'$($hit.Text)'" } elseif ($hit.Id) { "'$($hit.Id)'" } else { $hit.Class }), $cx, $cy) -ForegroundColor Cyan
        }
        Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'input', 'tap', "$cx", "$cy") | Out-Null
    }
    'text' {
        if (-not $Value) { throw '-Value is required.' }
        # `input text` treats spaces literally only when escaped as %s.
        $escaped = $Value -replace ' ', '%s'
        $escaped = $escaped -replace '([&<>|;()$"''`\\])', '\$1'
        Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'input', 'text', $escaped) | Out-Null
        Write-Host "Typed: $Value" -ForegroundColor Green
    }
    'key' {
        if (-not $Name) { throw '-Name is required (e.g. BACK, HOME, ENTER, DEL).' }
        $code = if ($Name -match '^\d+$') { $Name } else { "KEYCODE_$($Name.ToUpper())" }
        Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'input', 'keyevent', $code) | Out-Null
        Write-Host "Key: $code" -ForegroundColor Green
    }
    'swipe' {
        $ms = 300
        Invoke-Adb -Serial $dev.Serial -Arguments @('shell', 'input', 'swipe', "$X1", "$Y1", "$X2", "$Y2", "$ms") | Out-Null
        Write-Host "Swiped ($X1,$Y1) -> ($X2,$Y2)" -ForegroundColor Green
    }
    'wait' {
        if (-not $Text -and -not $Id -and -not $Desc) { throw 'wait needs -Text, -Id or -Desc.' }
        $deadline = (Get-Date).AddSeconds($TimeoutSec)
        while ((Get-Date) -lt $deadline) {
            try {
                $nodes = ConvertTo-UiNodes -Raw (Get-UiXml -Serial $dev.Serial)
                $hit = Select-UiNode -Nodes $nodes -Text $Text -Id $Id -Desc $Desc
                if ($hit) { Write-Host 'Found.' -ForegroundColor Green; return }
            } catch { }
            Start-Sleep -Milliseconds 800
        }
        throw "Timed out after ${TimeoutSec}s waiting for Text='$Text' Id='$Id' Desc='$Desc'."
    }
    'screenshot' {
        if (-not $Out) { $Out = Join-Path $env:TEMP ("ui_{0:yyyyMMdd_HHmmss}.png" -f (Get-Date)) }
        $p = Save-AdbScreenshot -Path $Out -Serial $dev.Serial
        Write-Host "Saved: $p" -ForegroundColor Green
        Write-Output $p
    }
    default { throw "Unknown action '$Action'. See the header of as-ui.ps1." }
}
