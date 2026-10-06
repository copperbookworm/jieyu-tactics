# as-ide.ps1 — control the Android Studio installation itself.
#
# Android Studio is a GUI, but it exposes a real headless command surface:
#   * launch studio64.exe <project>   -> open a project in the IDE
#   * inspect.bat                     -> offline code inspection (no GUI)
#   * format.bat                      -> offline formatter (no GUI)
#   * Gradle (as-build.ps1)           -> the actual build engine the IDE drives
# Those plus adb are what "using Android Studio" means in practice — the GUI is a
# viewer for the same underlying toolchain.
#
#   .\as-ide.ps1 which
#   .\as-ide.ps1 status
#   .\as-ide.ps1 launch   -Project <dir>
#   .\as-ide.ps1 close
#   .\as-ide.ps1 inspect  -Project <dir> [-Out <dir>]
#   .\as-ide.ps1 format   -Project <dir>
#   .\as-ide.ps1 log      [-Tail 60]

# Deliberately a SIMPLE (non-advanced) script: [CmdletBinding()] or any [Parameter()]
# attribute would add the common parameters, making this script's own -Out ambiguous
# with -OutVariable/-OutBuffer when called directly (`as-ide.ps1 inspect -Out dir`).
param(
    [string]$Action = 'which',
    [string]$Project,
    [string]$Out,
    [string]$ReportFormat = 'xml',
    [int]$Tail = 60,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'as-lib.ps1') -AsProjectRoot $Project -AsQuiet

$studioBin = if ($AsEnv.StudioHome) { Join-Path $AsEnv.StudioHome 'bin' } else { $null }
$inspectBat = if ($studioBin) { Join-Path $studioBin 'inspect.bat' } else { $null }
$formatBat  = if ($studioBin) { Join-Path $studioBin 'format.bat' } else { $null }

function Get-StudioProcess {
    Get-Process -Name 'studio64', 'studio' -ErrorAction SilentlyContinue
}

function RequireProject {
    if (-not $Project) { throw '-Project <dir> is required for this action.' }
    if (-not (Test-Path -LiteralPath $Project)) { throw "Project not found: $Project" }
    return (Resolve-Path -LiteralPath $Project).Path
}

