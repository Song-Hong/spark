#消息数据
class_name MessageData

var own  #是否是对方发的
var data #消息内容
var id   #消息id
var time #消息的接收时间
var type #消息类型 0:文本

#初始化并返回字符串
func init_to_json(_data,_own=true,_id=null,_time=null,_type=0)->String:
	return init(_data,_own,_id,_time,_type).to_json()

# 存储消息
func init(_data,_own=true,_id=null,_time=null,_type=0)->MessageData:
	data = _data
	type = _type
	own  = _own
	if(id==null):generate_id()
	else:id = _id
	if(time==null):generate_time()
	else:time = _time
	return self

# 转换为存储字符串
func to_json()->String:
	var dir:Dictionary
	dir.data = data
	dir.id   = id
	dir.time = time
	dir.type = type
	dir.own  = own
	return JSON.stringify(dir)

#生成id
func generate_id():
	id = Time.get_ticks_usec()

#生成时间
func generate_time():
	time = Time.get_datetime_string_from_system()

#解析数据
func parsing(msg)->MessageData:
	data = msg.data
	id   = msg.id
	time = msg.time
	type = msg.type
	if msg.has("own"):
		own = msg.own
	return self

#解析
static func static_parsing(msg)->MessageData:
	var md  = MessageData.new()
	md.data = msg.data
	md.id   = msg.id
	md.time = msg.time
	md.type = msg.type
	if msg.has("own"):
		md.own = msg.own
	return md

#获取时间
func get_time()->Dictionary:
	return Time.get_datetime_dict_from_datetime_string(time,true)
