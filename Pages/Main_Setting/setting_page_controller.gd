#设置界面页面管理
extends Node

var now_show_page_name = "Universal"

func _ready():
	$"../..".SettingPageBtns.connect("pressed",Callable(self,"_on_pressed"))

#当按钮点击时
func _on_pressed(btn):
	if now_show_page_name == btn.name:return
	match btn.name:
		"Universal":
			$"../..".Universal.visible = true
			$"../..".Cache.visible     = false
		"Cache":
			$"../..".Universal.visible = false
			$"../..".Cache.visible     = true
	now_show_page_name = btn.name
