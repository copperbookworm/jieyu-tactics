---
name: deveco-studio-automation
description: 无人值守使用 DevEco Studio 工具链开发/构建/签名/安装 HarmonyOS（鸿蒙）应用。当任务涉及 DevEco、鸿蒙、HarmonyOS、ArkTS、.hap、hvigor、ohpm、hdc、hilog，或"给华为设备做 app / 上真机"时使用。不需要打开 IDE 图形界面。
---

# DevEco Studio 无人值守开发

## 一句话口径

**DevEco Studio 本体是 IntelliJ 平台 IDE，没有"把 GUI 当人用"的脚本接口。**
真正的自动化面 = IDE 自带的那套 CLI（与 IDE 点 Run 时走的是**同一套** hvigor + SDK）。
本技能把它编排成一条命令链：生成工程 → 出包 → 自签 → 装 → 起 → 看日志。

## 入口

```powershell
$D = 'D:\dsh-data\skills\deveco-studio-automation\scripts\deveco.ps1'
& $D doctor                     # 体检（第一次必跑）
& $D env                        # 打印所有路径 + 可用 PATH 前缀
& $D new    -Path D:\tmp\demo -Bundle com.example.demo
& $D build  -Project D:\tmp\demo                       # 出未签名 HAP
& $D sign   -Project D:\tmp\demo                       # 自签（自动带上设备 udid）
& $D verify -Hap <signed.hap>                          # 校验签名
& $D devices                                           # 列设备（含 udid）
& $D install -Hap <signed.hap>
& $D run     -Bundle com.example.demo
& $D log     -Bundle com.example.demo -Seconds 15 -Filter 'jank|ERROR'
& $D shell   -Cmd "bm dump -n com.example.demo | head -30"
& $D screenshot -Out D:\tmp\shot.jpeg
```

`-DryRun` 可打印等价命令而不执行；`-Target <key>` 用于多设备（`hdc list targets -v` 的 key）。

## 本机环境事实（2026-10-06 核实）

| 项 | 值 |
|---|---|
| DevEco 安装根 | `E:\Huawei\DevEco Studio` |
| SDK 根（`DEVECO_SDK_HOME`） | `E:\Huawei\DevEco Studio\sdk` |
| SDK 版本 | API 26 / platformVersion 26.0.0（`sdk\default\{openharmony,hms}`） |
| 工程模板 | `plugins\codegenie-plugin\previewProject`（自带的完整可编译工程，比新建向导可靠） |
| node | `tools\node\node.exe`（**不要**用 PATH 上那个坏 node） |
| hvigor | `tools\hvigor\bin\hvigorw.js`（6.26.8） |
| ohpm | `tools\ohpm\bin\pm-cli.js`（26.0.0.630） |
| hdc | `sdk\default\openharmony\toolchains\hdc.exe`（3.2.0f） |
| 签名工具 | `sdk\default\openharmony\toolchains\lib\hap-sign-tool.jar` |
| 测试签名材料 | 同目录 `OpenHarmony.p12`（口令 `123456`）、`OpenHarmonyProfileDebug.pem`、`UnsgnedDebugProfileTemplate.json` |
| JDK | 机器 `JAVA_HOME` 是 **jdk-11**；脚本默认改用 `C:\Program Files\Java\jdk-17`（可用 `DEVECO_JAVA_HOME` 覆盖） |
| 模拟器 | `tools\emulator\Emulator.exe` 在，**但系统镜像没下**（`%LOCALAPPDATA%\Huawei\Sdk\system-image\HarmonyOS-5.0.5` 是空目录）⇒ 无真机时跑不了 |
| 真机 | 当前 `hdc list targets` 为空 |

## 出包命令（等价展开）

```powershell
$env:DEVECO_SDK_HOME = 'E:\Huawei\DevEco Studio\sdk'
$node = 'E:\Huawei\DevEco Studio\tools\node\node.exe'
& $node 'E:\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.js' `
  --mode module -p product=default -p module=entry@default -p buildMode=debug `
  assembleHap --no-daemon
# 产物：entry\build\default\outputs\default\entry-default-unsigned.hap
```

## 签名（踩过的三个坑，都验证过）

1. **`OpenHarmony.p12` 里 `openharmony application release` 是自签证书**（subject == issuer）。
   直接把它当 `-appCertFile` 会被拒：
   - 单证书 → `11013004 Profile cert must a cert chain`
   - 拼进 CA 链 → `verify certificate chain failed! Signature does not match.`
   **正解**：自己生成密钥对，让 SDK 的 `openharmony application ca` 签发（这就是 DevEco 给开发者的形态）。
