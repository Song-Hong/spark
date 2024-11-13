#负责消息的接收和发送服务
extends Node

@export var server:Node #服务器连接
@export var receive:Node #服务器监听

#发送数据
func send(data:String):
	server.send(data)
	
