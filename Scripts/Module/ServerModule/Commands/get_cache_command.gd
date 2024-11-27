#获取缓存消息
extends ACommand
class_name get_cache_command

func _init():
	var json     = NetJson.new()
	json.Type    = 10010
	json.Data.ID = Global.SelfID
	SparkServer.init.send(json.to_json())
	exec_finshed()
