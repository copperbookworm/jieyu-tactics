# 配方集（android-studio）

所有示例约定：
```powershell
$A = 'D:\dsh-data\skills\android-studio\scripts\android.ps1'
```

## 1. 接任何 Android 任务的第一步

```powershell
& $A doctor                 # 不带 -Project 只体检工具链
& $A doctor -Project $p     # 顺带体检工程（settings/app/包名/已有 APK）
```

先看结论。`READY` = 构建+装机都能做。没有设备只是 warn，除非任务本身要真机。

## 2. 新工程一路到跑起来

```powershell
$app = 'D:\work\MyApp'
& $A new -Path $app -Name MyApp -Package com.example.myapp -Build
& $A run -Project $app -Screenshot D:\work\shots\first.png
```

`new -Language kotlin` 生成 Kotlin 版（Kotlin 2.1.20 已缓存）。
`-Force` 允许写进非空目录。`-Build` 等于紧接着跑 `build`。

## 3. 值得知道的 Gradle 任务

```powershell
& $A build -Project $app                                   # assembleDebug（默认）
& $A build -Project $app -Task testDebugUnitTest            # 单元测试
& $A build -Project $app -Task lintDebug                    # Android lint
& $A build -Project $app -Task assembleRelease -Variant release
& $A build -Project $app -Task installDebug                 # 出包 + 装
& $A build -Project $app -Clean -Offline -NoDaemon
& $A build -Project $app -Task dependencies -ExtraArgs '--configuration','debugRuntimeClasspath'
```

脚本以 Gradle 的退出码退出；成功打印 APK 路径与字节数；失败只回放关键行。
release 需要签名配置，模板只带 debug 签名——正式发布走 `release-engineering-android` 技能。

## 4. 装机与观察

```powershell
& $A run -Project $app -Build -Screenshot D:\work\shots\a.png
& $A run -Project $app -Activity .SettingsActivity      # 指定 Activity
& $A run -Apk D:\path\app-debug.apk -Package com.example.app
& $A run -Project $app -ClearData                       # 先清应用数据
& $A run -Project $app -WaitSec 8 -LogcatSec 5           # 等久一点 / 再采样 5s 日志
```

返回对象字段：`Serial`、`Package`、`Apk`、`Launched`、`Pid`、`Running`、`Crashed`、
`Screenshot`、`Logcat`。`Crashed=True` 时已经把 `FATAL EXCEPTION` / `AndroidRuntime` 挑出来了。

需要手工 adb 时：

```powershell
& $A device shell -Command "pm list packages | grep example"
& $A device shell -Command "dumpsys activity activities | grep mResumedActivity"
& $A device shell -Command "getprop ro.product.model"
& $A device screenshot -Out D:\work\shots\now.png
```

## 5. 驱动界面

**先发现，再动手：**
```powershell
& $A ui describe                  # 人读：text / id / content-desc + 中心坐标
& $A ui nodes -Json               # 全节点 JSON
& $A ui find -Id 'com.example.app:id/list'
& $A ui find -Text '登录'
& $A ui dump -Out ui.xml          # 原始 XML，难 case 用
```

**再操作：**
```powershell
& $A ui tap  -Text '继续'
& $A ui tap  -Desc '托盘,DemoApp'      # content-desc 匹配，中文可用
& $A ui tap  -Xy '1440 900'
& $A ui text -Value 'user@example.com'
& $A ui key  -Name BACK                # BACK/HOME/ENTER/DEL/APP_SWITCH/WAKEUP...
& $A ui swipe -X1 1440 -Y1 1500 -X2 1440 -Y2 400
& $A ui wait -Text '欢迎' -TimeoutSec 20
```

要点：
- `tap` 每次都会重新 dump 一次层级，所以总是对**当前**状态生效。
- 坐标是**设备物理像素**；本机手机 2880x1920，中心坐标可以到 2880。
- `describe` 返回空 ⇒ 息屏 / 锁屏 / 安全窗口（`FLAG_SECURE`）。
  先 `ui key -Name WAKEUP`，或 `device shell -Command "input keyevent 82"` 解锁。
- WebView 与游戏通常暴露不出有用节点 ⇒ 退回"截图 + 坐标点击"，每步后用新截图确认。
- 拖拽类交互（摇杆、轮盘、准星）只给 tap 常常不触发，要用 `swipe` 给全"按下→移动→抬起"。

