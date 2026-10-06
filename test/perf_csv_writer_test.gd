@tool
extends EditorScript

## M4（施工单 `改动1.md` §4 的下一步）：完成标志哨兵 —— 干净跑完才写 `perf_<ts>.done`。
##
## 为什么值得单测：取数脚本现在按这个文件「等」（而不是按固定秒数睡）。如果 stop() 忘了写它、
## 或内容对不上，取数侧会永远等超时 / 误报「样本被中断」。
## 反过来，**没跑完就不许有它** —— 否则半截样本会被当成完整样本分析。
##
## 只碰 user://，跑完自己删掉；不写 res://。

const PerfCsv := preload("res://systems/debug/PerfCsvWriter.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_cleanup_previous()
	PerfCsv.tag = "unit"
	PerfCsv.start("unit_driver")
	var csv: String = PerfCsv.path()
	var done: String = PerfCsv.done_path()
	_check("start 后文件开着", PerfCsv.is_open(), true)
	_check("CSV 后缀 .csv", csv.ends_with(".csv"), true)
	_check("完成标志后缀 .done", done.ends_with(".done"), true)
	_check("跑完之前没有完成标志", PerfCsv.is_done(), false)
	# driver 守卫：别的 driver 的 frame 不许写进来（否则 frames 会多）
	PerfCsv.frame("unit_driver", 0.016)
	PerfCsv.frame("别的 driver", 0.016)
	PerfCsv.frame("unit_driver", 0.016)
	PerfCsv.stop()
	_check("stop 后写出完成标志", PerfCsv.is_done(), true)
	var text := _read_all(done)
	var lines := text.split(String.chr(10))
	_check("完成标志第一行是 done", lines[0], "done")
	_check("记录 frames=2（driver 守卫生效）", _field(text, "frames"), "2")
	_check("记录 tag", _field(text, "tag"), "unit")
	_check("记录 driver", _field(text, "driver"), "unit_driver")
	_check("记录 csv 文件名", _field(text, "csv"), csv.get_file())
	_check("span_ms 只累加了匹配 driver 的两帧", _field(text, "span_ms"), "32.0")
	var csv_lines := _read_all(csv).split(String.chr(10))
	var rows := 0
	for line in csv_lines:
		if line.strip_edges() != "":
			rows += 1
	_check("CSV 只有表头 + 2 行数据", rows, 3)
	_check("CSV 是删得掉的普通文件", FileAccess.file_exists(csv), true)
	# 幂等：再来一次不许炸、也不许把完成状态弄丢
	PerfCsv.stop()
	_check("stop 幂等后仍标记完成", PerfCsv.is_done(), true)
	_cleanup(csv, done)
	_check("清理后完成标志与 CSV 都没了", [FileAccess.file_exists(csv), FileAccess.file_exists(done)], [false, false])
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


func _field(text: String, key: String) -> String:
	for line in text.split(String.chr(10)):
		if line.begins_with(key + "="):
			return line.substr(key.length() + 1)
	return "<缺失>"


func _read_all(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var text := f.get_as_text()
	f.close()
	return text


## 上一轮可能没删干净：开始前把历史 perf_*.done / perf_*.csv 清掉，避免旧完成标志把 is_done() 弄成假绿
func _cleanup_previous() -> void:
	var dir := DirAccess.open("user://")
	if dir == null:
		return
	for file in dir.get_files():
		if file.begins_with("perf_") and (file.ends_with(".done") or file.ends_with(".csv")):
			DirAccess.remove_absolute(ProjectSettings.globalize_path("user://" + file))


func _cleanup(csv: String, done: String) -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(csv))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(done))
