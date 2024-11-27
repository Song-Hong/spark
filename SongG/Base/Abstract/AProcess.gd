##
# type   : 抽象类
# de_zh  : 流程基类
# author : HongSong
# time   : 2023/12/20 14:53
##
extends IState
class_name AProcess

#改变状态
func change_process(process:AProcess):
	Process.init.change_process(process)
