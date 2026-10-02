---
name: godot-perf-profile
description: "《解域》性能采样与预算报告：节点/对象/内存/帧时间（draw call、FPS、帧时间分布），桌面 headless 跑内存与对象口径、真机跑帧时间与卡顿口径。凡是「这轮加了 20 个敌人会不会卡」「载具协同帧率掉没掉」「内存涨了多少」「出个性能预算报告」「优化前后对比」这类请求都走本技能。"
whenToUse: "改完一批实体/特效/载具协同逻辑后需要确认性能没有退化；需要给出性能预算报告（帧时间 / 内存 / 绘制调用）；需要对比两次改动或两个档位的开销；需要定位卡顿（jank）时。"
metadata:
  project: jieyu-1
  version: 1
  updated: 2026-10-02
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

## B 路 · 真机（帧时间 / 卡顿）—— 权威口径

Android 上**唯一权威**的帧时间来自 `dumpsys gfxinfo`（这是系统统计，不是引擎自报）。

```powershell
$adb = "C:\Users\feiyun\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$pkg = "com.example.jieyu1"

& $adb shell dumpsys gfxinfo $pkg reset      # 清统计（必须在测之前）
# —— 这里开始做你要测的操作（进载具、开火、24 兵种协同…），持续 20~30 s ——
& $adb shell dumpsys gfxinfo $pkg > "<工作区>\perf_gfxinfo_<yyyyMMdd-HHmm>.txt"
```

从输出里读这几段（脚本 `scripts/perf_gfxinfo.ps1` 已自动解析）：

| 段 | 看什么 |
|---|---|
| `Total frames rendered` | 总帧数；结合时长算实际 FPS |
| `Janky frames` | **卡顿帧数与占比** —— 这是体验指标，比平均 FPS 重要 |
| `50th/90th/95th/99th percentile` | **帧时间分布**；99th 才是「会不会突然一顿」 |
| `HISTOGRAM` | 各帧时间桶的分布，长尾一眼可见 |
| `GPU` | GPU 内存（部分机型才有） |

**预算建议线**（16.7 ms = 60 FPS）：

| 指标 | 建议 | 说明 |
|---|---|---|
| 50th percentile | ≤ 16 ms | 主体要贴住 60 FPS |
| 90th percentile | ≤ 25 ms | 偶尔掉帧可接受 |
| Janky frames | ≤ 5% | 超过就体感卡 |
| 99th percentile | ≤ 50 ms | 再高就是「明显一顿」 |

> 这套线是**建议**，不是工程既定标准。第一次跑出来的实数要**登记进报告并交人拍板**，
> 之后才作为回归基线。

**顺带取的辅助指标**：

```powershell
& $adb shell dumpsys meminfo $pkg      # PSS / Java heap / native heap
& $adb shell dumpsys SurfaceFlinger --latency <layer>   # 需要先查 layer 名，进阶用
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
| `scripts/perf_gfxinfo.ps1` | B 路：`gfxinfo reset` → 提示你做操作 → 抓取 → 解析出帧时间分布 / jank 占比 / 是否超建议线 |

```powershell
# A 路：复制进工程再跑（--script 需要 res:// 路径）
Copy-Item "D:\dsh-data\skills\godot-perf-profile\scripts\perf_probe.gd" "D:\Godot4.7_Proj\jieyu-1\tools\perf_probe.gd"
& "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe" --headless `
  --path "D:\Godot4.7_Proj\jieyu-1" --log-file "D:\Godot4.7_Proj\jieyu-1\_perf.log" `
  --script res://tools/perf_probe.gd -- --seconds 20 --interval 0.5

# B 路：真机帧时间（本机没有 pwsh，用 & 直接调）
& "D:\dsh-data\skills\godot-perf-profile\scripts\perf_gfxinfo.ps1" `
  -OutDir "D:\Godot4.7_Proj\jieyu-1\_perf_android" -DoSeconds 30
```

> ⚠ 本机**没有 `pwsh`**（PATH 里没有 PowerShell 7），工具 shell 是 **Windows PowerShell 5.1**：
> 调用 `.ps1` 一律用 `& "<绝对路径>" -参数 值`。这些脚本存成 **UTF-8 带 BOM**，改完别把 BOM 弄丢。
