#图片预览窗口
extends Button

var base_node

#初始化动画
func _init_animation(node:Control):
	base_node = node
	#初始化位置
	var texture             = $TextureRect
	var target_po           = texture.position
	texture.global_position = node.global_position
	texture.scale           = Vector2(node.size/texture.size)
	node.visible            = false
	
	#设置终点位置
	var target              = (size/2)-(texture.size/2)
	
	var tween               = create_tween()
	tween.set_parallel()
	tween.tween_property(texture,"position",target,0.2)
	tween.tween_property(texture,"scale",Vector2.ONE,0.2)

#初始化
func _ready():
	pressed.connect(Callable(self,"on_pressed"))
	$MarginContainer/Button.pressed.connect(Callable(self,"on_pressed"))

#当关闭按钮点击
func on_pressed():
	pressed.disconnect(Callable(self,"on_pressed"))
	$MarginContainer/Button.pressed.disconnect(Callable(self,"on_pressed"))
	
	#关闭背景
	$Panel.visible            = false
	$MarginContainer.visible = false
	
	#销毁动画
	var texture             = $TextureRect
	var tween               = create_tween()
	var sclae_size          = Vector2(base_node.size/texture.size)
	tween.set_parallel()
	tween.tween_property(texture,"position",base_node.global_position,0.2)
	tween.tween_property(texture,"scale",sclae_size,0.16)
	await tween.finished
	base_node.visible            = true
	Blackboard.init.get_data("ViewArea").remove_child(self)