## 6. 模拟器（**已实测可用**）

```powershell
& $A device avd-list
& $A device avd-create -Avd asprobe33 -Api 33 -Tag google_apis -Abi x86_64   # 走 avdmanager
& $A device emulator-start -Avd asprobe33      # 最多等 300s，等到 sys.boot_completed=1
& $A device emulator-stop
& $A run -Apk <apk> -Package <pkg> -Serial emulator-5554        # ⚠ 必须显式 -Serial
& $A ui describe -Serial emulator-5554
```

- 本机已建 `asprobe33`（Android 13 / API 33 / google_apis / x86_64），
  实测启动成功：`emulator-5554` / `sdk_gphone64_x86_64` / `sys.boot_completed=1`，
  装机、启动、截图、UI 读取与输入全部跑通。
- 加速走 **WHPX**（`emulator -accel-check` → `accel: 0`）。**不要装 HAXM**（与 Hyper-V 冲突且不需要）。
- 只有 `android-33 / google_apis / x86_64` 一个镜像；`avd-create` 要别的会**列出已装镜像**再报错。
  补镜像用 `sdkmanager`，但它要连 `dl.google.com`（本机常不通）；替代路径是从
  `mirrors.cloud.tencent.com/AndroidSDK/` 取 zip 手工解压。
- ⚠ **真机与模拟器同时在线时必须 `-Serial`**：不指定时脚本取第一个可用设备（通常是真机，
  于是"在模拟器上测试"会变成往真机装包）。

## 7. 无线 adb（拔线）

```powershell
& $A device tcpip -Port 5555
& $A device shell -Command "ip route"          # 找手机 IP
& $A device connect -Address 192.168.0.116:5555
& $A device status
```

## 8. Android Studio 本体

```powershell
& $A ide which                                  # 解析出的路径 + 配置/日志目录
& $A ide status                                 # 在跑吗（pid / 内存 / command port）
& $A ide launch -Project $app                   # 用 GUI 打开（给人看时）
& $A ide inspect -Project $app -Out .\build\inspections      # 实际发的是 <proj> -e <out> -format xml
& $A ide format  -Project $app                  # 实际发的是 format.bat -r -allowDefaults app\src
& $A ide log -Tail 80                           # tail idea.log
```

两个命令的真实契约（都是踩过才摸清的）：

- **inspect**：`<project_file_path> <inspection_profile> <output_path> [options]`，
  给 `-e` 时 profile 可省略。只传 `(project, out)` 会被拒；而 `-format` **后面必须有值**，
  传了空的 `-format` 会让 headless IDE 抛 `IndexOutOfBoundsException: Index 5 out of bounds for length 5`。
  ⚠ **但本机它用不了**：参数修正后 headless IDE 能起来、写出 2.3 MB 的 `.descriptions.xml`，
  然后 15 分钟只烧 58s CPU —— 卡在等网络。**静态检查请改用 Gradle Lint**：

  ```powershell
  & $A build -Project $app -Task lintDebug      # 报告在 app\build\reports\lint-results-debug.*
  ```
  实测在线 29s / 离线 3s，模板默认就能报出 3 条真问题
  （`MissingApplicationIcon` / `SetTextI18n` / `OldTargetApi`）。
  卡住的 inspect 进程要手动收拾：`Stop-Process` 掉 `F:\AndroidStudio\jbr\bin\java.exe`。
- **format**：`format [-r] [-d] [-s settings] [-allowDefaults] path...`。
  它**默认不递归**（要 `-r`），且**没有 `-allowDefaults` 时"不属于任何 IDEA 工程"的文件会被静默忽略**
  （`No style for ... skipping`，一个字节都不改）。本机这些 Gradle 工程从没在 IDE 里打开过，
  所以两个开关都必须给。实测：故意把 `MainActivity.kt` 的缩进打乱后跑 format，
  3 个文件全被格式化，缩进还原为标准风格（幂等）。

GUI 只是同一套 Gradle + adb 工具链的查看器，所以**很少需要自动化 GUI**；
需要给用户看画面时才 `launch`。

## 9. 全链路实测记录（这次是怎么验收的）

本机 2026-10-06 实测，每一步都有验收输出。

### 9.1 真机（PCE-W30，Android 12，2880x1920）

