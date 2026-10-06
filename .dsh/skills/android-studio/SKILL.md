---
name: android-studio
description: 无人值守使用 F:\AndroidStudio 这套 Android Studio 工具链开发/构建/安装/运行/驱动 Android 应用。当任务涉及 Android Studio、Android app、APK、AAB、Gradle、AGP、adb、模拟器、真机装包，或"做个安卓应用 / 打个包 / 装到手机上 / 应用闪退了 / 点一下界面"时使用。不需要打开 IDE 图形界面。
whenToUse: 需要新建或修改 Android 工程并出包；需要跑 Gradle 构建/单测/lint；需要把 APK 装到真机或模拟器并启动、截图、看 logcat；需要脚本化地操作应用界面（点击/输入/滑动/等待元素）；需要调用 Android Studio 自带的 headless 检查与格式化；需要确认本机 Android 工具链当前到底能不能用。
metadata:
  version: 1
  updated: 2026-10-06
---

# android-studio · 无人值守使用 Android Studio 工具链

## 一句话口径

**Android Studio 本体是 IntelliJ 平台 IDE，没有"把 GUI 当人用"的脚本接口。**
真正的自动化面 = IDE 底下那一整套 CLI：**Gradle + AGP + Android SDK + adb + emulator**，
外加 IDE 自带的 headless 入口（`inspect.bat` / `format.bat`）。
本技能把它编排成一条命令链：**体检 → 生成工程 → 出包 → 装 → 起 → 截图 → 读界面 → 点 → 复验**。
GUI 只是同一套工具链的查看器，要看画面时才 `ide launch`。

## 入口

```powershell
$A = 'D:\dsh-data\skills\android-studio\scripts\android.ps1'

& $A doctor                       # 体检（第一次必跑，判断"现在能不能干"）
& $A env                          # 打印所有解析出的路径（-Json 给机器读）
& $A new   -Path D:\tmp\Demo -Name Demo -Package com.example.demo -Build
& $A build -Project D:\tmp\Demo                     # assembleDebug
& $A build -Project D:\tmp\Demo -Task testDebugUnitTest
& $A run   -Project D:\tmp\Demo -Build -Screenshot D:\tmp\shots\a.png
& $A ui    describe                                 # 看一眼屏幕上有什么
& $A ui    tap -Text 'Continue'
& $A ui    text -Value 'hello world'
& $A ui    key -Name BACK
& $A device status                                  # 列设备
& $A device screenshot -Out D:\tmp\s.png
& $A ide   which                                    # IDE / 检查器 / 日志目录
```

`-DryRun` 打印等价的 `as-*.ps1` 调用而不执行。
`android.ps1` 只是转发器，真正干活的是同目录 8 个聚焦脚本（见下表）。

## 本机环境事实（2026-10-06 核实）

