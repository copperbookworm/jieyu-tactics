---
name: release-engineering-android
description: "《解域》Android 发布工程：release keystore、AAB、版本号、签名与真机校验、商店素材清单、隐私/权限清单。凡是「出个正式包」「要发商店」「AAB 怎么打」「签名怎么弄」「版本号怎么涨」「上架要准备什么材料」「隐私政策/权限声明」这类请求都走本技能。"
whenToUse: "需要产出可发布的 Android 包（AAB/APK）；需要创建或更换 release keystore；需要涨 versionCode/versionName；需要在上架前核对素材与合规清单；需要验证包签名与包内实际内容时。"
metadata:
  project: jieyu-1
  version: 1
  updated: 2026-10-02
---

# release-engineering-android · 《解域》Android 发布工程

先读 `..\_shared\环境事实.md`（SDK / JDK / keystore / 包名实测基线）。

## 第 0 步：先看当前离「能上架」差多远（2026-10-02 实测）

| 项 | 现状 | 能不能上架 | 该怎么办 |
|---|---|---|---|
| 包名 | `com.example.jieyu1` | ❌ **Play 明确不接受 `com.example.*`** | 改成你拥有的域名的反写，例如 `com.<你的域名>.jieyu`；改完等于**换了一个 App**（旧包不能升级） |
| 导出格式 | `gradle_build/export_format=0` | ❌ 是 **APK**，Play 要 **AAB** | 改 `1`（AAB）；或只在自用/侧载时才用 APK |
| 签名 | `package/signed=true`，走的是 **debug keystore** | ❌ 不能作正式发布 | 建 release keystore（见第 1 步） |
| versionCode / versionName | `1` / `"jieyu"` | ⚠ 形式不对 | versionName 用语义化版本（`0.1.0`）；**每次上架 versionCode 必须严格递增** |
| 架构 | 仅 `arm64-v8a` | ⚠ 够用（现代机都是 arm64） | 若要覆盖老机再加 `armeabi-v7a` |
| minSdk / targetSdk | `24` / `36` | ✅ | Play 对 targetSdk 有逐年下限要求，**每次上架前重查一遍** |
| 权限 | **全部为 false（一个权限都不申请）** | ✅ 很好 | 这是合规优势：隐私清单好写。**以后加了权限必须回来更新隐私声明** |
| 图标 | `launcher_icons/*` 全空 | ❌ | 补主图标 192x192 + 自适应前景/背景 432x432 |
| 隐私政策 URL | 无 | ❌ | Play 要求提供，且要能在应用内/商店页访问 |
| 内容分级 / 数据安全表单 | 未填 | ❌ | Play Console 里逐项填，**必须与实际权限/采集一致** |

> **本技能不替你决定发行目标**。上不上 Play、要不要商业化、是否接 Steam，属于待拍板项
> （见进度文件「七、已知待拍板」）。本技能只保证：一旦要发，流程是确定的、可核对的。

---

## 第 1 步 · release keystore（**做一次，永久保管**）

```powershell
$jdk = "C:\Program Files\Java\jdk-17\bin"
& "$jdk\keytool.exe" -genkeypair -v `
  -keystore "D:\keys\jieyu-release.keystore" `
  -alias jieyu `
  -keyalg RSA -keysize 4096 -validity 10000 `
  -storetype PKCS12
```

**必须知道的三件事**（说给未来的你听）：

1. **keystore 丢了 = 这个 App 永远无法再更新**（除非走 Play App Signing 的密钥重置流程，很麻烦）。
   → 备份到**至少两个异地位置**，并把口令存进密码管理器。**不要只留在 D 盘。**
2. **不要把 keystore 和口令提交进 git**。`.gitignore` 里加 `*.keystore` / `*.jks` / `*.p12`。
3. Git 里的 `export_presets.cfg` **会明文存 keystore 路径与口令**。公开仓库前必须处理
   （用环境变量/本地覆盖，或把该段剥离）。

然后在 Godot 的 Android 导出预设里填：
`keystore/release`、`keystore/release_user`（alias）、`keystore/release_password`。

> ⚠ 本机 Godot 编辑器设置里的 **debug** keystore 已存在（口令 `android`），那是给调试包用的，
> **不是** release keystore，别混。

---

## 第 2 步 · 出 AAB

```powershell
$g = "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe"
$p = "D:\Godot4.7_Proj\jieyu-1"

# ① 出包前必跑测试（本项目踩过两次「开发机好、导出包跑不起来」）
& $g --headless --path $p --log-file "$p\_rel_tests.log" --script res://tools/run_tests_headless.gd
if ($LASTEXITCODE -ne 0) { throw "单元测试没全绿，停止出包" }

# ② 导出包内容验收（高度图 / 数据表这两类问题就靠它）
& $g --headless --path $p --log-file "$p\_rel_probe.log" --export-pack "Android" "D:\tmp\jieyu1.pck"
& $g --headless --main-pack "D:\tmp\jieyu1.pck" --log-file "$p\_rel_probe2.log" --script res://tools/probe_export_pack.gd

# ③ 真正导出（AAB 要先把 export_format 改成 1）
& $g --headless --path $p --export-release "Android" "D:\Godot4.7_Proj\APK\jieyu-<version>.aab" `
      --log-file "$p\_rel_export.log"
