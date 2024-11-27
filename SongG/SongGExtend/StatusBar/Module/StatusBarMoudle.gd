extends IModule
class_name StatusBar
static var init:StatusBar
func _init():init = self

###### 状态栏路径
var mac_status = "res://SongG/SongGExtend/StatusBar/Scenes/macStatus.tscn"
var win_status = "res://SongG/SongGExtend/StatusBar/Scenes/winStatus.tscn"
######

#显示状态栏
func show_stauts():
	var window = Blackboard.init.get_data("StatusBar")
	var scene
	if OS.get_name() == "macOS":
		scene = load(mac_status).instantiate()
	else:
		scene = load(win_status).instantiate()
	window.add_child(scene)
