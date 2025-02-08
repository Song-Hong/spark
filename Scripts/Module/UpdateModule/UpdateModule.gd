# 软件更新模块
extends IModule
class_name UpdateModule
static var init: UpdateModule
func _init(): init = self

#服务器
var http_manager : HTTPManager
#版本文件
var version_json

#动态下载状态栏
var download_event_state

#初始化
func _ready():
	#创建http 连接
	http_manager = HTTPManager.new()
	add_child(http_manager)
	
	#初始化设置
	http_manager.accept_cookies = true
	http_manager.print_debug = true
	http_manager.use_cache = true
	
	## TODO 测试
	#http_manager.display_progress = true
	#http_manager.job(
		#"https://github.com/Song-Hong/spark/releases/download/Preview/Mac_Spark.dmg"
	#).on_success(
		#func(response): 
			#Tip.init.create_tip(TipTopShort.new("下载成功"))
			#finshed.emit()
	#).on_failure(
		#func( _response ): 
			#Tip.init.create_tip(TipTopShort.new("下载失败"))
			#finshed.emit()
	#).download("/Users/song/Downloads/TEST/Spark.dmg")
	
	#检查版本更新
	await get_tree().create_timer(2).timeout
	check_version()

#检查版本
func check_version():
	http_manager.job(
		"http://49.235.238.251:17281/version/spark"
	).charset("utf-8").on_success(
		func(response): 
			parsing_version(response.fetch())
	).on_failure(
		func( _response ): print("i told this wont work!")
	).fetch()



#解析版本文件
func parsing_version(_data):
	version_json = JSON.parse_string(_data)
	var version = ProjectSettings.get_setting("application/config/version")
	var web_version = version_json.version.split(".")
	var local_version = version.split(".")
	var is_update = false
	for i in range(3):
		if web_version[i] > local_version[i]: #有新版本
			is_update = true
			break
	if is_update:
		show_update_tip()

#显示版本更新
func show_update_tip():
	Tip.init.create_tip(TipChoosePanel.new(
		"新版本 "+version_json.version,
		version_json.update_info,
		"更新",
		"取消更新",
		Callable(self,"agree_update"),
		Callable(self,"cancle_update")
	))

#取消更新
func cancle_update():
	print("取消更新")

#同意更新
func agree_update():
	print("开始更新")
	download()
	
#下载更新包
func download():
	#创建进度条
	download_event_state = EventStateDownload.new()
	EvenState.init.create(download_event_state)
	#获取名称
	var os_name = OS.get_name()
	#初始化文件
	var download_url #下载地址
	var save_path    = "user://Cache/" #存储位置
	match os_name: 
		"macOS":
			download_url = version_json.mac
			save_path += "Spark.dmg"
		"Windows":
			download_url = version_json.win
			save_path += "Spark.exe"
		"Linux":
			download_url = version_json.linux
			save_path += "Spark.x86_64"
		_:
			pass
	print(download_url)
	#开始下载
	http_manager.job(
		download_url
	).on_success(
		func(_response): 
			Tip.init.create_tip(TipTopShort.new("下载成功"))
			destory_progress()
			exec_install(save_path)
	).on_failure(
		func( _response ): 
			Tip.init.create_tip(TipTopShort.new("下载失败"))
			destory_progress()
	).download(ProjectSettings.globalize_path(save_path))

#设置下载进度
func set_progress(_value:float):
	if download_event_state!=null:
		download_event_state.set_progress(_value)

#删除当前下载
func destory_progress():
	if download_event_state!=null:
		download_event_state.download_finshed()

#执行安装
func exec_install(_app_path):
	_app_path = ProjectSettings.globalize_path(_app_path)
	if FileAccess.file_exists(_app_path):
		OS.shell_open(_app_path)
