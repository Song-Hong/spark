#负责消息的接收和发送服务
extends Node

#服务器地址及端口
@export var host:String #服务器地址
@export var port:int    #端口

#信号
signal receive_data     #监听服务器接收数据

#变量
var server = StreamPeerTCP.new() #服务器

#准备
func _ready():
	server.connect_to_host(host,port)

#监听服务器数据
func _process(_delta):
	server.poll()
	var status = server.get_status()
	if status == server.STATUS_CONNECTING || status == server.STATUS_CONNECTED:
		var count = server.get_available_bytes()
		if count > 0:
			var data = server.get_data(count)
			var _temp_bytes:PackedByteArray
			_temp_bytes.append_array(data[1])
			var s = _temp_bytes.get_string_from_utf8()
			receive_data.emit(s)
			print(s)

#发送数据
func send(data:String):
	server.poll()
	server.put_data(data.to_utf8_buffer())
