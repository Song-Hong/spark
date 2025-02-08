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
signal search_friend_info    #10011 查询好友详细信息请求

#服务器
var server_tcp: ServerTCP
var server_http:HTTPRequest

# 初始化
func _ready():
	#创建TCP连接
	server_tcp = Server.init.create_tcps("spark", "49.235.238.251", 1728)
	server_tcp.connect("receive_data", Callable(self, "on_data_received"))
	server_tcp.connect_server()
	
	#创建http服务器
	server_http  = HTTPRequest.new()
	add_child(server_http)
	
	#创建心跳检测
	var timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = 11
	timer.timeout.connect(Callable(self,"heartbeat_detection"))
	timer.autostart = true
	add_child(timer)
	timer.start()

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
		10011: #查询好友详细信息
			search_friend_info.emit(json.Data)
		10012: #更新个人信息
			pass
		99999: #心跳检测
			on_heartbeat_received()

# 发送数据
func send(data: String):
	server_tcp.send_data(data)

#当接收到服务器数据时
func on_request_completed(_result: int,_response_code: int,_headers: PackedStringArray,_body: PackedByteArray):
	if _result != HTTPRequest.RESULT_SUCCESS:
		print("请求失败")
		return
		
	match _response_code:
		200:
			print("文件下载成功")
		404:
			print("文件未找到")
		500:
			print("服务器错误")

#接收到心跳
func on_heartbeat_received():
	Global.Heartbeat = min(Global.Heartbeat+1,3)

#心跳检测
func heartbeat_detection():
	if Global.Heartbeat <= 0:
		Tip.init.create_tip(TipTopShort.new("Disconnect from the server"))
		create_tcp_connect()
		await Core.init.get_tree().create_timer(1).timeout
		var ac = DB.init.read_core()
		send_login_command.new(ac.user_username,ac.user_password)
		login_state_receive.connect(Callable(self,"heartbeat_login_check"),4)
	Global.Heartbeat = max(Global.Heartbeat-1,0)
	#发送心跳加册
	send_heartbeat_detection_command.new()

#心跳检测登陆
func heartbeat_login_check(_data):
	if _data.S == 1: # 登陆成功
		Tip.init.create_tip(TipTopShort.new("Reconnect successfully"))
		Global.Heartbeat = 3
	else:
		Tip.init.create_tip(TipTopShort.new("Reconnect failure"))

#创建TCP连接
func create_tcp_connect():
	if server_tcp != null:
		server_tcp.receive_data.disconnect(Callable(self, "on_data_received"))
	var spark = Server.init.get_tcp("spark")
	if spark != null:
		spark.dislistener()
		Server.init.destory_tcp("spark")
	server_tcp = Server.init.create_tcps("spark", "49.235.238.251", 1728)
	server_tcp.connect("receive_data", Callable(self, "on_data_received"))
	server_tcp.connect_server()
	await Core.init.get_tree().create_timer(0.5).timeout
