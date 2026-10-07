---
name: android-device-verify
description: "jieyu-1 真机验证的固定流程：装包 → 启动 → 抓 logcat → 截图 → 模拟触摸 → 收结论。凡是「把 APK 装到手机上看看」「真机复测」「手机上闪退/黑屏」「真机反馈修完复验」「验证触屏操作」这类请求都走本技能。不适用于纯 headless 逻辑测试（那用 run_tests_headless.gd）。"
whenToUse: "需要把 jieyu-1 的 APK 装到真机/模拟器上并验证行为；需要抓真机 logcat 定位崩溃或脚本错误；需要在真机上截图或模拟点击/滑动来复现问题；真机反馈修完要复验时。"
metadata:
  project: jieyu-1
  version: 1
  updated: 2026-10-02
---

# android-device-verify · 真机验证固定流程

**目标**：任何一次「真机上到底怎么样」的问题，都用同一条流程回答，结论必须带**证据**（设备序列号、
logcat 原文、截图路径），不许用「应该没问题」结案。

先读 `..\_shared\环境事实.md`——里面是 adb / SDK / 包名 / 架构的实测基线，本文件不重复。

---

## 第 0 步 · 先确认有设备（最容易忽略）

```powershell
$adb = "C:\Users\feiyun\AppData\Local\Android\Sdk\platform-tools\adb.exe"
& $adb devices -l
```

- **0 台设备就停在这里**，如实报告「当前没有连接的设备」，不要伪造流程。
- `unauthorized` ⇒ 手机上要点「允许 USB 调试」。
- `offline` ⇒ `& $adb kill-server; & $adb start-server` 重来。

> 本技能自带的 `scripts/android_verify.ps1` 已把下面 1~5 步串起来，优先用它；
> 手工排查时再按步拆开看。

---

## 第 1 步 · 装包

```powershell
& $adb install -r "D:\Godot4.7_Proj\APK\解域MVP.apk"
```

- 包名 **`io.github.copperbookworm.jieyu`**（实测；`export_presets.cfg` 里是 `com.example.$genname`）。
- 架构：APK **只有 arm64-v8a**。x86 模拟器装不上，别在 x86 模拟器上浪费时间。
- 换包失败先卸载：`& $adb uninstall io.github.copperbookworm.jieyu`（会清 `user://` 存档/日志）。

**重新出包**（改了代码要重装时）——**一律走包装脚本**，不要手敲 Godot 导出：

```powershell
# 真机复测装 release 包（跟发布件同一条链）；只调 UI 想快就 -Mode debug
& "D:\Godot4.7_Proj\jieyu-1\tools\android_overrides\export_android.ps1" `
    -Mode release -Out "D:\Godot4.7_Proj\APK\jieyu-0.1.0.apk"
```

它按顺序做五件事并复核（2026-10-07 第八十七版扩的）：① headless 测试（红就停）
② 导出窗口内本地覆盖（`-Format aab` 时改 `gradle_build/export_format`；release/AAB 一律把 `package/signed` 关掉）
③ Godot 导出 ④ **我们自己的签名**（AAB → `jarsigner`，APK → `apksigner`）+ 导出后打 splash 主题补丁
⑤ `aapt2 badging` 打印 minSdk/ABI/体积/包名/签名 DN。

> ⚠ **Godot 自带的 release 签名链在本机接不通**（详见 `release-engineering-android` 技能与
> `docs/发布收口.md` 第七节）：preset 里 `keystore/release` 三样都读得到，verbose 下给 gradle 的命令行却只有
> `-Pperform_signing=true`、没有任何 keystore 属性，报「代码签名: 找不到发布密钥库」。所以改成上面第 ④ 步。
> ⚠ **GradleDaemon 会拖住导出进程的 stdout 管道**（脚本用 .NET Process + 看门狗自动收掉空闲 daemon）；
> 手敲或另写脚本时若发现「包已写好、命令不返回」，就是这个原因。
> ⚠ 手敲导出会漏掉第 ③ 步：Godot 每次导出都会重写 `res/values/themes.xml`，把 API 31 才有的
> `android:windowSplashScreenBackground` 放回无限定的 `values/`，于是 lint 重新报 Error、低版本设备
> 有厂商属性 id 冲突风险。另外手敲时**必须带** `$env:JAVA_HOME="C:\Program Files\Java\jdk-17"`。
> minSdk 要看 badging 的实数（留空 preset 会得到 Godot 默认 29，不是 24）；体积异常大说明 NDK 没被找到、`.so` 没 strip。

> 导出前**必须先跑一遍** `res://tools/run_tests_headless.gd`；本项目踩过两次「开发机跑得好、
> 导出包跑不起来」（高度图、数据表）。要抓这类问题再跑 `--export-pack` + `probe_export_pack.gd`。

