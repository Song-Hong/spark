#模式选择控制
extends Node

#初始化
func _ready():
	$"../..".ChooseMode.connect("pressed",Callable(self,"mode_change"))

#退出清空订阅
func _exit_tree():
	$"../..".ChooseMode.disconnect("pressed",Callable(self,"mode_change"))

#模式切换
func mode_change(btn):
	match btn.name:
		"Login":
			$"../..".LoginPnael.visible  = true
			$"../..".SigninPanel.visible = false
		"Signin":
			$"../..".LoginPnael.visible  = false
			$"../..".SigninPanel.visible = true
