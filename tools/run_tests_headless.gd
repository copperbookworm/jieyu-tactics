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
##   godot --headless --path . --script res://tools/run_tests_headless.gd -- --jobs=4      # 进程级分片并行
##   godot --headless --path . --script res://tools/run_tests_headless.gd -- --jobs=1      # 强制串行（旧行为）
## 退出码：0 = 全绿，1 = 有失败（方便脚本/CI 判读）。
## 提示：受限沙箱里 Godot 写不了 user:// 日志会崩（Failed to open 'user://logs/...'），
## 此时加 --log-file <工作区内可写路径> 即可。
##
## 【2026-10-06 第七十九版 · 并行计算整改】进程级分片：
##   54 个脚本 + 3 条门禁原来在一个进程里串行跑（桌面实测 118.8 s）。脚本之间**零共享状态**
##   （每个都是独立 RefCounted + 自己 new 的世界），所以按核数切给 N 个 Godot 子进程即可。
##   默认 jobs = 自动（核数÷3，夹在 1~4）—— 不是越多越好：每个子进程都要重新加载整个工程
##   （实测每个约 1 s 起步），过量分片会把收益吃回去。实测与结论见 docs/性能预算.md 第二十八节。
##   ⚠ 分片只切**测试脚本**；三条几何门禁在父进程里并行跑（它们各自起自己的子进程）。

## 自动分片的分母与上限（实测依据见 §28）
const AUTO_JOBS_DIVISOR := 3
const AUTO_JOBS_MAX := 4

var _jobs := 0                 ## 0 = 自动；1 = 串行
var _shard := -1               ## >= 0 表示自己是某个分片子进程
var _shards := 1
var _wanted: Array[String] = []


func _initialize() -> void:
	_parse_args()
	var names := _test_scripts()
	if _wanted.size() > 0:
		var filtered: Array[String] = []
		for name in names:
			for want in _wanted:
				if name.contains(want):
					filtered.append(name)
		names = filtered
	if names.is_empty():
		print("！！ res://test 下没找到要跑的脚本（筛选参数 %s）" % str(_wanted))
		quit(1)
		return
	if _shard >= 0:
		quit(_run_script_slice(_slice(names, _shard, _shards), false))
		return
	var jobs := _effective_jobs(names.size())
	if jobs > 1:
		quit(_run_sharded(names, jobs))
		return
	quit(_run_script_slice(names, _wanted.is_empty()))


## 参数：--jobs=N / --shard=i/N / 其余当筛选关键词（与旧行为一致）
func _parse_args() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--jobs="):
			_jobs = int(arg.split("=")[1])
		elif arg.begins_with("--shard="):
			var parts := arg.split("=")[1].split("/")
			if parts.size() == 2:
				_shard = int(parts[0])
				_shards = maxi(int(parts[1]), 1)
		else:
			_wanted.append(arg)


## 分片数：0 = 自动（核数÷3，夹 1~AUTO_JOBS_MAX）；显式 <= 1 = 串行
func _effective_jobs(script_count: int) -> int:
	var jobs := _jobs
	if jobs <= 0:
		jobs = clampi(OS.get_processor_count() / AUTO_JOBS_DIVISOR, 1, AUTO_JOBS_MAX)
	return clampi(jobs, 1, maxi(script_count, 1))


## 按名轮转分片（round-robin）：跑得慢的几个脚本基本会落在不同片里，
## 比「前 1/4 全给 0 号片」更均衡（本轮没有逐脚本历史耗时，先这样；有耗时数据后再按 LPT 排）。
func _slice(names: Array[String], index: int, total: int) -> Array[String]:
	var out: Array[String] = []
	for i in names.size():
		if i % total == index:
			out.append(names[i])
	return out