| 项 | 值 |
|---|---|
| Android Studio 安装根 | `F:\AndroidStudio`（build `AI-262.9437.185.2621.16467767`，即 2026.2.1） |
| IDE 启动器 | `F:\AndroidStudio\bin\studio64.exe` |
| IDE 自带 JDK | `F:\AndroidStudio\jbr` = **JDK 25.0.3**（`minRequiredJavaVersion=25`，**只给 IDE 用**） |
| **Gradle 用的 JDK** | `C:\Program Files\Java\jdk-17`（**JDK 17，构建必须用这个**） |
| Android SDK | `C:\Users\feiyun\AppData\Local\Android\Sdk` |
| adb | `<SDK>\platform-tools\adb.exe` |
| emulator | `<SDK>\emulator\emulator.exe` |
| platforms | android-28 / 33 / 34 / 35 / 36 |
| build-tools | 28.0.3 / 30.0.3 / 33.0.0 / 34.0.0 / 35.0.0 / 36.0.0 / **36.1.0** |
| Gradle 发行版（已解压，**不必下载**） | `C:\Users\feiyun\.gradle\wrapper\dists\gradle-8.11.1-bin\<hash>\gradle-8.11.1\bin\gradle.bat` |
| 已缓存的 AGP | `com.android.tools.build:gradle:8.6.1` |
| 已缓存的 Kotlin 插件 | `org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.20` / `2.1.21` |
| **cmdline-tools** | `<SDK>\cmdline-tools\latest`（19.0，2026-10-06 装入）⇒ `sdkmanager` / `avdmanager` **可用** |
| 系统镜像 | `system-images\android-33\google_apis\x86_64`（8.2 GB，完整） |
| 已建 AVD | `asprobe33`（Android 13 / API 33 / google_apis / x86_64），在 `%USERPROFILE%\.android\avd\` |
| 模拟器加速 | `emulator -accel-check` → `accel: 0`，`WHPX(10.0.19045) is installed and usable`；**不需要 HAXM**（与 Hyper-V 冲突） |
| 全局 Gradle 配置 | `C:\Users\feiyun\.gradle\gradle.properties` + `init.gradle`：把 `google()` 重定向到阿里云镜像 |
| 网络（重要） | `dl.google.com` **时通时不通**；`maven.aliyun.com` 稳定（google/central/gradle-plugin 三个仓）；`mirrors.cloud.tencent.com/AndroidSDK/` 提供 SDK 包与 cmdline-tools |
| IDE 配置/日志 | `%APPDATA%\Google\AndroidStudio2026.2.1\`（日志 `log\idea.log`） |

**已验证可用的组合：JDK 17 + Gradle 8.11.1 + AGP 8.6.1 + compileSdk 35。**
网络可达 dl.google.com / Maven Central / services.gradle.org，缺的包能现下。

## 铁律：两个 JDK，别弄反

| 用途 | JDK | 原因 |
|---|---|---|
| Android Studio IDE 本体 | `F:\AndroidStudio\jbr`（**25**） | 2026.2.1 强制要求 25 |
| **Gradle / AGP 构建** | `C:\Program Files\Java\jdk-17`（**17**） | Gradle 8.11 最高支持 Java 23；AGP 8.x 要求 17+。**JBR 25 跑不了构建** |

`as-env.ps1` 自动解析两者，**只把 `JAVA_HOME` 导出成 Gradle 那个 JDK**。
构建前**不要**手动把 `JAVA_HOME` 指向 JBR，否则报 unsupported class file major version。

## 标准流程

### 1. 任何 Android 任务的第一步
```powershell
& $A doctor                  # 带 -Project <dir> 可顺带体检工程
```
脚本给出 `READY / NOT READY` 与阻塞项。没有设备只是 warn，不影响出包；
设备 `unauthorized` 会单独列为 action-needed（需要人在手机上点"允许 USB 调试"）。

### 2. 新建并跑起来
```powershell
& $A new -Path D:\work\MyApp -Name MyApp -Package com.example.myapp -Build
& $A run -Project D:\work\MyApp -Screenshot D:\work\shots\first.png
```
模板**刻意不带 AndroidX**（依赖解析最简单、构建最快）；需要时把
`android.useAndroidX=true` 打开再加依赖，`androidx.*` 大多已缓存。
`-Language kotlin` 生成 Kotlin 版（Kotlin 2.1.20 已缓存）。`-Force` 可写进非空目录。

### 3. 常用 Gradle 任务
```powershell
& $A build -Project $p                                  # assembleDebug
& $A build -Project $p -Task testDebugUnitTest           # 单测
& $A build -Project $p -Task lintDebug                   # Android lint
& $A build -Project $p -Task assembleRelease -Variant release
& $A build -Project $p -Task installDebug                # 顺带装
& $A build -Project $p -Clean -Offline -NoDaemon
```
退出码即 Gradle 退出码；成功打印 APK 路径与字节数；失败只回放关键行
（`What went wrong` / `error:` / `FAILED` 任务）。
release 需要签名配置，模板只带 debug 签名。

> ⚠ **换了镜像之后，每个工程都要先在线跑一次**。Gradle 的缓存与"构件来自哪个仓库"绑定，
> 改了仓库 URL（比如镜像切换）后，`-Offline` 会报
> `No cached version of ... available for offline mode`。跑一次在线、再跑 `-Offline` 即可。
> `lintDebug` 还额外需要 androidTest 类路径（`core-ktx`、`core-runtime` 等），同理会先缺一次。

### 4. 装机 + 观察（闭环关键一步）
```powershell
& $A run -Project $p -Build -Screenshot D:\work\shots\a.png
& $A run -Project $p -Activity .SettingsActivity        # 指定 Activity
& $A run -Apk D:\path\app-debug.apk -Package com.example.app
& $A run -Project $p -ClearData                         # 先清应用数据
```
返回对象含 `Running` / `Pid` / `Crashed` / `Launched` / `Logcat` / `Screenshot`；
`Crashed=True` 时已把 `FATAL EXCEPTION` / `AndroidRuntime` 原文挑出来。

### 5. 脚本化操作界面
```powershell
& $A ui describe                       # 列出可见 text / id / content-desc 及中心坐标
& $A ui nodes -Json                    # 全节点 JSON
& $A ui find -Id 'com.example.app:id/list'
& $A ui dump -Out ui.xml               # 原始 XML（难 case 用）
& $A ui tap -Text '继续'                # 按文本
& $A ui tap -Desc '托盘,DemoApp'         # 按 content-desc（中文可用）
& $A ui tap -Xy '1440 900'              # 直接坐标
& $A ui text -Value 'user@example.com'
& $A ui key -Name BACK                  # BACK/HOME/ENTER/DEL/WAKEUP...
& $A ui swipe -X1 1440 -Y1 1500 -X2 1440 -Y2 400
& $A ui wait -Text '欢迎' -TimeoutSec 20
```
- **先 `describe` 再动手**，不要猜选择器或坐标。
- 坐标是**设备物理像素**（本机手机 2880x1920），不是逻辑坐标。
- `describe` 空 ⇒ 息屏/锁屏/安全窗口（`FLAG_SECURE`）；先 `ui key -Name WAKEUP`。
- WebView 与游戏常暴露不出节点 ⇒ 退回"截图 + 坐标点击"，每步后补一张截图作证。
- 每次输入后**紧跟截图**，否则无法证明这一步起了作用。

### 6. 模拟器（**已实测可用**，2026-10-06）
```powershell
& $A device avd-list
& $A device avd-create -Avd asprobe33 -Api 33 -Tag google_apis -Abi x86_64   # 走 avdmanager
& $A device emulator-start -Avd asprobe33      # 最多等 300s，等到 sys.boot_completed=1
& $A device emulator-stop
& $A run -Apk <apk> -Package <pkg> -Serial emulator-5554     # 注意显式 -Serial
```
- 本机已建 `asprobe33`，实测启动成功（`emulator-5554` / `sdk_gphone64_x86_64` / `sys.boot_completed=1`），
  装机、启动、截图、UI 读取与输入全部跑通（截图 `shots\emulator_demo.png`）。
- 加速走 **WHPX**（`accel: 0`，已就绪）；**不要装 HAXM**（与 Hyper-V 冲突，且不需要）。
- 目前只有 `android-33/google_apis/x86_64` 一个镜像。补镜像用 `sdkmanager`（需要 `dl.google.com`，
  见下一节，可能不通），或从腾讯镜像直接取 zip 手工解压。
- ⚠ **真机与模拟器同时在线时必须显式 `-Serial`**：脚本默认取第一个可用设备（通常是真机）。

### 7. 网络与镜像（本机特有，动手前先看）
- **境外仓库在本机都不稳**：`dl.google.com` 与 `repo.maven.apache.org` 都会出现
  `基础连接已经关闭: 发送时发生错误` / `Connect timed out`，而且**时通时不通**。
  （`avdmanager` 偶尔能取到远端仓库，但**不能依赖**。）凡是"要去境外下载"的步骤都要先想好退路。
- 已配**全局 Gradle 镜像** `C:\Users\feiyun\.gradle\init.gradle`，把三个上游**就地换掉 URL**：

  | 上游 | 换成 |
  |---|---|
  | `dl.google.com` / `maven.google.com` | `https://maven.aliyun.com/repository/google` |
  | `repo.maven.apache.org` / `repo1.maven.org` | `https://maven.aliyun.com/repository/public` |
  | `plugins.gradle.org` | `https://maven.aliyun.com/repository/gradle-plugin` |

  实测：AndroidX + Material 工程、Kotlin 工程都能正常构建，下载全部来自 `maven.aliyun.com`。
  之所以是"换 URL"而不是"追加镜像"：追加的话 Gradle 仍会先试原仓库，每次都失败会拖慢解析，
  甚至把该仓库标记为 `disabled due to earlier error`。
