#好友界面的UI管理
extends Node

var FriendAreaButtonGroup:ButtonGroup
var FriendArea:VBoxContainer #好友列表位置

#获取好友列表
func _ready():
	#获取好友列表位置
	FriendArea = $"../..".FriendArea
	FriendAreaButtonGroup = $"../..".FriendAreaButtonGroup
	
	#获取好友列表
	var json     = NetJson.new()
	json.Type    = 10003
	json.Data.ID = Song.Module.Data.SelfID
	Song.Module.Net.send(json.to_json())
	Song.Module.Net.receive.connect("friend_list_receive",Callable(self,"_on_friend_list_receive"))
	
	#订阅好友列表点击事件
	FriendAreaButtonGroup.connect("pressed",Callable(self,"_on_friend_button_pressed"))

#退出清空订阅
func _exit_tree():
	FriendAreaButtonGroup.disconnect("pressed",Callable(self,"_on_friend_button_pressed"))

#接收到好友列表请求
func _on_friend_list_receive(data):
	Song.Module.Net.receive.disconnect("friend_list_receive",Callable(self,"_on_friend_list_receive"))
	for friend in data:
		#friend.id friend.Name friend.Msg
		# 创建好友
		create_friend_item(friend.id,friend.Name)

#创建好友
func create_friend_item(id,friend_name):
	var friend = load("res://Pages/Main_ChatsPage/Prefabs/friend_item.tscn").instantiate()
	FriendArea.add_child(friend)
	friend.init(id,friend_name)
	friend.button_group = FriendAreaButtonGroup

#好友列表按钮点击
func _on_friend_button_pressed(btn):
	Song.Module.Data.TargetID = btn.id
	$"../..".ChatPanel.visible = true

#更新好友最后消息
func update_friend_last_message(id,msg):
	var friend = FriendArea.get_node_or_null(str(id))
	if friend != null:
		friend.set_friend_last_message(msg)

#新好友消息
func new_friend_msg(friend_id,friend_name,friend_msg):
	var friend = load("res://Pages/Main_ChatsPage/Prefabs/new_friend.tscn").instantiate()
	FriendArea.add_child(friend)
	friend.init(friend_id,friend_name,friend_msg)
	friend.move_to_front()
