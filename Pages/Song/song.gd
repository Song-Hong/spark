#程序入口
extends Node
class_name Song
static var Module:Song
func _init():Module=self

## 初始场景
@export var StartPage:PackedScene #初始场景
@export var Net:Module_Net        #网络模块
@export var Data:Module_Data      #数据模块

func _ready():
	## 初始化加载场景
	$View.add_child(StartPage.instantiate())
