#############################################
# de_zh  : 
# de_en  : 
# author : Song
# time   : 2023/11/04 18:58
#############################################
extends IModule
class_name Tip
static var init:Tip
func _init():init = self

signal update

var area

func _process(delta):
	update.emit(delta)

func create_tip(tip:ITip):
	if !area:
		area = Blackboard.init.get_data("Tips")
	tip.init()
	tip.showTip()
	tip.connect("destory",Callable(self,"on_destory"))
	area.add_child(tip.scene)
	tip.showAnimation(get_tree().create_tween())

func destory(tip:ITip):
	await tip.destoryAnimation(get_tree().create_tween()).finished
	area.remove_child(tip.scene)