- `~/.gradle/gradle.properties` 里**故意不设全局代理**：镜像走国内直连即可，而把 JVM 代理硬指到
  本机 Clash，会在代理未开时让**所有**依赖解析一起失败。需要时按该文件注释打开。
- **腾讯镜像** `https://mirrors.cloud.tencent.com/AndroidSDK/` 有 `commandlinetools-win-<build>_latest.zip`、
  `repository2-3.xml`、`platform-tools-latest-windows.zip` 等，实测 ~5 MB/s。cmdline-tools 就是从这里装的。
- **SDK XML v4 警告可忽略**：cmdline-tools 19.0 只认 SDK XML v3，而 Android Studio 2026.2.1 写的是 v4，
  于是会打印 `This version only understands SDK XML versions up to 3 ...`。
  因为**任何已发布的 cmdline-tools 都比这个 Studio 旧**，这属于前向兼容噪声，`avdmanager` 照常工作。

### 8. 无线调试（拔线）
```powershell
& $A device tcpip -Port 5555
& $A device shell -Command "ip route"                  # 查手机 IP
& $A device connect -Address 192.168.0.116:5555
& $A device status
```

### 9. Android Studio 本体
```powershell
& $A ide which                              # 解析出的路径 + 配置/日志目录
& $A ide status                             # 是否在跑（pid / 内存 / command port）
& $A ide launch -Project $p                 # 用 GUI 打开工程（给人看时用）
& $A ide log -Tail 80                       # tail idea.log
& $A ide format  -Project $p                # headless 格式化（可用，见下）
& $A ide inspect -Project $p -Out .\build\inspections   # ⚠ 本机会卡住，见下
```

