#搜索界面
extends AComponent
class_name MainPage_ChatsState_SearchComponent

#搜索按钮
var search_btn
#搜索框输入
var search_input 
#搜索结果显示区域
var search_area

func start():
	search_btn = Blackboard.init.get_data("MainPageSearch")
	search_btn.pressed.connect(Callable(self,"on_search_btn_pressed"))

#退出
func exit():
	search_btn.pressed.disconnect(Callable(self,"on_search_btn_pressed"))

#当搜索按钮点击时
func on_search_btn_pressed():
	search_btn.visible = false
	var search_panel = Scene.init.add_scene("MainPage_Search")
	#监听当搜索按钮点击时
	search_panel.pressed.connect(Callable(self,"on_search_panel_pressed"),4)
	
	#获取输入框
	search_input = search_panel.find_child("SearchInput")
	#获取结果显示区域
	search_area = search_panel.find_child("SearchArea")
	#订阅输入框提交事件
	search_input.connect("text_submitted",Callable(self,"_on_text_submitted"))
	#给予输入框焦点
	search_input.grab_focus()
	#订阅搜索结果
	SparkServer.init.friend_search_receive.connect(Callable(self,"on_search_receive"))


#当输入框提交时
func _on_text_submitted(text):
	#清除搜索框内容
	search_input.clear()
	#清除搜索结果显示区域
	clear_search_area()
	#提交搜索结果
	get_friend_info_command.new(text)

#当获取到搜索结果
func on_search_receive(_data):
	for item in _data:
		#创建好友列表
		create_person_card(item.id,item.name,item.username)

#创建好友卡片
func create_person_card(_id,_name,_username):
	var person_card = Scene.init.load_scene("/prefabs/person_card")
	search_area.add_child(person_card)
	person_card.init(_id,_name,_username)
	person_card.name = str(_id)

#当搜索界面点击时
func on_search_panel_pressed():
	#显示搜索按钮
	search_btn.visible = true
	#取消订阅搜索框提交事件
	search_input.disconnect("text_submitted",Callable(self,"_on_text_submitted"))
	#取消订阅搜索接收
	SparkServer.init.friend_search_receive.disconnect(Callable(self,"on_search_receive"))
	#删除搜索场景
	Scene.init.remove_scene("MainPage_Search")

#清空搜索结果界面
func clear_search_area():
	for item in search_area.get_children():
		search_area.remove_child(item)
