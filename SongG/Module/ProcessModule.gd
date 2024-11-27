##
# type   : 模块
# de_zh  : 流程管理模块
# author : HongSong
# time   : 2023/12/20 15:33
##
extends IModule
class_name Process
static var init:Process
func _init():init = self

#当流程切换时
signal process_change

#当前流程
var now_process:AProcess

#切换流程
func change_process(process:AProcess):
	process_change.emit()
	if now_process != null:
		now_process.exit()
	now_process = process
	now_process.start()

#更新模块
func _process(delta):
	if now_process != null:
		now_process.update(delta)
