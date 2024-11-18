#提示模块
extends Node
class_name Module_Tip

@export var TipPanel:PackedScene

func _ready():
	pass

#普通提示
func tip(msg):
	create_Tip(msg)

#警告提示
func warring():
	pass
	
#创建提示
func create_Tip(msg):
	var _tip  = TipPanel.instantiate()
	_tip.text = msg
	$"../../View".add_child(_tip)
