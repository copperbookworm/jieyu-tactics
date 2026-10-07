# 产品版 MVP 就绪度（2026-10-07 · 第九十六版）

> 口径：docx **22.10**（2 阵营 / 1 张地图 / 3 模式，单机 + AI 填充 20v20 与 4P-30E）。
> 本文是**一张能核对的表** —— 每一条都给出证据出处，你可以照着复跑，而不是听一句「做完了」。

## 一、四块逐条对照

| 目标块 | 状态 | 证据 |
|---|---|---|
| **A 档 ① 20v20 配平 + 平衡复测** | ✅ | 正面对撞交换比 3.5:1、节点推进 19:1；对抗时长 10 s → 300 s；队友分批推进已落地（进度文件第九十三版） |
| **A 档 ② PVEVP 战术目标口径** | ✅ | 改为「完成 3 个主线任务」才结算（第八十四版 · docx 22.6） |
| **A 档 ③ 建筑毁伤文档债** | ✅ | 第八十四版销账 |
| **美术产线** | ✅ 规格 + 入库校验 + 取用层 + 占位 | `assets/spec/art_manifest.json`（59 资产 / 25 动画）、`tools/check_art_manifest.gd`（第 4 道门禁，**batch1 入库 18/18**）、`systems/art/ArtAssets.gd`；**正式美术待交付**（同名替换即可） |
| **发布收口** | 部分 | keystore → AAB → **真机回归** ✅（`docs/发布收口.md` 第九/十一节）；商店素材 ✅（`store/`，占位）；**隐私政策 URL 与主体信息 ❌ 待你** |
| **真机试玩验收** | ✅ | 触屏五项全过（摇杆 / 开火 / 战术地图 / 报点轮盘 / 指令轮盘）+ APK 与 AAB 两条路径装机跑通（第八十八~九十二版） |

## 二、验收数字（都在本轮周期内真跑过）

| 项 | 值 |
|---|---|
| 单元测试 | **62 个测试文件 / 未全绿 0**，断言 **2205 项** |
| 集成冒烟 | **317 / 0** |
| 四道门禁 | 几何 6/0 ｜ 外壳屏 30/0 ｜ 缩放接线 21/0 ｜ 美术清单 19/0 |
| 发布件 AAB | **31.8 MB**，SHA256 `C1A3D1AA9E8ED78C03C9B5ED41F41874F4FAAC51003ACBC23521B51A5B330950`，`jarsigner -verify` 退出码 0 |
| 侧载 APK | 30.4 MB，`debuggable: no`，包名 `io.github.copperbookworm.jieyu` |
| 代码规模 | 205 个 `.gd` / 38543 行（含 android/.dsh，不含 addons）；工程主体 198 / 37526 |

## 三、自己复跑一遍（复制粘贴即可）

```powershell
$g = 'E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe'
$p = 'D:\Godot4.7_Proj\jieyu-1'

# 两套测试（都要 0：看两个退出码 + 两行汇总）
& $g --headless --path $p --script res://tools/run_tests_headless.gd -- --jobs=1
& $g --headless --path $p --script res://tools/run_integration_headless.gd

# 出侧载包（自带测试 + splash 补丁 + 签名复核）
& "$p\tools\android_overrides\export_android.ps1" -Mode release -Out "D:\Godot4.7_Proj\APK\jieyu-0.1.0.apk"

# 出上架件
& "$p\tools\android_overrides\export_android.ps1" -Mode release -Format aab -Out "D:\Godot4.7_Proj\APK\jieyu-0.1.0.aab"

# 真机（装包 → 启动 → 抓日志 → 截图）
& "D:\dsh-data\skills\android-device-verify\scripts\android_verify.ps1" `
    -Apk "D:\Godot4.7_Proj\APK\jieyu-0.1.0.apk" -Package "io.github.copperbookworm.jieyu" `
    -OutDir "$p\_verify_android"
```

## 四、卡在你这边的六件事（都不阻塞复跑上面那套）

| # | 事 | 影响 | 要你给什么 |
|---|---|---|---|
| 1 | **隐私政策托管 URL + 主体名称/邮箱** | Play 上架硬门槛 | 一个公开可访问的 URL（草稿在发布收口文档 3.2） |
| 2 | **正式应用图标 + 特色图** | 商店观感 | 图画（占位已在 assets/icons 与 store/） |
| 3 | **正式美术（batch1 共 18 张）** | 画面从占位换成成品 | 按美术资产规格文档命名与尺寸出图，同名替换 |
| 4 | **角色：按兵种 4 张还是共用 1 张** | 关系到美术要多画 3 张 | 二选一（规格文档第七节第 3 条；工程现状＝共用 1 张 + 染色） |
| 5 | **设计表两条**：加资源 ID 列 / 规格列只允许 W×H | 规格可机器解析 | 点头即可（工程侧已用 manifest 顶上） |
| 6 | **商店文案终审 + 数据安全表单 + 内容分级** | 上架材料 | 审阅草稿并按发布收口文档 3.3 填 |

## 五、有意**没做**的（写清楚，免得被当成漏了）

- **真联机 PVP**：netcode-godot 技能里只有选型结论与改造成本，第一版不联网（docx 22.10 是单机 + AI 填充）。
- **准星/角色之外的帧动画**：art_manifest 的 25 条动画（走跑爬、换弹…）全部未接 —— 现在单位是
  Lower/Upper 分离的**程序绘制**，按 12.7.1 的语义做对了「上下半身分别朝向」，但不是逐帧贴图。
- **九宫格按钮之外的外壳主题**：面板与列表仍走程序绘制的 StyleBoxFlat。
- **载具的独立美术**：载具目前是程序绘制的形状（规格里已登记尺寸）。

## 六、这个周期里「翻过车又修好」的坑（都在文档里留了痕）

1. **Godot 的 ConfigFile 里 `#` 不是注释**（只有 `;` 是）⇒ 它把紧跟其后的键一起吃掉，报的是「找不到发布密钥库」。
2. **export_filter 默认全量** ⇒ 验证截图被当成纹理打进包，AAB 一度虚胖到 38.3 MB（修完 31.8 MB）。
3. **导出「假死」**：GradleDaemon 拖住 stdout 管道；不能靠 org.gradle.daemon=false 治（那会打断构建）。
4. **改 if/elif 链必须整段替换并回读**：漏掉前半段 if 会让脚本解析失败，且级联崩到「世界装配 0 敌 0 友」。
5. **相机跟准星不跟玩家** ⇒ 判「输入有没有生效」不能看整屏像素差（差点误判摇杆没生效）。