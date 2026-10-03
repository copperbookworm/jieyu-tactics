extends RefCounted

## 编成命令层（docx 4.10.8 · 2026-10-03 使用者拍板）
##
##   4.10.8 原话：「主线下发给小队长、小队长按模板派发小队内子任务」。
##
## 小队长 = 每个小队第一个组的组长（Organization.squad_leaders）；单机里玩家就是 0 号小队长
## （Organization.of_friendly_total 把玩家放在名册第 0 位），所以主线收件人恒为玩家。
## 没有小队时（PVEVP 4P = 1 个组）没有小队长 —— 主线直接发玩家，这是 docx 第十九章 ㊸ 的
## **工程默认（候选 A）**；要改候选 B（AI 补一组凑满 8 人）只需改 Organization.of_mode 的人数口径。
##
## 本模块只做**派发**：把一条主线（指向某个占领节点）按模板摊成「每组的子任务」，
## 并回答「谁收主线、我这组该干什么」。它不碰场景树，所以能直接单测。
## 指令的**执行**（队友按组任务行动、HUD 显示组任务）是下一层，不在本模块里。
##
## 刻意不写 class_name：引用方 preload。

## 组任务的三个模板（4.10.8 说「按模板派发」，不是每局临场编）
const TEMPLATE_TAKE := "占领"
const TEMPLATE_HOLD := "守住"
const TEMPLATE_SCOUT := "侦察"


## 派发：organization 来自 Organization.of_*；zone_count = 本局占领节点数；main_zone = 主线指向的节点下标
## 模板分配：0 组（玩家所在组）拿主线那一个节点「占领」；1 组「守住」下一个节点；其余「侦察」再后面的节点。
## 节点不够就按 zone_count 取模循环 —— 节点数少于组数是常态（本局 3 个节点、5 个组）。
static func issue(organization: Dictionary, zone_count: int, main_zone: int = 0) -> Dictionary:
	var groups := int(organization.get("group_count", 0))
	var member_of: Dictionary = organization.get("member_of", {})
	var orders := {}
	var items: Array = []
	for g in groups:
		var zone := 0 if zone_count <= 0 else posmod(main_zone + g, zone_count)
		var template := TEMPLATE_TAKE if g == 0 else (TEMPLATE_HOLD if g == 1 else TEMPLATE_SCOUT)
		var entry := {
			"group": g,
			"template": template,
			"zone": zone,
			"text": "%s %s" % [template, zone_name(zone)],
		}
		orders[g] = entry
		items.append(entry)
	var squad_of_group := int((member_of.get(0, {}) as Dictionary).get("squad", -1))
	return {
		"recipient": 0,                 # 主线收件人：0 = 玩家（单机里他就是自己小队的队长）
		"has_squad": int(organization.get("squad_count", 0)) > 0,
		"squad": squad_of_group,
		"orders": orders,
		"items": items,
		"my_group": int((member_of.get(0, {}) as Dictionary).get("group", 0)),
		"my_order": orders.get(int((member_of.get(0, {}) as Dictionary).get("group", 0)), {}),
	}


## 占领节点的显示名：目标节点用字母（A/B/C…），与射击游戏的通行叫法一致；越界给「节点 N」
static func zone_name(zone_index: int) -> String:
	if zone_index < 0:
		return "—"
	if zone_index < 26:
		return char(65 + zone_index)
	return "节点 %d" % (zone_index + 1)


## 界面用的一句话（玩家那一组的组任务）
static func summary_text(data: Dictionary) -> String:
	var mine: Dictionary = data.get("my_order", {})
	if mine.is_empty():
		return "无组任务"
	var who := "小队长" if bool(data.get("has_squad", false)) else "组长（本局无小队）"
	return "%s：%s" % [who, String(mine.get("text", "—"))]
