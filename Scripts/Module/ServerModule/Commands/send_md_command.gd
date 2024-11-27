#向服务器发送
extends ACommand
class_name send_md_command

func _init(md:MessageData):
	var json  = NetJson.new()
	json.Type = 10004
	json.Data.SID = Global.SelfID
	json.Data.TID = Global.TargetID
	json.Data.MSG = md.to_json()
	SparkServer.init.send(json.to_json())
	exec_finshed()
