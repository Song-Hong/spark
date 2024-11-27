#向服务器发送登陆请求
extends ACommand
class_name send_login_command

func _init(_username,_password):
	var json = NetJson.new()
	json.Type = 10001
	json.Data.U = _username
	json.Data.P = _password
	SparkServer.init.send(json.to_json())
