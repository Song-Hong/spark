#网络传输中间包
class_name NetJson

var App = "Spark"     #软件名
var Type:int = 10001  #类型
var Data:Dictionary   #数据体

#设置类型
func set_type(type:int)->NetJson:
	Type = type
	return self

#转换为网络json格式
func to_json()->String:
	var json = '{"App":"%s",'%App
	json    += '"Type":%s,'%str(Type)
	json    += '"Data":%s}'%JSON.stringify(Data)
	return json
