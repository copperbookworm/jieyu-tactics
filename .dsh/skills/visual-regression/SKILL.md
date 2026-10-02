---
name: visual-regression
description: "《解域》画面与 HUD 的回归验证：几何断言（按钮不重叠 / 不出屏 / 点按目标够大，headless 可跑）+ 基线截图与差异比对（真机或带窗口跑）。凡是「改了 HUD 怕挤坏别的控件」「按钮重叠了」「轮盘展开后跑出屏幕」「特效改了想确认画面没崩」「UI 布局回归」这类请求都走本技能。"
whenToUse: "改动 ui/ 下任何 HUD/控件、改动 CommandWheel/MarkWheel 的展开方向、改动特效或相机后，需要确认布局没有被挤坏；需要为 HUD/特效建立基线截图并比对差异；需要断言「按钮不重叠、不出屏、可点」时。"
metadata:
  project: jieyu-1
  version: 1
  updated: 2026-10-02
---

# visual-regression · 画面与 HUD 回归

先读 `..\_shared\环境事实.md`（路径 / 坑位基线）。

## 最重要的一条判断：你要的是「几何」还是「像素」

| 你要回答的问题 | 该用哪条路 | 为什么 |
|---|---|---|
| 按钮**有没有重叠**、**有没有出屏**、**点按目标够不够大** | **几何断言**（`--headless` 可跑） | 只看 `Control.get_global_rect()`，不需要画面 |
| 画面**看起来**变没变、特效/配色有没有崩 | **基线截图比对**（真机或带窗口） | 需要真实渲染 |

> ⚠ **`--headless` 渲染不出画面**。在 headless 下截 Viewport 会得到空/黑图。
> 所以：几何类断言一定放几何那条路；像素比对必须用真机（走 `android-device-verify` 的截图）
> 或带窗口的编辑器运行。**不要把「headless 截图」写进任何流程**——那是假的。

---

## A 路 · 几何断言（headless 可跑，可进测试体系）

脚本 `scripts/geom_assertions.gd` 用 `SceneTree` 直跑，复用本项目 `effects_test.gd` 的
`[OK] / [FAIL] … 期望=… 实际=…` 输出格式与「通过 N 项 / 失败 M 项」汇总行。

```powershell
$g = "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe"
$p = "D:\Godot4.7_Proj\jieyu-1"
# 首次：把工程复制进去，生成基线（人工过一眼！）
Copy-Item "D:\dsh-data\skills\visual-regression\scripts\geom_assertions.gd" "$p\tools\geom_assertions.gd"
& $g --headless --path $p --log-file "$p\_verify_geom.log" --script res://tools/geom_assertions.gd -- --init
# 之后（改 HUD 后）：默认模式，只对「新出现」的重叠报错
& $g --headless --path $p --log-file "$p\_verify_geom.log" --script res://tools/geom_assertions.gd
```

### 三种模式（这是本工具的关键设计）

| 模式 | 行为 | 什么时候用 |
|---|---|---|
| `-- --init` | 把当前可见重叠集合写成 `res://test/geom_baseline.json` | 首次接入 + 人工确认后 |
| 默认 | **只有新出现的重叠才失败**；基线里已登记的不报错；基线里消失的会「提示你收紧基线」 | 日常回归（唯一该进测试体系的模式） |
| `-- --strict` | 任何可见同级重叠都失败 | 做 HUD 专项排查时 |

> **为什么不默认「任何重叠都失败」**：本工程的 HUD 是**平铺在同一个 `CanvasLayer` 上的绝对定位控件**，
> 存在大量**按状态显隐**的短暂重叠（轮盘展开、提示行、任务卡出现/消失）。一刀切全红会让这个门禁
> 立刻被关掉。基线差分把「已知的既有重叠」变成一条**可审查的账**，把信号集中在**新引入的**问题上。

### 它断言什么

1. **不出屏**：每个可见 Control 的 `global_rect` 必须落在 `(0,0,960,540)` 逻辑视口内（容差由常量给）。
2. **兄弟不重叠**：同一父节点下的可见 Control 两两不相交（父子包含是正常嵌套，不算；`Container` 的子节点跳过）。
   命中时打印**两个控件路径 + 两个 rect + 交集**，可直接定位。
3. **点按目标够大**：带点击语义的控件（`BaseButton` / 有 `pressed` 等信号的）最短边 ≥ `MIN_TAP_SIZE`
   （默认 32 px，按 960x540 逻辑像素）。
4. **CanvasLayer 层号**在 `[0,100]`（防止 HUD 被误塞到世界层被相机带着跑）。

