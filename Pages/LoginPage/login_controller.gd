#登陆管理
extends Node

func _ready():
	$"../..".LoginBtn.connect("pressed",Callable(self,"login_request"))
	Song.Module.Net.receive.connect("login_state_receive",Callable(self,"_on_login_state_receive"))

#退出清空订阅
func _exit_tree():
	$"../..".LoginBtn.disconnect("pressed",Callable(self,"login_request"))
	Song.Module.Net.receive.disconnect("login_state_receive",Callable(self,"_on_login_state_receive"))

#点击登陆按钮时
func login_request():
	var json    = NetJson.new()
	json.Type   = 10001
	json.Data.U = $"../..".Username.text
	json.Data.P = $"../..".Password.text
	#向服务器发送登陆请求
	Song.Module.Net.send(json.to_json())

#当获取到登陆请求回馈
func _on_login_state_receive(data):
	print(data)
	if data.S == 1: #登陆成功
		#将当前登陆ID存储至数据中
		Song.Module.Data.SelfID = data.ID
		Song.Module.Data.Name = data.Name
		
		#切换场景至主场景
		var view  = $"../..".get_parent()
		var scene = load("res://Pages/MainPage/MainPage.tscn").instantiate()
		view.add_child(scene)
		view.remove_child($"../..")
	else:           #登陆失败
		print("登陆失败")
