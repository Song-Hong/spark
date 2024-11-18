#注册管理
extends Node

#初始化
func _ready():
	$"../..".SigninLoginBtn.connect("pressed",Callable(self,"_on_pressed"))
	Song.Module.Net.receive.connect("singin_state_receive",Callable(self,"_on_singin_state_receive"))

#退出时清除订阅
func _exit_tree():
	$"../..".SigninLoginBtn.disconnect("pressed",Callable(self,"_on_pressed"))
	Song.Module.Net.receive.disconnect("singin_state_receive",Callable(self,"_on_singin_state_receive"))

#当按钮点击时
func _on_pressed():
	#获取输入值
	var new_name = str($"../..".SigninName.text)
	var username = str($"../..".SigninUsername.text)
	var password = str($"../..".SigninPassword.text)
	
	print("注册")
	#用户名检测
	if new_name == "" or new_name.length()<1:
		Song.Module.Tip.tip("The name cannot be empty")
		Song.Module.AnimationU.shake($"../..".SigninName)
		return
	elif new_name.length() < 4:
		Song.Module.Tip.tip("Name number must be greater than 4 digits")
		Song.Module.AnimationU.shake($"../..".SigninName)
		return
	
	#账号检测
	if username == "":
		Song.Module.Tip.tip("The username cannot be empty")
		Song.Module.AnimationU.shake($"../..".SigninUsername)
		return
	elif username.length() < 8:
		Song.Module.Tip.tip("Username number must be greater than 8 digits")
		Song.Module.AnimationU.shake($"../..".SigninUsername)
		return
	
	if password == "":
		Song.Module.Tip.tip("The password cannot be empty")
		Song.Module.AnimationU.shake($"../..".SigninPassword)
		return
	elif password.length() < 8:
		Song.Module.Tip.tip("Password number must be greater than 8 digits")
		Song.Module.AnimationU.shake($"../..".SigninPassword)
		return
	
	#向服务器发送注册请求
	var json     = NetJson.new()
	json.Type    = 10002
	json.Data.U  = username
	json.Data.P  = password
	json.Data.N  = new_name
	Song.Module.Net.send(json.to_json())

func _on_singin_state_receive(data):
	#S:是否注册成功;ID:用户ID(只会在注册成功时返回)
	if data.S == 1: #注册成功
		Song.Module.Data.SelfID = data.ID
		Song.Module.Data.Name   = $"../..".SigninName.text
		
		#更新用户
		Song.Module.Data.update_firend_cache_path(str(data.ID))
		
		#切换场景
		var view  = $"../..".get_parent()
		var scene = load("res://Pages/MainPage/MainPage.tscn").instantiate()
		view.add_child(scene)
		view.remove_child($"../..")
	else:
		Song.Module.Tip.tip("Account duplication")
		Song.Module.AnimationU.shakei(get_window())
