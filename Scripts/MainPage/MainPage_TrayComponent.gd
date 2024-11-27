#左侧托盘管理
extends AComponent
class_name MainPage_TrayComponent

#初始化
func start():
	Blackboard.init.get_data("TrayButtonGroup").button_group.connect("pressed",Callable(self,"_on_tray_pressed"))
	Blackboard.init.set_blackboard_data("MainPage","now_tray_state","Chats")

#退出时清空订阅
func exit():
	Blackboard.init.get_data("TrayButtonGroup").button_group.disconnect("pressed",Callable(self,"_on_tray_pressed"))

#当托盘按钮点击时
func _on_tray_pressed(btn):
	if btn.name == Blackboard.init.get_blackboard_data("MainPage","now_tray_state"):return
	Blackboard.init.get_blackboard_data("MainPage","mainPageContents").change_state(btn.name)
	Blackboard.init.set_blackboard_data("MainPage","now_tray_state",btn.name)
