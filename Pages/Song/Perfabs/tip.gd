#提示界面
extends Label

#销毁时间
var destory_time = 3

#自销毁
func _ready():
	await get_tree().create_timer(destory_time).timeout
	get_parent().remove_child(self)
