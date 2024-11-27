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
	
	#检查是否已添加
	var friend_area = Blackboard.init.get_data("FriendArea")
	if friend_area != null:
		var friend = friend_area.get_node_or_null(str(id))
		if friend != null:
			_on_reject_pressed()
	if id == Global.SelfID:
		_on_reject_pressed()

#当按钮同意按钮点击时
func _on_agree_pressed():
	if id == Global.SelfID:
		Tip.init.create_tip(TipShort.new(TipShort.PO.TOP,"Cannot add yourself"))
		return
	
	#向服务器发送同意申请请求
	send_agree_add_friend_command.new(id)
	
	#更新页面
	create_frient_item_command.new(id,$Name.text)
	
	#删除自身
	get_parent().remove_child(self)

#当拒绝按钮点击时
func _on_reject_pressed():
	get_parent().remove_child(self)
