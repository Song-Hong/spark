#向服务器发送心跳检测
extends ACommand
class_name send_heartbeat_detection_command

func _init():
	var json  = NetJson.new()
	json.Type = 99999
	json.Data.ID = Global.SelfID
	SparkServer.init.send(json.to_json())
	exec_finshed()
