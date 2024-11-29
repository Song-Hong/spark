#文件导入管理
extends AComponent
class_name MainPage_ChatsState_FileComponent

#初始化
func start():
	#监听文件拖动
	Core.init.get_tree().root.files_dropped.connect(Callable(self,"on_file_dropped"))

func exit():
	#取消监听 文件拖动
	Core.init.get_tree().root.files_dropped.disconnect(Callable(self,"on_file_dropped"))

#当文件拖动导入
func on_file_dropped(paths):
	if Global.TargetID == 0:return
	if !Blackboard.init.get_data("enable chat page"):return
	for path in paths:
		#创建消息类型
		var md:MessageData
		var last_msg = ""
		#设置类型
		var file_type = path.get_extension()
		if file_type in ["svg","png","jpg","jepg"]:
			md = MessageData.Img(path)
			last_msg = "[图片]"
		else:
			md = MessageData.File(path)
			last_msg = "[文件]"
		#生成存储文件位置
		var save_path = DB.init.NowUserPath+"/"+md.gen_only_id()+"."+file_type
		md.data = save_path
		#将文件缓存到缓存文件夹中
		DB.init.copy_file(path,save_path)
		#向服务器发送图片
		upload_file_to_server_command.new(save_path)
		#创建消息气泡
		create_chat_item_command.new(md)
		#更新最后消息
		update_friend_last_message_command.new(Global.TargetID,last_msg)
		#存储当前消息
		DB.init.save_md(Global.TargetID,md)
		#发送消息
		md.data = md.gen_only_id()+"."+file_type
		send_md_command.new(md)
		#滚动消息
		await Core.init.get_tree().create_timer(0.1).timeout
		chats_area_scroll_bar_lowest_command.new()
