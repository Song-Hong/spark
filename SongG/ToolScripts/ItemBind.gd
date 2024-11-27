##
# type   : 负责快速添加场景中的物体到黑板上
# de_zh  : 黑板数据
# author : HongSong
# time   : 2023/12/20 15:27
##
extends IGodot

#场景加载后绑定数据到黑板上
func _ready():
	Blackboard.init.append(name,self)

#场景销毁时从黑板上擦除数据
func _exit_tree():
	Blackboard.init.del_data(name)
