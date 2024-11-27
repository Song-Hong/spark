#更新好友列表最后一条消息
extends ACommand
class_name update_friend_last_message_command

#初始化
func _init(_id,_msg):
	var friend_area = Blackboard.init.get_data("FriendArea")
	if friend_area != null:
		var friend = friend_area.get_node_or_null(str(_id))
		if friend != null:
			friend.set_friend_last_message(_msg)
	exec_finshed()
