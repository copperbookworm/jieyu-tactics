---
name: godot-perf-profile
description: "《解域》性能采样与预算报告：节点/对象/内存/帧时间（draw call、FPS、帧时间分布），桌面 headless 跑内存与对象口径、真机跑帧时间与卡顿口径。凡是「这轮加了 20 个敌人会不会卡」「载具协同帧率掉没掉」「内存涨了多少」「出个性能预算报告」「优化前后对比」这类请求都走本技能。"
whenToUse: "改完一批实体/特效/载具协同逻辑后需要确认性能没有退化；需要给出性能预算报告（帧时间 / 内存 / 绘制调用）；需要对比两次改动或两个档位的开销；需要定位卡顿（jank）时。"
metadata:
  project: jieyu-1
  version: 3
  updated: 2026-10-06
---

# godot-perf-profile · 性能采样与预算

先读 `..\_shared\环境事实.md`（路径 / 坑位基线）。

## 最重要的一条：性能分两层，别混着测

| 口径 | 在哪测 | 能测到 | 测不到 |
|---|---|---|---|
| **节点 / 对象 / 内存 / 静态结构** | 桌面 `--headless` | 节点数、对象数、静态内存、脚本加载量 | **帧时间/FPS/绘制调用** |
| **帧时间 / 卡顿 / 绘制调用 / 发热** | **真机** | 真实帧时间分布、jank 比例、GPU 内存 | 断点式调试 |

> ⚠ **`--headless` 不渲染**，所以 headless 里的 `TIME_FPS` / `TIME_PROCESS` / `RENDER_TOTAL_DRAW_CALLS_IN_FRAME`
> **全是 0 或没有意义**。不要在 headless 里下「帧率没问题」的结论——那是假绿。
> 反过来，真机测不了「对象泄漏」这类静态口径。**两个都要，但各答各的问题。**

---

## A 路 · 桌面 headless（内存 / 对象 / 结构）

```powershell
$g = "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe"
$p = "D:\Godot4.7_Proj\jieyu-1"
& $g --headless --path $p --log-file "$p\_perf_desktop.log" `
      --script "D:\dsh-data\skills\godot-perf-profile\scripts\perf_probe.gd"
```

退出码 0，指标打到 stdout（同时随 `--log-file` 落盘）。它给：

- `ENGINE_OBJECT_COUNT` —— **对象泄漏的首选指标**（跨采样点只涨不落 = 泄漏）。
- `OBJECT_NODE_COUNT` / 场景树节点总数。
- `MEMORY_STATIC` / `MEMORY_STATIC_MAX` —— 静态内存水位。
- 按类名分组的节点直方图（谁在涨一眼看出）。
- **采样曲线**：跑 N 秒、每 0.5 s 采一次，输出「首值 → 末值 → 增量」。
  泄漏看的是**结尾相对开头**，不是单点绝对值。

判定纪律：
- 单点内存**没有可比性**；要比就比**同场景、同采样时长、同采样点**的曲线。
- 对象数**只涨不落**才叫泄漏；启动后先涨后平是正常的（缓存/池化）。
- 报告里必须写**采样时长与采样点数**，否则数字无法复现。

---

## B 路 · 真机（帧时间 / 卡顿）

> ⚠⚠ **`dumpsys gfxinfo` 对 Godot 结构性无效 —— 本技能的旧说法已作废**
>
> （2026-10-05 实测，判据见 jieyu-1 进度文件）
> Godot 走**原生 SurfaceView** 直接渲染、不走 HWUI，所以 `gfxinfo` 统计不到它的帧：
> 实测两次 `Total frames rendered` 都是 **0**。
> **不要再用 `gfxinfo` 测 Godot 的帧率**，那条路只会给出「0 帧 / 假绿」。

### ⓿ 逐帧 CSV 落盘（**现在的首选口径**，2026-10-06 起）

**为什么不用 logcat 当唯一口径**：华为私有管理器会在**6~9 s 后停掉采样**（standard doze 已排除，
adb 关不掉私有层）⇒ 每轮只拿到 1~2 个 2.5~3 s 窗口，**不足以断言整局不掉帧**。

工程侧 `systems/debug/PerfCsvWriter.gd` 逐帧写 `user://perf_<时间戳>.csv`
（列：`tag,frame_index,delta_ms,fps,physics_frames,physics_steps_delta`），跑完用一条命令取回解析：

