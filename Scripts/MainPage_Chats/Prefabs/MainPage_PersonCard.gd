#好友卡片
extends Panel

#用户ID
var id

#初始化
func init(person_id,person_name,person_username):
	id             = person_id
	$Name.text     = person_name
	$Username.text = person_username
	if Blackboard.init.get_data("FriendArea").get_node_or_null(str(id)) != null:
		$Message.visible = false
		$Button.text = "Added"
		$Button.disabled = true
	elif id == Global.SelfID:
		$Message.visible = false
		$Button.text = "Self"
		$Button.disabled = true
	
#初始化
func _ready():
	$Button.connect("pressed",Callable(self,"_on_pressed"))

#退出时取消订阅
func _exit_tree():
	$Button.disconnect("pressed",Callable(self,"_on_pressed"))

#当按钮点击时
func _on_pressed():
	if $Name.text == Global.Name:
		Tip.init.create_tip(TipShort.new(TipShort.PO.TOP,"Cannot add yourself"))
		return
	
	## 发送好友申请请求
	send_add_friend_command.new(id,$Message.text)
	
	## 显示提示
	Tip.init.create_tip(TipShort.new(TipShort.PO.TOP,"Sent request"))
	
	## 销毁自己
	get_parent().remove_child(self)
