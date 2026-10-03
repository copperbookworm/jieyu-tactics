extends SceneTree

## 价格清单生成器 / 校验器（维护者用）
##
## 为什么要有它：价格表的格式只有一处定义（AiPriceManifest.SCHEMA），生成与解析共用同一套校验，
## 所以**不要让维护者手抄一遍价格** —— 抄错没人发现，而这是给玩家算钱的东西。
## 生成出来的清单直接就是「内置表的当前内容」，改价时改 AiPriceTable.gd 再跑一次这个脚本即可。
##
## 用法：
##   生成（打印到 stdout，重定向存盘）：
##     godot --headless --path . --script res://tools/price_manifest_build.gd \
##           -- --version=3 --updated=2026-10-05 --source=https://… --note="…"
##   生成并存盘：
##     … -- --version=3 --out=user://price_manifest.json
##   发布前校验一个已有的清单文件（把别人的 / 自己改过的都过一遍）：
##     … -- --check=user://price_manifest.json
##   退出码：0 = 成功/校验通过，1 = 参数错或校验不通过。
##
## 发布方式（任一静态托管都行）：
##   1. 把生成的 json 放到一个公开 https 地址（例如某个静态站点或仓库的 raw 链接）
##   2. 在游戏的「价格清单 URL」里填上该地址（面板里就能填，不用重新打包）
##   3. 下次开面板会自动拉一次；也可以点「更新价格表」手动拉

const PriceTable := preload("res://systems/ai/AiPriceTable.gd")
const ManifestScript := preload("res://systems/ai/AiPriceManifest.gd")

var _args := {}


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var i := a.find("=")
		if a.begins_with("--") and i > 0:
			_args[a.substr(2, i - 2)] = a.substr(i + 1)
	var check_path := String(_args.get("check", ""))
	if check_path != "":
		quit(_check_file(check_path))
		return
	var version := int(_args.get("version", PriceTable.VERSION + 1))
	if version <= PriceTable.VERSION:
		print("！！ version 必须大于内置 VERSION(%d)，否则游戏会因「版本只能升不能降」而整份拒绝" % PriceTable.VERSION)
		quit(1)
		return
	var updated := String(_args.get("updated", Time.get_date_string_from_system()))
	var source := String(_args.get("source", ""))
	var note := String(_args.get("note", "由 tools/price_manifest_build.gd 从 AiPriceTable.gd 生成"))
	var models := {}
	for id in PriceTable.MODELS.keys():
		models[id] = (PriceTable.MODELS[id] as Dictionary).duplicate(true)
	var payload := ManifestScript.build_payload(models, version, updated, source, note)
	var text := JSON.stringify(payload, "  ")
	# 自己生成的自己也过一遍校验：生成器与游戏用的是同一套规则，生成即合法
	var back: Dictionary = ManifestScript.parse(text, PriceTable.VERSION)
	if not bool(back.get("ok", false)):
		print("！！ 生成的清单没通过自家校验：%s %s" % [back.get("error", ""), back.get("error_detail", "")])
		quit(1)
		return
	var out := String(_args.get("out", ""))
	if out != "":
		var f := FileAccess.open(out, FileAccess.WRITE)
		if f == null:
			print("！！ 写不进去：%s（错误码 %d）" % [out, FileAccess.get_open_error()])
			quit(1)
			return
		f.store_string(text)
		f.close()
		print("已写出 %s（VERSION %d，%d 个模型，%d 字节）" % [out, version, models.size(), text.length()])
	else:
		print(text)
	print("—— 自检通过：schema %d / version %d / %d 个模型 ——" % [ManifestScript.SCHEMA, version, models.size()])
	quit(0)


func _check_file(path: String) -> int:
	if not FileAccess.file_exists(path):
		print("！！ 找不到文件：%s" % path)
		return 1
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		print("！！ 打不开：%s" % path)
		return 1
	var text := f.get_as_text()
	f.close()
	var r: Dictionary = ManifestScript.parse(text, PriceTable.VERSION)
	if bool(r.get("ok", false)):
		print("—— 校验通过：schema %d / version %d / updated %s / %d 个模型 ——" % [
			int(r.get("schema", 0)), int(r.get("version", 0)), String(r.get("updated", "")),
			int(r.get("model_count", 0))])
		return 0
	print("！！ 校验不通过：%s %s" % [ManifestScript.error_text(String(r.get("error", ""))),
			String(r.get("error_detail", ""))])
	return 1
