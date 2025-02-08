#右键菜单元素
extends Node

#右键菜单元素
class_name right_menu_item

var text:String = ""           #文字
var color:Color = Color.BLACK  #颜色
var index:int   = 0
	
func _init(_text,_color,_index = 0):      #初始化
	text  = _text
	color = _color
	index = _index
