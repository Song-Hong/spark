# Spark服务器
extends IModule
class_name SparkServer
static var init: SparkServer
func _init(): init = self

signal login_state_receive   #10001 登陆状态请求
signal singin_state_receive  #10002 注册状态请求
signal friend_list_receive   #10003 好友列表请求
signal friend_msg_receive    #10005 接收到好友消息
signal friend_add_receive    #10006 接收到好友申请
signal friend_agree_receive  #10007 接收到同意好友请求
signal friend_search_receive #10008 好友搜索请求
signal self_cache_receive    #10010 缓存消息请求

#服务器
var server_tcp: ServerTCP

# 初始化
func _ready():
	#创建TCP连接
	server_tcp = Server.init.create_tcps("spark", "60.204.140.223", 1728)
	server_tcp.connect("receive_data", Callable(self, "on_data_received"))
	server_tcp.connect_server()

# 数据接收
func on_data_received(data: String):
	var try_json = JSON.new()
	var error = try_json.parse(data)
	if error != OK:return
	var json = try_json.data #解析接收到的消息
	if !json.has("Type") : return
	var type = json.Type #消息类型
	match int(type):
		10001: #登陆请求
			login_state_receive.emit(json.Data)
		10002: #注册请求
			singin_state_receive.emit(json.Data)
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
		10009: #退出登陆
			pass
		10010: #查询缓存消息
			self_cache_receive.emit(json.Data)

# 发送数据
func send(data: String):
	server_tcp.send_data(data)
