# 工具链参考（android-studio）

本机实测基线。若版本看起来不对，用 `& $A doctor -Json` 重新测量——Studio 或 SDK 升级后会变。
（`$A` = `D:\dsh-data\skills\android-studio\scripts\android.ps1`）

## Android Studio 本体

```
F:\AndroidStudio\                       AI-262.9437.185.2621.16467767  (Android Studio 2026.2.1)
  bin\studio64.exe                      IDE 启动器
  bin\studio.bat                        CLI 分发器：studio.bat <inspect|format|...>
  bin\inspect.bat                        headless 离线代码检查（→ studio.bat inspect）
  bin\format.bat                         headless 格式化（→ studio.bat format）
  bin\profiler.bat, ltedit.bat, game-tools.bat
  jbr\                                  自带 JetBrains Runtime = JDK 25.0.3（**只给 IDE**）
```

配置与日志：`%APPDATA%\Google\AndroidStudio2026.2.1\`，日志 `log\idea.log`。

`product-info.json` 里 `minRequiredJavaVersion: 25`，`studio.bat` 也优先用自带的 `jbr`。
这对 **IDE** 是对的，对 **构建** 是错的——见下节。

`inspect.bat` / `format.bat` 都只是 `studio.bat` 的薄封装，参数直接透传：
`inspect.bat <工程目录> <输出目录> [检查配置]`。

## Android SDK

```
C:\Users\feiyun\AppData\Local\Android\Sdk
  platform-tools\adb.exe                adb（还有 fastboot、sqlite3）
  platforms\                            android-28, 33, 34, 35, 36
  build-tools\                          28.0.3, 30.0.3, 33.0.0, 34.0.0, 35.0.0, 36.0.0, 36.1.0
  emulator\emulator.exe                 emulator + mksdcard
  system-images\android-33\google_apis\x86_64     8.2 GB 的 system.img，完整
  extras\intel\Hardware_Accelerated_Execution_Manager\    HAXM 安装器（本机用不到）
  cmdline-tools\latest\bin\             sdkmanager / avdmanager / lint / apkanalyzer（19.0）
```

### cmdline-tools（2026-10-06 装入）

- 来源：`https://mirrors.cloud.tencent.com/AndroidSDK/commandlinetools-win-13114758_latest.zip`
  （146 MB，实测 ~5 MB/s；`dl.google.com` 上同名包在本机取不到）。
- 安装位置：`<SDK>\cmdline-tools\latest`（`source.properties` 里 `Pkg.Revision=19.0`）。
- `sdkmanager --version` → `19.0`；`avdmanager list avd` 正常。
- ⚠ 会打印 `This version only understands SDK XML versions up to 3 but an SDK XML file
  of version 4 was encountered`。因为 Android Studio 2026.2.1 写的 `package.xml` 是 v4，
  而**任何已发布的 cmdline-tools 都比这个 Studio 旧**，属前向兼容噪声，可忽略。
- ⚠ `sdkmanager` 需要访问 `dl.google.com` 取仓库清单，本机**经常不通**（卡在
  `Loading package information...`）。要装包时的替代路径：从腾讯镜像取
  `repository2-3.xml` 与对应 zip，手工解压进 SDK（每个包的 zip 自带 `package.xml`）。

### AVD

`device avd-create` 现在**优先调 `avdmanager`**（`create avd -n <name> -k <pkg> --abi <abi>
--force --device pixel_5`，并用 `echo no|` 回答 "custom hardware profile" 提示）；
只有 `cmdline-tools` 缺失时才回退到手工写两个 INI：

- `%USERPROFILE%\.android\avd\<name>.ini` → `path`、`path.rel`、`target`
- `%USERPROFILE%\.android\avd\<name>.avd\config.ini` → `image.sysdir.1`、`abi.type`、
  `tag.id`、分辨率、RAM 等

`image.sysdir.1` 是**相对 SDK 根、用正斜杠**，例如
`system-images/android-33/google_apis/x86_64/`。

本机已建 AVD：`asprobe33`（Android 13 / API 33 / google_apis / x86_64）。
`emulator -accel-check` → `accel: 0` + `WHPX(10.0.19045) is installed and usable`，
所以模拟器可跑；**不要装 HAXM**（与 Hyper-V 冲突且不需要）。

## 本机 JDK 清单

| 主版本 | 路径 | 角色 |
|---|---|---|
| 25 | `F:\AndroidStudio\jbr` | 只给 IDE —— **Gradle 8.11 用不了** |
| 17 | `C:\Program Files\Java\jdk-17` | **Gradle / AGP 用的那个** |
| 17 | `C:\Users\feiyun\.jdks\jbr-17.0.14` | JetBrains Runtime 17（备用） |
| 11 | `C:\Program Files\Java\jdk-11` | 对 AGP 8.x 太旧 |
| 8  | `C:\Program Files\Java\jdk-1.8` | 遗留 |

`as-env.ps1` 选构建 JDK 的顺序：**17 → 21 → 23 → 22 → 20 → 19 → 18**，
扫描目录：`%ProgramFiles%\Java`、Eclipse Adoptium、Microsoft、Amazon Corretto、Zulu、
`%USERPROFILE%\.jdks`、`%LOCALAPPDATA%\Programs\Eclipse Adoptium`。
17..23 任意一个都能用，**优先 17** 因为它是实测通过的那个。