有意重叠的装饰层（准星、摇杆触摸热区）在 `IGNORE_NODES` 里按名字跳过，**每加一条都要写理由**。

> 加进项目测试体系时，在 `tools/run_tests_headless.gd` 的汇总里挂上它
> （本项目 29 个脚本 845 项的汇总口径见进度文件）。

### 2026-10-02 首次实跑的既有结果（未修，留给拍板）

`--strict` 下当前工程有 **18 组可见同级重叠**，`role`/`quest_card` 区域为主。逐条归类需要一轮专项
（哪些是有意堆叠、哪些是真 bug）。**不要为了让断言变绿去改白名单**——这份清单正是要交给人拍板的输入。
典型条目（原样摘自实跑输出）：

```
QuestCard(16,60 300x96)  × RoleButton(16,140 80x40)      ← 任务卡盖住左下按键
MatchClock(802,184 143x23) × HP(802,182 138x23)          ← 右上角两行贴身
MarkWheel(840,188 120x120) × MapButton(802,188 80x44)    ← 轮盘展开时压住地图键
Hint(16,12 441x23) × CombatFeed(300,34 360x110)          ← 顶部提示与播报
```

---

## B 路 · 基线截图与差异比对（真机或带窗口）

### 命名与归档口径（固定，别自创）

```
<工程或工作区>\shots\
    基线_<场景>_<状态>_<逻辑分辨率>.png        ← 基线，人工确认过「这是对的」
    当前_<场景>_<状态>_<yyyyMMdd-HHmm>.png     ← 本轮抓的
    差异_<场景>_<状态>_<yyyyMMdd-HHmm>.png     ← 比对产物（红=不同）
```

`<状态>` 用能复现的条件描述，例如 `主界面_idle`、`轮盘展开`、`载具三档近`、`开火曳光`。

### 抓图

| 目标 | 怎么抓 |
|---|---|
| 真机 | `android-device-verify` 技能（`adb exec-out screencap -p`） |
| 编辑器/桌面窗口 | 编辑器打开场景 → 跑起来 → 截图（**不要**用 `--headless`） |
| 编辑器内单帧 | godot-ai MCP `editor_screenshot`（编辑器必须开着） |

**抓图前必须固定这四件事**，否则差异全是噪声：
1. 逻辑分辨率 960x540 + `canvas_items` 拉伸；
2. 纹理过滤 Nearest（`default_texture_filter=0`）；
3. 随机数种子（有随机的特效/粒子要显式 seed）；
4. 同一台设备 / 同一窗口尺寸（换设备要重做基线）。

### 比对

```powershell
$py = "D:\dsh-data\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe"
& $py "D:\dsh-data\skills\visual-regression\scripts\img_diff.py" `
     --base "<shots>\基线_Main_idle_960x540.png" `
     --current "<shots>\当前_Main_idle_20261002-1930.png" `
     --out "<shots>\差异_Main_idle_20261002-1930.png" `
     --tolerance 3 --max-diff-ratio 0.002
```

- `--tolerance`：单通道容差（抗压缩噪声，默认 3）。
- `--max-diff-ratio`：允许的差异像素占比（默认 0.2%）。超了就**非零退出**并打印差异框。
- 输出：差异图（原图上标红）+ 差异像素数 / 占比 / 差异外接矩形。

### 判定纪律

- **基线只在人确认「这是对的」之后才落盘**。不许把当前截图直接当基线——那等于把 bug 固化成标准。
- 差异超阈值时**先看差异图再下结论**：局部小差异可能是抗锯齿/字体渲染，大面积是布局或资源缺失。
- 已有基线要改，必须写明**为什么旧基线是错的**，并保留旧基线改名成 `基线_…_作废_<日期>.png`。

---

## 铁律

1. **headless 不能出像素**——几何走 A 路，像素走 B 路，不要混。
2. **不许为了让断言变绿而放宽阈值**；要放宽必须把「为什么这是可接受的」写进本文件的例外清单。
3. **基线图必须人确认过**；当前图永远不能自动晋升为基线。
4. 抓图前固定分辨率/过滤/随机种子/设备，否则差异不可归因。
5. 几何断言失败要能**直接定位**：打印两个控件路径 + 两个 rect，别只说「重叠了」。

---

## 脚本

| 脚本 | 语言 | 作用 |
|---|---|---|
| `scripts/geom_assertions.gd` | GDScript | A 路：不出屏 / 兄弟不重叠 / 点按目标够大 / CanvasLayer 白名单；`[OK]/[FAIL]` 格式，退出码 0/1 |
| `scripts/img_diff.py` | Python (Pillow) | B 路：两张 PNG 比对，出差异图 + 差异占比 + 差异框；超阈值非零退出 |
