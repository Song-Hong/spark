#托盘控制管理
extends Node

#准备
func _ready():
	$"../..".LeftTrayMode.connect("pressed",Callable(self,"_on_pressed"))

#退出清空订阅
func _exit_tree():
	$"../..".LeftTrayMode.disconnect("pressed",Callable(self,"_on_pressed"))

#当托盘按钮点击时
func _on_pressed(btn):
	match btn.name:
		"Exit":
			#向服务器发送退出登陆
			var json     = NetJson.new()
			json.Type    = 10009
			json.Data.ID = Song.Module.Data.SelfID
			Song.Module.Net.send(json.to_json())
			
			#切换场景
			var view  = $"../..".get_parent()
			var scene = load("res://Pages/LoginPage/LoginPage.tscn").instantiate()
			view.add_child(scene)
			view.remove_child($"../..")
		"Chats":
			print("Chats")
