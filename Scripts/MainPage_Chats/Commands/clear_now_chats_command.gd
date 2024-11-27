#清除当前聊天界面全部消息
extends ACommand
class_name clear_now_chats_command

func _init():
	var ChatContentArea = Blackboard.init.get_data("ChatContentArea")
	if ChatContentArea == null:return
	for item in ChatContentArea.get_children():
		ChatContentArea.remove_child(item)
	exec_finshed()
