#文件导入管理
extends Button
class_name FileImportArea

#["svg","png","jpg","jepg"]
#var tip_text:String
#导入类型限制
var type:Array
#当监听到文件导入时
signal on_files_import

#初始化场景
static func init_to_scene()->FileImportArea:
	return Scene.init.add_scene("prefabs/file_import_area")

#初始化
func init(_tip:String,_type=null):
	$Label.text = _tip
	type = _type

#初始化
func _ready():
	#监听文件拖动
	Core.init.get_tree().root.files_dropped.connect(Callable(self,"on_file_dropped"))
	pressed.connect(Callable(self,"on_click_area"))

func _exit_tree():
	#取消监听 文件拖动
	Core.init.get_tree().root.files_dropped.disconnect(Callable(self,"on_file_dropped"))
	pressed.disconnect(Callable(self,"on_click_area"))

#当文件拖动导入
func on_file_dropped(paths):
	var files_paths:Array[String]#导入文件
	for path in paths:
		var extens = path.get_extension()
		if type != null and extens.to_lower() in type:
			files_paths.append(path)
		else:
			files_paths.append(path)
	if files_paths.size()>0:
		on_files_import.emit(files_paths)
		Scene.init.remove_scene("prefabs/file_import_area")

#当点击空白处,退出此区域
func on_click_area():
	Scene.init.remove_scene("prefabs/file_import_area")
