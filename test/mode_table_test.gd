@tool
extends EditorScript

## 模式表（docx 5.3 / 5.7 / 22.10）。纯逻辑：第一版可选哪几个、每个模式的规则字段、循环取模式。

const ModeTableScript := preload("res://data/config/ModeTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_first_version_scope()
	_test_locked_modes()
	_test_fields_complete()
	_test_competitive_is_ranked_only()
	_test_friendly_fire_rule()
	_test_pvevp_win_rule()
	_test_durations_track_game_config()
	_test_cycling_skips_locked()
	_test_headcount()
	_test_unknown_mode_is_safe()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


## 22.10 第一版范围「2 阵营 / 1 地图 / 3 模式」——模式＝PVP 竞技 + PVP 休闲 + PVEVP
func _test_first_version_scope() -> void:
	var ids := ModeTableScript.available_ids()
	_check("22.10：第一版可选模式 3 个", ids.size(), 3)
	_check_true("22.10：可选里有 PVP 竞技", ids.has(ModeTableScript.Mode.PVP_RANKED))
	_check_true("22.10：可选里有 PVP 休闲", ids.has(ModeTableScript.Mode.PVP_CASUAL))
	_check_true("22.10：可选里有 PVEVP", ids.has(ModeTableScript.Mode.PVEVP))
	_check_true("22.10：装甲对抗不在第一版可选里", not ids.has(ModeTableScript.Mode.ARMORED))
	_check_true("22.10：困难模式不在第一版可选里", not ids.has(ModeTableScript.Mode.HARDCORE))
	_check_true("22.10：兵棋模式不在第一版可选里", not ids.has(ModeTableScript.Mode.WARGAME))


## 11.4 大厅列 6 个模式：未上线的也要列出来，但必须置灰并写明理由
func _test_locked_modes() -> void:
	_check("11.4：表里一共 6 个模式（大厅模式列表就是 6 个）", ModeTableScript.count(), 6)
	var locked := [
		ModeTableScript.Mode.ARMORED, ModeTableScript.Mode.HARDCORE,
		ModeTableScript.Mode.WARGAME,
	]
	for mode_id in locked:
		var name := ModeTableScript.name_of(mode_id)
		_check_true("%s：置灰不可选" % name, not ModeTableScript.is_available(mode_id))
		_check_true("%s：写了置灰理由（22.10 后续版本）" % name,
				ModeTableScript.locked_reason(mode_id) != "")
		_check_true("%s：理由里点名「后续版本」" % name,
				ModeTableScript.locked_reason(mode_id).contains("后续版本"))


func _test_fields_complete() -> void:
	for entry in ModeTableScript.all():
		var mode_id := int(entry["id"])
		var name := String(entry["name"])
		for key in ["name", "tag", "desc", "flags", "source", "win_rule"]:
			_check_true("%s：有 %s 字段" % [name, key], String(entry.get(key, "")) != "")
		# 每模式人数（2026-10-03 使用者拍板 · docx 5.8 与模式表新增的「人数 / 编成」列）：
		# 第四十七版曾以「docx 没有人数口径」为由不放，那条理由现在不成立
		_check_true("%s：有人数口径字段（拍板后入表）" % name,
			entry.has("enemy_count") and entry.has("ally_count"))
		_check_true("%s：敌人数在 0~30 之间" % name,
			int(entry["enemy_count"]) >= 0 and int(entry["enemy_count"]) <= 30)
		_check_true("%s：说明里有 docx 出处" % name,
				String(entry["source"]).contains("docx"))
	_check_true("可选的模式一定有置灰理由字段（可空）",
			ModeTableScript.locked_reason(ModeTableScript.Mode.PVP_CASUAL) == "")


## 20 章：只有「竞技 / 严格对抗」才关 AI 参谋，PVEVP 开放
func _test_competitive_is_ranked_only() -> void:
	_check_true("20 章：PVP 竞技 → AI 参谋关闭",
			ModeTableScript.competitive(ModeTableScript.Mode.PVP_RANKED))
	_check("20 章：PVP 休闲 → AI 参谋开放",
			ModeTableScript.competitive(ModeTableScript.Mode.PVP_CASUAL), false)
	_check("20 章：PVEVP → AI 参谋开放（使用者拍板 PVEVP 开放）",
			ModeTableScript.competitive(ModeTableScript.Mode.PVEVP), false)


## 5.3 休闲「与竞技同表」，差别是规则松紧：关友伤
func _test_friendly_fire_rule() -> void:
	_check("5.3：竞技开友伤", ModeTableScript.friendly_fire(ModeTableScript.Mode.PVP_RANKED), true)
	_check("5.3：休闲关友伤", ModeTableScript.friendly_fire(ModeTableScript.Mode.PVP_CASUAL), false)
	_check("5.3：PVEVP 单人不涉及友伤（默认关）",
			ModeTableScript.friendly_fire(ModeTableScript.Mode.PVEVP), false)


## 22.6 PVEVP：胜负看战术目标，无平局无加时
func _test_pvevp_win_rule() -> void:
	_check("22.6：PVEVP 用「战术目标达成」口径",
			ModeTableScript.win_rule(ModeTableScript.Mode.PVEVP), ModeTableScript.WIN_OBJECTIVE)
	_check("22.6：PVEVP 没有加时段（无平局）",
			ModeTableScript.uses_overtime(ModeTableScript.Mode.PVEVP), false)
	_check("5.7：竞技用「占领数」口径",
			ModeTableScript.win_rule(ModeTableScript.Mode.PVP_RANKED), ModeTableScript.WIN_OCCUPY)
	_check("5.7：竞技有加时段", ModeTableScript.uses_overtime(ModeTableScript.Mode.PVP_RANKED), true)


## 说明文案里的数字必须来自 GameConfig（不许手抄）
func _test_durations_track_game_config() -> void:
	_check("5.7：竞技时长就是 GameConfig.MATCH_DURATION",
			ModeTableScript.duration_s(ModeTableScript.Mode.PVP_RANKED), GameConfig.MATCH_DURATION)
	_check("5.7：竞技加时就是 GameConfig.OVERTIME_DURATION",
			ModeTableScript.overtime_s(ModeTableScript.Mode.PVP_RANKED), GameConfig.OVERTIME_DURATION)
	var desc := ModeTableScript.desc_of(ModeTableScript.Mode.PVP_RANKED)
	_check_true("5.7：说明文案里的重生预算倍率来自 GameConfig",
			desc.contains(str(GameConfig.RESPAWN_BUDGET_MULTIPLIER)))
	_check_true("5.7：说明文案里的分钟数来自 GameConfig",
			desc.contains(str(int(round(GameConfig.MATCH_DURATION / 60.0)))))
	_check_true("22.10：默认模式是可选的（一进游戏不能落在置灰模式上）",
			ModeTableScript.is_available(ModeTableScript.default_mode_id()))


## 左右换模式要跳过置灰项（大厅 6 个模式里只有 3 个能选）
func _test_cycling_skips_locked() -> void:
	var first := ModeTableScript.Mode.PVP_RANKED
	_check("循环：竞技 → 休闲", ModeTableScript.next_available(first), ModeTableScript.Mode.PVP_CASUAL)
	_check("循环：休闲 → PVEVP",
			ModeTableScript.next_available(ModeTableScript.Mode.PVP_CASUAL), ModeTableScript.Mode.PVEVP)
	_check("循环：PVEVP 的下一个是竞技（跳过后面 3 个置灰项）",
			ModeTableScript.next_available(ModeTableScript.Mode.PVEVP), ModeTableScript.Mode.PVP_RANKED)
	_check("循环：竞技的上一个是 PVEVP",
			ModeTableScript.prev_available(first), ModeTableScript.Mode.PVEVP)
	_check("循环：置灰模式的 next 落到第一个可选模式",
			ModeTableScript.next_available(ModeTableScript.Mode.WARGAME), ModeTableScript.Mode.PVP_RANKED)


## 人数与编成（docx 5.8 + 4.10.8 · 2026-10-03 使用者拍板）
func _test_headcount() -> void:
	var pvp := [ModeTableScript.Mode.PVP_RANKED, ModeTableScript.Mode.PVP_CASUAL,
		ModeTableScript.Mode.ARMORED, ModeTableScript.Mode.HARDCORE]
	for mode_id in pvp:
		_check("5.8：%s = 20 v 20（玩家 + 19 队友）" % ModeTableScript.name_of(mode_id),
			[ModeTableScript.enemy_count(mode_id), ModeTableScript.ally_count(mode_id)], [20, 19])
		_check_true("5.8：%s 的人数已定义" % ModeTableScript.name_of(mode_id),
			ModeTableScript.counts_defined(mode_id))
	_check("5.8：PVEVP = 4P v 30E（玩家 + 3 队友）",
		[ModeTableScript.enemy_count(ModeTableScript.Mode.PVEVP),
		ModeTableScript.ally_count(ModeTableScript.Mode.PVEVP)], [30, 3])
	_check("5.8：兵棋人数未定（0 / 0）",
		[ModeTableScript.enemy_count(ModeTableScript.Mode.WARGAME),
		ModeTableScript.ally_count(ModeTableScript.Mode.WARGAME)], [0, 0])
	_check_true("5.8：兵棋 counts_defined 为 false（调用方要回落到玩家设置）",
		not ModeTableScript.counts_defined(ModeTableScript.Mode.WARGAME))
	_check("4.10.8：组 = 4 人", ModeTableScript.GROUP_SIZE, 4)
	_check("4.10.8：一小队至少 2 组", ModeTableScript.MIN_GROUPS_PER_SQUAD, 2)
	_check("4.10.8：20 人 = 5 个组", ModeTableScript.group_count(20), 5)
	_check("4.10.8：PVEVP 的 4P = 1 个组", ModeTableScript.group_count(4), 1)
	_check("4.10.8：5 个组 = 至少 2 个小队（2 组 + 3 组）", ModeTableScript.squad_count(5), 2)
	_check("4.10.8：1 个组编不成小队（0）", ModeTableScript.squad_count(1), 0)
	_check("4.10.8：人数为 0 时组数为 0（未定义不是一组）", ModeTableScript.group_count(0), 0)


func _test_unknown_mode_is_safe() -> void:
	_check("未知 id：get_mode 返回空字典", ModeTableScript.get_mode(9999).size(), 0)
	_check("未知 id：name_of 兜底不返回空串", ModeTableScript.name_of(9999), "未知模式")
	_check("未知 id：is_available 为 false", ModeTableScript.is_available(9999), false)
	_check("未知 id：时长用兜底值（＝GameConfig 的对局时长）",
			ModeTableScript.duration_s(9999), GameConfig.MATCH_DURATION)
