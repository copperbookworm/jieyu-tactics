extends SceneTree

## 导出包验收探针（2026-10-01 加，替代原先只验高度图的 probe_height_export.gd）
##
## 为什么必须有它：**开发机跑得好好的，不等于导出包跑得起来**。本项目踩过两次，都是「静默降级」：
##   ① 高度图是按 res:// 直接读原图的 —— 导出包里 PNG 只留 .ctex，读不到原图（Godot 会 WARNING
##      「this will not work on export」）。已改成先走 ResourceLoader 取 Texture2D → get_image()。
##   ② 三张数据表是 data/*.txt —— **.txt 不是 Godot 资源**（刻意如此：.csv 会被当翻译表导入），
##      只配 export_filter="all_resources" 的话一张都不会进包。真机症状：载具 hp/弹药归零
##      （HUD 显示「车体 0/0 ｜ 余弹 0」），炮永远打不出来，而游戏照跑不误、只在日志里 push_error。
##      已在 export_presets.cfg 里加 include_filter="data/*.txt"。
##
## 跑法（两条命令，PCK 只是临时产物，跑完可删）：
##   godot --headless --path <proj> --export-pack "Android" <tmp>\jieyu1.pck
##   godot --headless --main-pack <tmp>\jieyu1.pck --script res://tools/probe_export_pack.gd
## 退出码：0 = 导出包自检通过；1 = 有项目缺失（**导出前必跑**）。
##
## 注：--script 模式下 autoload 未注册，preload 到用 EventBus 的脚本会打几条
## 「Identifier not found: EventBus」——那是 --script 模式的既有脾性（见 run_integration_headless.gd 头部）。

const WorldSetupScript := preload("res://scenes/gameplay/WorldSetup.gd")
const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")
const WeaponTableScript := preload("res://systems/weapons/WeaponTable.gd")
const QuestTableScript := preload("res://systems/quest/QuestTable.gd")

var _failed := 0


func _check(title: String, ok: bool) -> void:
	if ok:
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s" % title)


func _initialize() -> void:
	print("===== 导出包自检 =====")

	# ① 三张数据表必须在包里（.txt 不是资源，靠 export_presets.cfg 的 include_filter）
	for path in [WeaponTableScript.CSV_PATH, VehicleTableScript.CSV_PATH,
			QuestTableScript.CSV_PATH]:
		_check("数据表在包里：%s" % path, FileAccess.file_exists(path))

	# ② 表真的解析得出来（光有文件不算，得能查出数据）
	var ifv = VehicleTableScript.get_vehicle("ifv_a")
	_check("载具表能查出 ifv_a（hp=%.0f ammo=%.0f）" % [
			VehicleTableScript.number(ifv, "hp", -1.0),
			VehicleTableScript.number(ifv, "ammo", -1.0)], not ifv.is_empty())
	_check("载具表能查出 mbt_t1", not VehicleTableScript.get_vehicle("mbt_t1").is_empty())
	var gun = WeaponTableScript.get_weapon("qbz191")
	_check("武器表能查出 qbz191（弹匣 %.0f）" % WeaponTableScript.number(gun, "mag_size", -1.0),
			not gun.is_empty())
	_check("任务表能查出 T-M1", not QuestTableScript.get_template("T-M1").is_empty())

	# ③ 高度图要读得到（导出包里只有 .ctex，走 ResourceLoader；老写法必然失败）
	var image: Image = WorldSetupScript._load_height_image(GameConfig.MAP_HEIGHT_IMAGE)
	_check("高度图读得到（%s）" % (str(image.get_size()) if image != null else "null"),
			image != null)
	if image != null:
		_check("高度图尺寸 = 网格尺寸",
				image.get_width() == GameConfig.GRID_WIDTH
				and image.get_height() == GameConfig.GRID_HEIGHT)
		var grid := HeightGrid.new(GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT)
		_check("高度图能直接填进网格", grid.fill_from_image(image))
	_check("原图 PNG 确实不在包里（说明走的是导入资源那条路，符合预期）",
			not FileAccess.file_exists("res://assets/maps/map_demo_height.png"))

	print("—— 导出包自检：失败 %d 项 ——" % _failed)
	quit(1 if _failed > 0 else 0)
