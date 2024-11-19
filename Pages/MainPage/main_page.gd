#主界面
extends Node

## TEST
class_name Main
static var Module:Main
func _init():Module=self


@export var LeftTrayMode:ButtonGroup   #左侧托盘按钮
@export var MainPageArea:HBoxContainer #主界面页面显示区域

@export var Main_ChatsPage   :HBoxContainer #主界面聊天界面
@export var Main_SettingPage :HBoxContainer #主界面设置界面

func _ready():
	get_window().size = Vector2(1152,648)
