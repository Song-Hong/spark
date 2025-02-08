#右键菜单
extends PanelContainer

#当按键点击时
signal btn_click
#按钮组
var button_group:ButtonGroup

#初始化
func init(right_menu_items:Array):
	#检查是否存在右键
	if Global.RightMenu != null:
		Global.RightMenu.get_parent().remove_child(Global.RightMenu)
	Global.RightMenu = self
	#初始化按钮样式
	button_group = ButtonGroup.new()
	button_group.pressed.connect(Callable(self,"button_pressed"),4)
	#初始化元素
	var index = 0
	for item in right_menu_items:
		#设置横线
		if index < item.index:
			index = item.index
			var line = HSeparator.new()
			line.theme_type_variation = "HSeparator_RightMenu"
			$MarginContainer/VBoxContainer.add_child(line)
		#初始化样式
		var btn = Button.new()
		btn.name = item.text
		btn.text = item.text
		btn.add_theme_color_override("font_color",item.color)
		btn.add_theme_color_override("font_hover_color",item.color)
		btn.add_theme_color_override("font_pressed_color",item.color)
		btn.focus_mode = Control.FOCUS_NONE
		btn.theme_type_variation = "Button_RightMenu"
		#设置按钮组
		btn.toggle_mode = true
		btn.button_group = button_group
		#添加至右键
		$MarginContainer/VBoxContainer.add_child(btn)
	#设置父物体
	Blackboard.init.get_data("ViewArea").add_child(self)
	#设置位置
	set_po()

#按钮点击
func button_pressed(btn):
	btn_click.emit(btn)
	remove_self()

#设置位置
func set_po():
	var global_po = get_global_mouse_position()
	global_position = global_po

#销毁自身
func remove_self():
	Global.RightMenu = null
	get_parent().remove_child(self)