1. `doctor` → `READY: autonomous build/install is possible.`
   工具链 8 项全 ok；设备 `5JB0224412000317[device]PCE_W30`。
2. `new -Path DemoApp -Name DemoApp -Package com.example.demoapp -Build`
   → 生成 9 个文件；`BUILD SUCCESSFUL in 15s`；`app-debug.apk` **9,538 字节**；8 个任务 `FROM-CACHE`。
3. `run -Project DemoApp -Screenshot demo_launch.png`
   → `Installed.`；`Running: True`；`Pid: 18072`；`Crashed: False`；
   截图（2880x1920）上显示 **"DemoApp is running"**。
4. `ui describe` → `TextView text='DemoApp is running'` 位于 `[1440,1049]`。
5. `ui key -Name HOME` → 设备回到 `com.huawei.android.launcher`。
6. 在启动器上再 `ui describe` → 53 个节点，中文正确解码
   （`第 1 屏，共 4 屏`、`设置`、`华为视频`），并看到 `DemoApp` 图标。
7. `ui tap -Desc '托盘,DemoApp'` → 点了 `(2176,1744)`；随后
   `find -Text 'DemoApp is running'` 确认应用又回到前台。

### 9.2 模拟器（asprobe33 / emulator-5554）

8. `device avd-create -Avd asprobe33 -Api 33 -Tag google_apis -Abi x86_64`
   → `avdmanager` 创建成功，`list avd` 认到 `Android 13.0 ("Tiramisu") Tag/ABI: google_apis/x86_64`。
9. `device emulator-start -Avd asprobe33` → `Emulator ready: emulator-5554`（`sys.boot_completed=1`）。
10. `run -Apk <DemoApp apk> -Package com.example.demoapp -Serial emulator-5554 -Screenshot emulator_demo.png`
    → `Installed.` / `Running: True` / `Pid: 4630` / `Crashed: False`；
    截图（1080x2340）显示 **"DemoApp is running"**。
11. `ui wait -Text 'DemoApp is running'` → `Found.`；
    `ui swipe` → `Swiped (540,1800) -> (540,600)`；`ui text -Value 'hello world'` → `Typed: hello world`；
    `ui key -Name BACK` → 回到 `com.google.android.apps.nexuslauncher`（33 个节点）。
12. `ui wait -Text '这个文本不存在xyz' -TimeoutSec 6` → 如实报
    `Timed out after 6s waiting for ...`（超时路径不会谎报成功）。

### 9.3 依赖与镜像

13. `MirrorProbe`（AndroidX appcompat 1.7.0 + Material 1.12.0 + constraintlayout 2.1.4）
    在线构建 → `BUILD SUCCESSFUL in 1m 1s`，`app-debug.apk` 5,889,181 字节；
    日志里 `Downloading` 全部指向 `maven.aliyun.com`，`dl.google.com` 出现 **0** 次。
14. `KotlinDemo`（Kotlin 2.1.20 模板）在线构建 → `BUILD SUCCESSFUL in 52s`，
    APK 831,750 字节；日志中 `repo.maven.apache.org` / `dl.google.com` / `plugins.gradle.org`
    出现次数均为 **0** —— 三个上游全部走阿里云镜像。
15. `new -Path DemoApp -Build -Task assembleDebug -Offline` → `BUILD SUCCESSFUL`（缓存已足够，可离线构建）。

### 9.4 静态检查与格式化

16. `build -Task lintDebug`（MirrorProbe）→ 在线 `BUILD SUCCESSFUL in 29s`、离线 `in 3s`，
    产出 `lint-results-debug.{html,txt,xml}`，报出 3 条真问题：
    `MissingApplicationIcon`、`SetTextI18n`、`OldTargetApi`。
17. `ide format -Project KotlinDemo`：先把 `MainActivity.kt` 的缩进故意打乱，跑完
    `3 file(s) scanned / 3 file(s) formatted`，缩进还原为标准风格（幂等）。
18. `ide inspect`：参数修正后不再报 `invalid args`，`.descriptions.xml`（2.3 MB）写出后
    **挂住不返回**（15 分钟仅 58s CPU）→ 判定本机不可用，改用 `lintDebug`。

即：**写码 → 编译 → 部署 → 观察 → 交互**全闭环，真机与模拟器两条路都验证过，
没有人碰设备，路径里也没有 GUI。

