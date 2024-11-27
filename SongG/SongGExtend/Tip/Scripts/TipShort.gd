# 短提示
extends ITip
class_name TipShort

enum PO {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	TOPLEFT,
	TOPRIGHT,
	BOTTOMLEFT,
	BOTTOMRIGHT
}
var po: PO

var icon: TextureRect # 图标
var content: Label # 内容

func _init(_po: PO, _content: String, _icon = null, _close_time = 3):
	#初始化场景
	scene = preload("res://SongG/SongGExtend/Tip/Scenes/TipShort.tscn").instantiate()
	
	#获取图标,内容
	icon = scene.get_child(0)
	content = scene.get_child(1)
	
	#为变量赋值
	icon = _icon
	content.text = _content
	close_time = _close_time
	po = _po

#显示动画
func showAnimation(tween: Tween):
	if !icon:
		content.size = scene.size
		content.position = Vector2.ZERO
	match po:
		PO.TOP: top(tween)
		PO.BOTTOM: bottom(tween)
		PO.LEFT: left(tween)
		PO.RIGHT: right(tween)
		PO.TOPLEFT: top_left(tween)
		PO.TOPRIGHT: top_right(tween)
		PO.BOTTOMLEFT: bottom_left(tween)
		PO.BOTTOMRIGHT: bottom_right(tween)

#顶部中
func top(tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(wnd.x / 2 - scene.size.x / 2, scene.size.y)
	up2down(tween, wnd, target)

#底部中
func bottom(tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(wnd.x / 2 - scene.size.x / 2, wnd.y - scene.size.y - 10)
	down2up(tween, wnd, target)

#左侧中
func left(tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(10, wnd.y / 2 - scene.size.y / 2)
	scene.position = Vector2(-100, target.y)
	tween.tween_property(scene, "position", Vector2(target.x + 10, target.y), 0.18)
	tween.tween_property(scene, "position", Vector2(target.x - 8, target.y), 0.14)
	tween.tween_property(scene, "position", Vector2(target.x + 6, target.y), 0.1)
	tween.tween_property(scene, "position", Vector2(target.x - 4, target.y), 0.08)
	tween.tween_property(scene, "position", Vector2(target.x + 3, target.y), 0.04)
	tween.tween_property(scene, "position", Vector2(target.x - 2, target.y), 0.02)
	tween.tween_property(scene, "position", target, 0.02)


func right(tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(wnd.x - scene.size.x - 10, wnd.y / 2 - scene.size.y / 2)
	scene.position = Vector2(wnd.x + 100, target.y)
	tween.tween_property(scene, "position", Vector2(target.x - 10, target.y), 0.18)
	tween.tween_property(scene, "position", Vector2(target.x + 8, target.y), 0.14)
	tween.tween_property(scene, "position", Vector2(target.x - 6, target.y), 0.1)
	tween.tween_property(scene, "position", Vector2(target.x + 4, target.y), 0.08)
	tween.tween_property(scene, "position", Vector2(target.x - 3, target.y), 0.04)
	tween.tween_property(scene, "position", Vector2(target.x + 2, target.y), 0.02)
	tween.tween_property(scene, "position", target, 0.02)

func top_left(tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(10, scene.size.y)
	up2down(tween, wnd, target)

func top_right(tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(wnd.x - scene.size.x - 10, scene.size.y)
	up2down(tween, wnd, target)

func bottom_left(tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(10, wnd.y - scene.size.y - 10)
	down2up(tween, wnd, target)

func bottom_right(tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(wnd.x - scene.size.x - 10, wnd.y - scene.size.y - 10)
	down2up(tween, wnd, target)


func up2down(tween: Tween, _wnd: Vector2, target: Vector2):
	scene.position = Vector2(target.x, -100)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 10), 0.18)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 8), 0.14)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 6), 0.1)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 4), 0.08)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 3), 0.04)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 2), 0.02)
	tween.tween_property(scene, "position", target, 0.02)

func down2up(tween: Tween, _wnd: Vector2, target: Vector2):
	scene.position = Vector2(target.x, _wnd.y + 100)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 10), 0.18)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 8), 0.14)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 6), 0.1)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 4), 0.08)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 3), 0.04)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 2), 0.02)
	tween.tween_property(scene, "position", target, 0.02)
