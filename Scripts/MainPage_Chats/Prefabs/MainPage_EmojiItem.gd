#Emoji显示管理
extends Button

var emoji_dir = "res://Assets/Emoji/%s.svg"

#初始化
func init(_emoji_code):
	icon = load(emoji_dir%_emoji_code)