**要做静态检查，用 Gradle 的 Android Lint，不要用 `ide inspect`：**

```powershell
& $A build -Project $p -Task lintDebug      # 首次需在线跑一遍（要补 androidTest 类路径的缓存）
# 报告：app\build\reports\lint-results-debug.{html,txt,xml}
```
实测在线 29s / 离线 3s，能报出真问题（模板默认就有 3 条：
`MissingApplicationIcon`、`SetTextI18n`、`OldTargetApi`）。

三个命令的实测结论：

- **`ide inspect` 在本机会卡住**：参数契约本身已经摸清并修正（见下），headless IDE 也能起来、
  写出 2.3 MB 的 `.descriptions.xml`，但随后 15 分钟只烧 58s CPU —— 它在**等网络**
  （与 `dl.google.com`/Maven Central 不通同源）。所以本机**不要指望它**，进程会一直挂着
  （需要 `Stop-Process` 杀掉 `F:\AndroidStudio\jbr\bin\java.exe`）。
  真实签名是 `<project> <inspection_profile> <output> [options]`；给 `-e` 时 profile 可省略。
  早期只传 `(project, out)` 会被拒（`invalid args ... Expected parameters: ...`）；
  而 `-format` **后面必须有值**，传空的会让它抛
  `IndexOutOfBoundsException: Index 5 out of bounds for length 5`。
- **`ide format` 可用，但必须带 `-r` 和 `-allowDefaults`**。真实用法是
  `format [-r] [-d] [-s settings] [-allowDefaults] path...`：它**默认不递归**，而且
  **没有 `-allowDefaults` 时"不属于任何 IDEA 工程"的文件会被静默忽略**
  （`No style for ... skipping`，一个字节都不改）。这些 Gradle 工程从没在 IDE 里打开过，
  所以两个开关都要给。实测：故意打乱 `MainActivity.kt` 缩进后跑 format，
  3 个文件全被格式化、缩进还原（幂等）。
- **`ide launch` / `ide status` / `ide log` 正常**，GUI 打开工程给人看时用。

## 脚本