---

## 第 2 步 · 启动并抓 logcat（同一次会话里做，别分开）

**关键**：先清缓冲、再启动、再抓——顺序反了会混进上一次的日志。

```powershell
& $adb logcat -c                                              # 清缓冲
# ⚠ 实测（2026-10-07）：monkey 这条路在本机会报 args 错误；`.../com.godot.game.GodotApp` 也不是导出入口
#（会 SecurityException: not exported）。**可用的启动方式是这样**：
& $adb shell am start -n io.github.copperbookworm.jieyu/com.godot.game.GodotAppLauncher
Start-Sleep -Seconds 8                                        # 等启动稳定
& $adb logcat -d -v time > "<工作区可写路径>\logcat_<yyyyMMdd-HHmm>.txt"
```

**看什么**（按优先级）：

| 关键字 | 含义 |
|---|---|
| `godot` / `GodotEngine` | 引擎自身输出（含 `push_error` / `push_warning`） |
| `SCRIPT ERROR` | GDScript 运行期错误 —— **往往才是根因** |
| `Parse Error` | 脚本解析失败，通常是导出漏了依赖 |
| `FATAL EXCEPTION` | Java 层崩溃（权限、SDK 版本、Gradle） |
| `AndroidRuntime` | 上面那条崩溃的堆栈跟着它 |

```powershell
Select-String -Path .\logcat_*.txt -Pattern "SCRIPT ERROR","FATAL EXCEPTION","Parse Error","GodotEngine"
```

> 日志尾巴永远比开头重要；抓完**把关键字命中行原文留证**，不要只写「有报错」。

**确认进程真的起来了**：

```powershell
& $adb shell pidof io.github.copperbookworm.jieyu      # 空 = 没起来或已崩
```

---

## 第 3 步 · 截图

```powershell
& $adb exec-out screencap -p > "<工作区>\shots\真机_<yyyyMMdd-HHmm>_<说明>.png"
```

- **必须用 `exec-out`**，不要用 `adb shell screencap -p > file`（CRLF 转换会损坏 PNG）。
- 命名与归档口径与 `visual-regression` 技能一致：`shots/真机_<时间>_<说明>.png`。
- 抓完自己 `read_image` 看一眼，别把黑屏当成功：
  - 全黑 ⇒ 可能是启动画面/崩溃；先看 logcat。
  - 分辨率不对 ⇒ 记录实际分辨率，与 960x540 + `canvas_items` 拉伸口径比对。

---

## 第 4 步 · 模拟触摸

**输入事件要按「按下 → 移动 → 抬起」给全**，只给 tap 常常触发不了拖拽类交互
（本项目的准星拖拽、轮盘、虚拟摇杆都是拖拽语义）。

```powershell
& $adb shell input tap 480 270                  # 点按（960x540 中心）
& $adb shell input swipe 480 270 700 270 300    # 滑动：x1 y1 x2 y2 时长ms
& $adb shell input keyevent KEYCODE_BACK
```

- 坐标是**设备实际分辨率**下的像素，不是 960x540 逻辑坐标；先用 `& $adb shell wm size` 取真实分辨率再换算。
- ⚠ **本机（PCE-W30）实测的换算式子（2026-10-07）**：`wm size` 会报「Override size: 1920x2880」（竖屏），
  但应用在清单里锁了 landscape、`screencap` 出来的是 **2880x1920**，而 `input tap` 吃的就是**横屏这一套坐标**。
  游戏是 960x540（16:9）在 2880x1920（3:2）上按 `canvas_items` 等比缩放 ⇒ 缩放 **3×**、上下各留 **150 px 黑边**：
  **设备 x = 逻辑 x × 3，设备 y = 150 + 逻辑 y × 3**。例：大厅「开始游戏」逻辑约 (171,209) → 点 `514 777`；
  模式页「开始对局」逻辑约 (845,539) → 点 `2535 1616`（两个都实测点得中）。
