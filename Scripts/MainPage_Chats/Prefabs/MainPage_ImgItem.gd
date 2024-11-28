#图片显示组件
extends Button

var img_path

func _ready():
	pressed.connect(Callable(self,"on_pressed"))

#延迟加载
func wait_load_img():
	icon = null
	text = "[图片加载中...]"
	await Core.init.get_tree().create_timer(1).timeout
	print(FileAccess.file_exists(img_path))
	if FileAccess.file_exists(img_path):
		var img = Image.load_from_file(img_path)
		icon = ImageTexture.create_from_image(img)
		text = ""
	else:
		text = "[图片丢失]"

#退出场景
func _exit_tree():
	pressed.disconnect(Callable(self,"on_pressed"))
	
#当图片点击时
func on_pressed():
	print(1)
