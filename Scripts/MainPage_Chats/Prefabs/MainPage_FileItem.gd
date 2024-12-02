#文件消息
extends Button

#文件路径
var file_path:String

#初始化
func init(_file_path):
	_file_path = str(_file_path)
	if _file_path.begins_with("["):
		var index = _file_path.find("]")
		var file_name = _file_path.substr(0,index)
		file_name = file_name.replace("[","")
		text = file_name
		_file_path = _file_path.replace("[%s]"%file_name,"")
	else:
		text = ""
	if _file_path.contains("user://"):
		_file_path = ProjectSettings.globalize_path(_file_path)
	file_path = _file_path

#准备
func _ready():
	pressed.connect(Callable(self,"on_pressed"))

#退出场景时
func _exit_tree():
	pressed.disconnect(Callable(self,"on_pressed"))

#当按钮点击时
func on_pressed():
	OS.shell_open(file_path)
