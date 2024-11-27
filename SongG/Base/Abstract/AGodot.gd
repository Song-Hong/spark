##
# type   : 抽象类
# de_zh  : IGodot的抽象表现,方便初始化自动添加黑板
# author : HongSong
# time   : 2023/12/20 13:00
##
extends IGodot
class_name AGodot
func name():return ""

#初始化提交到黑板
func _init():
	Blackboard.init.set_data(name(),self)
