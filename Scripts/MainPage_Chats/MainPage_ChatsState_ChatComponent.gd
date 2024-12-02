# 消息管理
extends AComponent
class_name MainPage_ChatsState_ChatComponent

var MessageInput:TextEdit #文本输入组件
var ChatContentArea:VBoxContainer#聊天消息添加区域
var ChatContentScroll:ScrollContainer#文本显示区域

#初始化
func start():
	#初始化
	MessageInput = Blackboard.init.get_data("MessageInput")
	ChatContentArea = Blackboard.init.get_data("ChatContentArea")
	ChatContentScroll = Blackboard.init.get_data("ChatContentScroll")
	
	#监听当接收到好友消息时
	SparkServer.init.friend_msg_receive.connect(Callable(self,"_on_friend_msg_receive"))
	#监听当聊天对象切换时
	Global.target_id_change.connect(Callable(self,"on_target_change"))
	#监听输入框输入输入事件
	MessageInput.connect("gui_input",Callable(self,"_on_message_input_event"))

#取消订阅
func exit():
	MessageInput.disconnect("gui_input",Callable(self,"_on_message_input_event"))
	SparkServer.init.friend_msg_receive.disconnect(Callable(self,"_on_friend_msg_receive"))
	Global.target_id_change.disconnect(Callable(self,"on_target_change"))

#聊天消息事件
func _on_message_input_event(_event):
	if Input.is_action_just_released("ui_text_line_feed"): #换行 shift + enter
		print("shift + enter")
		MessageInput.text+="\n"
		MessageInput.set_caret_line(MessageInput.get_line_count())
	elif Input.is_action_just_released("ui_text_submit"):       #发送 enter
		#格式化消息
		var msg_text = MessageInput.text.trim_suffix("\n")
		#格式化消息类型
		var md:MessageData
		if is_url(msg_text):
			md = MessageData.Link(msg_text)
		else:
			md = MessageData.Text(msg_text)
		#创建气泡,清空消息区
		create_item(md)
		MessageInput.clear()
		#滚动滚轮
		scroll_bar_lowest()
		#发送消息
		send_md_command.new(md)
		#更新最后消息
		update_friend_last_message_command.new(Global.TargetID,msg_text)
		#存储至本地
		DB.init.save_md(Global.TargetID,md)

#当从网络接收到好友消息时
func _on_friend_msg_receive(_data):
	if _data.TID != Global.SelfID:return
	var md = MessageData.static_parsing(_data.MSG) #解析消息
	md.own = false #将消息设置为对方发送
	if md.type != 0:
		create_item(md,true) #创建消息气泡
		return
	create_item(md) #创建消息气泡
	scroll_bar_lowest() #滚动消息

#当聊天对象切换时
func on_target_change(_id):
	#显示聊天窗口
	Blackboard.init.get_data("ChatPanel").visible = true
	#清空全部消息
	clear_all_text()
	#从本地加载聊天消息
	for md in DB.init.read_md_today(_id):
		md = md as MessageData
		create_item(md)
	scroll_bar_lowest()

#滚动至最底部
func scroll_bar_lowest():
	#await Process.init.get_tree().process_frame
	await Process.init.get_tree().create_timer(0.1).timeout
	ChatContentScroll.get_v_scroll_bar().ratio = 1

#创建item
func create_item(md:MessageData,wait_load = false):
	var item = null
	match str(md.type):
		'0': #文本消息
			item = Scene.init.load_scene("/prefabs/chat_item")
			item.text = md.data
		'1':
			item = Scene.init.load_scene("/prefabs/emoji_item")
			item.init(md.data)
		'2': #图片消息
			if wait_load:
				item = Scene.init.load_scene("/prefabs/img_item")
				item.img_path  = DB.init.NowUserPath+"/"+str(Global.TargetID)+"/"+md.data
				item.wait_load_img()
			elif FileAccess.file_exists(md.data):
				item = Scene.init.load_scene("/prefabs/img_item")
				item.set_img_from_file(md.data)
			else:
				item = Scene.init.load_scene("/prefabs/chat_item")
				item.text = "[图片丢失]"
		'3': #语音消息
			item = Scene.init.load_scene("/prefabs/voice_item")
			item.init(md.data)
		'4': #文件消息
			item = Scene.init.load_scene("/prefabs/file_item")
			item.init(md.data)
		'5': #链接消息
			item = Scene.init.load_scene("/prefabs/link_item")
			item.init(md.data)
	if item == null:return
	#将气泡添加至场景
	ChatContentArea.add_child(item)
	#设置气泡的位置
	if md.own:
		item.size_flags_horizontal = Control.SIZE_SHRINK_END
	else:
		item.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN

# 清空全部消息
func clear_all_text():
	for item in ChatContentArea.get_children():
		ChatContentArea.remove_child(item)

#region 消息类型格式化
func is_url(message: String) -> bool:
	# 定义 URL 的正则表达式
	var url_pattern = r"^(https?:\/\/)?([\w\-]+\.)+[a-z]{2,6}(:\d+)?(\/\S*)?$"
	var regex = RegEx.new()
	regex.compile(url_pattern)
	# 检查消息是否匹配 URL 格式
	return regex.search(message) != null
#endregion
