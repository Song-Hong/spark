#网络服务
extends IModule
class_name Server
static var init:Server
func _init():init=self

#信号
signal update

############################################
# 主体
#初始化
func _ready():
	pass

#每帧更新
func _process(_delta):
	update.emit()

#当退出app时
func on_exit_app():
	pass

############################################
# Tcp服务器
var tcps:Dictionary

#获取tcp服务器
func get_tcp(tcp_name:String)->ServerTCP:
	if !tcps.has(tcp_name): 
		return null
	return tcps[tcp_name]

#发送数据
func send_data(tcp_name:String,data:String):
	if !tcps.has(tcp_name): 
		return null
	tcps[tcp_name].send_data(data)

#创建tcp服务器
func create_tcps(tcp_name:String,host:String,port:int)->ServerTCP:
	if !tcps.has(tcp_name):
		tcps[tcp_name] = ServerTCP.new(host,port)
	return tcps[tcp_name]

#删除tcp服务器
func destory_tcp(tcp_name:String)->bool:
	if !tcps.has(tcp_name): 
		return true
	tcps[tcp_name].dislistener()
	tcps.erase(tcp_name)
	return true

############################################
# http服务器
var https:Dictionary

#获取http服务器
func get_http(http_name:String)->ServerMoudle_HTTP:
	if!tcps.has(http_name): 
		return null
	return tcps[http_name]

#创建http服务器
func create_http(http_name:String,host:String,port:int)->ServerMoudle_HTTP:
	if!https.has(http_name):
		https[http_name] = ServerMoudle_HTTP.new(host,port)
	return https[http_name]

#创建http get请求
func http_get(http_name:String,url:String,callback:Callable):
	if!https.has(http_name): 
		return null
	https[http_name].GET(url,callback)

#创建http post请求
func http_post(http_name:String,url:String,data,callback:Callable):
	if!https.has(http_name): 
		return null
	https[http_name].POST(url,data,callback)

#创建一次性的GET请求
func GET(host:String,port:int,url:String,callback:Callable)->ServerMoudle_HTTP:
	var http_server = ServerMoudle_HTTP.new(host,port)
	http_server.GET(url,callback)
	return http_server

#创建一次性的GET URL请求
func GET_URL(url:String,callback:Callable)->ServerMoudle_HTTP:
	var http_server = ServerMoudle_HTTP.new("",0)
	http_server.GET_URL(url,callback)
	return http_server

#创建一次性的GET URL请求来获取图片
func GET_URL_IMG(url:String,callback:Callable):
	var http_server = ServerMoudle_HTTP.new("",0)
	http_server.GET_URL_IMG(url,callback)
	return http_server

#创建一次性的POST请求
func POST(host:String,port:int,url:String,data,callback:Callable)->ServerMoudle_HTTP:
	var http_server = ServerMoudle_HTTP.new(host,port)
	http_server.POST(url,data,callback)
	return http_server
