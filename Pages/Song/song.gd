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
	# 获取当前显示屏的索引
	var primary_screen = DisplayServer.get_primary_screen()
	var resolution     = DisplayServer.screen_get_size(primary_screen)
	var scale_size     =  Vector2(resolution.x,resolution.y)/Vector2(1920,1080)
	window_scale       = scale_size
	#设置根节点内容的缩放比例
	get_tree().root.content_scale_factor = window_scale.x
	
	## 初始化加载场景
	$View.add_child(StartPage.instantiate())

#窗口缩放尺寸
var window_scale = 1

#设置屏幕尺寸
func set_window_size(h,w):
	get_window().size = Vector2(h,w) * window_scale
