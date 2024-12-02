#链接消息
extends Button

#文件路径
var url:String

#初始化
func init(_url_path):
	url = _url_path
	text = url

#准备
func _ready():
	pressed.connect(Callable(self,"on_pressed"))

#退出场景时
func _exit_tree():
	pressed.disconnect(Callable(self,"on_pressed"))

#当按钮点击时
func on_pressed():
	OS.shell_open(url)
