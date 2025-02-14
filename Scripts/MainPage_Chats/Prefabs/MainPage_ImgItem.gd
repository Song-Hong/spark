#图片显示组件
extends TextureRect

var img_path

func _ready():
	$Button.pressed.connect(Callable(self,"on_pressed"))

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
	var img_preview = Scene.init.load_scene("prefabs/ImagePreview")
	Blackboard.init.get_data("ViewArea").add_child(img_preview)
	img_preview.get_child(1).texture = texture
	img_preview._init_animation(self)

#设置图片
func set_img(img):
	texture = img
	
#从文件中加载图片
func set_img_from_file(file_path):
	var img = Image.load_from_file(file_path)
	var tex = ImageTexture.create_from_image(img)
	var siz = img.get_size()
	var sizf = Vector2(siz.x,siz.y)
	#设置缩放比例
	var scale_size = 2
	while sizf.x> 300:
		sizf /= scale_size
		scale_size += 0.1
	custom_minimum_size = sizf
	texture = tex
