extends RefCounted

## 逐帧帧时间落盘（godot-perf-profile · M1 · 施工单 `改动1.md` §4 M1）
##
## 为什么需要它：真机上每轮只能拿到 1~2 个 2.5~3 s 的 logcat 窗口 —— 华为私有管理器会在 6~9 s 后
## 停掉采样（standard doze 已排除，adb 关不掉私有层），**不足以断言整局不掉帧**。
## 改成每帧一行写 `user://perf_<时间戳>.csv`，跑完用 adb pull 取回：
##   · 不受 logcat 缓冲与采样窗口限制，能拿整局分布
##   · 能算「连续超 16.7 ms 的最长连击」这种 logcat 窗口看不到的量
##
## 纪律（照施工单）：
##   · 只写 `user://`（Android 上是 /sdcard/Android/data/<pkg>/files/），**不写 res://**
##   · **不每帧 flush**：每 CSV_FLUSH_EVERY 帧 flush 一次（既不丢太多、也不让采样开销失控）
##   · 静态状态：调用方不用持有实例（PerfOverlay 逐帧调；_measure_boot 只改 tag）
##   · 刻意不写 class_name：引用方 preload（本工程纪律）
##
## 表头：tag,frame_index,delta_ms,fps,physics_frames,physics_steps_delta
##   tag 用来把同一份 CSV 里的不同变体/场景分开（_measure_boot 写变体名；整局跑是 "match"）
##
## 完成标志（M4 · 2026-10-06）：**干净跑完**才写一个与 CSV 同名的 `perf_<时间戳>.done` 哨兵。
##   取数脚本按它「等」而不是按固定秒数睡 —— 系统挤占调度时引擎时间会明显慢于墙钟，
##   固定秒数会在探针自退之前就把数据取走，拿到被截断的半截样本
##   （第七十七版实测：探针设 60 s，只跑到 40.7 s 就被取数打断）。
##   被强杀 / 崩溃时这个文件**不存在** ⇒ 取数侧能明确报「样本不完整」，而不是静默分析半截数据。
##
## 归属者（driver）：两条路径都可能驱动逐帧写入 —— 正常对局是 ui/PerfOverlay.gd（"overlay"），
## 变体扫描是 scenes/_measure_boot.gd（"sweep"，它直接实例化 Main.tscn、**不经过 MatchHost**，
## 所以那个场景下 overlay 根本不存在）。用 driver 守卫保证**只有一个在写**，避免双写同一份 CSV。

const CSV_FLUSH_EVERY := 120

static var _file: FileAccess = null
static var _buffer: PackedStringArray = []
static var _flushed := 0
static var _index := 0
static var _prev_phys := 0
static var _path := ""
static var _done_path := ""
static var _span_ms := 0.0
static var _driver := ""
static var tag := "match"


static func is_open() -> bool:
	return _file != null


static func path() -> String:
	return _path


## 完成标志文件路径（没跑过 / 被强杀时它是空的，文件也不存在）
static func done_path() -> String:
	return _done_path


## 已经写完成标志了吗 —— 取数侧/自检用
static func is_done() -> bool:
	return _done_path != "" and FileAccess.file_exists(_done_path)


static func driver() -> String:
	return _driver


## 幂等：已经开着就保持原 driver 只更新 tag（多个调用方都能安全调）
static func start(owner: String = "match") -> void:
	if _file != null:
		return
	_driver = owner
	var ts := Time.get_datetime_string_from_system(false, true)
	ts = ts.replace("-", "").replace(":", "").replace("T", "-").replace(" ", "-")
	_path = "user://perf_%s.csv" % ts
	_done_path = "user://perf_%s.done" % ts
	# 新的一次落盘：计数器归零（同一进程里出现第二次 start/stop 也不会串台）
	_buffer.clear()
	_flushed = 0
	_index = 0
	_span_ms = 0.0
	_file = FileAccess.open(_path, FileAccess.WRITE)
	if _file == null:
		push_warning("[perf-csv] 打不开 %s（错误码 %d）" % [_path, FileAccess.get_open_error()])
		return
	_prev_phys = Engine.get_physics_frames()
	_file.store_line("tag,frame_index,delta_ms,fps,physics_frames,physics_steps_delta")
	_file.flush()
	print("[perf-csv] 开始落盘：%s（driver=%s）" % [ProjectSettings.globalize_path(_path), _driver])


## 每帧调一次；只有 driver 匹配时才写。必须在任何「每 N 秒才刷新」的早退之前调用，否则会漏帧。
static func frame(owner: String, delta: float) -> void:
	if _file == null or owner != _driver:
		return
	var phys := Engine.get_physics_frames()
	var steps := phys - _prev_phys
	_prev_phys = phys
	_span_ms += delta * 1000.0
	_buffer.append("%s,%d,%.3f,%d,%d,%d" % [
			tag, _index, delta * 1000.0,
			int(Engine.get_frames_per_second()), phys, steps])
	_index += 1
	if _index % CSV_FLUSH_EVERY == 0:
		_flush()


## 幂等：没开着就什么都不做
static func stop() -> void:
	if _file == null:
		return
	_flush()
	_file.close()
	_file = null
	_write_done()
	print("[perf-csv] 落盘结束：%s（%d 帧 / %.1f s）" % [
			ProjectSettings.globalize_path(_path), _index, _span_ms / 1000.0])


## 完成标志：只有 stop() 被正常调到才会写（被强杀 / 崩溃 ⇒ 文件不存在）
static func _write_done() -> void:
	var f := FileAccess.open(_done_path, FileAccess.WRITE)
	if f == null:
		push_warning("[perf-csv] 写不了完成标志 %s（错误码 %d）" % [_done_path, FileAccess.get_open_error()])
		return
	f.store_string("done\n")
	f.store_string("tag=%s\n" % tag)
	f.store_string("driver=%s\n" % _driver)
	f.store_string("csv=%s\n" % _path.get_file())
	f.store_string("frames=%d\n" % _index)
	f.store_string("span_ms=%.1f\n" % _span_ms)
	f.store_string("unix=%d\n" % int(Time.get_unix_time_from_system()))
	f.close()
	print("[perf-csv] 完成标志：%s（frames=%d span=%.1f s）" % [
			ProjectSettings.globalize_path(_done_path), _index, _span_ms / 1000.0])


static func _flush() -> void:
	if _file == null or _buffer.is_empty():
		return
	_file.store_string("\n".join(_buffer) + "\n")
	_file.flush()
	_flushed += _buffer.size()
	_buffer.clear()
