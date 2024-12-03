# 登陆界面控制
extends AComponent
class_name LoginPage_LoginComponent

# 初始化
func start():
	Blackboard.init.get_data("LoginPanel_Login").connect("pressed", Callable(self, "on_login_btn_pressed"))
	SparkServer.init.login_state_receive.connect(Callable(self, "on_login_state_receive"))
	
	#检查是否登陆,如登陆则直接登陆
	await Core.init.get_tree().create_timer(0.5).timeout
	var ac = DB.init.read_core()
	if ac.logined:
		Blackboard.init.get_data("LoginPanel_Username").text = ac.user_username
		Blackboard.init.get_data("LoginPanel_Password").text = ac.user_password
		on_login_btn_pressed()

# 组件退出时,断开连接
func exit():
	Blackboard.init.get_data("LoginPanel_Login").disconnect("pressed", Callable(self, "on_login_btn_pressed"))
	SparkServer.init.login_state_receive.disconnect(Callable(self, "on_login_state_receive"))

# 登陆按钮点击
func on_login_btn_pressed():
	# 获取用户名和密码
	var username = Blackboard.init.get_data("LoginPanel_Username").text
	var password = Blackboard.init.get_data("LoginPanel_Password").text

	# 判断用户名和密码是否为空
	if username == "" or username == null:
		Tip.init.create_tip(TipTopShort.new("The username cannot be empty"))
		return
	if password == "" or password == null:
		Tip.init.create_tip(TipTopShort.new("The password cannot be empty"))
		return

	# 向服务器发送登陆请求
	send_login_command.new(username,password)

# 登陆状态接收
func on_login_state_receive(_data):
	if _data.S == 1: # 登陆成功
		#将当前登陆ID存储至数据中
		Global.SelfID = _data.ID
		Global.Name = _data.Name
		
		#更新用户
		DB.init.set_user(_data.ID)
		
		#设置并存储配置文件
		var app_config = DB.init.read_core()
		app_config.logined = true
		app_config.user_username = Blackboard.init.get_data("LoginPanel_Username").text
		app_config.user_password = Blackboard.init.get_data("LoginPanel_Password").text
		DB.init.save_core(app_config)
		
		#切换场景至主场景
		Process.init.change_process(MainPageProcess.new())

	else: # 登陆失败
		Tip.init.create_tip(TipTopShort.new("The account or password is incorrect"))