- 本项目 12.7 / 4.13 的交互在**右半屏**（瞄准）与**轮盘向右展开**；测轮盘时滑动终点要往右。
- 每做一步输入后**紧跟一张截图**，否则无法证明这一步起了作用。
- ⚠ **别用「整屏像素变化」判断输入有没有生效（2026-10-07 实测踩到）**：本作**相机跟准星、不跟玩家**
  （准心＝屏心＝相机中心），所以玩家**走动时世界几乎不动**，只有玩家精灵在动 —— 整屏差只有 ~0.3%，
  差点把「摇杆其实是好的」判成「摇杆没生效」。正确判据：**按区域分别统计变化像素**
  （摇杆区 / 中央世界区 / 右上小地图），再按精灵前后两簇算位移；
  本机换算 **1 逻辑 px = 3 设备 px**（见上一条），位移 ÷ 时间 ≈ move_speed(2.4 m/s) 即通过。
- ⚠ **对局只活 20~35 s**：玩家不动时 AI 会把三个点全部压满（首占 15 s/点）⇒「全部节点失守」直接结算。
  要测局内 HUD（开火/地图/报点/指令），**必须在进局后 15 s 内开始**，或先想办法延长对局。

---

## 第 5 步 · 收结论（四段，可核对）

1. **设备**：序列号 / 型号 / Android 版本 / 分辨率（`& $adb shell getprop ro.product.model` 等）。
2. **装包**：APK 路径与时间戳、`install` 的成功输出、包名。
3. **现象**：logcat 关键字命中行**原文**（没有就写「无 SCRIPT ERROR / 无 FATAL」）+ 进程是否存活。
4. **截图**：文件路径 + 你看到的内容（附 `present` 或 Markdown 图片链接）。
5. **结论与下一步**：修了什么 / 还没修什么；不能确定就写「不能确定」。

---

## 铁律

1. **没设备就说没设备**，不许把「流程跑完了」当成「验证通过了」。
2. **证据原文**优先：logcat 行、退出码、截图路径。不许用「看起来正常」结案。
3. **装包前先跑 headless 测试**（导出 bug 和逻辑 bug 是两类问题，别混在一起查）。
4. **改完代码必须重新出包再装**——手机上的旧包不会自己更新。
5. `adb uninstall` 会**清掉 `user://`**（存档 / 历史日志）；要留档就先 `& $adb pull` 出来。

---

## 脚本

| 脚本 | 作用 |
|---|---|
| `scripts/android_verify.ps1` | 串起 0~5 步：列设备 → 装包 → 清日志 → 启动 → 抓日志 → 截图，最后打印证据摘要 |

用法（在工程目录下跑，输出都落在你给的工作目录）：

```powershell
& "D:\dsh-data\skills\android-device-verify\scripts\android_verify.ps1" `
  -Apk "D:\Godot4.7_Proj\APK\解域MVP.apk" -OutDir "D:\Godot4.7_Proj\jieyu-1\_verify_android"
```

> ⚠ 本机**没有 `pwsh`**（PATH 里没有 PowerShell 7），工具 shell 是 **Windows PowerShell 5.1**。
> 调用脚本一律用 `& "<绝对路径>" -参数 值`，**不要写 `pwsh -File ...`**（会报「无法将 pwsh 项识别为 cmdlet」）。
> 另：这些 `.ps1` 都存成 **UTF-8 带 BOM**——PS 5.1 读无 BOM 的 UTF-8 会按 ANSI 解码，中文字符串会直接语法报错。
> 改动这些脚本后**必须确认 BOM 还在**。

脚本是**只读式**的：它不会改工程、不会卸载、不会改 ACL；失败就地报错并保留现场。
