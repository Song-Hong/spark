#好友
extends Button

var id

func init(friend_id,friend_name="",friend_message=""):
	id = friend_id
	name = str(friend_id)
	if friend_name   != null:set_friend_name(friend_name)
	if friend_message!= null:set_friend_last_message(friend_message)

#设置头像
func set_friend_head(_head):
	pass
	
#设置好友名称
func set_friend_name(friend_name):
	$Name.text = friend_name

#设置好友最新消息
func set_friend_last_message(friend_last_message):
	$LastMessage.text = friend_last_message
