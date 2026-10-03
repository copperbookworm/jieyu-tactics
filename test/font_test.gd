@tool
extends EditorScript

## 工程默认字体 · 钉子测试
##
## 为什么要有它：2026-10-03 真机验证发现「中英混排里全角标点变豆腐块」，
## 根因是本工程没有随包字体、CJK 靠 Godot 的隐式系统回退（HarmonyOS 上不稳定）。
## 修法是随包一份 OFL 子集字体并设为项目默认字体（assets/fonts/ + project.godot 的 gui/theme/custom_font）。
## 这条测试钉住三件事：①设置还在 ②文件还在且能加载 ③常用全角标点真的有字形。
## 以后谁把设置删了、把字体换成不含 CJK 的、或删了 assets/fonts，这里会红。

const KEY := "gui/theme/custom_font"
const FONT_PATH := "res://assets/fonts/JieyuCJK-Subset.otf"
## 真机上踩过坑的那批字符（全角标点 + 圈号 + 常用符号）
const MUST_HAVE := ["（", "）", "：", "；", "｜", "。", "，", "、", "「", "」", "【", "】",
	"！", "＝", "＋", "①", "②", "③", "④", "→", "⇒", "≈", "≤", "≥", "⚠", "…", "—"]

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_setting()
	_test_coverage()
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


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _test_setting() -> void:
	var configured := String(ProjectSettings.get_setting(KEY, ""))
	_check_true("project.godot 设了 %s" % KEY, configured != "")
	_check("默认字体指向随包字体", configured, FONT_PATH)
	_check_true("字体文件存在", ResourceLoader.exists(FONT_PATH))
	var f: Font = load(FONT_PATH)
	_check_true("字体能加载", f != null)
	if f != null:
		_check_true("字体名里有 Noto（确认不是被换成别的）",
				f.get_font_name().to_lower().contains("noto"))


func _test_coverage() -> void:
	var f: Font = load(FONT_PATH)
	if f == null:
		_check_true("字体加载失败，覆盖率无法检查", false)
		return
	var missing: Array[String] = []
	for ch in MUST_HAVE:
		if not f.has_char(ch.unicode_at(0)):
			missing.append(ch)
	_check("常用全角标点/符号全部有字形（共 %d 个）" % MUST_HAVE.size(), missing.size(), 0)
	if missing.size() > 0:
		print("       缺字形：%s" % " ".join(missing))
