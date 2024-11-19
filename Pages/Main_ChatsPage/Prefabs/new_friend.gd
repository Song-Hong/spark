#新好友界面
extends Panel

#用户id
var id

func _ready():
	$HBoxContainer/Agree.connect("pressed",Callable(self,"_on_agree_pressed"))
	$HBoxContainer/Reject.connect("pressed",Callable(self,"_on_reject_pressed"))

#退出清空订阅
func _exit_tree():
	$HBoxContainer/Agree.disconnect("pressed",Callable(self,"_on_agree_pressed"))
	$HBoxContainer/Reject.disconnect("pressed",Callable(self,"_on_reject_pressed"))

#初始化
func init(friend_id,friend_name,friend_msg):
	id = friend_id
	$Name.text = friend_name
	$Msg.text  = friend_msg

#当按钮同意按钮点击时
func _on_agree_pressed():
	if $Name.text == Song.Module.Data.Name:
		Song.Module.Tip.tip("Cannot add yourself")
		return
	
	#向服务器发送同意申请请求
	var json       = NetJson.new()
	json.Type      = 10007
	json.Data.SID  = Song.Module.Data.SelfID
	json.Data.Name = Song.Module.Data.Name
	json.Data.TID  = id
	Song.Module.Net.send(json.to_json())
	
	#更新页面
	$"../../../../../../Controller/FirendController".create_friend_item(id,$Name.text)
	
	#删除自身
	get_parent().remove_child(self)

#当拒绝按钮点击时
func _on_reject_pressed():
	get_parent().remove_child(self)
