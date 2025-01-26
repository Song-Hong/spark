#个人面板界面
extends AState
class_name MainPage_SettingState_UserInfoState

var avatar   #头像区域
var userinfo #用户信息区域
var save_btn #存储信息按钮

#新头像路径
var new_avatar_path

#初始化
func start():
	#获取区域
	avatar = Blackboard.init.get_data("AvatarInfo")
	userinfo = Blackboard.init.get_data("UserInfo")
	save_btn = userinfo.get_child(3)
	#修改信息
	avatar.get_child(0).icon   = Blackboard.init.get_data("UserAvatar").icon#头像
	userinfo.get_child(0).text = str(Global.SelfID)
	userinfo.get_child(1).text = Global.Username
	userinfo.get_child(2).text = Global.Name
	#事件订阅
	avatar.get_child(0).pressed.connect(Callable(self,"on_avatar_pressed"))
	userinfo.get_child(2).text_changed.connect(Callable(self,"on_user_name_change"))
	save_btn.pressed.connect(Callable(self,"on_save_btn_pressed"))
	
#取消订阅
func exit():
	#取消订阅
	avatar.get_child(0).pressed.disconnect(Callable(self,"on_avatar_pressed"))
	userinfo.get_child(2).text_changed.disconnect(Callable(self,"on_user_name_change"))
	save_btn.pressed.disconnect(Callable(self,"on_save_btn_pressed"))

#头像点击
func on_avatar_pressed():
	var file_import_area = FileImportArea.init_to_scene()
	file_import_area.on_files_import.connect(Callable(self,"on_avatar_import"))
	file_import_area.init("Drag the picture to the current area to modify the profile picture",["svg","png","jpg","jepg"])

#当头像导入时
func on_avatar_import(paths):
	var path = paths[0]
	new_avatar_path = path
	avatar.get_child(0).icon = ImageTexture.create_from_image(Image.load_from_file(path))
	show_save_button()

#显示存储按钮
func show_save_button():
	save_btn.visible = true

#当用户名修改时
func on_user_name_change(_new_text):
	show_save_button()

#当存储按钮点击时
func on_save_btn_pressed():
	#设置路径
	var path = DB.init.get_avatar_path_name(Global.SelfID) +"."+new_avatar_path.get_extension()
	#头像修改
	if avatar.get_child(0).icon != Blackboard.init.get_data("UserAvatar").icon:
		#修改本地头像
		DB.init.copy_file(new_avatar_path,path)
		#修改页面头像
		Blackboard.init.get_data("UserAvatar").icon = avatar.get_child(0).icon
		#上传修改头像
		upload_avatar_command.new(path)
	#数据更新
	send_user_info_command.new(Global.SelfID,userinfo.get_child(2).text,path.get_file())
