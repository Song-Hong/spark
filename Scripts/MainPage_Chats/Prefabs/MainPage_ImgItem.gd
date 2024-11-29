#图片显示组件
extends TextureRect

var img_path

func _ready():
	#pressed.connect(Callable(self,"on_pressed"))
	pass

#延迟加载
func wait_load_img():
	texture = null
	await Core.init.get_tree().create_timer(1).timeout
	if FileAccess.file_exists(img_path):
		set_img_from_file(img_path)
	else:
		pass

#退出场景
func _exit_tree():
	pass
	
#当图片点击时
func on_pressed():
	print(1)

#设置图片
func set_img(img):
	texture = img
	
#从文件中加载图片
func set_img_from_file(file_path):
	var img = Image.load_from_file(file_path)
	var tex = ImageTexture.create_from_image(img)
	var siz = img.get_size()
	custom_minimum_size = Vector2(siz.x/2,siz.y/2)
	texture = tex
