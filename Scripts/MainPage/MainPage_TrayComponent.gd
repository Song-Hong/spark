#左侧托盘管理
extends AComponent
class_name MainPage_TrayComponent

#初始化
func start():
	Blackboard.init.get_data("TrayButtonGroup").button_group.connect("pressed",Callable(self,"_on_tray_pressed"))
	Blackboard.init.set_blackboard_data("MainPage","now_tray_state","Chats")
	
	#设置自身头像信息
	var img = DB.init.get_self_avatar_img()
	if img != null: #文件存在则更新本地头像
		Blackboard.init.get_data("UserAvatar").icon = img
	#else :
		##从服务器获取自身详细数据
		#SparkServer.init.search_friend_info.connect(Callable(self,"on_search_friend_info"),4)
		#get_user_info_command.new(Global.SelfID)

#退出时清空订阅
func exit():
	Blackboard.init.get_data("TrayButtonGroup").button_group.disconnect("pressed",Callable(self,"_on_tray_pressed"))

#当托盘按钮点击时
func _on_tray_pressed(btn):
	if btn.name == Blackboard.init.get_blackboard_data("MainPage","now_tray_state"):return
	Blackboard.init.get_blackboard_data("MainPage","mainPageContents").change_state(btn.name)
	Blackboard.init.set_blackboard_data("MainPage","now_tray_state",btn.name)

#当获取到自身详细数据
func on_search_friend_info(json):
	if json.Avatar == null || json.Avatar == "null" || json.Avatar == "":
		return
	var dac = download_avatar_command.new(json.Avatar,DB.init.NowUserPath+"/"+json.Avatar)
	dac.download_finished.connect(Callable(self,"load_avatar"),4)

#当头像下载结束
func load_avatar()->bool:
	await Core.init.get_tree().create_timer(0.1).timeout
	var img = DB.init.get_self_avatar_img()
	if img != null: #文件存在则更新本地头像
		Blackboard.init.get_data("UserAvatar").icon = img
		return false
	else:
		return true
