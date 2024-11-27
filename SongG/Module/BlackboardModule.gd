##
# type   : 模块
# de_zh  : 黑板
# author : HongSong
# time   : 2023/12/20 15:25
##
extends IModule
class_name Blackboard
static var init:Blackboard
func _init():init = self

#数据
var data:Dictionary

#添加数据
func append(data_name,_data):
	data[data_name] = _data

#添加数据
func set_data(data_name,_data):
	data[data_name] = _data

#获取数据
func get_data(data_name):
	if data.has(data_name):
		return data[data_name]

#尝试获取数据
func try_get_data(data_name,call_data:Callable):
	if data.has(data_name):
		call_data.callv([data[data_name]])

#删除数据
func del_data(data_name):
	if data.has(data_name):
		data.erase(data_name)

#设置黑板
func set_blackboard(blackboard_name,blackboard:BlackboardData):
	data[blackboard_name] = blackboard

#设置黑板数据
func set_blackboard_data(_blackboard_name,_data_name,_data):
	if data.has(_blackboard_name):
		data[_blackboard_name].set_data(_data_name,_data)

#获取黑板
func get_blackboard(blackboard_name):
	if data.has(blackboard_name):
		return blackboard_name

#获取黑板数据
func get_blackboard_data(blackboard_name,data_name):
	if data.has(blackboard_name):
		if data[blackboard_name].has(data_name):
			return data[blackboard_name].get_data(data_name)

#删除黑板
func del_blackboard(blackboard_name):
	if data.has(blackboard_name):
		data.erase(blackboard_name)

#删除黑板数据
func del_blackboard_data(blackboard_name,data_name):
	if data.has(blackboard_name):
		if data[blackboard_name].has(data_name):
			return data[blackboard_name].del_data(data_name)

#尝试获取黑板
func try_get_blackboard(blackboard_name,call_data:Callable):
	if data.has(blackboard_name):
		call_data.callv([data[blackboard_name]])

#尝试获取黑板数据
func try_get_blackboard_data(blackboard_name,data_name,call_data:Callable):
	if data.has(blackboard_name):
		if data[blackboard_name].has(data_name):
			call_data.callv([data[blackboard_name].get_data(data_name)])
