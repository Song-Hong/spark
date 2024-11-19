#聊天文件
extends PanelContainer

var rootfolder #根目录

#初始化
func _ready():
	$MarginContainer/Clear.connect("pressed",Callable(self,"_on_pressed"))

#当按钮点击时
func _on_pressed():
	rootfolder = Song.Module.Data.get_friend_cache_path()
	delete_folder_contents(rootfolder)
	
	# 清除所有好友最后发送的消息
	Main.Module.Main_ChatsPage.clear_all_friend_last_message()
	# 清除当前聊天的全部消息
	Main.Module.Main_ChatsPage.clear_all_text()

#删除全部文件夹
func delete_folder_contents(folder_path):
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name!= "":
			var file_path = folder_path + "/" + file_name
			if dir.current_is_dir():
				# 如果是文件夹，递归删除
				delete_folder_contents(file_path)
			else:
				# 如果是文件，直接删除
				dir.remove(file_path)
			file_name = dir.get_next()
		dir.list_dir_end()
		#dir.free()
		# 删除空文件夹（自身）
		if folder_path == rootfolder: return
		dir.remove(folder_path)
	else:
		print("无法打开文件夹: ", folder_path)
