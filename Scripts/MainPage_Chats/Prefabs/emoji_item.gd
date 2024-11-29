#Emoji显示管理
extends Button

var emoji_dir = "res://Assets/Emoji/"

#初始化
func init(_emoji_code):
	print(_emoji_code)
	if DynamicAssets.init.emojis.has(_emoji_code):
		icon = DynamicAssets.init.emojis[_emoji_code]
