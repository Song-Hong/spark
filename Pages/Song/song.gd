#程序入口
extends Node
class_name Song
static var Module:Song
func _init():Module=self

## 初始场景
@export var StartPage:PackedScene       #初始场景
@export var Net:Module_Net              #网络模块
@export var Data:Module_Data            #数据模块
@export var Tip:Module_Tip              #提示模块
@export var AnimationU:Module_Aniamtion #动画模块

var Config:AppConfig                    #软件配置

func _ready():
	## 初始化加载场景
	$View.add_child(StartPage.instantiate())
