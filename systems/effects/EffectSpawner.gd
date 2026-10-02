extends RefCounted

## 表现层特效的生成入口（候选 M · 12.7.3 枪口火光 / 12.7.4 命中特效）。
##
## 统一负责「把一次性特效挂到场景里」这件事，调用方只管传坐标：
##   · 没有场景时（单元测试里的 Player / Enemy 是裸 new 的）→ 返回 null，不报错、不崩；
##   · 挂载点取 current_scene（Enemy 画曳光也是这么找的），没有就退到 tree.root。
##
## 为什么不让 Main 管：Main 的 ≤400 行是硬验收线（第三十三版结束时 397 行），
## 开枪的人（Player / Enemy / VehicleController）自己按坐标放特效，Main 一行都不用加。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const MuzzleFlashScript := preload("res://entities/effects/MuzzleFlash.gd")
const ImpactFxScript := preload("res://entities/effects/ImpactFx.gd")
const WreckSmokeScript := preload("res://entities/effects/WreckSmoke.gd")

## 命中类型（与 ImpactFx.Kind 同值；这里再列一遍是为了让调用方不必 preload ImpactFx）
const IMPACT_GROUND := 0
const IMPACT_UNIT := 1
const IMPACT_COVER := 2


static func host_for(node: Node) -> Node:
	if node == null or not is_instance_valid(node) or not node.is_inside_tree():
		return null
	var tree := node.get_tree()
	if tree == null:
		return null
	if tree.current_scene != null:
		return tree.current_scene
	return tree.root


## 枪口火光（scale 给载具主炮这类大口径用）
static func muzzle_at(node: Node, origin: Vector2, direction: Vector2, scale: float = 1.0):
	var host := host_for(node)
	if host == null:
		return null
	var fx = MuzzleFlashScript.new()
	host.add_child(fx)
	fx.setup(origin, direction, scale)
	return fx


## 残骸冒烟（12.7.2 毁伤表现）：挂在残骸**自己身上** —— 残骸不会再移动，
## 跟着它走最省事，也不会像一次性特效那样被场景清理掉。已经在冒烟就复用。
static func wreck_smoke_on(node: Node, radius: float = -1.0):
	if node == null or not is_instance_valid(node) or not node.is_inside_tree():
		return null
	var existing := node.get_node_or_null("WreckSmoke")
	if existing != null:
		return existing
	var smoke = WreckSmokeScript.new()
	smoke.name = "WreckSmoke"
	node.add_child(smoke)
	smoke.setup(radius)
	return smoke


## 命中特效
static func impact_at(node: Node, point: Vector2, kind: int = IMPACT_GROUND):
	var host := host_for(node)
	if host == null:
		return null
	var fx = ImpactFxScript.new()
	host.add_child(fx)
	fx.setup(point, kind)
	return fx
