# 登陆场景流程
extends AProcess
class_name LoginPageProcess

var components:ComponentArray

# 流程开始
func start():
	#设置窗口尺寸
	Wnd.init.set_size(Vector2(800,500))
	
	# 加载场景
	Scene.init.add_scene("LoginPage")
	
	#添加组件
	components = ComponentArray.Q("LoginPageComponents", [
		LoginPage_ChooseLoginModeComponent.new(), # 模式选择
		LoginPage_LoginComponent.new(), # 登陆
		LoginPage_SigninComponent.new() # 注册
	])

# 流程结束
func exit():
	components.clear()
	components.free()
	Scene.init.remove_scene("LoginPage")
