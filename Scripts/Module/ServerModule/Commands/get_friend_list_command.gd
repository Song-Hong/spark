#10003 获取好友列表
extends ACommand
class_name get_friend_list_command

func start():
	var json     = NetJson.new()
	json.Type    = 10003
	json.Data.ID = Global.SelfID
	SparkServer.init.send(json.to_json())
	exec_finshed()
