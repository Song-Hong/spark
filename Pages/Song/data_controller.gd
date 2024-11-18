#本地数据的存储、查询、缓存
extends Node
class_name Module_Data

var SelfID:int   = 0 #当前登陆用户ID
var TargetID:int = 0 #当前聊天用户ID
var Name:String      #当前用户昵称

var DataSaveDir  = "user://Cache" #数据存储位置
var FriendCache  = "/friends"    #好友消息存储位置

#初始化
func _ready():
	if !DirAccess.dir_exists_absolute(DataSaveDir):
		DirAccess.make_dir_absolute(DataSaveDir)

#更新用户存储位置
func update_firend_cache_path(path:String):
	FriendCache = "/%s_friends"%path
	if !DirAccess.dir_exists_absolute(DataSaveDir+FriendCache):
		DirAccess.make_dir_absolute(DataSaveDir+FriendCache)

#读取指定用户当天的聊天数据
func read_msg(id)->Array:
	var array_mds = []
	var dir_path  = DataSaveDir+FriendCache+"/%s/"%str(id)
	if !DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_absolute(dir_path)
	var file_path = dir_path + get_now_date() + "spark.msg.json"
	for line in read(file_path).split("\n"):
		if line == "":continue
		var md   = MessageData.new().parsing(JSON.parse_string(line))
		array_mds.append(md)
	return array_mds

# 获取指定用户最后一条消息
func read_last_msg(id)->String:
	var dir_path  = DataSaveDir+FriendCache+"/%s/"%str(id)
	if !DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_absolute(dir_path)
	var file_path = dir_path + get_now_date() + "spark.msg.json"
	var lines     = read(file_path).split("\n")
	var msg       = lines[lines.size()-1]
	if msg       == "" :return ""
	var md        = MessageData.new().parsing(JSON.parse_string(msg))
	return md.data

#存储指定用户数据
func save_msg(id,data:MessageData):
	var dir_path  = DataSaveDir+FriendCache+"/%s/"%str(id)
	if !DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_absolute(dir_path)
	var file_path = dir_path + get_now_date() + "spark.msg.json"
	save_append(file_path,data.to_json())

# 追加存储
func save_append(file_path,content):
	if !FileAccess.file_exists(file_path):
		FileAccess.open(file_path,FileAccess.WRITE)
	var file         = FileAccess.open(file_path, FileAccess.READ_WRITE)
	var file_content = file.get_as_text()
	var save_content = file_content+"\n"+content
	save_content     = save_content.trim_suffix("\n").trim_prefix("\n")
	file.store_string(save_content)

#获取今天的日期
func get_now_date()->String:
	var time = Time.get_datetime_dict_from_system()
	return str(time.year)+"_"+str(time.month)+"_"+str(time.day)

#获取全部消息
func read_all_msg():
	pass

#读取文件数据
func read(file_path)->String:
	if !FileAccess.file_exists(file_path):
		return ""
	var file = FileAccess.open(file_path,FileAccess.READ)
	return file.get_as_text()#.trim_suffix("\n").trim_prefix("\n")
