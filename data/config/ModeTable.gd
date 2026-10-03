extends RefCounted

## 模式表（docx 5.3 各模式胜负表 + 22.10 第一版范围「2 阵营 / 1 地图 / 3 模式」）
##
## 为什么单开一张表：模式选择界面、对局装配（App / MatchScreen）、对局规则（MatchRules）、
## 以及「哪些模式该关掉 AI 参谋」都只该有一个数据源。散在各处迟早对不上。
##
## 第一版可选的 3 个模式按 22.10 原文拍板：PVP 竞技 + PVP 休闲 + PVEVP（占位）。
## 装甲对抗 / 困难 / 兵棋按 22.10 的降级清单标成「后续版本」——**仍然列出来**（11.4 的大厅
## 本来就列 6 个模式），但界面置灰不可选，别让玩家以为已经能玩。
##
## 表为什么是「运行时构建 + 缓存」而不是 const：
##   const 里不能用 % 格式化（编译期常量折叠不认），而说明文案里的时长 / 重生预算倍率
##   必须从 GameConfig 推导、不能手抄数字（手抄迟早和 GameConfig 对不上）。
##
## 刻意不写 class_name：新 class_name 在 --script 模式下不在全局类缓存里，引用方会解析失败
## （见 本项目开发进度.txt ⑤ 与 ui/Cover.gd 头部）。引用方一律 preload。
##
## 只有「真的接了线」的字段才写进表里（文档必须落地）：
##   competitive   -> AiAdvisor.competitive（关掉 AI 参谋）
##   friendly_fire -> Player.shoot 的目标列表（友军可被误伤）
##   win_rule / duration_s / overtime_s -> MatchFlow
## 兵种 / 载具走玩家配置（GameSettings 与模式选择界面）。
## 每模式人数（enemy_count / ally_count）在 2026-10-03 由使用者拍板后入表（docx 5.8 + 模式表新增列）——
## 第四十七版曾以「docx 没有人数口径」为由不放，那条理由现在不成立了。

enum Mode { PVP_RANKED, PVP_CASUAL, PVEVP, ARMORED, HARDCORE, WARGAME }

## 胜负判定口径（MatchFlow 用 win_rule 分派）
const WIN_OCCUPY := "occupy"        ## 占领节点数（5.3 / 5.7：全占立即胜 / 超时比点数 / 加时突然死亡 / 平局）
const WIN_OBJECTIVE := "objective"  ## 战术目标达成（22.6 PVEVP：达成＝胜，未达成＝败，无平局）

## 默认模式：休闲。理由——它是唯一「既有占领规则 + AI 参谋开放 + 关友伤」的组合，
## 与今天工程的行为最接近，回归面最小；竞技会关掉 AI 参谋，PVEVP 换胜负口径，都不适合当默认。
const DEFAULT_MODE := Mode.PVP_CASUAL

static var _modes: Array = []


static func all() -> Array:
	if _modes.is_empty():
		_modes = _build()
	return _modes


