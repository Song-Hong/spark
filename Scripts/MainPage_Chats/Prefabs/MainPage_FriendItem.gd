#好友
extends Button

#当前好友id
var id
var friend_name

func init(_friend_id,_friend_name="",_friend_message=""):
	id = _friend_id
	name = str(_friend_id)
	if _friend_name   != null:set_friend_name(_friend_name)
	if _friend_message!= null:set_friend_last_message(_friend_message)

#设置头像
func set_friend_head(_head):
	pass
	
#设置好友名称
func set_friend_name(_friend_name):
	$Name.text = _friend_name
	friend_name = _friend_name

#设置好友最新消息
func set_friend_last_message(_friend_last_message):
	$LastMessage.text = _friend_last_message
