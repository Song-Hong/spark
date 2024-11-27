##
# type   : class
# de_zh  : 黑板数据
# author : HongSong
# time   : 2023/12/20 15:27
##
class_name BlackboardData

#数据
var data:Dictionary

#快速初始化
func _init(_data:Dictionary={}):
	for key in _data.keys():
		data[key] = _data[key]

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

func has(data_name):
	return data.has(data_name)
