# 动态资源
extends IModule
class_name DynamicAssets
static var init: DynamicAssets
func _init(): init = self

@export var emojis:Dictionary
