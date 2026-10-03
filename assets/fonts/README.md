# 随包字体（全工程默认字体）

| 文件 | 说明 |
|---|---|
| `JieyuCJK-Subset.otf` | Noto Sans SC 的**子集**，1.66 MB，Godot 项目默认字体 |
| `OFL.txt` | 字体授权原文（SIL Open Font License 1.1） |

## 为什么要有它

2026-10-03 真机验证发现：本工程原先**没有随包字体**，Godot 的 `ThemeDB.fallback_font` 是只有拉丁的
`Open Sans SemiBold`，CJK 与全角标点全靠 Godot 的**隐式系统回退**。那条路在 HarmonyOS 上不稳定 ——
中英混排文本里紧跟 ASCII 的全角标点会变成「豆腐块」（实测 `has_char('（') = false`）。
既有 HUD 也中招（`ui/DownedOverlay.gd` 的「剩余 57 s（第一版单机没有队友，无法被扶起）」）。

使用者拍板走 **B：随包塞一份 CJK 字体**。字体经
`project.godot` 的 `gui/theme/custom_font` 设为**项目默认字体**，所有 Control 天生覆盖 CJK，
不再依赖任何系统回退。

## 来源与授权

- 上游：**Noto Sans SC Regular**（notofonts/noto-cjk 的 `Sans/SubsetOTF/SC/NotoSansSC-Regular.otf`，8.33 MB）
  <https://github.com/notofonts/noto-cjk>
- 授权：**SIL Open Font License 1.1**（见同目录 `OFL.txt`）—— 允许随软件分发与修改（子集化属于修改），
  要求保留授权原文、且不得单独售卖字体本身。
- 本工程做的是**子集化**（去掉用不到的字形），字体名仍为 `Noto Sans SC`。

## 子集范围（重要）

字符集 = **ASCII 可打印** ∪ **GB2312 全字集（7445 字）** ∪ **工程源文件里出现的所有字符** ∪
常用符号区（箭头 U+2190-21FF、数学 U+2200-22FF、圈号 U+2460-24FF、制表 U+2500-257F、
几何 U+25A0-25FF、杂项符号 U+2600-26FF、CJK 标点 U+3000-303F、全角 U+FF00-FFEF）。
合计 **8707 个字符 / 8069 个字形**（源文件里用到的 1722 个字符全部覆盖）。

⇒ 常规简体中文 UI 文案**随便写**都在覆盖范围内；只有**生僻字 / 新增的冷门符号**才需要重做子集。

## 怎么重做子集（改了 UI 文案且出现生僻字时）

```powershell
# 1) 重新生成字符集（ASCII + GB2312 + 工程实际用到的字符 + 常用符号区）
#    参考脚本逻辑见 git 历史里的 _mkcharset.py（放在工程外跑）
# 2) 子集化（本机 pyftsubset 在 D:\Python313x\Scripts\）
& "D:\Python313x\Scripts\pyftsubset.EXE" NotoSansSC-Regular.otf `
    --text-file=charset.txt `
    --output-file=JieyuCJK-Subset.otf `
    --layout-features=* --name-IDs=* --recommended-glyphs --no-hinting
# 3) 覆盖 assets/fonts/ 下的文件后，跑一次 godot --headless --path . --import
# 4) 跑几何门禁（字体度量变了可能影响 HUD 版式）：--script res://tools/run_tests_headless.gd
```