> 注意：`%JAVA_HOME%` 系统变量指向 **jdk-11**，与构建需求不符。
> 不要依赖它——一律让脚本解析。

## Gradle

```
C:\Users\feiyun\.gradle\wrapper\dists\gradle-8.11.1-bin\<hash>\gradle-8.11.1\bin\gradle.bat
```

发行版**已解压**，所以构建**不需要**下载 Gradle。
解析顺序：工程的 `gradlew.bat` → 本地缓存的发行版 → PATH 上的 `gradle`。

## 网络与镜像（本机关键约束）

**境外仓库在本机不可靠**，实测两者都会失败：

| 端点 | 现象 |
|---|---|
| `dl.google.com`（AGP/androidx/命令行工具） | `基础连接已经关闭: 发送时发生错误` |
| `repo.maven.apache.org`（Maven Central） | `Connect timed out`（`103.73.220.188`） |
| `plugins.gradle.org` | 同上游，随代理抖动 |
| `maven.aliyun.com/repository/{google,public,gradle-plugin}` | **稳定 200** |
| `mirrors.cloud.tencent.com/AndroidSDK/` | 稳定 200，~5 MB/s |

代理是 `HTTP(S)_PROXY=http://127.0.0.1:7897`（Clash 类），但**即便走代理，境外两个仓库也会失败**。

### 全局配置（已就位，2026-10-06）

`C:\Users\feiyun\.gradle\init.gradle` —— 把三个上游仓库**就地换 URL**：

| 上游 | 换成 |
|---|---|
| `dl.google.com` / `maven.google.com` | `https://maven.aliyun.com/repository/google` |
| `repo.maven.apache.org` / `repo1.maven.org` | `https://maven.aliyun.com/repository/public` |
| `plugins.gradle.org` | `https://maven.aliyun.com/repository/gradle-plugin` |

覆盖范围：settings 的 `pluginManagement` 与 `dependencyResolutionManagement`、以及每个工程的
`repositories` 与 `buildscript.repositories`。

**为什么是换 URL 而不是追加镜像**：追加时 Gradle 仍会先试原仓库；每次都失败不只是慢，还会把仓库
标记为 `disabled due to earlier error`，导致后续构件直接解析失败。换 URL 则顺序/去重/工程配置全不动。

**为什么只能 `setUrl`**：Gradle 禁止仓库加入容器后改名，`setName()` 会让配置阶段直接失败。

`C:\Users\feiyun\.gradle\gradle.properties` —— 性能参数 + 连接超时（15s/30s，让不可达仓库快速失败）。
里面**故意没有全局代理**：镜像走国内直连，而把 JVM 代理硬指到本机 Clash，会在代理未开时让**所有**
依赖解析一起失败。需要时按文件内注释打开 `systemProp.*.proxyHost`。

### 实测结论

- 含 AndroidX + Material 的工程：`BUILD SUCCESSFUL`，日志里下载全部来自 `maven.aliyun.com`。
- Kotlin 工程：`BUILD SUCCESSFUL in 52s`，日志中 `repo.maven.apache.org` / `dl.google.com` /
  `plugins.gradle.org` 出现次数均为 **0**。
- 一次并发抓取时出现过 `Could not parse POM .../material-1.12.0.*`，串行重跑即成功 → 视为瞬时抖动。

## 依赖缓存现状

`%USERPROFILE%\.gradle\caches\modules-2\files-2.1\` 里已有：

- `com.android.tools.build:gradle:8.6.1`（以及 aapt2、builder、manifest-merger、lint…）
- `org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.20` 与 `2.1.21`、`kotlin-bom`、插件 marker
- `androidx.*`：`appcompat:1.7.0`、`constraintlayout:2.1.4`、activity、core、lifecycle、fragment…
- `com.google.android.material:material:1.12.0`

2026-10-06 已用两个真实工程（`MirrorProbe`、`KotlinDemo`）把这些拉进缓存，
所以这些依赖现在**离线也能构建**；用 `-Offline` 可以验证。

## `as-new.ps1` 生成的工程结构

刻意最小化——不用 AndroidX，依赖解析最简单、构建最快：

```
MyApp/
  settings.gradle          pluginManagement { google(); mavenCentral(); gradlePluginPortal() }
  build.gradle             plugins { id 'com.android.application' version '8.6.1' apply false }
  gradle.properties        android.useAndroidX=false, org.gradle.jvmargs=-Xmx2048m
  local.properties         sdk.dir=...（由解析出的 SDK 写入，无 BOM）
  app/build.gradle         namespace, compileSdk 35, minSdk 21, targetSdk 35, Java 17
  app/src/main/AndroidManifest.xml
  app/src/main/res/values/strings.xml
  app/src/main/java/<pkg>/MainActivity.java     （extends android.app.Activity）
```

要上 AndroidX：把 `android.useAndroidX=true` 打开再加依赖；`androidx.*` 大多已缓存。
AGP 8 要求用 `namespace`（manifest 里的 `package` 属性已废弃）。
`compileSdk 35` 需要 AGP ≥ 8.6.0。

## 本次验收用的工程

`C:\Users\feiyun\Documents\deepseek-harness\default-workspace\android-studio\` 下的三个样例
（`DemoApp` 最简 Java；`KotlinDemo` Kotlin 模板；`MirrorProbe` AndroidX + Material）都完整走通过
"构建 → 装机 → 启动 → 截图 → 读界面 → 点击"。需要"已知能跑的参照物"时用它们。
