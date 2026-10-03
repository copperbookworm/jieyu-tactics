extends RefCounted

## 编成（docx 4.10.8 / 5.8 · 2026-10-03 使用者拍板）
##
##   **组（战斗小组）＝ 4 人**，是**比小队更基础的作战单元**；
##   **一小队至少 2 组**（≥ 8 人），组数不要求相等。
##
## 据此：PVP 20 v 20 的进攻方 20 人 = 5 组 = 2 个小队（2 组 + 3 组）；
## PVEVP 的 4P = 1 组，按「小队 ≥ 2 组」**不构成小队**（该组是「独立组」）。
##
## 为什么单开一个纯逻辑模块：4.10.8 的「主线下发给小队长、小队长按模板派发小队内子任务」
## 需要先能回答「谁在哪一组、谁是组长、哪个组属于哪个小队」。这层与场景树无关，所以能直接单测；
## 场景侧（WorldSetup）只负责把结果发给每个 Ally。
##
## 口径单一来源：GROUP_SIZE / MIN_GROUPS_PER_SQUAD 一律读 ModeTable（不写第二份）。
## 刻意不写 class_name：引用方 preload。

const ModeTableScript := preload("res://data/config/ModeTable.gd")


static func group_size() -> int:
	return ModeTableScript.GROUP_SIZE


static func min_groups_per_squad() -> int:
	return ModeTableScript.MIN_GROUPS_PER_SQUAD


## 把 people 个人切成组（最后一组可以不满 —— 「组 4 人」是上限不是整除要求）
static func build_groups(people: int) -> Array:
	var groups: Array = []
	var i := 0
	while i < people:
		var n := mini(group_size(), people - i)
		var g: Array = []
		for k in n:
			g.append(i + k)
		groups.append(g)
		i += n
	return groups


## 把 groups 个组切成小队的**规模序列**：每队至少 2 组，余数并进最后一队。
## 5 组 → [2, 3]；4 → [2, 2]；3 → [3]；2 → [2]；1 → []（不足 2 组 ⇒ 编不成小队）
static func build_squads(groups: int) -> Array:
	var min_per := min_groups_per_squad()
	if groups < min_per:
		return []
	var squads: Array = []
	var remaining := groups
	while remaining >= min_per:
		var take := min_per
		# 扣掉这一队之后还够再编一队，就只拿最小规模；否则把余数全拿（余数 ≥ min_per）
		if remaining - take < min_per:
			take = remaining
		squads.append(take)
		remaining -= take
	return squads


## 友好方名册：索引 0 = 玩家，1..n-1 = AI 队友（与 WorldSetup 的 Ally# 对齐）
static func of_friendly_total(total: int) -> Dictionary:
	var groups := build_groups(total)
	var squad_sizes := build_squads(groups.size())
	# 小队 → 它包含哪些组（按顺序切）
	var squads: Array = []
	var gi := 0
	for size in squad_sizes:
		var member_groups: Array = []
		for _k in size:
			member_groups.append(gi)
			gi += 1
		squads.append(member_groups)
	# 每个单位 → 它的组 / 小队 / 组内序号 / 是不是组长 / 是不是小队长
	var member_of := {}
	for g in groups.size():
		var squad_of_group := -1
		for s in squads.size():
			if (squads[s] as Array).has(g):
				squad_of_group = s
		var members: Array = groups[g]
		for slot in members.size():
			member_of[int(members[slot])] = {
				"group": g,
				"squad": squad_of_group,
				"slot": slot,
				"is_group_leader": slot == 0,
				"is_squad_leader": slot == 0 and squad_of_group >= 0 \
						and int((squads[squad_of_group] as Array)[0]) == g,
			}
	# 小队长（每小队第一个组的组长）
	var leaders: Array = []
	for s in squads.size():
		leaders.append(int(groups[int((squads[s] as Array)[0])][0]))
	var in_squads := 0
	for size in squad_sizes:
		in_squads += int(size)
	return {
		"people": total,
		"groups": groups,
		"squads": squads,
		"group_count": groups.size(),
		"squad_count": squads.size(),
		"member_of": member_of,
		"squad_leaders": leaders,
		"standalone_groups": groups.size() - in_squads,
	}


## 某个模式开局的友好方编成（玩家 + 该模式的 AI 队友数）
static func of_mode(mode_id: int) -> Dictionary:
	var allies := ModeTableScript.ally_count(mode_id)
	if allies <= 0:
		allies = GameConfig.ALLY_SQUAD_SIZE      # 人数未定（兵棋）⇒ 与单跑 Main.tscn 同一口径
	return of_friendly_total(1 + allies)


## 主线归属（4.10.8：主线下发给小队长）。
## 单机里玩家就是自己小队的队长 ⇒ 两种情形都是玩家收；区别只在「有没有小队」：
##   PVP：玩家是小队长（squad 0）｜PVEVP：只有 1 个组、没有小队 ⇒ 主线直接发玩家
##   （这正是 docx 第十九章 ㊸ 待拍板的问题，工程先按「没有小队就直接发玩家」实现。）
static func main_quest_recipient(data: Dictionary) -> int:
	return 0


static func has_squad(data: Dictionary) -> bool:
	return int(data.get("squad_count", 0)) > 0


## 界面用的一句话（模式选择 / 大厅都显示这个）
static func summary_text(data: Dictionary) -> String:
	var gc := int(data.get("group_count", 0))
	var sc := int(data.get("squad_count", 0))
	if sc > 0:
		return "%d 小队 / %d 组（组 %d 人）" % [sc, gc, group_size()]
	if gc > 0:
		return "%d 组（不足 %d 组，不构成小队）" % [gc, min_groups_per_squad()]
	return "无编成"