```

> `--export-release` 用的是 **release** 模板。要用 Gradle 构建（自定义 Android 插件、
> 单独改 AndroidManifest）才需 `gradle_build/use_gradle_build=true`，那时才需要 Gradle 与完整 SDK 构建链。

`scripts/build_aab.ps1` 把这三步串起来并做前置检查。

---

## 第 3 步 · 涨版本号（**每次上架都要做，忘了就被商店拒**）

| 字段 | 位置 | 规则 |
|---|---|---|
| `version/code` | `export_presets.cfg` | 整数，**严格递增**；Play 拒绝重复的 versionCode |
| `version/name` | `export_presets.cfg` | 给人看的，用语义化 `主.次.修订`（如 `0.1.0`） |

`scripts/bump_version.ps1` 做这件事：读当前值 → 按 `-Bump` 增减 →
**先备份 `export_presets.cfg.bak-<时间>`** → 只改这两行 → 回读校验。
用它，不要手改——手改容易漏掉一边或改错行。

---

## 第 4 步 · 出货前校验（别信「导出成功」这四个字）

```powershell
$sdk = "C:\Users\feiyun\AppData\Local\Android\Sdk"
# 签名是否有效、是不是 release 签名
& "$sdk\build-tools\36.0.0\apksigner.bat" verify --verbose --print-certs "<包路径>"
# 包里到底是什么：包名 / 版本 / 权限 / 架构 / minSdk
& "$sdk\build-tools\36.0.0\aapt2.exe" dump badging "<包路径>"
```

`scripts/verify_artifact.ps1` 把这两条 + 关键字段断言（包名不是 `com.example.*`、
versionCode 匹配预期、权限与预期一致）一次跑完。

**必须核对**：
- 包名**不是** `com.example.*`；
- versionCode/versionName 与本次发布计划一致；
- 签名是 **release** 证书（不是 debug；debug 证书指纹历史上是固定的，一眼能认）；
- 申请权限集合 = 你隐私声明里写的集合（**多一个都算事故**）；
- 架构包含你打算支持的 ABI。

---

## 第 5 步 · 商店素材清单（一次准备，逐次复用）

| 素材 | 规格 | 现状 |
|---|---|---|
| 应用图标 | 512x512 PNG（Play 用） | ❌ 待做 |
| 主图标 / 自适应图标 | 192x192 + 自适应前景/背景 432x432 | ❌ 预设里全空 |
| 特色图片 | 1024x500 | ❌ |
| 手机截图 | 2~8 张，16:9 或 9:16，最短边 ≥ 320 | ❌ 可用 `visual-regression` 抓图产出 |
| 简短说明 / 完整说明 | 字数上限按商店要求 | ❌ |
| 隐私政策 URL | 公开可访问 | ❌ |
| 数据安全表单 | 与实际采集一致 | ❌ |
| 内容分级问卷 | — | ❌ |

> 截图不要临时乱抓：用 `visual-regression` 技能的 `shots/` 归档口径产出一组
> **固定状态**的图（主界面 / 载具 / 战术地图 / 结算），这样每一版都能复用同一套对比。

---

## 第 6 步 · 合规与隐私（本工程当前的有利条件）

- **当前不申请任何 Android 权限**（`permissions/*` 全 false）⇒ 数据安全表单可以填得最干净。
- **但要如实体检**：只要以后接入联网（联机/统计/崩溃上报，如 Sentry）、内购、
  或者读取设备标识，**隐私声明与数据安全表单必须同步更新**，否则会被下架。
- 若接入**崩溃上报/分析 SDK**（例如 Sentry），要在隐私声明里写明采集了什么、
  是否可关闭、保留多久。**别只加 SDK 不改声明。**
- 第三方的字体 / 音效 / 美术资源要留**授权凭证**（商店可能要求举证）。

---

## 铁律

1. **没改包名、没换 release keystore、没升 versionCode —— 不要点「发布」。** 三条任一缺失都会被拒或造成不可升级。
2. **出包前必须跑测试 + 导出包验收**；「导出成功」不等于「包里对」。
3. **keystore 与口令永不进 git**；`export_presets.cfg` 会明文带口令，公开前要处理。
4. **权限集合必须与隐私声明逐条一致**；加权限就得改声明。
5. **versionCode 只增不减**，且从不复用。
6. 每个产物都要**留下可核对的证据**：包路径 + 大小 + 指纹 + `aapt2 dump badging` 关键行。
7. 拿不准的发行决策（上哪个商店、要不要商业化、是否接 Steam）**不要自己拍**，登记进待拍板项并提问。

---

## 脚本

| 脚本 | 作用 |
|---|---|
| `scripts/bump_version.ps1` | 升 versionCode / versionName（先备份，只改这两行，回读校验） |
| `scripts/build_aab.ps1` | 前置检查（包名/格式/keystore）→ 跑测试 → 导出包验收 → 导出 AAB/APK → 打印产物指纹 |
| `scripts/verify_artifact.ps1` | `apksigner verify` + `aapt2 dump badging` + 关键字段断言（包名/版本/权限/ABI/**签名指纹**） |

调用方式（本机**没有 `pwsh`**，工具 shell 是 **Windows PowerShell 5.1**，一律用 `&` 调）：

```powershell
$S = "D:\dsh-data\skills\release-engineering-android\scripts"
# 先空跑看前置检查（不改工程、不出包）
& "$S\build_aab.ps1" -Project "D:\Godot4.7_Proj\jieyu-1" -OutDir "D:\Godot4.7_Proj\APK" -VersionTag "0.1.0" -DryRun
# 升版本
& "$S\bump_version.ps1" -Project "D:\Godot4.7_Proj\jieyu-1" -VersionName "0.1.0"
# 校验任意产物
& "$S\verify_artifact.ps1" -Artifact "D:\Godot4.7_Proj\APK\解域MVP.apk" -ExpectCode 1
```

> 这些 `.ps1` 存成 **UTF-8 带 BOM**：PS 5.1 读无 BOM 的 UTF-8 会按 ANSI 解码，中文字符串会直接语法报错。
> 用编辑器改完必须确认 BOM 还在，否则脚本会在解析阶段就崩。
