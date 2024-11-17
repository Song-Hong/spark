extends Node

@export var LeftTrayMode:ButtonGroup #左侧托盘按钮

func _ready():
	get_window().size = Vector2(1152,648)
