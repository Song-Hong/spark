#负责消息的与网路的接收和发送
extends Node

var Net:Module_Net #网络服务器

func _ready():
	Net = Song.Module.Net
	Net.receive.connect("friend_msg_receive",Callable(self,"_on_friend_msg_receive"))
	Net.receive.connect("friend_add_receive",Callable(self,"_on_friend_add_receive"))
	Net.receive.connect("friend_agree_receive",Callable(self,"_on_friend_agree_receive"))

#退出清空订阅
func _exit_tree():
	Net.receive.disconnect("friend_msg_receive",Callable(self,"_on_friend_msg_receive"))
	Net.receive.disconnect("friend_add_receive",Callable(self,"_on_friend_add_receive"))
	Net.receive.disconnect("friend_agree_receive",Callable(self,"_on_friend_agree_receive"))

#发送消息
func send_messgae(text):
	if Song.Module.Data.TargetID  == 0:return #纠错,防止目标ID为空
	
	#格式化消息
	var md = MessageData.new().init(str(text).trim_suffix("\n"))
	
	#发送消息
	var json      = NetJson.new()
	json.Type     = 10004
	json.Data.SID = Song.Module.Data.SelfID
	json.Data.TID = Song.Module.Data.TargetID
	json.Data.MSG = md.to_json()
	Net.send(json.to_json())
	
	#存储消息
	Song.Module.Data.save_msg(Song.Module.Data.TargetID,md) 

#接收消息
func _on_friend_msg_receive(data):

	#格式化消息
	var md = MessageData.new().parsing(data.MSG)
	
	#判断消息是否是当前聊天的对象
	if data.SID == Song.Module.Data.TargetID:
		$"../TextEditController"._on_friend_msg_receive(md.data)
	
	#存储消息
	md.own = false
	Song.Module.Data.save_msg(data.SID,md) #存储消息
	
	#更新好友界面消息
	$"../FirendController".update_friend_last_message(data.SID,md.data)

#接收到好友申请请求
func _on_friend_add_receive(data):
	#data.TID
	$"../FirendController".new_friend_msg(data.SID,data.Name,data.MSG)

#接收到新好友同意申请请求
func _on_friend_agree_receive(data):
	$"../FirendController".create_friend_item(data.SID,data.Name)
