extends SceneTree

## 导出预设诊断（2026-10-07 第八十七版）：把 export_presets.cfg 里可疑的键**逐条打印出来**
##
## 为什么留这个小工具：发布收口那一轮，Godot 报「代码签名: 找不到发布密钥库，无法导出」，
## 而文件里的路径、口令、文件、别名**全是好的**。对着 cfg 猜了两轮没结论，
## 用这个脚本一打印就看见：`keystore/release` 读出来是 <缺>、而它下面两行却读得到 ——
## 根因是那三行前面有一段以 `#` 开头的说明；**Godot 的 ConfigFile 里 `#` 不是注释**（只有 `;` 是），
## 它会把紧跟其后的那一条键一起吃掉。
##
## 用法：godot --headless --path <工程> --script res://tools/diag_export_preset.gd
##
## 排查同类问题的套路：怀疑「某个配置项没生效」时，**先让 Godot 自己读一遍给你看**，
## 比对着文件猜快得多 —— 文件没问题不代表 Godot 读到的东西没问题。

const KEYS := [
	"package/unique_name", "package/name", "package/signed",
	"version/code", "version/name",
	"gradle_build/export_format", "gradle_build/min_sdk",
	"keystore/release", "keystore/release_user", "keystore/release_password",
	"launcher_icons/main_192x192",
	"launcher_icons/adaptive_foreground_432x432",
	"launcher_icons/adaptive_background_432x432",
]


func _initialize() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load("res://export_presets.cfg")
	print("[diag] ConfigFile.load err = ", err, "（0 = 成功）")
	if err != OK:
		quit(1)
		return
	print("[diag] 预设名 = ", cfg.get_value("preset.0", "name", "<缺>"))
	print("[diag] 段列表 = ", cfg.get_sections())
	var missing := 0
	for key in KEYS:
		var value: Variant = cfg.get_value("preset.0.options", key, "<缺>")
		var shown := str(value)
		if key.contains("password"):
			# 口令只报长度，不打印内容
			shown = "<空>" if shown.is_empty() else "<非空，长度 %d>" % shown.length()
		print("[diag] %-46s = %s" % [key, shown])
		if shown == "<缺>":
			missing += 1
	if missing > 0:
		print("[diag] ⚠ 有 %d 个键读不到 —— 先查这个文件里有没有以 # 开头的行" % missing)
	quit(0)