static func _build() -> Array:
	var match_minutes := int(round(GameConfig.MATCH_DURATION / 60.0))
	var overtime_minutes := int(round(GameConfig.OVERTIME_DURATION / 60.0))
	return [
		{
			"id": Mode.PVP_RANKED,
			"enemy_count": 20, "ally_count": 19,
			"name": "PVP 竞技",
			"tag": "竞技 · 严格对抗",
			"available": true,
			"competitive": true,
			"friendly_fire": true,
			"win_rule": WIN_OCCUPY,
			"duration_s": GameConfig.MATCH_DURATION,
			"overtime_s": GameConfig.OVERTIME_DURATION,
			"desc": "全占节点立即取胜；重生预算（进攻方人数 × %d）耗尽即本阶段失败；%d 分钟到点比占领数，持平进加时 %d 分钟突然死亡，仍平即平局。" % [
				GameConfig.RESPAWN_BUDGET_MULTIPLIER, match_minutes, overtime_minutes],
			"flags": "AI 参谋：关闭（竞技 / 严格对抗）｜友伤：开",
			"source": "docx 5.3 / 5.7 胜负判定确认稿；22.10 第一版",
		},
		{
			"id": Mode.PVP_CASUAL,
			"enemy_count": 20, "ally_count": 19,
			"name": "PVP 休闲",
			"tag": "休闲",
			"available": true,
			"competitive": false,
			"friendly_fire": false,
			"win_rule": WIN_OCCUPY,
			"duration_s": GameConfig.MATCH_DURATION,
			"overtime_s": GameConfig.OVERTIME_DURATION,
			"desc": "胜负表与竞技完全同表（5.3），差别只在规则松紧：关闭友伤，AI 参谋开放。",
			"flags": "AI 参谋：开放｜友伤：关",
			"source": "docx 5.3（与竞技同表）；22.10 第一版",
		},
		{
			"id": Mode.PVEVP,
			"enemy_count": 30, "ally_count": 3,
			"name": "PVEVP",
			"tag": "单人 PVE（占位）",
			"available": true,
			"competitive": false,
			"friendly_fire": false,
			"win_rule": WIN_OBJECTIVE,
			"duration_s": 1200.0,
			"overtime_s": 0.0,
			"desc": "单人 PVE，没有对手玩家：战术目标达成＝胜，未达成＝败，无平局、无加时。本版战术目标＝完成当前主线任务。",
			"flags": "AI 参谋：开放｜友伤：关｜无平局",
			"source": "docx 5.3 PVEVP 行；22.6 入场五步（时长候选 20~30 分钟，取 20）",
		},
		{
			"id": Mode.ARMORED,
			"enemy_count": 20, "ally_count": 19,
			"name": "PVP 装甲对抗",
			"tag": "后续版本",
			"available": false,
			"competitive": false,
			"friendly_fire": false,
			"win_rule": WIN_OCCUPY,
			"duration_s": GameConfig.MATCH_DURATION,
			"overtime_s": GameConfig.OVERTIME_DURATION,
			"desc": "同竞技，另加「每小队一辆全员投票自选的武装载具」与载具被毁后的重选等待（上限 30 s）。",
			"flags": "载具投票 / 重选等待：未实现",
			"source": "docx 5.3 装甲对抗行；22.10 降级为后续版本",
			"locked_reason": "载具投票与重选等待流程未做（22.10 后续版本）",
		},
		{
			"id": Mode.HARDCORE,
			"enemy_count": 20, "ally_count": 19,
			"name": "困难模式",
			"tag": "后续版本",
			"available": false,
			"competitive": false,
			"friendly_fire": true,
			"win_rule": WIN_OCCUPY,
			"duration_s": GameConfig.MATCH_DURATION,
			"overtime_s": GameConfig.OVERTIME_DURATION,
			"desc": "规则与胜负表同竞技。困难项（护甲 / 弹药 / 医疗的紧缩）尚未逐条定标。",
			"flags": "困难项：未定标",
			"source": "docx 5.3 困难模式行；17.5 合规改口径；22.10 降级为后续版本",
			"locked_reason": "困难项未逐条定标（22.10 后续版本）",
		},
		{
			"id": Mode.WARGAME,
			"enemy_count": 0, "ally_count": 0,
			"name": "兵棋模式",
			"tag": "后续版本",
			"available": false,
			"competitive": false,
			"friendly_fire": true,
			"win_rule": WIN_OCCUPY,
			"duration_s": GameConfig.MATCH_DURATION,
			"overtime_s": GameConfig.OVERTIME_DURATION,
			"desc": "兵棋段按占点 / 歼灭结算，打满 5 回合转 PVP 段；每多占 1 点 = 初始重生预算 +8（或以开局多数点计，二选一未定）。",
			"flags": "兵棋 SOP（行政 / 机动 / 战斗 CRT / 恢复）：未做",
			"source": "docx 22.5 兵棋模式规则；22.10 降级为后续版本",
			"locked_reason": "兵棋 SOP 与回合系统未做（22.10 后续版本）",
		},
	]


static func count() -> int:
	return all().size()


static func index_of(mode_id: int) -> int:
	var modes := all()
	for i in modes.size():
		if int(modes[i]["id"]) == mode_id:
			return i
	return -1


static func get_mode(mode_id: int) -> Dictionary:
	var i := index_of(mode_id)
	return all()[i] if i >= 0 else {}


## 表里缺字段时的兜底：宁可给保守默认，也不要在界面上把 null 显示出来
static func value_of(mode_id: int, key: String, fallback: Variant) -> Variant:
	var entry := get_mode(mode_id)
	return entry.get(key, fallback)


