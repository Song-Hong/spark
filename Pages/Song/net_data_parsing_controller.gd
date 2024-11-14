#数据解析
extends Node
class_name Module_Net_Receive

signal login_state_receive #登陆状态请求
signal friend_list_receive #好友列表请求
signal friend_msg_receive  #接收到好友消息

func _ready():
	#消息接收监听
	$"../NetConnectionController".connect("receive_data",Callable(self,"_on_receive_data"))

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
