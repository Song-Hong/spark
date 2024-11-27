#Song Window
#拖动窗口
extends Button

#检测鼠标是否按下
var isdown = false
#记录初始鼠标位置
var mouseDownPo

func _ready():
	connect("button_up",Callable(self,"_on_button_up"))
	connect("button_down",Callable(self,"_on_button_down"))

#当鼠标按下时候,开始窗口跟手
func _on_button_down():
	isdown = true
	mouseDownPo = get_window().get_mouse_position()
	
#当鼠标抬起时,停止窗口跟手
func _on_button_up():
	isdown = false

func _input(_event):
	if isdown:
		var winPo = get_window().position
		var Nowpo = get_window().get_mouse_position()
		winPo.x += Nowpo.x - mouseDownPo.x
		winPo.y += Nowpo.y - mouseDownPo.y
		get_window().position = winPo
