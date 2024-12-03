extends AComponent
class_name LoginPage_SigninComponent

# 初始化
func start():
	Blackboard.init.get_data("SigninPanel_Signin").pressed.connect(Callable(self,"_on_pressed"))
	#监听注册请求
	SparkServer.init.singin_state_receive.connect(Callable(self,"_on_singin_state_receive"))

# 组件退出时,断开连接
func exit():
	Blackboard.init.get_data("SigninPanel_Signin").pressed.disconnect(Callable(self,"_on_pressed"))
	SparkServer.init.singin_state_receive.disconnect(Callable(self,"_on_singin_state_receive"))

#当按钮点击时
func _on_pressed():
	#获取输入值
	var new_name = Blackboard.init.get_data("SigninPanel_Name").text
	var username = Blackboard.init.get_data("SigninPanel_Username").text
	var password = Blackboard.init.get_data("SigninPanel_Password").text
	
	#用户名检测
	if new_name == "" or new_name.length()<1:
		Tip.init.create_tip(TipTopShort.new("The name cannot be empty"))
		shake(Blackboard.init.get_data("SigninPanel_Name"))
		return
	elif new_name.length() < 4:
		Tip.init.create_tip(TipTopShort.new("Name number must be greater than 4 digits"))
		shake(Blackboard.init.get_data("SigninPanel_Name"))
		return
	
	#账号检测
	if username == "":
		Tip.init.create_tip(TipTopShort.new("The username cannot be empty"))
		shake(Blackboard.init.get_data("SigninPanel_Username"))
		return
	elif username.length() < 8:
		Tip.init.create_tip(TipTopShort.new("Username number must be greater than 8 digits"))
		shake(Blackboard.init.get_data("SigninPanel_Username"))
		return
	
	#密码检测
	if password == "":
		Tip.init.create_tip(TipTopShort.new("The password cannot be empty"))
		shake(Blackboard.init.get_data("SigninPanel_Password"))
		return
	elif password.length() < 8:
		Tip.init.create_tip(TipTopShort.new("Password number must be greater than 8 digits"))
		shake(Blackboard.init.get_data("SigninPanel_Password"))
		return
	
	#向服务器发送注册请求
	send_signin_command.new(username,password,new_name)

func _on_singin_state_receive(_data):
	#S:是否注册成功;ID:用户ID(只会在注册成功时返回)
	if _data.S == 1: #注册成功
		Global.SelfID = _data.ID
		Global.Name   = Blackboard.init.get_data("SigninPanel_Name").text
		
		#更新用户
		DB.init.set_user(_data.ID)
		
		#设置并存储配置文件
		var app_config = DB.init.read_core()
		app_config.logined = true
		app_config.user_username = Blackboard.init.get_data("SigninPanel_Username").text
		app_config.user_password = Blackboard.init.get_data("SigninPanel_Password").text
		DB.init.save_core(app_config)
		
		#切换场景
		Process.init.change_process(MainPageProcess.new())
	else:
		Tip.init.create_tip(TipTopShort.new("Account duplication"))
		Wnd.init.Jitter()

## TODO 单独列为模块
func shake(item,extent = Vector2(6,0),count = 10,time = 0.02):
	var position = item.position
	var tween = Core.init.get_tree().create_tween()
	for i in range(count):
		tween.tween_property(item,"position",item.position+extent,time)
		tween.tween_property(item,"position",item.position-extent,time)
	await tween.finished
	item.position = position
