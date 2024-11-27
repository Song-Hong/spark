#############################################
# de_zh  : 
# de_en  : 
# author : Song
# time   : 2023/10/31 18:16
#############################################
extends IServer
class_name ServerTCP

#信号
signal receive_data #当接受到消息时
signal disconnect   #当从服务器断开时

#服务器
var client:StreamPeerTCP

#是否连接成功
var isconnect=false #是否连接

func connect_server():
	client = StreamPeerTCP.new()
	if client.connect_to_host(host,port)==OK:
		isconnect = true
		Server.init.update.connect(Callable(self,"listener"))

func send_data(data:String):
	client.poll()
	client.put_data(data.to_utf8_buffer())

func on_receive_data():
	var count = client.get_available_bytes()
	if count > 0:
		var data = client.get_data(count)
		var _temp_bytes:PackedByteArray
		_temp_bytes.append_array(data[1])
		var s = _temp_bytes.get_string_from_utf8()
		receive_data.emit(s)

func listener():
	client.poll()
	var status = client.get_status()
	if status == client.STATUS_CONNECTING || status == client.STATUS_CONNECTED:
		on_receive_data()
	else:
		dislistener()

#尝试重新连接
func try_connect():
	pass

#断开连接
func dislistener():
	isconnect = false
	client.disconnect_from_host()
	disconnect.emit()
