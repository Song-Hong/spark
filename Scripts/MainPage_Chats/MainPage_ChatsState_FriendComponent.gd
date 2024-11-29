#主界面消息状态好友管理
extends AComponent
class_name MainPage_ChatsState_FriendComponent

var friend_area  #好友显示区域
var button_group #按钮组

#初始化
func start():
	#获取创建好友列表区域
	friend_area  = Blackboard.init.get_data("FriendArea")
	#获取好友列表点击组
	button_group = Blackboard.init.get_data("FriendAreaButtonGroup").button_group
	
	#监听好友列表点击事件
	button_group.connect("pressed",Callable(self,"on_frined_item_pressed"))
	
	#向服务器发送获取好友请求
	SparkServer.init.friend_list_receive.connect(Callable(self,"on_friend_list_recive"),4)
	get_friend_list_command.new().start()
	
	#监听服务器新好友请求
	SparkServer.init.friend_add_receive.connect(Callable(self,"on_friend_add_receive"))
	#监听服务器新好友同意
	SparkServer.init.friend_agree_receive.connect(Callable(self,"on_friend_agree_receive"))
	
	#监听服务器新消息
	SparkServer.init.friend_msg_receive.connect(Callable(self,"on_friend_msg_receive"))

#结束时断开全部连接
func exit():
	button_group.disconnect("pressed",Callable(self,"on_frined_item_pressed"))
	#取消监听好友消息
	SparkServer.init.friend_msg_receive.disconnect(Callable(self,"on_friend_msg_receive"))
	#取消监听服务器新好友请求
	SparkServer.init.friend_add_receive.disconnect(Callable(self,"on_friend_add_receive"))
	#取消监听服务器新好友同意
	SparkServer.init.friend_agree_receive.disconnect(Callable(self,"on_friend_agree_receive"))

#当接收到好友列表请求
func on_friend_list_recive(friends):
	#创建全部好友列表
	for friend in friends:
		create_friend_item(friend.id,friend.Name)
		
		#更新离线消息
		if friend.Msg != "" or friend.Msg != null  or friend.Msg != "null":
			var msg_str = '{"msgs":[%s]}'%str(friend.Msg).trim_suffix(",")
			var json = JSON.new()
			var error = json.parse(msg_str)
			if error != OK:continue
			for chat in json.data.msgs:
				var server_md = MessageData.static_parsing(chat)
				server_md.own = false #设置为对方发送
				#检测接收到的消息类型
				if server_md.type > 1:
					var save_path = DB.init.NowUserPath+"/"+str(friend.id)+"/"+server_md.data
					download_file_from_server_command.new(
					server_md.data,
					save_path)
					server_md.data = save_path
				#存储至本地
				DB.init.save_off_line_md(friend.id,server_md)
			
		# 从本地更新好友的最新消息
		var last_md  = DB.init.read_today_last_md(friend.id)
		var last_msg = format_receive_md(last_md)
		update_friend_last_message_command.new(friend.id,last_msg)

#当接收到好友消息
func on_friend_msg_receive(_data):
	var friend = friend_area.get_node_or_null(str(_data.SID))
	if friend == null: return
	#解析消息
	var md     = MessageData.static_parsing(_data.MSG)
	var msg    = format_receive_md(md)
	friend.set_friend_last_message(msg)
	#检测消息类型,当类型不为纯文本消息时,从服务器下载资源
	if md.type > 1:
		await Core.init.get_tree().create_timer(0.3).timeout
		var save_path = DB.init.NowUserPath+"/"+str(_data.SID)+"/"+md.data
		download_file_from_server_command.new(
		md.data,
		save_path)
		md.data = save_path
	#存储到本地
	md.own = false
	DB.init.save_md(_data.SID,md)

#接收到好友申请请求
func on_friend_add_receive(_data):
	create_new_friend_item(_data.SID,_data.Name,_data.MSG)

#接收到新好友同意申请请求
func on_friend_agree_receive(_data):
	create_friend_item(_data.SID,_data.Name)

#创建好友
func create_friend_item(friend_id,friend_name):
	var friend_item = Scene.init.load_scene("/prefabs/friend_item")
	friend_item.init(friend_id,friend_name)
	friend_item.button_group = button_group
	friend_area.add_child(friend_item)

#当好友列表点击时
func on_frined_item_pressed(btn):
	Global.set_target_id(btn.id)

#创建新好友申请
func create_new_friend_item(friend_id,friend_name,friend_msg):
	var friend = Scene.init.load_scene("/prefabs/new_friend")
	friend_area.add_child(friend)
	friend.init(friend_id,friend_name,friend_msg)
	friend.move_to_front()

#格式化接收到的消息
func format_receive_md(md:MessageData)->String:
	if md == null:return ""
	var msg = ""
	match str(md.type):
		'0': #消息
			msg = md.data
		'1':
			msg = "[表情]"
		'2':
			msg = "[图片]"
		'3':
			msg = "[语音]"
		'4':
			msg = "[文件]"
		'5':
			msg = "[链接]"
	return msg
