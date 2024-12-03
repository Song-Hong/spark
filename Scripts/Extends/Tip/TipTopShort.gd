# 顶部短提示
extends ITip
class_name TipTopShort

#初始化
func _init(_content: String):
	#初始化场景
	scene = preload("res://Scripts/Extends/Tip/TipTopShort.tscn").instantiate()
	
	#添加文本
	scene.text = _content
	
	#设置关闭时间
	close_time = 3

#显示动画
func showAnimation(tween: Tween):
	var area = Blackboard.init.get_data("Tips")
	var wnd = area.get_window().size
	var target = Vector2(wnd.x / 2 - scene.size.x / 2, scene.size.y)
	scene.position = Vector2(target.x, -100)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 10), 0.16)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 8), 0.12)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 6), 0.08)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 4), 0.06)
	tween.tween_property(scene, "position", Vector2(target.x, target.y + 3), 0.04)
	tween.tween_property(scene, "position", Vector2(target.x, target.y - 2), 0.02)
	tween.tween_property(scene, "position", target, 0.02)

#销毁动画
func destoryAnimation(tween:Tween)->Tween:
	tween.tween_property(scene, "position", Vector2(scene.position.x, -100), 0.3)
	return tween