static func default_mode_id() -> int:
	return DEFAULT_MODE


static func name_of(mode_id: int) -> String:
	return String(value_of(mode_id, "name", "未知模式"))


static func tag_of(mode_id: int) -> String:
	return String(value_of(mode_id, "tag", ""))


static func desc_of(mode_id: int) -> String:
	return String(value_of(mode_id, "desc", ""))


static func flags_of(mode_id: int) -> String:
	return String(value_of(mode_id, "flags", ""))


static func source_of(mode_id: int) -> String:
	return String(value_of(mode_id, "source", ""))


static func is_available(mode_id: int) -> bool:
	return bool(value_of(mode_id, "available", false))


static func locked_reason(mode_id: int) -> String:
	return String(value_of(mode_id, "locked_reason", ""))


static func competitive(mode_id: int) -> bool:
	return bool(value_of(mode_id, "competitive", false))


static func friendly_fire(mode_id: int) -> bool:
	return bool(value_of(mode_id, "friendly_fire", false))


static func win_rule(mode_id: int) -> String:
	return String(value_of(mode_id, "win_rule", WIN_OCCUPY))


static func duration_s(mode_id: int) -> float:
	return float(value_of(mode_id, "duration_s", GameConfig.MATCH_DURATION))


static func overtime_s(mode_id: int) -> float:
	return float(value_of(mode_id, "overtime_s", GameConfig.OVERTIME_DURATION))


## 无平局、无加时的模式（PVEVP）：MatchFlow 据此跳过加时段
static func uses_overtime(mode_id: int) -> bool:
	return overtime_s(mode_id) > 0.0


## 每模式人数（2026-10-03 使用者拍板 · docx 5.8 与模式表新增的「人数 / 编成」列）：
##   PVP 各模式 20 v 20（玩家 + 19 队友 vs 20 敌）；PVEVP 4P v 30E（玩家 + 3 队友 vs 30 敌）；
##   兵棋 0 / 0 = 文档未定（待拍板），调用方要按「未定义」处理。
## ⚠ 这两位只是**数据**：本轮（性能采样）还没有接线到 MatchHost / WorldSetup。
## 编成（2026-10-03 使用者拍板 · docx 4.10.8 / 5.8）：**组（战斗小组）＝ 4 人**，是比小队更基础的作战单元；
## **一小队至少 2 组**（≥ 8 人），组数不要求相等。据此：20 人 = 5 组 = 2 个小队（2 组 + 3 组）；PVEVP 的 4P = 1 组、不构成小队。
const GROUP_SIZE := 4
const MIN_GROUPS_PER_SQUAD := 2


## 人数 → 组数（向上取整：不足一组也算一组）
static func group_count(people: int) -> int:
	if people <= 0:
		return 0
	return int(ceil(float(people) / float(GROUP_SIZE)))


## 组数 → 至少能编几个小队（余下的组并入最后一个；不足 2 组＝编不成小队）
static func squad_count(groups: int) -> int:
	return groups / MIN_GROUPS_PER_SQUAD


static func enemy_count(mode_id: int) -> int:
	return int(value_of(mode_id, "enemy_count", 0))


static func ally_count(mode_id: int) -> int:
	return int(value_of(mode_id, "ally_count", 0))


## 人数是否已定义（兵棋模式 = false ⇒ 调用方回落到玩家设置）
static func counts_defined(mode_id: int) -> bool:
	return enemy_count(mode_id) > 0


static func available_ids() -> Array:
	var ids: Array = []
	for entry in all():
		if bool(entry["available"]):
			ids.append(int(entry["id"]))
	return ids


static func available_count() -> int:
	return available_ids().size()


## 在可选模式里循环：模式选择界面用左右键换模式，置灰项自动跳过
static func next_available(mode_id: int) -> int:
	var ids := available_ids()
	if ids.is_empty():
		return mode_id
	var at := ids.find(mode_id)
	return int(ids[(at + 1) % ids.size()]) if at >= 0 else int(ids[0])


static func prev_available(mode_id: int) -> int:
	var ids := available_ids()
	if ids.is_empty():
		return mode_id
	var at := ids.find(mode_id)
	return int(ids[(at - 1 + ids.size()) % ids.size()]) if at >= 0 else int(ids[0])
