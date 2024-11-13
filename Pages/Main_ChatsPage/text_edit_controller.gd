extends Node

var TextInput:TextEdit #文本输入组件
var TextArea:VBoxContainer#聊天消息添加区域
var TextView:ScrollContainer#文本显示区域
var Net:Node #网络服务器

func _ready():
	TextInput = $"../..".TextInput
	TextArea  = $"../..".TextArea
	TextView  = $"../..".TextView
	Net       = $"../../../../../..".Net
	TextInput.connect("gui_input",Callable(self,"_on_text_edit_gui_input"))
	Net.server.connect("receive_data",Callable(self,"_on_receive_message"))

#输入文本的UI事件
func _on_text_edit_gui_input(event):
	if Input.is_action_just_released("ui_text_line_feed"): #换行 shift + enter
		TextInput.text+="\n"
		TextInput.set_caret_line(TextInput.get_line_count())
	elif Input.is_action_just_released("ui_accept"):       #发送 enter
		## 生成消息气泡,并清空输入区
		var msg_text = TextInput.text
		create_msg_bubble(msg_text)
		TextInput.clear()
		
		## 滚动滚轮
		scroll_bar_lowest()
		
		##发送消息
		Net.server.send(msg_text)

#当接收到消息
func _on_receive_message(msg):
	create_msg_bubble(msg,false)
	scroll_bar_lowest()

#生成消息气泡
func create_msg_bubble(text,is_self = true):
	var chatItem = load("res://Prefabs/chat_item.tscn").instantiate()
	if is_self:
		chatItem.size_flags_horizontal = Control.SIZE_SHRINK_END
	else:
		chatItem.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	chatItem.text = text
	TextArea.add_child(chatItem)

#滚动滑轮至最底部
func scroll_bar_lowest():
	await get_tree().process_frame
	TextView.get_v_scroll_bar().ratio = 1
