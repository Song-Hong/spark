##
# type   : 模块
# de_zh  : 核型模块,负责管理全部模块
# author : HongSong
# time   : 2023/12/20 15:48
##
extends IModule
class_name Core
static var init: Core
func _init(): init = self

#更新信号
signal update

#软件的入口
func _ready():
	Process.init.change_process(SongGProcess.new())

#更新
func _process(delta):
	update.emit(delta)

# 添加自定义模块
func add_CustomModule(Module: IModule):
	Blackboard.init.get_data("CustomModule").add_child(Module)