| 脚本 | 作用 |
|---|---|
| `scripts\android.ps1` | 单一入口，按子命令转发到下面 8 个（`-DryRun` 只打印） |
| `scripts\as-env.ps1` | 解析 Studio/SDK/JDK/Gradle；dot-source 拿 `$AsEnv`，`-Json` 输出 |
| `scripts\as-doctor.ps1` | 体检：工具链、JDK、设备、工程状态；`READY` 即"能构建能装" |
| `scripts\as-new.ps1` | 生成可编译工程（`-Language java\|kotlin`，`-Build` 直接出包） |
| `scripts\as-build.ps1` | 用正确 JDK 跑任意 Gradle 任务；报 APK、挑关键错误行 |
| `scripts\as-run.ps1` | 装 + 起 + 判崩溃 + 截图（观察步） |
| `scripts\as-ui.ps1` | `describe/find/tap/text/key/swipe/wait/screenshot/dump/nodes` |
| `scripts\as-device.ps1` | 设备与模拟器：status/wait/screenshot/shell/install/tcpip/avd-create/… |
| `scripts\as-ide.ps1` | IDE 控制：launch/close/status + headless `inspect`/`format` + `idea.log` |
| `scripts\as-lib.ps1` | 共享库：`Invoke-Native`、`Invoke-Adb`、`Save-AdbScreenshot`、`Write-TextNoBom` |

> 本目录 `.ps1` 一律**纯 ASCII**（因此不需要 BOM）。这是刻意的：
> PS 5.1 会把无 BOM 的 UTF-8 当 ANSI 读，一旦脚本里出现中文而 BOM 又被编辑器丢掉，
> 脚本会在**解析阶段**就崩。中文只写在 `SKILL.md` 与 `references\*.md` 里（由 Node 按 UTF-8 读，安全）。

## 与兄弟技能的分工

| 场景 | 用哪个 |
|---|---|
| 通用：任何 Android 工程建/编/装/驱动界面 | **本技能** |
| 「把 jieyu-1 的 APK 装真机复验」固定取证流程 | `android-device-verify`（证据口径更严，专为 jieyu-1 定） |
| 《解域》出正式包：AAB、release keystore、涨版本、上架清单 | `release-engineering-android` |
| Godot 本身怎么导出 Android 包 | `android-device-verify` 第 1 步 / Godot 侧文档 |
| 鸿蒙 / DevEco / .hap | `deveco-studio-automation`（**不是** Android，内核与运行时都不同） |

真机坐标与设备基线见 `..\_shared\环境事实.md` 第二节（序列号 `5JB0224412000317`、
PCE-W30、Android 12/sdk 31、**物理 2880x1920 是唯一有效口径**）。

## 坑（按被咬过的顺序，都已在脚本里处理）

1. **`JAVA_HOME` = JBR 25 直接让构建失败** —— Gradle 要 JDK 17。`as-env.ps1` 已分流。
2. **PS 5.1 的 `Set-Content -Encoding UTF8` 会写 BOM**，Groovy 报
   `Unexpected character: '?'`（`settings.gradle` 第一行）。生成工程一律走 `Write-TextNoBom`。
3. **PS 5.1 按 GBK 读无 BOM 的 UTF-8**，`uiautomator` dump 里的中文会把属性闭合引号吃掉，
   整份 XML 解析失败（`'false' is an unexpected token`）。读 dump **必须 `-Encoding UTF8`**。
4. **`> file.png` 会写坏二进制截图**（PS 5.1 重定向）——用 `Save-AdbScreenshot`
   （`screencap` 到 `/sdcard` 再 `pull`）。
5. **`$ErrorActionPreference='Stop'` 会把 adb/Gradle 的 stderr 升级成终止错误**
   （原生程序把进度写 stderr）。统一走 `Invoke-Native`，它在调用期间强制 `Continue`。
6. **没有 cmdline-tools** ⇒ `avdmanager`/`sdkmanager` 不存在，建 AVD 走 `device avd-create`。
7. **`monkey` 在部分 OEM 上不回报启动的组件** ⇒ `as-run.ps1` 回退到
   `cmd package resolve-activity --brief`。
8. **Gradle 路径比想象的深一层**：`dists\gradle-<ver>-bin\<hash>\gradle-<ver>\bin\gradle.bat`
   （不是 `<ver>-bin\gradle.bat`）。`as-env.ps1` 已按正确层级递归查找。
