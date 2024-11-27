#获取好友信息
extends ACommand
class_name get_friend_info_command

#初始化
func _init(_text):
	var json    = NetJson.new()
	json.Type   = 10008
	json.Data.U = _text
	SparkServer.init.send(json.to_json())
	exec_finshed()
