#动画管理
extends Node
class_name Module_Aniamtion

# 抖动
# extent 幅度 count 次数 time 每次时间间隔
func shake(item,extent = Vector2(6,0),count = 10,time = 0.02):
	var position = item.position
	var tween = get_tree().create_tween()
	for i in range(count):
		tween.tween_property(item,"position",item.position+extent,time)
		tween.tween_property(item,"position",item.position-extent,time)
	await tween.finished
	item.position = position

# 抖动
# extent 幅度 count 次数 time 每次时间间隔
func shakei(item,extent = Vector2i(6,0),count = 10,time = 0.02):
	var tween = get_tree().create_tween()
	for i in range(count):
		tween.tween_property(item,"position",item.position+extent,time)
		tween.tween_property(item,"position",item.position-extent,time)

#尺寸变化回归
#target 变化值
func scale_out_back(item,target=Vector2(1.2,1.2),time = 0.1):
	var default = item.scale
	var tween = get_tree().create_tween()
	tween.tween_property(item,"scale",target,time)
	tween.tween_property(item,"scale",default,time)
