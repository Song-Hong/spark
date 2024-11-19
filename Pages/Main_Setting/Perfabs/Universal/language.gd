#语言控制
extends VBoxContainer

@export var ChooseGroup:ButtonGroup #按钮组

var local_lang_name

#初始化
func _ready():
	ChooseGroup.connect("pressed",Callable(self,"_on_pressed"))
	match TranslationServer.get_locale():
		"zh_Hans_CN":
			$Panel/MarginContainer/HBoxContainer/SimplifiedChinese.button_pressed = true
			local_lang_name = "SimplifiedChinese"
		"en":
			$Panel/MarginContainer/HBoxContainer/English.button_pressed = true
			local_lang_name = "English"

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
