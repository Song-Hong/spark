#登陆场景
extends Node

@export var ChooseMode:ButtonGroup #选择的登陆模式
@export var Username:LineEdit      #账号
@export var Password:LineEdit      #密码
@export var LoginBtn:Button        #登陆按钮

#初始化
func _ready():
	get_window().size = Vector2(600,400)
