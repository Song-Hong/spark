#好友卡片
extends Panel

#用户ID
var id

#初始化
func init(person_id,person_name,person_username):
	id             = person_id
	$Name.text     = person_name
	$Username.text = person_username
	
#初始化
func _ready():
	$Button.connect("pressed",Callable(self,"_on_pressed"))

#当按钮点击时
func _on_pressed():
	$Button.disconnect("pressed",Callable(self,"_on_pressed"))
	
	## 发送好友申请请求
	#SID:自身ID;Name:自身名称;TID:接受者ID；MSG:验证消息
	var _sid  = str(Song.Module.Data.SelfID)
	var _name = str(Song.Module.Data.Name)
	var _tid  = str(id)
	var _msg  = $Message.text
	if _msg  == "" : _msg = "Hello"
	var json  = '{"App" : "Spark","Type" : 10006,"Data" : {'
	json     += '"SID":%s'%_sid
	json     += ',"Name":"%s"'%_name
	json     += ',"TID":%s'%_tid
	json     += ',"MSG":"%s"'%_msg
	json     += "}}"
	Song.Module.Net.send(json)
	
	## 显示提示
	
	## 销毁自己
	get_parent().remove_child(self)