```powershell
# 真机一条命令：启动 → 等完成标志 → 取回 → 解析（M4 起推荐）
& "D:\dsh-data\skills\godot-perf-profile\scripts\perf_frame.ps1" -Launch -WaitForDone `
    -OutDir "D:\Godot4.7_Proj\_perf" -Scenario "固定场景 20v20 60s"
# 真机：已经跑完了，只取数（不等待）
& "...\perf_frame.ps1" -OutDir "D:\Godot4.7_Proj\_perf" -Scenario "..."
# 桌面自检（不需要真机，用于验证落盘链路本身）
& "...\perf_frame.ps1" -LocalCsvDir "$env:APPDATA\Godot\app_userdata\JIEYU1" -OutDir .\_perf
```

它一次给出：每个 `tag` 的 **帧数 / 时长 / fps / p50 / p90 / p99 / max / jank% / 最长连击**
（`最长连击` = 连续超 16.7 ms 的最大帧数，logcat 窗口看不到这个量），并**把同轮 logcat 的
`[测帧]` 分位数并排打印做交叉验证**（CSV 与 logcat 应在噪声内一致——这是落盘链路的自证）。

驱动者（driver）只有一个：正常对局走 `ui/PerfOverlay.gd`（"overlay"），变体扫描走
`scenes/_measure_boot.gd`（"sweep"，该场景直接实例化 Main.tscn、不经 MatchHost ⇒ 没有 overlay）。
两者都安全，重复调用幂等。

**完成标志（M4 · 2026-10-06）**：`PerfCsvWriter.stop()` 干净收尾时会写一个与 CSV 同名的 `perf_<ts>.done`
哨兵（内含 `tag / driver / csv / frames / span_ms / unix`）。取数脚本的 `-WaitForDone` 就是**等它**，
不再睡固定秒数 —— 系统挤占调度时引擎时间会明显慢于墙钟，固定秒数会在探针自退之前把数据取走
（实测：探针设 60 s，只跑到 40.7 s 就被取走）。**没有哨兵 = 样本被强杀 / 崩在半路**：报告会标
`完整=NO` + `样本不完整`，`-WaitForDone` 时还会退 **4**，避免拿半截样本当完整分布。

### ① 引擎自报分位数（逐窗一行，与 CSV 交叉验证用）

`scenes/_measure_boot.gd` 每窗打一行，形如：

```
[测帧] 01_base_maxfps0_vsync_on | 帧数=362 fps=144.0 steps=0.9/帧 | p50=6.9 p90=6.9 p99=6.9 max=8.0 ms | ...
```

读法：

| 看什么 | 含义 |
|---|---|
| **帧数 ÷ 窗口秒数** | 真实 fps —— **这才是可信的 fps** |
| `p50` | 主体手感 |
| `p90` / `p99` | 会不会突然一顿 |
| `max` | 单次最长停顿 |

> ⚠ `Engine.get_frames_per_second()` 实测在 PCE-W30 上**恒报同一个整数**（曾见 5），不可单独采信，
> 必须用「帧数 ÷ 窗口时长」交叉验证。
> ⚠ 若 p95/p99 **顶在同一个常数**（实测 150 ms），那是**限帧/停顿**的形态，
> 不是渲染能力的度量 —— 这时先查设备侧限帧（厂商白名单 / 热限频），别急着优化渲染。

### ② `dumpsys SurfaceFlinger --latency <layer>`（系统侧帧时间戳，绕开 HWUI）

```powershell
$adb = "C:\Users\feiyun\AppData\Local\Android\Sdk\platform-tools\adb.exe"
# 先查 layer 名（SurfaceView 层通常含包名）
& $adb shell dumpsys SurfaceFlinger --list | Select-String jieyu
& $adb shell dumpsys SurfaceFlinger --latency "<layer 名>" > "<工作区>\sf_latency_<yyyyMMdd-HHmm>.txt"
```

输出是「每个待显示帧三个时间戳（ns）」，相邻行相减即帧间隔分布。

> `scripts/perf_gfxinfo.ps1` 是按 gfxinfo 写的，**对 Godot 已不可用**（保留给传统 View/HWUI 渲染的应用）。


**预算建议线**（16.7 ms = 60 FPS）：

| 指标 | 建议 | 说明 |
|---|---|---|
| 50th percentile | ≤ 16 ms | 主体要贴住 60 FPS |
| 90th percentile | ≤ 25 ms | 偶尔掉帧可接受 |
| Janky frames | ≤ 5% | 超过就体感卡 |
| 99th percentile | ≤ 50 ms | 再高就是「明显一顿」 |

> 这套线是**建议**，不是工程既定标准。第一次跑出来的实数要**登记进报告并交人拍板**，
> 之后才作为回归基线。

**顺带取的辅助指标**（可取，但不是帧时间）：

```powershell
& $adb shell dumpsys meminfo $pkg      # PSS / Java heap / native heap
```

引擎侧真机实时数据也可以用 godot-ai：编辑器连通时 `editor_manage(op="monitors_get")`；
或 `game_manage` + `editor_manage(op="game_eval")` 在跑着的游戏里读 `Performance.get_monitor(...)`。
**但那要求编辑器/游戏是活的**，不要把它当主路径。

---

## 报告格式（固定八行，便于逐轮对比）

```
轮次/日期  : 第 N 版 · 2026-10-XX
场景与操作 : Main.tscn 默认开局 → 进主战坦克 → 三档相机切换 → 开火 20 发（持续 30 s）
采样口径   : 真机 dumpsys gfxinfo / 30 s / <设备型号> Android <版>
50th/90th/99th : 12.1 ms / 18.4 ms / 41.2 ms
Janky      : 37 / 1800 帧 = 2.06%
绘制调用   : <值或「本口径取不到」>
内存       : PSS 218 MB（含 GPU 54 MB）
对比基线   : 上一轮 11.8 / 17.9 / 39.0 ms，jank 1.94% → 结论：在噪声内，无退化
结论/风险  : 无退化；但 99th 逼近 50 ms 建议线，24 兵种协同场景要单独测一轮
```

**「取不到」就写取不到**，不要用 0 或估算值填空。

---

## 铁律

1. **headless 不谈帧率**；真机才谈帧时间。两边结论不许互相顶替。
   **Godot 上也不要用 `gfxinfo`** —— 它统计不到原生 SurfaceView（实测 0 帧），走 B 路 ① / ②。
2. **测之前先 `gfxinfo reset`**，否则会混进上一次的统计。
3. **必须报采样时长与采样点数**；没有口径的数字不可复现 = 不可用。
4. **比曲线不比单点**（内存/对象）；**比分布不比平均**（帧时间）。
5. 场景与操作要写**能复现的那一串动作**，不写「随便玩了会儿」。
6. 真机没连上就如实说没连上（走 `android-device-verify` 第 0 步），别用桌面数糊弄。
7. **不要为了让报告好看而改预算线**；要改就写清理由并交人拍板。

---

## 脚本

| 脚本 | 作用 |
|---|---|
| `scripts/perf_probe.gd` | A 路：headless 采对象/节点/内存曲线 + 类名直方图；指标随 `--log-file` 落盘 |
| `scripts/perf_frame.ps1` | ⓿ **首选口径**：`-Launch -WaitForDone` 启动→等完成标志→run-as 取回 CSV→出「帧数/时长/fps/p50/p90/p99/max/jank%/最长连击」+ 与同轮 logcat 分位数交叉验证；`-LocalCsvDir` 桌面自检 |
| `scripts/perf_gfxinfo.ps1` | ⚠ **对 Godot 已失效**（gfxinfo 统计不到原生 SurfaceView）。仅对传统 View/HWUI 渲染的应用有效；Godot 请用 B 路 ① / ② |

```powershell
# A 路：复制进工程再跑（--script 需要 res:// 路径）
Copy-Item "D:\dsh-data\skills\godot-perf-profile\scripts\perf_probe.gd" "D:\Godot4.7_Proj\jieyu-1\tools\perf_probe.gd"
& "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe" --headless `
  --path "D:\Godot4.7_Proj\jieyu-1" --log-file "D:\Godot4.7_Proj\jieyu-1\_perf.log" `
  --script res://tools/perf_probe.gd -- --seconds 20 --interval 0.5

# B 路：真机帧时间（本机没有 pwsh，用 & 直接调；⓿ 首选，不要用 gfxinfo）
& "D:\dsh-data\skills\godot-perf-profile\scripts\perf_frame.ps1" -Launch -WaitForDone `
  -OutDir "D:\Godot4.7_Proj\_perf" -Scenario "固定场景 20v20 60s"
```

> ⚠ 本机**没有 `pwsh`**（PATH 里没有 PowerShell 7），工具 shell 是 **Windows PowerShell 5.1**：
> 调用 `.ps1` 一律用 `& "<绝对路径>" -参数 值`。这些脚本存成 **UTF-8 带 BOM**，改完别把 BOM 弄丢。