## 一片（或串行时的全部）：跑脚本 → 视情况跑门禁 → 打印汇总 → 返回退出码
func _run_script_slice(names: Array[String], with_gates: bool) -> int:
	var bad: Array[String] = []
	var total_scripts := names.size()
	for name in names:
		var path := "res://test/" + name
		print("")
		print("===== %s =====" % path)
		var started := Time.get_ticks_usec()
		var inst := _make_instance(path)
		if inst == null:
			print("！！ 编译/实例化失败")
			bad.append(name + "（无法执行）")
			continue
		inst.call("_run")
		var passed: Variant = inst.get("_passed")
		var failed: Variant = inst.get("_failed")
		print("<<<<< %s 通过=%s 失败=%s 用时=%d ms" % [
				name, str(passed), str(failed), (Time.get_ticks_usec() - started) / 1000])
		if failed == null or int(failed) != 0:
			bad.append("%s（通过 %s / 失败 %s）" % [name, str(passed), str(failed)])
	# 几何门禁（visual-regression 技能）：控件不出屏 / 同级不新增重叠 / 点按目标够大 / 层号合法。
	# 为什么用子进程：两条门禁都跟本源文件一样是 SceneTree 入口（自己 quit），
	# 进程内没法把它们当普通测试实例化 —— 所以各起一个 headless 进程，把汇总行并进来。
	#   ① geom_assertions.gd   Main.tscn 的对局内 HUD
	#   ② screen_geom_check.gd App.tscn 的外壳五屏（大厅 / 模式 / 设置 / 暂停 / 结算）
	# ⚠ 「子进程没起来」= 门禁没跑，**必须算失败**。历史教训：把跳过的红当成绿提交过。
	if with_gates:
		var commands := _gate_commands()
		var logs := _run_processes(commands)
		for i in commands.size():
			var label := String(commands[i]["label"])
			total_scripts += 1
			var geom := _parse_gate(logs[i])
			if geom.has("passed"):
				print("<<<<< %s 通过=%d 失败=%d" % [label, int(geom["passed"]), int(geom["failed"])])
				if int(geom["failed"]) != 0:
					bad.append("%s（通过 %d / 失败 %d）" % [label, int(geom["passed"]), int(geom["failed"])])
			else:
				print("！！ %s 跳过（子进程没起来 / 输出里没有汇总行）—— 门禁没跑不等于通过" % label)
				bad.append("%s（跳过：门禁没跑起来）" % label)
	if _shard < 0:
		print("")
		print("#### 汇总：脚本 %d 个，未全绿 %d 个" % [total_scripts, bad.size()])
		for entry in bad:
			print("#### 未全绿：%s" % entry)
	return 1 if bad.size() > 0 else 0


## 父进程：把脚本切片交给 N 个 Godot 子进程，等它们全部跑完，再汇总
func _run_sharded(names: Array[String], jobs: int) -> int:
	print("#### 分片并行：%d 个脚本 → %d 个 Godot 子进程（每片约 %d 个）" % [
			names.size(), jobs, int(ceil(float(names.size()) / float(jobs)))])
	var shard_commands: Array = []
	for i in jobs:
		var args := _base_args("test_shard_%d.log" % i)
		args.append_array(["--script", "res://tools/run_tests_headless.gd", "--",
				"--shard=%d/%d" % [i, jobs]])
		for want in _wanted:
			args.append(want)
		shard_commands.append({"args": args, "log": "test_shard_%d.log" % i, "label": "shard%d" % i})
	# 门禁与分片**同时**起（门禁不依赖测试结果）：不然总时长 = 分片 + 门禁，白等一趟。
	# 实测这一改把 85 s 压到 ~50 s（jieyu_map_test 单独 40 s 是当前关键路径，见 §28）。
	var gate_commands: Array = [] if not _wanted.is_empty() else _gate_commands()
	var all_logs: Array[String] = _run_processes(shard_commands + gate_commands)
	var logs := all_logs.slice(0, shard_commands.size())
	var gate_logs := all_logs.slice(shard_commands.size())
	var bad: Array[String] = []
	var total := 0
	var reported := {}
	for i in logs.size():
		for line in logs[i].split("\n"):
			if not line.begins_with("<<<<< "):
				continue
			total += 1
			reported[line.split(" ")[1]] = true
			if _failed_from_line(line) != 0:
				bad.append(line.trim_prefix("<<<<< "))
	# ⚠ 缺片守卫（2026-10-06）：子进程崩了 / 起不来时它**不会**产出 <<<<< 行，
	# 只看"坏行数"会把"少跑了一半"当成全绿。历史教训同类：门禁"跳过"曾被当绿提交。
	for name in names:
		if not reported.has(name):
			bad.append("%s（**没报告结果**：该片崩了或没起来 —— 不算通过）" % name)
	if true:
		for i in gate_commands.size():
			var label := String(gate_commands[i]["label"])
			total += 1
			var geom := _parse_gate(gate_logs[i])
			if not geom.has("passed"):
				bad.append("%s（跳过：门禁没跑起来）" % label)
			elif int(geom["failed"]) != 0:
				bad.append("%s（通过 %d / 失败 %d）" % [label, int(geom["passed"]), int(geom["failed"])])
	print("")
	print("#### 汇总：脚本 %d 个，未全绿 %d 个" % [total, bad.size()])
	for entry in bad:
		print("#### 未全绿：%s" % entry)
	return 1 if bad.size() > 0 else 0


