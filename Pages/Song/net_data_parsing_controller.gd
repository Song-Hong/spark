#数据解析
extends Node
class_name Module_Net_Receive

signal login_state_receive   #登陆状态请求
signal friend_list_receive   #好友列表请求
signal friend_msg_receive    #接收到好友消息
signal friend_add_receive    #10006 接收到好友申请
signal friend_agree_receive  #10007 接收到同意好友请求
signal friend_search_receive #10008 好友搜索请求

func _ready():
	#消息接收监听
	$"../NetConnectionController".connect("receive_data",Callable(self,"_on_receive_data"))

#退出时断开全部订阅
func _exit_tree():
	$"../NetConnectionController".disconnect("receive_data",Callable(self,"_on_receive_data"))

#消息接收
func _on_receive_data(data):
	print("接收到数据: "+data)
	var json = JSON.parse_string(data) #解析接收到的消息
	var type = json.Type #消息类型
	match int(type):
		10001: #登陆请求
			login_state_receive.emit(json.Data)
		10002: #注册请求
			pass
		10003: #好友列表查询
			friend_list_receive.emit(json.Data)
		10004: #发送消息
			pass
		10005: #接收消息
			friend_msg_receive.emit(json.Data)
		10006: #接收好友申请
			friend_add_receive.emit(json.Data)
		10007: #同意好友申请
			friend_agree_receive.emit(json.Data)
		10008: #好友查询反馈
			friend_search_receive.emit(json.Data)
