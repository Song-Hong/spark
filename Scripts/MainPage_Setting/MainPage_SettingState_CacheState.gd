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
	Tip.init.create_tip(TipShort.new(TipShort.PO.TOP,"Cleared"))
	var dir_path = DB.init.NowUserPath
	DB.init.delete_folder_contents(dir_path,dir_path)