switch ($Action.ToLower()) {
    'which' {
        Write-Host ("Studio home : {0}" -f $AsEnv.StudioHome)
        Write-Host ("Launcher    : {0}" -f $AsEnv.StudioExe)
        Write-Host ("IDE JDK     : {0} (major {1})" -f $AsEnv.IdeJdk, $AsEnv.IdeJdkMajor)
        Write-Host ("inspect.bat : {0}" -f $inspectBat)
        Write-Host ("format.bat  : {0}" -f $formatBat)
        Write-Host ("SDK         : {0}" -f $AsEnv.SdkRoot)
        $cfg = "$env:APPDATA\Google\AndroidStudio2026.2.1"
        Write-Host ("Config dir  : {0} (exists: {1})" -f $cfg, (Test-Path -LiteralPath $cfg))
        Write-Host ("Logs dir    : {0}" -f (Join-Path $cfg 'log'))
    }
    'status' {
        $p = Get-StudioProcess
        if ($p) {
            Write-Host "Android Studio is RUNNING:" -ForegroundColor Green
            $p | ForEach-Object { Write-Host ("  pid {0}  started {1}  mem {2:n0} MB" -f $_.Id, $_.StartTime, ($_.WorkingSet64 / 1MB)) }
            # IntelliJ keeps a per-instance "port" file used for command-line forwarding.
            $portFile = Join-Path "$env:APPDATA\Google\AndroidStudio2026.2.1" '.port'
            if (Test-Path -LiteralPath $portFile) { Write-Host ("  command port file: {0}" -f (Get-Content -LiteralPath $portFile -Raw).Trim()) }
        } else {
            Write-Host 'Android Studio is not running.' -ForegroundColor Yellow
        }
    }
    'launch' {
        if (-not $AsEnv.StudioExe) { throw 'studio64.exe not found.' }
        $args = @()
        if ($Project) { $args += (Resolve-Path -LiteralPath $Project).Path }
        Start-Process -FilePath $AsEnv.StudioExe -ArgumentList $args
        Write-Host ("Launched Android Studio{0}" -f $(if ($Project) { " on $Project" } else { '' })) -ForegroundColor Green
        Write-Host 'The IDE uses its own JDK 25; Gradle still needs JDK 17 (see as-build.ps1).' -ForegroundColor DarkGray
    }
    'close' {
        $p = Get-StudioProcess
        if (-not $p) { Write-Host 'Not running.' -ForegroundColor Yellow; return }
        Write-Host 'Requesting close (unsaved work may be lost; the IDE will prompt if -Force is not used)...' -ForegroundColor Yellow
        foreach ($proc in $p) {
            try { $proc.CloseMainWindow() | Out-Null } catch { }
        }
        Start-Sleep -Seconds 3
        $still = Get-StudioProcess
        if ($still -and $Force) {
            $still | Stop-Process -Force
            Write-Host 'Force-stopped.' -ForegroundColor Yellow
        } elseif ($still) {
            Write-Host 'Still running (a dialog may be waiting, or the IDE is saving). Re-run with -Force to kill.' -ForegroundColor Yellow
        } else {
            Write-Host 'Closed.' -ForegroundColor Green
        }
    }
    'inspect' {
        $proj = RequireProject
        if (-not $inspectBat) { throw 'inspect.bat not found in the Android Studio bin directory.' }
        if (-not $Out) { $Out = Join-Path $proj 'build\inspections' }
        New-Item -ItemType Directory -Path $Out -Force | Out-Null
        # inspect.bat's real contract is
        #   <project_file_path> <inspection_profile> <output_path> [<options>]
        # where the profile may be skipped when -e is supplied. Passing just
        # (project, outdir) fails with "invalid args".
        $inspectArgs = @($proj, '-e', $Out, '-format', $ReportFormat)
        Write-Host ("inspect.bat {0}" -f ($inspectArgs -join ' ')) -ForegroundColor DarkGray
        Write-Host 'Running offline inspection (this starts a headless IDE; it can take minutes)...' -ForegroundColor Cyan
        Push-Location $proj
        try {
            $r = Invoke-Native -FilePath $inspectBat -Arguments $inspectArgs
            Write-Host $r.Output
        } finally { Pop-Location }
        Write-Host "Inspection output: $Out" -ForegroundColor Green
        Get-ChildItem -LiteralPath $Out -ErrorAction SilentlyContinue | Select-Object Name, Length | Format-Table -AutoSize | Out-String | Write-Host
    }
    'format' {
        $proj = RequireProject
        if (-not $formatBat) { throw 'format.bat not found in the Android Studio bin directory.' }
        # Real usage: format [-h] [-r|-R] [-d|-dry] [-s settings] [-charset] [-allowDefaults] path...
        #   * -r  : the formatter is NON-recursive by default
        #   * -allowDefaults : without it, a file that belongs to no IntelliJ project is
        #     IGNORED ("No style for ... skipping"), which is exactly our case — these
        #     Gradle projects were never opened in the IDE, so they have no .idea styles.
        # Point it at source directories, never the project root: with -r the root would
        # also walk build/ and .gradle/ output.
        $targets = @()
        foreach ($rel in @('app\src', 'src')) {
            $d = Join-Path $proj $rel
            if (Test-Path -LiteralPath $d) { $targets += $d; break }
        }
        if (-not $targets) { $targets = @($proj) }
        $fmtArgs = @('-r', '-allowDefaults') + $targets
        Write-Host ("format.bat {0}" -f ($fmtArgs -join ' ')) -ForegroundColor DarkGray
        Write-Host 'Running offline formatter (factory code style; recurses over the source dirs)...' -ForegroundColor Cyan
        Push-Location $proj
        try {
            $r = Invoke-Native -FilePath $formatBat -Arguments $fmtArgs
            Write-Host $r.Output
        } finally { Pop-Location }
        Write-Host 'Formatting pass complete.' -ForegroundColor Green
    }
    'log' {
        $logDir = "$env:APPDATA\Google\AndroidStudio2026.2.1\log"
        if (-not (Test-Path -LiteralPath $logDir)) { throw "No IDE log directory at $logDir" }
        $idea = Join-Path $logDir 'idea.log'
        if (-not (Test-Path -LiteralPath $idea)) {
            Get-ChildItem -LiteralPath $logDir | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize | Out-String | Write-Host
            throw "idea.log not found in $logDir"
        }
        Get-Content -LiteralPath $idea -Tail $Tail
    }
    default { throw "Unknown action '$Action'. See the header of as-ide.ps1." }
}
