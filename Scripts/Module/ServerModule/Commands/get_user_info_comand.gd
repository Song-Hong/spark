#更新用户详细信息
extends ACommand
class_name get_user_info_command

#ID:用户ID
func _init(_ID):
	var json         = NetJson.new()
	json.Type        = 10011
	json.Data.ID     = _ID
	SparkServer.init.send(json.to_json())
	exec_finshed()
