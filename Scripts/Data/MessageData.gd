#消息数据
class_name MessageData

var own  #是否是对方发的
var data #消息内容
var id   #消息id
var time #消息的接收时间
var type #消息类型 0_文本 1_表情 2_图片 3_语音 4_文件 5_链接

#region 静态方法
# 0 文本消息
static func Text(_text)->MessageData:
	var md = MessageData.new()
	return md.init(_text)

# 1 表情
static func Emoji(_id)->MessageData:
	var md = MessageData.new()
	md.init(_id)
	md.type = 1
	return md

# 2 图片
static func Img(_img)->MessageData:
	var md = MessageData.new()
	md.init(_img)
	md.type = 2
	return md

# 3 语音
static func Aud(_aud)->MessageData:
	var md = MessageData.new()
	md.init(_aud)
	md.type = 3
	return md

# 4 文件
static func File(_file)->MessageData:
	var md = MessageData.new()
	md.init(_file)
	md.type = 4
	return md

# 5 链接
static func Link(_link)->MessageData:
	var md = MessageData.new()
	md.init(_link)
	md.type = 5
	return md
#endregion

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

#生成唯一id
func gen_only_id():
	var _time = Time.get_datetime_dict_from_system()
	return str(_time.year)+"_"+str(_time.month)+"_"+str(_time.day)+"_"+str(id)
