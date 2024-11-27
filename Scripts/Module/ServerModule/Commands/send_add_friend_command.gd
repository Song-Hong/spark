#发送添加好友命令
extends ACommand
class_name send_add_friend_command

func _init(_id,_msg):
	var json       = NetJson.new()
	json.Type      = 10006
	json.Data.SID  = Global.SelfID
	json.Data.Name = Global.Name
	json.Data.TID  = _id
	json.Data.MSG  = _msg
	SparkServer.init.send(json.to_json())
	exec_finshed()
