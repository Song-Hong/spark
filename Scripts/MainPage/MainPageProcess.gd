# 主场景流程
extends AProcess
class_name MainPageProcess

# 流程开始
func start():
	# 设置窗口尺寸
	Wnd.init.set_size(Vector2(1152,648))
	
	# 创建当前场景黑板
	Blackboard.init.set_blackboard("MainPage",BlackboardData.new())
	
	# 加载场景
	Scene.init.add_scene("MainPage")
	
	# 状态机
	var mainPageContents = Finite.new(self)
	Blackboard.init.set_blackboard_data("MainPage","mainPageContents",mainPageContents)
	mainPageContents.add_state("Chats",MainPage_ChatsState.new()) # 添加消息界面
	mainPageContents.add_state("Setting",MainPage_SettingState.new()) # 添加设置界面
	mainPageContents.add_state("Exit",MainPage_ExitState.new()) # 添加退出按钮点击
	mainPageContents.start("Chats")
	
	# 组件
	Blackboard.init.set_blackboard_data("MainPage","mainPageComponent",
		ComponentArray.Q("MainPage",[
		MainPage_TrayComponent.new() #托盘管理
	]))

# 流程结束
func exit():
	#清空状态机
	Blackboard.init.get_blackboard_data("MainPage","mainPageContents").clear()
	#清空组件
	Blackboard.init.get_blackboard_data("MainPage","mainPageComponent").clear()
	#删除当前黑板
	Blackboard.init.del_blackboard("MainPage")
	#移除当前场景
	Scene.init.remove_scene("MainPage")