#负责消息的与网路的接收和发送
extends Node

var Net:Module_Net #网络服务器

func _ready():
	Net = Song.Module.Net
	Net.receive.connect("friend_msg_receive",Callable(self,"_on_friend_msg_receive"))

#发送消息
func send_messgae(text):
	var tid  = Song.Module.Data.TargetID
	if tid  == 0:return #纠错,防止目标ID为空
	var sid  = Song.Module.Data.SelfID
	var json = '{"App"  : "Spark","Type" : 10004,"Data" : {'
	json    += '"SID":'  + str(sid)
	json    += ',"TID":' + str(tid)
	json    += ',"MSG":"' + str(text).trim_suffix("\n")
	json    += '"}}'
	Net.send(json)

#接收消息
func _on_friend_msg_receive(data):
	#判断消息是否是当前聊天的对象
	if data.SID == Song.Module.Data.TargetID:
		$"../TextEditController"._on_friend_msg_receive(data.MSG)
	else: #不是更新好友界面UI
		pass
	$"../FirendController".update_friend_last_message(data.SID,data.MSG)

## TEST 退出场景时断开全部监听
func _exit_tree():
	Net.receive.disconnect("friend_msg_receive",Callable(self,"_on_friend_msg_receive"))
