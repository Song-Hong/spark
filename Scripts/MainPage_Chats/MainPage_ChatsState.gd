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
		MainPage_ChatsState_SearchComponent.new()  #搜索管理
	])

#当流程切换时,清空全部
func _on_process_change():
	chat_state_components.clear()
