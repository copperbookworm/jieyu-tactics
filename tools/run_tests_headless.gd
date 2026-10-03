extends SceneTree

## 无编辑器跑批器：一次跑完 test/ 下的全部测试脚本（2026-09-30 加，配合 DSH 侧自动验收）
##
## 为什么要它：项目里的测试都是 @tool + extends EditorScript，而 EditorScript 只能在编辑器里
## 实例化（「Class 'EditorScript' can only be instantiated by editor.」）。这些测试本身不用任何
## 编辑器 API，所以这里读源码、把基类换成 RefCounted 再动态编译执行 —— 结果与编辑器里「文件 → 运行」等价。
##
## 用法（在项目根目录）：
##   godot --headless --path . --script res://tools/run_tests_headless.gd
##   godot --headless --path . --script res://tools/run_tests_headless.gd -- test/cover_test.gd
## 退出码：0 = 全绿，1 = 有失败（方便脚本/CI 判读）。
## 提示：受限沙箱里 Godot 写不了 user:// 日志会崩（Failed to open 'user://logs/...'），
## 此时加 --log-file <工作区内可写路径> 即可。

## 跑几何门禁子进程，解析它的「—— 通过 N 项 / 失败 M 项 ——」汇总行；拿不到就返回 {}
## script_path 与 log_name 都是参数：现在有两条门禁（Main.tscn 的 HUD + App.tscn 的外壳五屏）
func _run_geometry_gate(script_path: String, log_name: String) -> Dictionary:
	var exe := OS.get_executable_path()
	var project := ProjectSettings.globalize_path("res://")
	var output: Array = []
	var log_path := "user://%s" % log_name
	# 用 --log-file 而不是管道捕获：受限环境里 OS.execute 的 stdout 管道拿不到东西（实测「跳过」）。
	OS.execute(exe, ["--headless", "--path", project, "--log-file",
			ProjectSettings.globalize_path(log_path), "--script",
			script_path], output, false)
	var text := ""
	var f := FileAccess.open(log_path, FileAccess.READ)
	if f != null:
		text = f.get_as_text()
		f.close()
	for line in text.split("\n"):
		if not line.begins_with("—— 通过 "):
			continue
		var digits := ""
		for ch in line:
			digits += ch if (ch >= "0" and ch <= "9") or ch == "/" else ""
		var parts := digits.split("/")
		if parts.size() >= 2:
			return {"passed": int(parts[0]), "failed": int(parts[1])}
	return {}


func _initialize() -> void:
	var wanted := OS.get_cmdline_user_args()
	var names := _test_scripts()
	if wanted.size() > 0:
		var filtered: Array[String] = []
		for name in names:
			for want in wanted:
				if want.contains(name):
					filtered.append(name)
		names = filtered
	if names.is_empty():
		print("！！ res://test 下没找到要跑的脚本（筛选参数 %s）" % str(wanted))
		quit(1)
		return
	var bad: Array[String] = []
	for name in names:
		var path := "res://test/" + name
		print("\n===== %s =====" % path)
		var inst := _make_instance(path)
		if inst == null:
			print("！！ 编译/实例化失败")
			bad.append(name + "（无法执行）")
			continue
		inst.call("_run")
		var passed: Variant = inst.get("_passed")
		var failed: Variant = inst.get("_failed")
		print("<<<<< %s 通过=%s 失败=%s" % [name, str(passed), str(failed)])
		if failed == null or int(failed) != 0:
			bad.append("%s（通过 %s / 失败 %s）" % [name, str(passed), str(failed)])
	# 几何门禁（visual-regression 技能）：控件不出屏 / 同级不新增重叠 / 点按目标够大 / 层号合法。
	# 为什么用子进程：两条门禁都跟本源文件一样是 SceneTree 入口（自己 quit），
	# 进程内没法把它们当普通测试实例化 —— 所以各起一个 headless 进程，把汇总行并进来。
	#   ① geom_assertions.gd   Main.tscn 的对局内 HUD
	#   ② screen_geom_check.gd App.tscn 的外壳五屏（大厅 / 模式 / 设置 / 暂停 / 结算）
	# ⚠ 「子进程没起来」= 门禁没跑，**必须算失败**。历史教训：把跳过的红当成绿提交过。
	if wanted.is_empty():
		var gates := [
			["res://tools/geom_assertions.gd", "geom_gate.log"],
			["res://tools/screen_geom_check.gd", "screen_geom_gate.log"],
			["res://tools/scale_wiring_check.gd", "scale_wiring_gate.log"],
		]
		for gate in gates:
			var script_path := String(gate[0])
			var label := script_path.get_file()
			var geom := _run_geometry_gate(script_path, String(gate[1]))
			names.append(label)
			if geom.has("passed"):
				print("<<<<< %s 通过=%d 失败=%d" % [label, int(geom["passed"]), int(geom["failed"])])
				if int(geom["failed"]) != 0:
					bad.append("%s（通过 %d / 失败 %d）" % [label, int(geom["passed"]), int(geom["failed"])])
			else:
				print("！！ %s 跳过（子进程没起来 / 输出里没有汇总行）—— 门禁没跑不等于通过" % label)
				bad.append("%s（跳过：门禁没跑起来）" % label)
	print("\n#### 汇总：脚本 %d 个，未全绿 %d 个" % [names.size(), bad.size()])
	for entry in bad:
		print("#### 未全绿：%s" % entry)
	quit(1 if bad.size() > 0 else 0)


func _test_scripts() -> Array[String]:
	var names: Array[String] = []
	var dir := DirAccess.open("res://test")
	if dir == null:
		return names
	for file in dir.get_files():
		if file.ends_with(".gd"):
			names.append(file)
	names.sort()
	return names


## 读源码 → 把 extends EditorScript 换成 extends RefCounted → 动态编译 → 实例化
func _make_instance(path: String) -> Object:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("！！ 读不到 %s" % path)
		return null
	var source := file.get_as_text()
	file.close()
	if not source.contains("extends EditorScript"):
		print("！！ %s 的基类不是 EditorScript，跑批器不认识" % path)
		return null
	source = source.replace("extends EditorScript", "extends RefCounted")
	var script := GDScript.new()
	script.set_source_code(source)
	var err := script.reload()
	if err != OK:
		print("！！ 动态编译失败（err=%d）" % err)
		return null
	return script.new()