## 门禁命令（与串行分支同一张表）：3 条几何门禁 + 1 条美术规格门禁
## 美术门禁（2026-10-07 第八十六版）量的是「规格文件自洽 + 素材到货盘点」，
## 与几何门禁红的原因完全不同，所以单开一条（见 tools/check_art_manifest.gd 头部）。
func _gate_commands() -> Array:
	var out: Array = []
	var table := [
		["res://tools/geom_assertions.gd", "geom_gate.log"],
		["res://tools/screen_geom_check.gd", "screen_geom_gate.log"],
		["res://tools/scale_wiring_check.gd", "scale_wiring_gate.log"],
		["res://tools/check_art_manifest.gd", "art_manifest_gate.log"],
	]
	for row in table:
		out.append({
			"args": _base_args(String(row[1])) + ["--script", String(row[0])],
			"log": String(row[1]),
			"label": String(row[0]).get_file(),
		})
	return out


## 子进程的公共参数（headless + 同一个工程 + 自己的日志文件）
func _base_args(log_name: String) -> Array:
	return [
		"--headless",
		"--path", ProjectSettings.globalize_path("res://"),
		"--log-file", ProjectSettings.globalize_path("user://%s" % log_name),
	]


## 并行起一批子进程并等它们全部结束，返回各自的日志文本（顺序与入参一致）
func _run_processes(commands: Array) -> Array[String]:
	var logs: Array[String] = []
	if commands.is_empty():
		return logs
	var exe := OS.get_executable_path()
	var pids: Array[int] = []
	for c in commands:
		# 先删旧日志：子进程崩了不会覆盖它 ⇒ 不删就会把**上一轮**的 <<<<< 当成这一轮的结果（假绿）。
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://%s" % String(c["log"])))
		var pid := OS.create_process(exe, c["args"], false)
		if pid <= 0:
			print("！！ 子进程起不来：%s" % str(c["args"]))
		pids.append(pid)
	for pid in pids:
		if pid <= 0:
			continue
		while OS.is_process_running(pid):
			OS.delay_msec(50)
	for c in commands:
		logs.append(_read_log(String(c["log"])))
	return logs


func _read_log(name: String) -> String:
	var f := FileAccess.open("user://%s" % name, FileAccess.READ)
	if f == null:
		return ""
	var text := f.get_as_text()
	f.close()
	return text


## 从门禁日志里取「—— 通过 N 项 / 失败 M 项 ——」
func _parse_gate(text: String) -> Dictionary:
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


## 从「<<<<< name 通过=X 失败=Y 用时=Z ms」里取 Y
func _failed_from_line(line: String) -> int:
	var idx := line.find("失败=")
	if idx < 0:
		return 1
	var rest := line.substr(idx + "失败=".length())
	var digits := ""
	for ch in rest:
		if ch >= "0" and ch <= "9":
			digits += ch
		else:
			break
	return int(digits) if digits != "" else 1


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
