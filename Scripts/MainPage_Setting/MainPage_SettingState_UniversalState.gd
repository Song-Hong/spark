#设置界面_通用
extends AState
class_name MainPage_SettingState_UniversalState

var Langueage_Button_Group:ButtonGroup #按钮组
var Theme_Button_Group:ButtonGroup

#当前语言
var local_lang_name

#初始化
func start():
	#设置版本信息
	Blackboard.init.get_data("VersionNumber").text = ProjectSettings.get_setting("application/config/version")
	
	#语言监听按钮
	Langueage_Button_Group = Blackboard.init.get_data("Langueage_Button_Group").button_group
	Langueage_Button_Group.connect("pressed",Callable(self,"_on_pressed"))
	match TranslationServer.get_locale():
		"zh_Hans_CN":
			local_lang_name = "SimplifiedChinese"
		"en":
			local_lang_name = "English"
	if local_lang_name != null:
		var btn = Blackboard.init.get_data("LanguageArea").find_child(local_lang_name)
		btn.button_pressed = true
	
	#主题监听按钮
	Theme_Button_Group = Blackboard.init.get_data("ThemeButtonGroup").button_group
	Theme_Button_Group.connect("pressed",Callable(self,"_on_theme_button_pressed"))
	var btn_area = Blackboard.init.get_data("ThemeArea").find_child(Global.NowThemeName)
	if btn_area != null:
		btn_area.get_child(0).button_pressed = true

#退出时清空订阅
func exit():
	Langueage_Button_Group.disconnect("pressed",Callable(self,"_on_pressed"))
	Theme_Button_Group.disconnect("pressed",Callable(self,"_on_theme_button_pressed"))

#当按钮点击时
func _on_pressed(btn):
	if btn.name == local_lang_name:return
	match btn.name:
		"SimplifiedChinese":
			TranslationServer.set_locale("zh_Hans_CN")
		"TraditionalChinese":
			pass
		"English":
			TranslationServer.set_locale("en")
	local_lang_name = btn.name
	
	#设置配置文件,并存储
	var ac = DB.init.read_core()
	ac.language = TranslationServer.get_locale()
	DB.init.save_core(ac)

#当主题按钮点击时
func _on_theme_button_pressed(btn):
	#检查设置当前主题
	if Global.NowThemeName == btn.name:
		return
	Global.NowThemeName = btn.name
	#切换主题
	var theme
	match btn.name:
		"Light":
			theme = load("res://Assets/Theme/lighting.tres")
		"Dark":
			theme = null
		"Auto":
			theme = null
	Core.init.change_theme(theme)
