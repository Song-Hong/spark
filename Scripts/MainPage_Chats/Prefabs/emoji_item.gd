#Emoji显示管理
extends Button

var emoji_dir = "res://Assets/Emoji/"

#初始化
func init(_emoji_code):
	var emoji_path = emoji_dir+_emoji_code+".svg"
	#print(emoji_path)
	if FileAccess.file_exists(emoji_path):
		var img = Image.load_from_file(emoji_path)
		icon = ImageTexture.create_from_image(img)
