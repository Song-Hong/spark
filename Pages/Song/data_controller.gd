#本地数据的存储、查询、缓存
extends Node
class_name Module_Data

var SelfID:int     = 0 #当前登陆用户ID
var TargetID:int   = 0 #当前聊天用户ID
var Name:String        #当前用户昵称

var DataSaveDir    = "user://Cache" #数据存储位置
var FriendCache    = "/friends"     #好友消息存储位置
var CoreConfigPath = "/core/"       #核心配置文件

#region 初始化
func _ready():
	if !DirAccess.dir_exists_absolute(DataSaveDir):
		DirAccess.make_dir_absolute(DataSaveDir)
	if !DirAccess.dir_exists_absolute(DataSaveDir+CoreConfigPath):
		DirAccess.make_dir_absolute(DataSaveDir+CoreConfigPath)
	init_core()
#endregion

#region 通用方法
#更新用户存储位置
func update_firend_cache_path(path:String):
	FriendCache = "/%s_friends"%path
	if !DirAccess.dir_exists_absolute(DataSaveDir+FriendCache):
		DirAccess.make_dir_absolute(DataSaveDir+FriendCache)

#更新好友消息存储位置
func get_friend_cache_path()->String:
	return DataSaveDir+FriendCache

#获取今天的日期
func get_now_date()->String:
	var time = Time.get_datetime_dict_from_system()
	return str(time.year)+"_"+str(time.month)+"_"+str(time.day)

#获取核心配置文件位置
func get_core_config_path()->String:
	return DataSaveDir+CoreConfigPath + "spark.core.json"
#endregion

#region 文件读取
#初始化核心配置文件
func init_core():
	#初始化文件位置
	var path = get_core_config_path()
	#初始化配置文件
	var ac = AppConfig.new()
	Song.Module.Config = ac
	#检测文件是否存在,不存则则初始化文件
	if FileAccess.file_exists(path): #文件存在
		var file         = FileAccess.open(path,FileAccess.READ)
		var json         = JSON.parse_string(file.get_as_text())
		ac.language      = json.language
		ac.logined       = json.logined
		ac.user_username = json.user_username
		ac.user_password = json.user_password
		TranslationServer.set_locale(ac.language)
	else: #文件不存在
		ac.language      = 'zh_Hans_CN'
		ac.logined       = false
		ac.user_username = ""
		ac.user_password = ""
		save_core()

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

#获取全部消息
func read_all_msg():
	pass

#读取文件数据
func read(file_path)->String:
	if !FileAccess.file_exists(file_path):
		return ""
	var file = FileAccess.open(file_path,FileAccess.READ)
	return file.get_as_text()#.trim_suffix("\n").trim_prefix("\n")

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

#endregion

#region 文件存储
#存储核心配置文件
func save_core():
	var config = Song.Module.Config
	var file = FileAccess.open(get_core_config_path(),FileAccess.WRITE)
	file.store_string(config.to_json())

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
#endregion
