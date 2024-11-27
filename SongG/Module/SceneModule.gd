##
# type   : 模块
# de_zh  : 场景管理模块
# author : HongSong
# time   : 2023/12/20 13:00
##
extends IModule
class_name Scene
static var init:Scene
func _init():init = self

#场景
var scenes:Dictionary

#添加场景
func add_scene(scene_name):
	if scenes.has(scene_name): return
	var scene = load_scene(scene_name)
	Blackboard.init.get_data("ViewArea").add_child(scene)
	scenes[scene_name] = scene
	return scene

#获取场景
func get_scene(scene_name):
	if scenes.has(scene_name): 
		return scenes[scene_name]
	else:
		return null

#删除场景
func remove_scene(scene_name):
	if scenes.has(scene_name): 
		Blackboard.init.get_data("ViewArea").remove_child(scenes[scene_name])
		scenes.erase(scene_name)
	else:
		return null

#名称转为路径
func name_to_path(scene_name:String)->String:
	return "res://scenes/%s.tscn"%scene_name

#加载场景,并添加至场景列表中
func load_scene_to_scenes(scene_name:String):
	var path = name_to_path(scene_name)
	var scene = load(path).instantiate()
	scenes[scene_name] = scene
	return scene

#加载场景
func load_scene(scene_name:String):
	var path = name_to_path(scene_name)
	var scene = load(path).instantiate()
	return scene
