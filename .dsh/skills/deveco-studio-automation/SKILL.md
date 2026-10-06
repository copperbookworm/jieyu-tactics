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

**Godot 官方没有鸿蒙导出**（4.7.1 的导出预设里只有 Android/iOS/Web…）。社区 port 的实情（2026-10-06
逐个仓库实测核实，不是照抄搜索结果）：

| 方案 | 网址 | 版本 | 实测状态 |
|---|---|---|---|
| **kdada/godot（首选）** | [github.com/kdada/godot](https://github.com/kdada/godot) 分支 `port-to-openharmony` / `openharmony` | 4.5.0-beta（2025-08-23）/ 4.4.1-stable（2025-08-07） | ✅ 真移植：`platform/openharmony/` + `export/export_plugin.cpp` + `platform/openharmony/template/`（完整 DevEco 工程） |
| 提给官方的 PR | [godot PR #108553](https://github.com/godotengine/godot/pull/108553) · [proposal #12734](https://github.com/godotengine/godot-proposals/issues/12734) | — | ⚠️ **未合并**（refs 只有 `pull/108553/head`，无 merge 提交） |
| 作者教程 | [imkira.com/posts/Godot-HarmonyOS-Port](https://imkira.com/posts/Godot-HarmonyOS-Port/) | 4.4.1 | 编译命令 / 工具链路径 / 编辑器设置项 |
| Ceyase/godot-hm | [github.com/Ceyase/godot-hm](https://github.com/Ceyase/godot-hm) | 4.5-dev | ❌ **名不副实**：`platform/` 无任何鸿蒙代码，是 Godot 整树拷贝 |
| ambitiouscat/godot-harmonyos（4.7 移植） | 文章：[博客园](https://www.cnblogs.com/ambitiouscat/articles/22380392) | 4.7 | ❌ **仓库取不到**（`Repository not found`），只能当技术情报读 |
| kdada 的二进制 | — | — | ❌ **无 tag / 无 release** ⇒ 只能自己编 |

**关键接口（已读源码确认，接我们这套 CLI 正好）**：
- Godot 编辑器设置 `export/openharmony/openharmony_tool_path` 要指向 **DevEco 安装根**（如 `E:\Huawei\DevEco Studio`），
  因为导出插件按 `<tool_path>/tools/hvigor/bin/hvigorw.bat` 找 hvigor、按 `<tool_path>/tools/node` 找 node、
  按 `<tool_path>/jbr` 找 Java；另有一个 `export/openharmony/java_sdk_path`。
- `get_hdc_path()` = `<tool_path>/sdk/default/openharmony/toolchains/hdc` ⇒ 与手动 `hdc` 是同一个。
- 编译模板：`scons platform=openharmony target=template_debug arch=arm64 generate_bundle=yes
  OPENHARMONY_SDK_PATH="<DevEco>\sdk\default\openharmony"`（`detect.py` 会去
  `native/llvm/bin` 找 `clang/llvm-ar/ld.lld/llvm-ranlib`，头文件写死 `lib/clang/15.0.4/include`
  ——所以 **DevEco 6.0 自带的 SDK 正好够用**，无需另下 OpenHarmony SDK）。
- **它没有"请求高刷"**：只有 `ohos_wrapper_get_display_refresh_rate()`（读），没有 set/request；
  且鸿蒙侧默认**没有 vsync 节流**（有移植者用硬编码 `delay_usec(16000)` 锁 60 FPS 防 GPU 空转）
  ⇒ 鸿蒙上的帧率天花板问题与 Android 的"厂商按包名钉 60"是**两套不同机制**，必须真机实测。

**说结论时的口径**：Godot 出 Android 包（现状）与 Godot 出鸿蒙 HAP（需自编社区 port）是两条不同的路，
不许含糊成"已经用 DevEco 开发游戏"；HAP 也**装不进 Android 平板**（内核/运行时不同）。

## 已跑通：Godot → 鸿蒙 HAP 全链路（2026-10-06 实测验收）

本机实测一遍走完，**每一步都有验收输出**：

| 步骤 | 命令要点 | 验收 |
|---|---|---|
| 1. 编导出模板 | `scons platform=openharmony target=template_debug arch=arm64 generate_bundle=yes OPENHARMONY_SDK_PATH="E:\Huawei\DevEco Studio\sdk\default\openharmony"` | 17 分 26 秒，产出 `bin/openharmony_debug_arm64-v8a.zip`（30.9 MB，含 `libgodot.so` 108.9 MB） |
| 2. 编编辑器 | `scons platform=windows target=editor arch=x86_64 use_mingw=yes` | 36 分 9 秒，`bin/godot.windows.editor.x86_64.exe`（141 MB） |
| 3. 建预设 | 写 `export_presets.cfg`：`platform="OpenHarmony"`、`export_filter="all_resources"`、`build/override_project_dir=true`、`build/sign=false` | — |
| 4. 导出 | `godot.windows.editor.x86_64.console.exe --headless --path <工程> --export-debug "OpenHarmony" <出.hap>` | `Build completed successfully.` EXIT=0 |
| 5. 签名 | `deveco.ps1 sign -Hap <未签名.hap> -Bundle <包名> -Out <签名.hap>` | 89.2 MB → 85.8 MB |
| 6. 验签 | `deveco.ps1 verify -Hap <签名.hap>` | `verify-app: Verify success` |

产物 HAP 内含：`libs/arm64-v8a/{libgodot.so 87.6MB, libentry.so, libc++_shared.so}` +
`resources/rawfile/template.pck`（游戏数据）+ `ets/modules.abc`。

**主机侧前置**：Python 3.14 + `pip install scons`（4.11.1）+ MinGW-w64（`F:\w64devkit`，gcc 16.1，
官方要求 GCC 9+）。**交叉编译不需要额外下 OpenHarmony SDK** —— DevEco 6.0 自带的
`<DevEco>\sdk\default\openharmony` 里 clang 15.0.4 / llvm-ar / ld.lld / libcxx-ohos / sysroot 全都有
（detect.py 里路径写死 `lib/clang/15.0.4/include`，正好对上）。

### 四个坑（每个都卡过我一次，按顺序）

1. **`--script` 与 `--editor` 互斥**：`godot --headless --editor --script foo.gd` 里 `--script` **根本不执行**
   （main.cpp 分支决定），所以"用 EditorScript 自动化导出"这条路不通，必须写 **EditorPlugin**
   （它由编辑器实例化，能拿到编辑器上下文，也能自己 `get_tree().quit()`）。
2. **`EditorExport` / `EditorSettings` / `EditorInterface` 都不是 GDScript 全局类**，
   `EditorExport.get_singleton()` 直接 Parse Error；`Engine.get_singleton("EditorExport")` 也是 null
   —— 因为 `EditorExport` **没注册进 ClassDB**（只有 `EditorExportPlatform`/`EditorExportPreset` 注册了）。
   正解：`ClassDB.instantiate("EditorExportPlatformOpenHarmony")` 自己 new 平台，编辑器设置走
   `EditorInterface.get_editor_settings()`；`preset.name/export_path` 也不能点号赋值（用 `set()/get()`）。
3. **新建预设的 `files` 列表是空的**，`update_files()` 又没绑给脚本 ⇒ 直接 `export_project()` 会报
   `Must select at least one file to export.`（来自 `save_pack` 的 `p_total < 1`）。
   正解：**别用 `export_project()`，走官方 CLI `--export-debug`**，它会自己处理文件列表。
4. **`--export-debug` 的两项必备工程设置**：`textures/vram_compression/import_etc2_astc=true`
   （否则报 "ETC2/ASTC texture compression must be enabled for OpenHarmony export"），
   以及预设 `build/override_project_dir=true`（否则第二次导出报 "Project dir is already exists"）。

**插件内置签名的坑**：`build/sign=true` 时它调 `hap-sign-tool sign-app -profileFile <你给的>`，
但**必须给 `.p7b`**（给 `.pem` 报 `11012005 Not support file`）。
⇒ 推荐 `build/sign=false` 出未签名 HAP，再用本技能 `deveco.ps1 sign` 签（那条链已验证）。


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