## 10. 出问题时对照

| 现象 | 原因 | 处理 |
|---|---|---|
| `Unsupported class file major version` | Gradle 跑在 JBR 25 上 | 让 `as-env.ps1` 决定 `JAVA_HOME`；别自己 export JBR |
| `settings.gradle` 报 `Unexpected character: '?'` | 文件带 UTF-8 BOM | 用 `Write-TextNoBom`（`as-lib.ps1`）写 |
| `adb devices` 显示 `unauthorized` | 手机没授权 USB 调试 | 解锁手机点「允许 USB 调试」，重跑 `doctor` |
| `No usable device` | 线/扩展坞，或 adb server 卡住 | `device status`；`adb kill-server` 后 `adb start-server` |
| `uiautomator returned no hierarchy` | 息屏/锁屏/安全窗口 | 唤醒解锁，或改用截图 |
| UI dump XML 解析失败 | 读文件用了错误编码 | 用 `-Encoding UTF8` 读（`as-ui.ps1` 已如此） |
| 截图文件打不开/0 字节 | PS 5.1 的 `>` 重定向写坏了二进制 | 用 `Save-AdbScreenshot`（screencap + pull） |
| 构建要的包不在缓存里 | 离线缓存未命中 | 去掉 `-Offline`（镜像现在是通的） |
| `SDK location not found` | 缺 `local.properties` / `ANDROID_HOME` | `as-new.ps1` 会写 `local.properties`；或设 `ANDROID_HOME` |
| Gradle 路径找不到 | `dists` 层级比想象深一层 | `as-env.ps1` 已按 `dists\gradle-<ver>-bin\<hash>\gradle-<ver>\bin` 递归找 |
| `基础连接已经关闭` / `Connect timed out` / `Repository ... is disabled due to earlier error` | 直连 `dl.google.com` 或 `repo.maven.apache.org` | 检查 `~/.gradle/init.gradle` 的三条重定向是否还在；别把镜像删了 |
| `Could not parse POM ...` | 并发/瞬时抖动导致镜像响应被截断 | 串行重跑一次（实测重跑即成功） |
| `参数名称"Out"具有二义性` | 某个脚本被改成了 advanced script（加了 `[CmdletBinding()]` 或 `[Parameter()]`） | 去掉那个属性：`android.ps1`/`as-device`/`as-ui`/`as-ide` 必须是**简单脚本** |
| `Unknown command 'getprop ...'` | 转发器参数与子脚本重名（`$Command`） | 保持 `android.ps1` 的位置参数叫 `$Sub` |
| `invalid args ... Expected parameters: <project_file_path> ...` | `inspect` 少了 profile/`-e` 或 `-format` 没给值 | 用 `ide inspect`；它发的是 `<proj> -e <out> -format xml` |
| `IndexOutOfBoundsException: Index 5 out of bounds for length 5`（inspect） | `-format` 后面是空值 | `as-ide.ps1` 的 `$ReportFormat` 默认 `xml`，别传空 |
| `No style for ... skipping` / `0 file(s) scanned`（format） | 缺 `-allowDefaults`（非 IDEA 工程被忽略）或缺 `-r`（默认不递归） | 用 `ide format`；它发的是 `-r -allowDefaults app\src` |
| `This version only understands SDK XML versions up to 3` | cmdline-tools 比 Android Studio 旧 | 前向兼容噪声，可忽略 |
| `sdkmanager` 卡在 `Loading package information...` | 它要连 `dl.google.com` 取仓库清单 | 从腾讯镜像取 `repository2-3.xml` + 对应 zip 手工解压 |
| 模拟器起来了但装到了真机上 | 同时在线时没指定 `-Serial` | 加 `-Serial emulator-5554` |
| `ide inspect` 一直不返回（`.descriptions.xml` 写出后就停） | 本机 headless IDE 卡在等网络 | 用 `build -Task lintDebug` 代替；必要时 `Stop-Process` 掉 `F:\AndroidStudio\jbr\bin\java.exe` |
| 刚换过镜像就报 `No cached version of ... available for offline mode` | Gradle 按"构件来自哪个仓库"缓存，换 URL 后要重新锚定 | **在线跑一次**再 `-Offline`（不是配置坏了） |
