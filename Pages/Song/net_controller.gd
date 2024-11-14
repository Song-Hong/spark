#负责消息的接收和发送服务
extends Node
class_name Module_Net

@export var server:Module_Net_Server   #服务器连接
@export var receive:Module_Net_Receive #服务器监听

#发送数据
func send(data:String):
	server.send(data)
	
