#emoji界面
extends MarginContainer

#按钮组
@export var button_group:ButtonGroup

#初始化
func _ready():
	button_group.pressed.connect(Callable(self,"on_btn_pressed"))
	#Blackboard.init.get_data("ContentArea").gui_input.connect(Callable(self,"on_gui_input"))
	gui_input.connect(Callable(self,"on_gui_input"))
	 
#当退出场景时
func _exit_tree():
	button_group.pressed.disconnect(Callable(self,"on_btn_pressed"))
	#Blackboard.init.get_data("ContentArea").gui_input.disconnect(Callable(self,"on_gui_input"))
	gui_input.disconnect(Callable(self,"on_gui_input"))

#当按钮点击时
func on_btn_pressed(btn):
	#创建数据
	var md = MessageData.Emoji(btn.name)
	#创建消息气泡
	create_chat_item_command.new(md)
	#更新最后消息
	update_friend_last_message_command.new(Global.TargetID,"[表情]")
	#存储当前消息
	DB.init.save_md(Global.TargetID,md)
	#发送消息
	send_md_command.new(md)
	#滚动消息
	await Core.init.get_tree().create_timer(0.1).timeout
	chats_area_scroll_bar_lowest_command.new()

func on_gui_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		get_parent().remove_child(self)
