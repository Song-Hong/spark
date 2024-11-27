#清除全部好友的最后消息
extends ACommand
class_name clear_all_friend_last_msg_command

func _init():
	var friend_area  = Blackboard.init.get_data("FriendArea")
	if friend_area == null:return
	for item in friend_area.get_children():
		item.set_friend_last_message("")
	exec_finshed()
