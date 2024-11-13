#模式选择控制
extends Node

#初始化
func _ready():
	$"../..".ChooseMode.connect("pressed",Callable(self,"mode_change"))

#模式切换
func mode_change(btn):
	print(btn.name)
	pass
