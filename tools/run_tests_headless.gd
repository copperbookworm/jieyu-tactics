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
