#主界面设置界面
extends AState
class_name MainPage_SettingState

#自身场景
var self_scene
#设置界面按钮组
var setting_page_button_group
#设置状态机
var setting_finite:Finite

#当前设置界面
var now_setting_page

func _init():
	#监听当流程改变时
	Process.init.process_change.connect(Callable(self,"_on_process_change"),4)
	
#初始化
func start():
	#隐藏消息界面
	Blackboard.init.get_data("Main_ChatsPage").visible = false
	self_scene = Scene.init.load_scene("MainPage_SettingPage")
	Blackboard.init.get_data("ContentArea").add_child(self_scene)
	
	#获取按钮组
	setting_page_button_group = Blackboard.init.get_data("Main_SettingPage_Group").button_group
	
	#监听页面按钮点击事件
	setting_page_button_group.pressed.connect(Callable(self,"on_setting_page_group_btn_pressed"))
	
	#创建状态机
	setting_finite = Finite.new(self)
	setting_finite.add_state("Universal",MainPage_SettingState_UniversalState.new())
	setting_finite.add_state("Cache",MainPage_SettingState_CacheState.new())
	
	#初始化设置界面
	change_setting_page("Universal")

#退出时清空注册
func exit():
	#显示消息界面
	Blackboard.init.get_data("Main_ChatsPage").visible = true
	Blackboard.init.get_data("ContentArea").remove_child(self_scene)
	#取消监听页面按钮点击事件
	setting_page_button_group.pressed.disconnect(Callable(self,"on_setting_page_group_btn_pressed"))
	#清空显示区域
	now_setting_page = null
	#清空状态机
	setting_finite.clear()

#当设置按钮点击时
func on_setting_page_group_btn_pressed(btn):
	change_setting_page(btn.name)

#切换设置界面
func change_setting_page(setting_name):
	#获取设置区域
	var content_area = Blackboard.init.get_data("Setting_Content")
	#设置当前设置名称
	content_area.find_child("NowSettingName").text = setting_name
	#加载设置场景
	var scene = Scene.init.load_scene("/prefabs/"+setting_name)
	content_area.add_child(scene)
	if now_setting_page!= null:
		content_area.remove_child(now_setting_page)
	now_setting_page = scene
	#切换状态
	setting_finite.change_state(setting_name)

#当流程切换时,清空全部
func _on_process_change():
	pass
