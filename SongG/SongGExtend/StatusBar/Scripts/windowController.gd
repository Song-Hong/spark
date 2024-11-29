extends Button

#按钮类
enum Button_Type{
	QUIT,
	MIN,
	MAX
}
@export var btn_type:Button_Type

func _ready():
	match btn_type:
		Button_Type.QUIT : connect("button_down",Callable(self,"quitApp"))
		Button_Type.MIN  : connect("button_down",Callable(self,"minApp"))
		Button_Type.MAX  : connect("button_down",Callable(self,"maxApp"))
	connect("mouse_entered",Callable(self,"on_mouse_entered"))
	connect("mouse_exited",Callable(self,"on_mouse_exited"))

#当鼠标移动到当前节点时
func on_mouse_entered():
	for btn in get_parent().get_children():
		btn = btn as Button
		btn.add_theme_stylebox_override("normal",btn.get_theme_stylebox("hover"))

#当鼠标离开当前节点时
func on_mouse_exited():
	for btn in get_parent().get_children():
		btn = btn as Button
		btn.add_theme_stylebox_override("normal",btn.get_theme_stylebox("pressed"))

#退出软件
func quitApp():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

#最小化app
func minApp():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, false)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MINIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)

#最大化app
func maxApp():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#当窗口失去焦点时
func _notification(what): 
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT: 
		disabled = true
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		disabled = false
