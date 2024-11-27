extends Node
class_name IServer

var host:String #服务器地址
var port:int    #端口

func _init(_host,_port):
	host = _host
	port = _port
