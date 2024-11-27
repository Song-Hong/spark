#创建好友列表好友
extends ACommand
class_name create_frient_item_command

func _init(friend_id,friend_name):
	var friend_item = Scene.init.load_scene("/prefabs/friend_item")
	friend_item.init(friend_id,friend_name)
	friend_item.button_group = Blackboard.init.get_data("FriendAreaButtonGroup").button_group
	Blackboard.init.get_data("FriendArea").add_child(friend_item)
	exec_finshed()
