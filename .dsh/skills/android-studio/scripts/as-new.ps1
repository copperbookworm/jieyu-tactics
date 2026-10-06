# as-new.ps1 — scaffold a minimal, immediately-buildable Android app project.
#   .\as-new.ps1 -Path .\MyApp -Name MyApp -Package com.example.myapp
#   .\as-new.ps1 -Path .\MyApp -Name MyApp -Package com.example.myapp -Language kotlin -Build
#
# Produces a project that builds without AndroidX (fewest moving parts, fewest
# downloads). Add AndroidX later if the app needs it.

[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Package,
    [string]$Language = 'java',
    [int]$MinSdk = 21,
    [int]$TargetSdk = 35,
    [int]$CompileSdk = 35,
    [string]$AgpVersion = '8.6.1',
    [string]$KotlinVersion = '2.1.20',
    [switch]$Force,
    [switch]$Build
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'as-lib.ps1') -AsProjectRoot $null -AsQuiet

if (Test-Path -LiteralPath $Path) {
    $existing = @(Get-ChildItem -LiteralPath $Path -Force -ErrorAction SilentlyContinue)
    if ($existing.Count -gt 0 -and -not $Force) {
        throw "Path '$Path' already exists and is not empty. Use -Force to write into it anyway."
    }
} else {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}
$root = (Resolve-Path -LiteralPath $Path).Path

if ($Language -notin @('java', 'kotlin')) { throw "-Language must be 'java' or 'kotlin'." }
$isKotlin = ($Language -eq 'kotlin')

function Write-File {
    param([string]$Rel, [string]$Content)
    $full = Join-Path $root $Rel
    Write-TextNoBom -Path $full -Content $Content | Out-Null
    Write-Host ("  + {0}" -f $Rel) -ForegroundColor DarkGray
}

Write-Host "Scaffolding $Name ($Package, $Language) at $root" -ForegroundColor Cyan

Write-File 'settings.gradle' @"
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = '$Name'
include ':app'
"@

$plugins = @("    id 'com.android.application' version '$AgpVersion' apply false")
if ($isKotlin) { $plugins += "    id 'org.jetbrains.kotlin.android' version '$KotlinVersion' apply false" }
Write-File 'build.gradle' ("plugins {`n" + ($plugins -join "`n") + "`n}`n")

Write-File 'gradle.properties' @"
android.useAndroidX=false
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.caching=true
"@

if ($AsEnv.SdkRoot) {
    $sdkEsc = ($AsEnv.SdkRoot -replace '\\', '\\') -replace ':', '\:'
    Write-File 'local.properties' ("sdk.dir=" + $sdkEsc + "`n")
}

Write-File '.gitignore' @"
.gradle/
build/
local.properties
*.iml
.idea/
"@

$appPlugins = @("    id 'com.android.application'")
if ($isKotlin) { $appPlugins += "    id 'org.jetbrains.kotlin.android'" }
$kotlinBlock = if ($isKotlin) { "`n    kotlinOptions {`n        jvmTarget = '17'`n    }`n" } else { '' }

Write-File 'app/build.gradle' @"
plugins {
$($appPlugins -join "`n")
}

android {
    namespace '$Package'
    compileSdk $CompileSdk

    defaultConfig {
        applicationId '$Package'
        minSdk $MinSdk
        targetSdk $TargetSdk
        versionCode 1
        versionName '1.0'
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
$kotlinBlock
    buildTypes {
        release {
            minifyEnabled false
        }
    }
}
"@

Write-File 'app/src/main/AndroidManifest.xml' @"
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="@string/app_name"
        android:theme="@android:style/Theme.Material.Light">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
"@

Write-File 'app/src/main/res/values/strings.xml' @"
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">$Name</string>
</resources>
"@

$pkgPath = $Package -replace '\.', '\'
if ($isKotlin) {
    Write-File "app/src/main/java/$pkgPath/MainActivity.kt" @"
package $Package

import android.app.Activity
import android.os.Bundle
import android.widget.TextView

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val tv = TextView(this)
        tv.text = "$Name is running"
        tv.textSize = 28f
        setContentView(tv)
    }
}
"@
} else {
    Write-File "app/src/main/java/$pkgPath/MainActivity.java" @"
package $Package;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView tv = new TextView(this);
        tv.setText("$Name is running");
        tv.setTextSize(28f);
        setContentView(tv);
    }
}
"@
}

Write-Host ''
Write-Host "Scaffolded: $root" -ForegroundColor Green

if ($Build) {
    Write-Host 'Building...' -ForegroundColor Cyan
    & (Join-Path $PSScriptRoot 'as-build.ps1') -Project $root -Task 'assembleDebug'
    exit $LASTEXITCODE
}
