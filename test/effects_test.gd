@tool
extends EditorScript

## 表现层（候选 M · 第一轮）：12.3 Blob Shadow / 12.7.3 枪口火光 / 12.7.4 命中·受击·屏幕震动
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd
## 这里测纯规则与生命周期（不进场景树）；「真开枪时特效有没有挂进场景」跑在集成冒烟里。

const EffectSpawnerScript := preload("res://systems/effects/EffectSpawner.gd")
## 三个特效模块刻意不写 class_name（新 class_name 在 --script 下不进全局类缓存）⇒ 这里一律 preload
const BlobShadowScript := preload("res://entities/effects/BlobShadow.gd")
const MuzzleFlashScript := preload("res://entities/effects/MuzzleFlash.gd")
const ImpactFxScript := preload("res://entities/effects/ImpactFx.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_params()
	_test_shadow_math()
	_test_shadow_node()
	_test_muzzle_flash()
	_test_impact_fx()
	_test_spawner_without_tree()
	_test_player_hit_flash()
	_test_enemy_hit_flash()
	_test_screen_shake()
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


func _test_params() -> void:
	_check("12.3：贴地阴影不透明度 0.42", GameConfig.BLOB_SHADOW_ALPHA, 0.42)
	_check("12.3：阴影压扁比 0.55（扁椭圆）", GameConfig.BLOB_SHADOW_SQUASH, 0.55)
	_check("12.7.3：枪口火光寿命 0.06 s", GameConfig.MUZZLE_FLASH_LIFETIME, 0.06)
	_check("12.7.4：命中特效寿命 0.22 s", GameConfig.IMPACT_FX_LIFETIME, 0.22)
	_check("12.7.4：受击闪白 0.09 s", GameConfig.HIT_FLASH_TIME, 0.09)
	_check_true("12.7.4：屏幕震动幅度很小（< 1 m）", GameConfig.SCREEN_SHAKE_STRENGTH < 1.0)


## 12.3「滞空时阴影原位不动但缩小并变模糊」：高度 → 缩放 / 透明度
func _test_shadow_math() -> void:
	_check("阴影：贴地缩放 1.0", BlobShadowScript.scale_for(0.0), 1.0)
	_check("阴影：升高 0.25 m → 0.8", BlobShadowScript.scale_for(0.25), 0.8)
	_check("阴影：升高 0.5 m → 0.6", BlobShadowScript.scale_for(0.5), 0.6)
	_check("阴影：升得再高也不小于 0.35", BlobShadowScript.scale_for(5.0),
			GameConfig.BLOB_SHADOW_MIN_SCALE)
	_check("阴影：负高度按贴地算", BlobShadowScript.scale_for(-3.0), 1.0)
	_check_true("阴影：越高越小（单调）",
			BlobShadowScript.scale_for(0.1) > BlobShadowScript.scale_for(0.4))
	_check_true("阴影：越高越淡",
			BlobShadowScript.alpha_for(0.1) > BlobShadowScript.alpha_for(0.4))
	_check("阴影：贴地透明度 = 基准", BlobShadowScript.alpha_for(0.0), GameConfig.BLOB_SHADOW_ALPHA)
	# 12.3「遵循场景的全局光照方向统一微调」
	_check_true("阴影：光照偏移长度 = 常量（±0.001）",
			absf(BlobShadowScript.light_offset().length()
					- GameConfig.BLOB_SHADOW_LIGHT_OFFSET) < 0.001)
	_check("阴影：光照方向 = 135°",
			snappedf(rad_to_deg(BlobShadowScript.light_offset().angle()), 0.1), 135.0)


func _test_shadow_node() -> void:
	var shadow := BlobShadowScript.new()
	shadow.fit_body(0.4)
	_check("阴影节点：半径 ＝ 身体半径 × 1.30", shadow.radius,
			0.4 * GameConfig.BLOB_SHADOW_BODY_SCALE)
	_check("阴影节点：默认贴地缩放 1.0", shadow.current_scale(), 1.0)
	shadow.set_height(0.25)
	_check("阴影节点：设高度后缩放跟随", shadow.current_scale(), 0.8)
	_check("阴影节点：设高度后透明度跟随", shadow.current_alpha(),
			GameConfig.BLOB_SHADOW_ALPHA * 0.8)
	shadow.free()


func _test_muzzle_flash():
	var flash := MuzzleFlashScript.new()
	flash.setup(Vector2(10.0, 10.0), Vector2.RIGHT, 1.0)
	_check("枪口火光：刚生成时寿命 1.0", flash.remaining_ratio(), 1.0)
	_check("枪口火光：半程后没有到点", flash.tick(GameConfig.MUZZLE_FLASH_LIFETIME * 0.5), false)
	_check("枪口火光：半程后寿命约 0.5",
			snappedf(flash.remaining_ratio(), 0.01), 0.5)
	_check("枪口火光：到点该销毁", flash.tick(GameConfig.MUZZLE_FLASH_LIFETIME), true)
	flash.free()


func _test_impact_fx():
	var fx = ImpactFxScript.new()
	fx.setup(Vector2(50.0, 50.0), 1)
	_check("命中特效：火花条数 = 6", fx.spark_dirs().size(), GameConfig.IMPACT_FX_SPARKS)
	_check("命中特效：命中类型记下来了", fx.kind, 1)
	var other = ImpactFxScript.new()
	other.setup(Vector2.ZERO, 0)
	_check("命中特效：火花方向是确定性的（可复现）", other.spark_dirs(), fx.spark_dirs())
	_check("命中特效：半程没到点", fx.tick(GameConfig.IMPACT_FX_LIFETIME * 0.5), false)
	_check("命中特效：到点该销毁", fx.tick(GameConfig.IMPACT_FX_LIFETIME), true)
	_check("命中特效：越界类型被夹住",
			ImpactFxScript.new().kind, 0)
	fx.free(); other.free()


## 单元测试里 Player / Enemy 是裸 new 的（不在树里）⇒ 特效生成必须安全地什么都不做
func _test_spawner_without_tree() -> void:
	var player := PlayerUnit.new()
	_check("生成器：没有场景时 host 为 null", EffectSpawnerScript.host_for(player), null)
	_check("生成器：没有场景时 muzzle 返回 null",
			EffectSpawnerScript.muzzle_at(player, Vector2.ZERO, Vector2.RIGHT), null)
	_check("生成器：没有场景时 impact 返回 null",
			EffectSpawnerScript.impact_at(player, Vector2.ZERO, 0), null)
	_check("生成器：传 null 也不炸", EffectSpawnerScript.host_for(null), null)
	player.free()


func _test_player_hit_flash() -> void:
	var player := PlayerUnit.new()
	_check("玩家受击：一开始没有闪白", player._hit_flash_left, 0.0)
	player.take_damage(10.0)
	_check("玩家受击：闪白计时拉满", player._hit_flash_left, GameConfig.HIT_FLASH_TIME)
	player.tick_timers(GameConfig.HIT_FLASH_TIME * 0.5)
	_check_true("玩家受击：半程后闪白还在但更小",
			player._hit_flash_left > 0.0 and player._hit_flash_left < GameConfig.HIT_FLASH_TIME)
	player.tick_timers(GameConfig.HIT_FLASH_TIME)
	_check("玩家受击：闪白到点归零", player._hit_flash_left, 0.0)
	player.free()


func _test_enemy_hit_flash() -> void:
	var enemy := Enemy.new()
	_check("敌人受击：一开始没有闪白", enemy._hit_flash_left, 0.0)
	enemy.take_damage(10.0)
	_check("敌人受击：闪白计时拉满", enemy._hit_flash_left, GameConfig.HIT_FLASH_TIME)
	enemy._process(GameConfig.HIT_FLASH_TIME * 0.5)
	_check_true("敌人受击：半程后闪白更小",
			enemy._hit_flash_left > 0.0 and enemy._hit_flash_left < GameConfig.HIT_FLASH_TIME)
	enemy._process(GameConfig.HIT_FLASH_TIME)
	_check("敌人受击：闪白到点归零", enemy._hit_flash_left, 0.0)
	enemy.free()


## 12.7.4 轻微屏幕震动：受击触发、随时间归零
func _test_screen_shake() -> void:
	var camera := Camera2D.new()
	var controller := AimCameraController.new()
	_check_true("震动：一开始没有在抖", not controller.shake_active())
	_check("震动：没在抖时偏移为零", controller.advance_shake(0.1), Vector2.ZERO)
	controller.add_shake()
	_check_true("震动：受击后有在抖", controller.shake_active())
	var offset := controller.advance_shake(0.02)
	_check_true("震动：偏移不超过幅度",
			absf(offset.x) <= GameConfig.SCREEN_SHAKE_STRENGTH
			and absf(offset.y) <= GameConfig.SCREEN_SHAKE_STRENGTH)
	controller.advance_shake(GameConfig.SCREEN_SHAKE_TIME)
	_check_true("震动：到点停下", not controller.shake_active())
	_check("震动：停下后偏移为零", controller.advance_shake(0.1), Vector2.ZERO)
	camera.free(); controller.free()
