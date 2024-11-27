#向服务器发送同意好友请求
extends ACommand
class_name send_agree_add_friend_command

func _init(_id):
	#向服务器发送同意申请请求
	var json       = NetJson.new()
	json.Type      = 10007
	json.Data.SID  = Global.SelfID
	json.Data.Name = Global.Name
	json.Data.TID  = _id
	SparkServer.init.send(json.to_json())
	exec_finshed()
