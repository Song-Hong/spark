#设置界面_缓存
extends AState
class_name MainPage_SettingState_CacheState

#缓存清理按钮
var cache_clear_btn

#初始化
func start():
	cache_clear_btn = Blackboard.init.get_data("Cache_Clear_Btn")
	cache_clear_btn.pressed.connect(Callable(self,"on_pressed"))
	

#退出时清空订阅
func exit():
	cache_clear_btn.pressed.disconnect(Callable(self,"on_pressed"))

#当清理按钮点击时
func on_pressed():
	#清除缓存
	Tip.init.create_tip(TipShort.new(TipShort.PO.TOP,"Cleared"))
	var dir_path = DB.init.NowUserPath
	DB.init.delete_folder_contents(dir_path,dir_path)
	#清除全部好友的最后消息
	clear_all_friend_last_msg_command.new()
	#清除当前聊天消息
	clear_now_chats_command.new()
