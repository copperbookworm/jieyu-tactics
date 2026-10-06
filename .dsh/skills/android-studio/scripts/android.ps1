# android.ps1 — single entry point for the Android Studio toolkit (house style,
# like deveco.ps1). It forwards to the focused as-*.ps1 scripts in this directory.
#
#   .\android.ps1 doctor                       # readiness report (run this first)
#   .\android.ps1 env                          # resolved paths; -Json for machine output
#   .\android.ps1 new    -Path .\App -Name App -Package com.example.app -Build
#   .\android.ps1 build  -Project .\App [-Task testDebugUnitTest] [-Offline]
#   .\android.ps1 run    -Project .\App -Build -Screenshot .\shots\a.png
#   .\android.ps1 ui     describe | tap -Text '...' | text -Value '...' | key -Name BACK
#   .\android.ps1 device status | wait | screenshot -Out x.png | avd-create -Avd pixel33
#   .\android.ps1 ide    which | status | launch -Project .\App | inspect -Project .\App
#
# Add -DryRun to print the equivalent as-*.ps1 invocation without running it.
#
# Messages here are ASCII on purpose: PowerShell 5.1 reads BOM-less UTF-8 as ANSI,
# so a .ps1 containing Chinese would mis-parse as soon as an editor drops the BOM.
# The Chinese documentation lives in SKILL.md and references/.

# NOTE: this must stay a SIMPLE (non-advanced) script — no [CmdletBinding()] and no
# [Parameter()] attributes anywhere. Either one turns the script "advanced", which adds
# the common parameters (-OutVariable/-OutBuffer/-Verbose/...), and then a child's own
# -Out becomes ambiguous:
#     & android.ps1 device screenshot -Out x.png
#     -> "Parameter cannot be processed because the parameter name 'Out' is ambiguous"
# A simple script has no common parameters, so it collects every unbound token in $args
# and forwards it to the child untouched.
param(
    # Named $Sub, not $Command: as-device.ps1 itself takes a -Command parameter, and a
    # dispatcher parameter of the same name would capture it before it reached the child.
    [string]$Sub = 'doctor',
    [switch]$DryRun
)

$ErrorActionPreference = 'Continue'

$map = [ordered]@{
    'doctor' = 'as-doctor.ps1'
    'env'    = 'as-env.ps1'
    'new'    = 'as-new.ps1'
    'build'  = 'as-build.ps1'
    'run'    = 'as-run.ps1'
    'ui'     = 'as-ui.ps1'
    'device' = 'as-device.ps1'
    'ide'    = 'as-ide.ps1'
    'lib'    = 'as-lib.ps1'
}

$key = $Sub.ToLower()

if ($key -in @('help', '-h', '--help', '/?', '?')) {
    Write-Host 'android.ps1 - autonomous Android Studio toolchain'
    Write-Host ''
    Write-Host 'Usage:  .\android.ps1 <command> [args...] [-DryRun]'
    Write-Host ''
    Write-Host 'Commands:'
    Write-Host '  doctor    readiness report: toolchain, JDKs, device, project   (start here)'
    Write-Host '  env       resolved Studio/SDK/JDK/Gradle paths (-Json supported)'
    Write-Host '  new       scaffold a buildable app (-Path -Name -Package -Language -Build)'
    Write-Host '  build     run a Gradle task (-Project -Task -Variant -Offline -Clean)'
    Write-Host '  run       install + launch + crash check + screenshot (-Project -Build -Screenshot)'
    Write-Host '  ui        drive the app UI (describe|find|tap|text|key|swipe|wait|screenshot|dump|nodes)'
    Write-Host '  device    devices/emulator (status|wait|screenshot|shell|install|uninstall|tcpip|connect|avd-list|avd-create|emulator-start|emulator-stop)'
    Write-Host '  ide       Android Studio itself (which|status|launch|close|inspect|format|log)'
    Write-Host ''
    Write-Host 'Examples:'
    Write-Host '  .\android.ps1 doctor'
    Write-Host '  .\android.ps1 new  -Path .\MyApp -Name MyApp -Package com.example.myapp -Build'
    Write-Host '  .\android.ps1 run  -Project .\MyApp -Build -Screenshot .\shots\a.png'
    Write-Host '  .\android.ps1 ui   describe'
    Write-Host '  .\android.ps1 ui   tap -Text "Continue"'
    exit 0
}

if (-not $map.Contains($key)) {
    Write-Host ("Unknown command '{0}'." -f $Sub) -ForegroundColor Red
    Write-Host ("Known: {0}" -f (($map.Keys) -join ', ')) -ForegroundColor Yellow
    exit 2
}

$scriptPath = Join-Path $PSScriptRoot $map[$key]
if (-not (Test-Path -LiteralPath $scriptPath)) {
    Write-Host ("Missing script: {0}" -f $scriptPath) -ForegroundColor Red
    exit 2
}

# $args holds every token that did not bind to $Sub/$DryRun, parameter names included.
# Array splatting (`& $script @arr`) would pass them POSITIONALLY, so rebuild a command
# line instead, quoting only the values that need it.
$argList = @($args)
$parts = @()
foreach ($a in $argList) {
    $s = [string]$a
    if ($s -match '^-\w') {
        $parts += $s
    } elseif ($s -match '[\s"'']') {
        $parts += ("'" + ($s -replace "'", "''") + "'")
    } else {
        $parts += $s
    }
}
$rendered = ($parts -join ' ')

if ($DryRun) {
    Write-Host ("& '{0}' {1}" -f $scriptPath, $rendered)
    exit 0
}

Invoke-Expression ("& '{0}' {1}" -f $scriptPath, $rendered)
exit $LASTEXITCODE