2. **profile 的 `development-certificate` 必须钉住"签 HAP 用的那张证书"**，否则 `sign-app` 直接失败。
   模板里嵌的是 OpenHarmony 官方证书，用了自己的密钥就必须替换掉这一项，并把
   `not-before` / `not-after` 改到有效期内（模板是 2021 年的，早就过期）。
3. **PEM 必须是 LF、无 BOM**。PS 5.1 的 `Set-Content -Encoding UTF8` 会写 BOM，
   工具报 `Illegal header: -----END CERTIFICATE-----`。用
   `[System.IO.File]::WriteAllText($f,$t,(New-Object System.Text.UTF8Encoding($false)))`。

链路（脚本已固化）：

```
generate-keypair        → jieyu-dev.p12（ECC NIST-P-256）
generate-app-cert       → jieyu-dev.cer（issuer = SDK 的 Application CA）
root CA + sub CA + leaf → jieyu-dev-chain.cer（issuer 顺序，LF）
profile 模板替换 bundle-name / device-ids / development-certificate / 有效期
sign-profile            → profile-debug.p7b（keyAlias=openharmony application profile debug，
                           profileCertFile=OpenHarmonyProfileDebug.pem，三条证书的链）
sign-app                → *.hap 已签名（keyAlias=jieyu-dev-key，keystore=jieyu-dev.p12）
verify-app              → Verify success
```

**边界（必须如实说）**：这是 `type: debug` 的 profile，`device-ids` 钉 udid。
⇒ 只能装到写进 profile 的那台设备；**不能分发**；换设备要重新签。
要上架 / 分发必须用 AppGallery Connect 的真实证书与 profile（需要账号），本技能不伪造那条路。

## hdc 速查（HarmonyOS 侧，与 adb 不同名）

| 目的 | 命令 |
|---|---|
| 列设备+udid | `hdc list targets -v` |
| 装 | `hdc install -r x.hap` |
| 装（覆盖+授权） | `hdc install -r -g x.hap` |
| 起 | `hdc shell aa start -b <bundle> [-a <ability>]` |
| 停 | `hdc shell aa force-stop <bundle>` |
| 日志 | `hdc hilog`（`-h` 看参数；可 `hilog -x` 清缓冲） |
| 截屏 | `hdc shell snapshot_display -f /data/local/tmp/a.jpeg` + `hdc file recv` |
| 应用信息 | `hdc shell bm dump -n <bundle>` |
| 刷新率/显示 | `hdc shell hidumper -s RenderService -a screen` |
| 属性 | `hdc shell param get const.product.model` |

**不要**把 adb 命令直接搬过来：`adb shell dumpsys gfxinfo` 那套在鸿蒙上不成立。

## 游戏（Godot）与鸿蒙的关系

- Godot 4.7.1 **没有 HarmonyOS/OpenHarmony 导出模板**（导出预设里只有 Android/iOS/Web…）
  ⇒ "用 DevEco + Godot 一起做鸿蒙游戏"当前只有两条真实路径：
  A. Godot 出 Android 包（现状），DevEco/鸿蒙工具链只用来做**配套应用与真机度量**；
  B. 自己给 Godot 写鸿蒙平台导出（工作量大，不在本技能范围）。
  说结论时必须点明是哪一条，不要含糊成"已经用 DevEco 开发游戏"。
- 鸿蒙真机上量帧率/刷新率的可用口径：`hidumper -s RenderService -a screen`、
  `hdc shell aa dump`、应用内 `@ohos.graphics.displaySync`（帧回调）。

## 坑（按被咬过的顺序）

1. PS 5.1 会把原生程序写 stderr 的**警告**升级成 `NativeCommandError` 并终止脚本
   ⇒ `Invoke-Tool` 里临时 `$ErrorActionPreference='Continue'`，只认退出码。
2. 模板 `oh-package.json5` 的 `devDependencies` 引用了 **`@ohos/hamock@1.0.1-rc2`，仓库里没有**
   ⇒ `ohpm install` 直接失败。删掉测试依赖（或改成不装测试模块）才能离线装上。
3. `.hvigor` 缓存目录不要从模板里拷过来（会带着别的工程路径）。
4. `compatibleSdkVersion` 要与已装 SDK 对齐；模板写 `5.0.0(12)`，本机是 26 就写 `6.0.0(20)` 也可编过
   （hvigor 只警告 `targetSdkVersion` 未显式设置）。
5. PowerShell 里中文脚本文件要**保持 UTF-8 无 BOM 且别用 `Get-Content -Raw -Encoding UTF8 | Set-Content`** 回写，
   否则 PS 5.1 会按 GBK 读回来，脚本当场语法崩。
