#好友
extends Button

#当前好友id
var id
var friend_name
#未读数量
var unread_count = 0

#初始化动画
func _ready():
	#动画准备
	pivot_offset = size/2
	scale        = Vector2.ZERO
	modulate     = Color(1,1,1,0)
	
	#订阅右键事件
	gui_input.connect(Callable(self,"on_gui_input"))
	
	#播放动画
	var tween = create_tween()
	tween.parallel()
	tween.tween_property(self,"modulate", Color(1,1,1,1),0.31)
	tween.tween_property(self,"scale",Vector2.ONE,0.31)

func init(_friend_id,_friend_name="",_friend_message=""):
	id = _friend_id
	name = str(_friend_id)
	if _friend_name   != null:set_friend_name(_friend_name)
	if _friend_message!= null:set_friend_last_message(_friend_message)

#设置头像
func set_friend_head(_head):
	$Head.texture = _head
	
#设置好友名称
func set_friend_name(_friend_name):
	$Name.text = _friend_name
	friend_name = _friend_name

#设置好友最新消息
func set_friend_last_message(_friend_last_message):
	$LastMessage.text = _friend_last_message

#设置好友最新消息是否已读
func set_friend_message_read_state(state:bool,_unread_count = 1):
	if !state : 
		_unread_count = 0
	$MessageState.visible = state
	unread_count = _unread_count
	$MessageState/Label.text = str(unread_count)

#当鼠标右键点击时
func on_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var right_menu = Scene.init.load_scene("prefabs/RightMenu")
		right_menu.btn_click.connect(Callable(self,"button_pressed"),4)
		right_menu.init([
			#right_menu_item.new("Pinned",Color.BLACK),
			right_menu_item.new("Mark as unread",Color.BLACK),
			#right_menu_item.new("Do not show",Color.BLACK,1)
		])

#当按钮点击时
func button_pressed(btn):
	match btn.name:
		"Mark as unread":
			set_friend_message_read_state(true,1)
