extends RefCounted

## AI 参谋 —— 战局摘要（纯函数，可单测）
##
## 这是 token 成本的主战场：**绝不 dump 场景树**。只留「参谋复盘用得上」的白名单字段，
## 全部数值走定点、节点按序号称呼、敌情只给已确认信息。
## 上游（AiAdvisor）负责把游戏对象拍平成 snapshot 字典；本文件只认字典，因此可单测。
## 刻意不写 class_name：引用方 preload。

const MAX_TEXT_CHARS := 3000


## 白名单收敛：上游多塞的字段一律丢掉，防止哪天有人把整个 Main 节点塞进来把 token 撑爆
static func build(snapshot: Dictionary) -> Dictionary:
	return {
		"outcome": String(snapshot.get("outcome", "")),
		"reason": String(snapshot.get("reason", "")).substr(0, 160),
		"duration_s": int(snapshot.get("duration_s", 0)),
		"overtime": bool(snapshot.get("overtime", false)),
		"score": int(snapshot.get("score", 0)),
		"kills": int(snapshot.get("kills", 0)),
		"deaths": int(snapshot.get("deaths", 0)),
		"respawn_left": int(snapshot.get("respawn_left", 0)),
		"role_name": String(snapshot.get("role_name", "")),
		"zones": _norm_zones(snapshot.get("zones", [])),
		"quests": _norm_quests(snapshot.get("quests", {})),
		"vehicles": String(snapshot.get("vehicles", "")),
	}


static func _norm_zones(raw: Variant) -> Array:
	var out: Array = []
	if typeof(raw) != TYPE_ARRAY:
		return out
	for z in (raw as Array):
		if typeof(z) != TYPE_DICTIONARY:
			continue
		out.append({
			"n": int((z as Dictionary).get("n", 0)),
			"side": String((z as Dictionary).get("side", "neutral")),
			"progress": snappedf(float((z as Dictionary).get("progress", 0.0)), 0.01),
		})
	return out


static func _norm_quests(raw: Variant) -> Dictionary:
	if typeof(raw) != TYPE_DICTIONARY:
		return {"main": "", "done": [], "failed": [], "completed_count": 0}
	var d: Dictionary = raw
	return {
		"main": String(d.get("main", "")).substr(0, 80),
		"done": d.get("done", []),
		"failed": d.get("failed", []),
		"completed_count": int(d.get("completed_count", 0)),
	}


static func outcome_text(outcome: String) -> String:
	match outcome:
		"player": return "我方胜利"
		"enemy": return "我方失败"
		"draw": return "平局"
		_: return "未判定（%s）" % outcome


static func side_text(side: String) -> String:
	match side:
		"ours": return "我方"
		"enemy": return "敌方"
		_: return "中立"


## 紧凑文本：一行一项、去掉所有可推导的废话。目标 120~200 token。
static func to_text(digest: Dictionary) -> String:
	var lines: Array[String] = []
	lines.append("结局: %s" % outcome_text(String(digest.get("outcome", ""))))
	var reason := String(digest.get("reason", ""))
	if reason != "":
		lines.append("判定依据: %s" % reason)
	var overtime := "是" if bool(digest.get("overtime", false)) else "否"
	lines.append("时长: %d s ｜ 加时: %s" % [int(digest.get("duration_s", 0)), overtime])
	var zone_parts: Array[String] = []
	for z in (digest.get("zones", []) as Array):
		var zd: Dictionary = z
		zone_parts.append("N%d=%s(%.2f)" % [int(zd["n"]), side_text(String(zd["side"])),
				float(zd["progress"])])
	if not zone_parts.is_empty():
		lines.append("节点: %s" % " ".join(zone_parts))
	lines.append("战力分: %d ｜ 击杀: %d ｜ 阵亡: %d ｜ 剩余重生次数: %d" % [
			int(digest.get("score", 0)), int(digest.get("kills", 0)),
			int(digest.get("deaths", 0)), int(digest.get("respawn_left", 0))])
	var role := String(digest.get("role_name", ""))
	if role != "":
		lines.append("兵种: %s" % role)
	var q: Dictionary = digest.get("quests", {})
	var done: Array = q.get("done", [])
	var failed: Array = q.get("failed", [])
	if String(q.get("main", "")) != "" or not done.is_empty() or not failed.is_empty():
		lines.append("任务: 主线[%s] ｜ 完成%d条%s ｜ 失败%d条%s" % [
			String(q.get("main", "无")), done.size(),
			("(" + ", ".join(done) + ")") if not done.is_empty() else "",
			failed.size(),
			("(" + ", ".join(failed) + ")") if not failed.is_empty() else ""])
	var vehicles := String(digest.get("vehicles", ""))
	if vehicles != "":
		lines.append("载具: %s" % vehicles)
	return truncate("\n".join(lines), MAX_TEXT_CHARS)


static func truncate(text: String, max_chars: int) -> String:
	if text.length() <= max_chars:
		return text
	return text.substr(0, max_chars) + "…（截断）"


## 粗估 token：CJK 一个字 ≈ 3 字节 ≈ 1 token，ASCII 4 字节 ≈ 1 token，混合按 3.2 字节/token。
## 只用于「发出去之前的预算预估」，不用于记账（记账一律用供应商回的 usage）。
static func estimate_tokens(text: String) -> int:
	var bytes := text.to_utf8_buffer().size()
	return int(ceil(float(bytes) / 3.2)) + 8
