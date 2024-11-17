#登陆场景
extends Node

@export var ChooseMode:ButtonGroup      #选择的登陆模式

@export var LoginPnael:MarginContainer  #登陆界面
@export var Username:LineEdit           #账号
@export var Password:LineEdit           #密码
@export var LoginBtn:Button             #登陆按钮

@export var SigninPanel:MarginContainer #注册界面
@export var SigninName:LineEdit         #名称
@export var SigninUsername:LineEdit     #账号
@export var SigninPassword:LineEdit     #密码
@export var SigninLoginBtn:Button       #登陆按钮

#初始化
func _ready():
	get_window().size = Vector2(800,500)
