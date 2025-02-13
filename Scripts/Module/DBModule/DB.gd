# 数据库
extends IModule
class_name DB
static var init: DB
func _init(): init = self

# 数据存储位置
var DataSaveDir = "user://Cache"
#当前用户的存储位置
var NowUserPath = DataSaveDir
#配置文件位置
var ConfigPath  = "user://Cache/Config/"

#初始化
func _ready():
	#检查存储文件夹
	check_dir(DataSaveDir)
	check_dir(ConfigPath)
	#初始化配置文件
	init_core()

#设置当前登陆的用户
func set_user(_id):
	NowUserPath = DataSaveDir+"/user_%s"%str(_id)
	check_dir(NowUserPath)

#region 文件读取
#初始化核心配置文件
func init_core():
	#初始化文件位置
	var path = get_core_config_path()
	#检测文件是否存在,不存则则初始化文件
	if !FileAccess.file_exists(path): #当文件不存在
		var ac = AppConfig.new()
		ac.language      = 'zh_Hans_CN'
		ac.logined       = false
		ac.user_username = ""
		ac.user_password = ""
		save_core(ac)

#读取配置文件
func read_core()->AppConfig:
	var ac = AppConfig.new()
	var file         = FileAccess.open(get_core_config_path(),FileAccess.READ)
	var json         = JSON.parse_string(file.get_as_text())
	ac.language      = json.language
	ac.logined       = json.logined
	ac.user_username = json.user_username
	ac.user_password = json.user_password
	return ac

#读取今天消息
func read_md_today(_id)->Array:
	var array_mds = []
	var dir_path  = id_to_dir(_id)
	check_dir(dir_path)
	var file_path = append_file_extend_name(dir_path + get_now_date())
	for line in read_text(file_path).split("\n"):
		if line == "":continue
		var md   = MessageData.static_parsing(JSON.parse_string(line))
		array_mds.append(md)
	return array_mds
	
# 获取指定用户最后一条消息
func read_today_last_md(_id)->MessageData:
	var dir_path  = id_to_dir(_id)
	check_dir(dir_path)
	var file_path = append_file_extend_name(dir_path + get_now_date())
	var lines     = read_text(file_path).split("\n")
	var msg       = lines[lines.size()-1]
	if msg       == "" :return null
	var md        = MessageData.static_parsing(JSON.parse_string(msg))
	return md

#读取文件数据
func read_text(file_path)->String:
	if !FileAccess.file_exists(file_path):
		return ""
	var file = FileAccess.open(file_path,FileAccess.READ)
	return file.get_as_text()
#endregion

#region 文件存储
#存储核心配置文件
func save_core(_app_config:AppConfig):
	var file = FileAccess.open(get_core_config_path(),FileAccess.WRITE)
	file.store_string(_app_config.to_json())

#存储离线消息
func save_off_line_md(_id,_data:MessageData):
	save_md(_id,_data)

#存储指定用户数据
func save_md(_id,_data:MessageData):
	var dir_path  = id_to_dir(_id)
	if !DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_absolute(dir_path)
	var file_path = append_file_extend_name(dir_path + get_now_date())
	save_text_append(file_path,_data.to_json())

# 追加存储
func save_text_append(file_path,content):
	if !FileAccess.file_exists(file_path):
		FileAccess.open(file_path,FileAccess.WRITE)
	var file         = FileAccess.open(file_path, FileAccess.READ_WRITE)
	var file_content = file.get_as_text()
	var save_content = file_content+"\n"+content
	save_content     = save_content.trim_suffix("\n").trim_prefix("\n")
	file.store_string(save_content)

#转存缓存文件
func copy_file(source_path:String,target_path:String):
	if !FileAccess.file_exists(source_path):return
	# 读取源文件
	var content = FileAccess.get_file_as_bytes(source_path)
	# 写入新文件
	var file = FileAccess.open(target_path, FileAccess.WRITE)
	file.store_buffer(content)
#endregion

#region 删除文件
#删除文件夹,除去自身
func delete_folder_contents(folder_path,rootfolder):
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name!= "":
			var file_path = folder_path + "/" + file_name
			if dir.current_is_dir():
				# 如果是文件夹，递归删除
				delete_folder_contents(file_path,rootfolder)
			else:
				# 如果是文件，直接删除
				dir.remove(file_path)
			file_name = dir.get_next()
		dir.list_dir_end()
		#dir.free()
		# 删除空文件夹（自身）
		if folder_path == rootfolder: return
		dir.remove(folder_path)
	else:
		print("无法打开文件夹: ", folder_path)
#endregion

#region 公用方法
#获取核心配置文件位置
func get_core_config_path()->String:
	return ConfigPath + "core.spark.config.json"

#检查文件夹是否存在,如不存在则存储
func check_dir(dir_path):
	if !DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_absolute(dir_path)

#id转换为文件夹地址
func id_to_dir(_id)->String:
	return NowUserPath+"/%s/"%str(_id)

#添加文件扩展名
func append_file_extend_name(file_name):
	return file_name + ".spark.msg.json"

#获取今天的日期
func get_now_date()->String:
	var time = Time.get_datetime_dict_from_system()
	return str(time.year)+"_"+str(time.month)+"_"+str(time.day)

#获取自身用户头像
func get_self_avatar_img()->ImageTexture:
	return get_avatar_img(Global.SelfID)

#获取用户头像
func get_avatar_img(id)->ImageTexture:
	var img_path = find_avatar_path(id)
	if FileAccess.file_exists(img_path):
		return ImageTexture.create_from_image(Image.load_from_file(img_path))
	else:
		return null

#从名称中获取头像,包含自动删除过时头像
func comparison_get_avatar_img_with_path(id,name_path)->ImageTexture:
	if FileAccess.file_exists(join_avatar_path(name_path)):
		#一次比对
		var jpath = join_avatar_path(name_path)
		var fpath = find_avatar_path(id)
		if jpath != fpath:
			DirAccess.remove_absolute(fpath)
		#二次比对
		fpath = find_avatar_path(id)
		if jpath != fpath:
			DirAccess.remove_absolute(fpath)
		#返回图像
		return ImageTexture.create_from_image(Image.load_from_file(jpath))
	else:
		return null

#获取自己用户头像路径
func find_self_avatar_path()->String:
	return find_avatar_path(Global.SelfID)

#获取用户路径头像路径
func find_avatar_path(id)->String:
	var file_name = str(id)+"_avatar"
	var img_path = ""
	for item in DirAccess.get_files_at(NowUserPath):
		var file_type = item.get_extension()
		var file_path = NowUserPath+"/"+item.replace("."+file_type,"")
		file_path     = file_path.replace(file_path.substr(file_path.rfind(".")),"")
		var _file     = file_path.get_file()
		if _file == file_name:
			img_path = NowUserPath+"/"+item
	return img_path

#获取用户路径,不带扩展名
func get_avatar_path_name(id)->String:
	return NowUserPath+"/"+str(id)+"_avatar"

#头像文件路径
func join_avatar_path(_path)->String:
	return NowUserPath+"/"+str(_path)

#判断头像文件是否存在
func avatar_exists(_path)->bool:
	return FileAccess.file_exists(join_avatar_path(_path))
#endregion

#region [preview] latest DB loading opertion
func read_md_last():
	pass
#endregion
