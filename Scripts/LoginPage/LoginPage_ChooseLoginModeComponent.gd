# 选择登陆场景模式
extends AComponent
class_name LoginPage_ChooseLoginModeComponent

# 初始化
func start():
	Blackboard.init.get_data("ModeGroup").button_group.connect("pressed", Callable(self, "on_login_mode_selected"))
	
# 组件退出时
func exit():
	Blackboard.init.get_data("ModeGroup").button_group.disconnect("pressed", Callable(self, "on_login_mode_selected"))

# 登陆模式切换
func on_login_mode_selected(btn):
	match btn.name:
		"Login":
			Blackboard.init.get_data("LoginPanel").visible = true
			Blackboard.init.get_data("SigninPanel").visible = false
		"Signin":
			Blackboard.init.get_data("LoginPanel").visible = false
			Blackboard.init.get_data("SigninPanel").visible = true
