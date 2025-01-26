#更新用户详细信息
extends ACommand
class_name send_user_info_command

#ID:用户ID;Name:名称;Avatar:头像;Date:日期;Tag:标签;Sex:性别;Address:邮箱
func _init(_ID,_Name=null,_Avatar=null):
	var json          = NetJson.new()
	json.Type         = 10012
	json.Data.ID      = _ID
	json.Data.Name    = _Name
	json.Data.Avatar  = _Avatar
	json.Data.Date    = null
	json.Data.Tag     = null
	json.Data.Sex     = null
	json.Data.Address = null
	SparkServer.init.send(json.to_json())
	exec_finshed()
