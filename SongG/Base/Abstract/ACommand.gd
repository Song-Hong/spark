##
# type   : 抽象类
# de_zh  : 命令,用于拆分逻辑功能
# author : HongSong
# time   : 2023/12/20 15:08
##
extends IState
class_name ACommand

#当命令执行完成时
signal finshed
#当命令执行错误时
signal error

#命令名称
var command_name

#初始化
func _init(commandName = ""):
	command_name = commandName

#快捷方法
func exec_finshed() : finshed.emit() #运行完成
func exec_error()   : error.emit()   #运行失败