9. **dot-source 会污染调用者作用域**（踩过）：`as-lib.ps1` 必须在**子作用域**里调
   `as-env.ps1`（`& ... -AsJson`）并只取回 JSON。若改回 `. as-env.ps1`，as-env 的参数会被
   绑定进调用者作用域，把调用者自己的 `$Json` / `$Quiet` 悄悄重置成 `$false`
   ——症状是 `doctor -Json` 仍打印人读报告、`run -Quiet` 失效。同理 as-env 的参数带
   `As` 前缀（`-AsJson`/`-AsQuiet`/`-AsProjectRoot`），友好的 `-Json`/`-Quiet` 只是别名。
10. **转发器的参数名不能与子脚本重名**（踩过）：`android.ps1` 的位置参数叫 `$Sub` 而非
    `$Command`，否则 `device shell -Command "..."` 会被转发器自己截走
    （症状：报 `Unknown command 'getprop ...'`）。另外转发**不能用数组 splat**
    （`& $s @arr` 按位置传参，`-Json` 会变成位置值），必须重建成命令行再执行。
11. **`[CmdletBinding()]` 或任何 `[Parameter()]` 属性会让脚本变成 advanced script**，
    从而带上公共参数，`-Out` 就与 `-OutVariable`/`-OutBuffer` 二义
    （`参数名称"Out"具有二义性`）。这就是为什么 `android.ps1`、`as-device.ps1`、
    `as-ui.ps1`、`as-ide.ps1` **刻意都写成简单脚本**（`-Out` 是它们对外接口的一部分）。
    非 advanced 脚本用 `$args` 收剩余参数，不要改回 `ValueFromRemainingArguments`。
12. **Gradle 禁止仓库加入容器后改名**（踩过）：init 脚本里只能 `repo.setUrl(...)`；
    调用 `repo.setName(...)` 会让构建在配置阶段就失败
    （`The name of an ArtifactRepository cannot be changed after it has been added`）。
13. **境外仓库（dl.google.com / repo.maven.apache.org）在本机不靠谱**，见 §7：
    已用 `~/.gradle/init.gradle` 把三个上游换成阿里云镜像。若哪天又报
    `Connect timed out`，先去那个文件确认重定向还在。
14. **改过仓库 URL 后，`-Offline` 会先失败一次**：Gradle 按仓库缓存构件，换 URL 等于换了来源，
    报 `No cached version of ... available for offline mode`。在线跑一次即可恢复——
    不是配置坏了，别去改配置。
15. **`ide inspect` 在本机会挂死**（写得出 `.descriptions.xml`，然后一直等网络）。
    静态检查请用 `build -Task lintDebug`；真要 `inspect` 就得接受它可能永远不返回。

## 铁律

1. **先 `doctor` 再干活**，用它的结论说话，不要假设工具链可用。
2. **没设备就说没设备**，不许把"流程跑完了"当成"验证通过了"。
3. **构建失败要看原文**（`What went wrong` / `error:`），不许只报"构建失败"。
4. **装包成功后必须验证真的起来了**（`pidof` / `Running` / 截图看一眼），
   "install Success" 不等于能跑。
5. **界面操作先 `describe`**，坐标只作兜底；每次输入后补截图作证。
6. **这是用户的私人手机**：不卸载无关包、不清数据、不改系统设置，
   除非用户明确要求。`as-run.ps1` 只做 install + launch。
7. 截图内容是用户的屏幕，按隐私对待；`ide close` 可能丢未保存的编辑状态，
   优先让用户自己关 IDE。
8. **绝不按通配符删除共享目录**（这条是真犯过的错，代价无法挽回）：
   `%TEMP%`、用户主目录、SDK 目录里**只能逐个用完整绝对路径删自己刚创建的文件**。
   写过 `Remove-Item "$env:TEMP\*.log"` 想清自己的 3 个日志，结果连用户几个月的
   安装/驱动/调试日志（约 300 个）一起删了，且 `Remove-Item` **不进回收站、无法恢复**。
   清理前先 `Get-ChildItem` 把候选列出来核对，再按名字删。

## 参考文件

- `references\toolchain.md` —— 精确路径、版本、JDK 解析顺序、工程模板结构、缓存现状。
- `references\workflows.md` —— 更长的配方：变体与签名、无线 adb、模拟器、程序化读 UI 树、
  以及**本次全链路实测记录**（含每步的验收输出）。
