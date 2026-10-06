extends Node

## 【临时】空场景 headless 地板 + 卡顿定位：判断 50ms 尖峰是一次性的还是周期性的
var _t := 0.0
var _samples: Array = []
var _stalls: Array = []
var _last_msec := 0


func _ready() -> void:
	Engine.max_fps = 0
	OS.low_processor_usage_mode = false
	OS.low_processor_usage_mode_sleep_usec = 0
	_last_msec = Time.get_ticks_msec()
	print("[floor] max_fps=%d low_proc=%s phys_hz=%d" % [
			Engine.get_max_fps(), str(OS.low_processor_usage_mode), Engine.physics_ticks_per_second])


func _process(delta: float) -> void:
	_t += delta
	var ms := delta * 1000.0
	_samples.append(ms)
	if ms > 10.0:
		_stalls.append("%.2fs:+%.1fms" % [_t, ms])
	if _t < 12.0:
		return
	var sorted: Array = _samples.duplicate()
	sorted.sort()
	var c: int = sorted.size()
	print("[floor] 空场景：n=%d p50=%.3f p90=%.3f max=%.3f ms｜>10ms 卡顿 %d 次" % [
			c, sorted[int(float(c) * 0.5)], sorted[int(float(c) * 0.9)], sorted[c - 1], _stalls.size()])
	print("[floor] 卡顿时刻（前 12 个）：%s" % ", ".join(_stalls.slice(0, 12)))
	get_tree().quit(0)
