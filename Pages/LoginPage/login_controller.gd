#登陆管理
extends Node

func _ready():
	$"../..".LoginBtn.connect("pressed",Callable(self,"login_request"))
	Song.Module.Net.receive.connect("login_state_receive",Callable(self,"_on_login_state_receive"))
	
	#当已登陆时将自动登陆
	await get_tree().create_timer(0.02).timeout
	if Song.Module.Config.logined:
		$"../..".Username.text = Song.Module.Config.user_username
		$"../..".Password.text = Song.Module.Config.user_password
		login_request()

#退出清空订阅
func _exit_tree():
	$"../..".LoginBtn.disconnect("pressed",Callable(self,"login_request"))
	Song.Module.Net.receive.disconnect("login_state_receive",Callable(self,"_on_login_state_receive"))

#点击登陆按钮时
func login_request():
	var username = $"../..".Username.text
	var password = $"../..".Password.text
	if username == "" or username == null:
		Song.Module.Tip.tip("The username cannot be empty")
		return
	if password == "" or password == null:
		Song.Module.Tip.tip("The password cannot be empty")
		return
	var json    = NetJson.new()
	json.Type   = 10001
	json.Data.U = username
	json.Data.P = password
	#向服务器发送登陆请求
	Song.Module.Net.send(json.to_json())

#当获取到登陆请求回馈
func _on_login_state_receive(data):
	if data.S == 1: #登陆成功
		#将当前登陆ID存储至数据中
		Song.Module.Data.SelfID = data.ID
		Song.Module.Data.Name = data.Name
		
		#更新用户
		Song.Module.Data.update_firend_cache_path(str(data.ID))
		
		#设置并存储配置文件
		Song.Module.Config.logined = true
		Song.Module.Config.user_username = $"../..".Username.text
		Song.Module.Config.user_password = $"../..".Password.text
		Song.Module.Data.save_core()
		
		#切换场景至主场景
		var view  = $"../..".get_parent()
		var scene = load("res://Pages/MainPage/MainPage.tscn").instantiate()
		view.add_child(scene)
		view.remove_child($"../..")
	else:           #登陆失败
		Song.Module.Tip.tip("The account or password is incorrect")

#检测回车按钮点击
func _process(_delta):
	if Input.is_action_just_released("ui_text_submit"):       #发送 enter
		login_request()
