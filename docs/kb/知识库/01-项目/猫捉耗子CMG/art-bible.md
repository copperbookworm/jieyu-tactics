# 《猫捉耗子 CMG》美术圣经（Art Bible）

> 本项目所有图片资产的唯一风格基准。Agent 每次生成/处理资产前必须先读本文件，禁止自由发挥。
> 最后更新：2026-09-19

## 1. 项目定位
- 平台：抖音/微信小游戏（Godot 4.x，2D）
- 风格：卡通平涂（flat color），粗描边，无渐变阴影
- 角色：橙虎斑猫（主角）+ 灰鼠（猎物）

## 2. 调色板（Palette）——所有资产只准用这些色
| 名称 | HEX | 用途 |
|---|---|---|
| 猫橙 | #E8853A | 猫主毛色 |
| 猫橙深 | #B85C20 | 猫条纹/阴影 |
| 猫白 | #F5F0E8 | 猫胸口/爪子 |
| 猫耳粉 | #E8A0A0 | 耳内/鼻子 |
| 鼠灰 | #8A8F98 | 老鼠身体 |
| 鼠粉 | #D8A0A8 | 老鼠耳朵/尾巴 |
| 描边 | #3A2A20 | 所有轮廓线 |

> ⚠️ 若实际成品图配色与上表不符，以第一次定稿的「定妆照」为准，并回填本表。

## 3. 尺寸规范
- 生成分辨率：1024×1024（1 张精灵表 = 2 行 × 4 列 = 8 帧）
- 单帧画布：约 256×256（2 的幂，Godot 友好），水平居中、bottom 对齐
- 格式：真 alpha 的 PNG（RGBA），禁用 JPG / 假棋盘格
- 命名：`<角色>_<动作>_<两位编号>.png`，例 `cat_run_01.png`、`mouse_idle_01.png`

## 4. 提示词模板（统一纯洋红底 #FF00FF，ChatGPT / Gemini 通用）

Sprite sheet: a full-body side-view running animation of [an orange tabby cat,
cartoon style, flat colors, no shading gradients].

Exactly 8 frames, arranged in a grid of 2 rows x 4 columns, reading order
left-to-right, top-to-bottom.

Hard rules:

1.plain solid magenta background #FF00FF — perfectly uniform, no gradient, no vignette
2.clear empty space between every frame; sprites must not touch or overlap
3.no dust, no particles, no motion-blur trails, no speed lines, no shadows
4.the exact same character in every frame — same size, colors and style
5.all frames aligned to the same ground line, consistent scale and facing
6.no watermark, no text, no borders
Output: 1024x1024 PNG.

> 为什么统一洋红底：ChatGPT / Gemini 的「透明背景」都不可靠（常画成假棋盘格），
> 统一出纯洋红底再由本地 key 自动抠 #FF00FF 更稳。
> ⚠️ Gemini 仍会在右下角加水印（与底色无关），定稿优先 ChatGPT。

### 4.3 两步走（一致性必做）
1. 先出 1 张「定妆照」：`[角色] 全身侧面，卡通平涂，配色见调色板`，确认满意；
2. 把定妆照当参考图丢回：`用这同一个角色，出 8 帧 [动作] 动画`。

## 5. 本地处理流水线（下载后固定执行）
probe <图> # 验真透明/背景类型
slice <图> <outdir> --color 10B02C --count 8 # 连通域切帧
anchor <帧dir> <finaldir> --mode bottom --tight # 对齐 + 统一画布
sheet <预览.png> <finaldir> --cols 4 --bg FF00FF # 人眼验收
判读：probe 要「真透明」；sheet 洋红底要纯洋红；8 帧完整、脚踩同一线、顺序连贯。

## 6. 红线（禁止）
- ❌ 不写背景约束（渐变 / 暗角 / 假棋盘格）
- ❌ 帧间不留空、角色重叠
- ❌ 带烟尘 / 影子 / 速度线 / 拖影
- ❌ 定稿用 Gemini（带水印）
- ❌ 用 JPG 存有透明需求的资产
