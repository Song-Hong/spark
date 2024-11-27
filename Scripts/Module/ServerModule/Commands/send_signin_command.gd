#发送注册请求
extends ACommand
class_name send_signin_command

func _init(_username,_password,_new_name):
	var json     = NetJson.new()
	json.Type    = 10002
	json.Data.U  = _username
	json.Data.P  = _password
	json.Data.N  = _new_name
	SparkServer.init.send(json.to_json())
	exec_finshed()
