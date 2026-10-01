@tool
extends EditorScript

## 导出「当前 demo 噪声地形」为灰度高度图，作为自制地图的起手稿。
## 用法：脚本编辑器打开本文件 → 文件 → 运行
## 产物：res://assets/maps/map_demo_height.png（1000×1000，黑=0 m，白=MAX_ELEVATION）
## 之后：在任意画图软件里改这张图 → 把 Main.map_height_image 指向你的图 → 重跑

const OUT_PATH := "res://assets/maps/map_demo_height.png"


func _run() -> void:
	var grid := MapGenerator.build_demo_grid()
	var absolute := ProjectSettings.globalize_path(OUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute.get_base_dir())
	var err := MapGenerator.export_height_image(grid, absolute)
	if err != OK:
		print("！！ 导出失败：%s" % error_string(err))
		return
	print("已导出高度图：%s（%d×%d，黑 = 0 m，白 = %d m）"
			% [OUT_PATH, grid.width, grid.height, int(GameConfig.MAX_ELEVATION)])
	print("改图后把 Main 的 map_height_image 指向你的 PNG 即可生效（尺寸必须 1000×1000）")
