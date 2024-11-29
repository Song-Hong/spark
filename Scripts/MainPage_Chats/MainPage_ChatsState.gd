#消息界面
extends AState
class_name MainPage_ChatsState

#聊天消息组件集
var chat_state_components:ComponentArray

#初始化
func _init():
	#监听当流程改变时
	Process.init.process_change.connect(Callable(self,"_on_process_change"),4)
	
	#聊天界面组件
	chat_state_components = ComponentArray.Q("MainPage_ChatsState",[
		MainPage_ChatsState_FriendComponent.new(), #好友管理
		MainPage_ChatsState_ChatComponent.new(),   #消息管理
		MainPage_ChatsState_SearchComponent.new(), #搜索管理
		MainPage_ChatsState_FileComponent.new()
	])
	
	#Emoji按钮点击
	Blackboard.init.get_data("MainChat_Emoji_Button").pressed.connect(Callable(self,"on_main_chat_emoji_button"))

#当显示聊天窗口时
func start():
	Blackboard.init.set_data("enable chat page",true)

#当关闭聊天窗口时
func exit():
	Blackboard.init.set_data("enable chat page",false)

#当流程切换时,清空全部
func _on_process_change():
	Blackboard.init.get_data("MainChat_Emoji_Button").pressed.disconnect(Callable(self,"on_main_chat_emoji_button"))
	chat_state_components.clear()
	Blackboard.init.del_data("enable chat page")

#当表情按钮点击时
func on_main_chat_emoji_button():
	var scene = Scene.init.load_scene("/prefabs/emoji_panel")
	var chat_panel = Blackboard.init.get_data("ChatPanel")
	chat_panel.add_child(scene)
