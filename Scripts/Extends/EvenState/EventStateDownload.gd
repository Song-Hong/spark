#灵动状态栏 下载
extends IEvenState
class_name EventStateDownload

#进度条
var progress:ProgressBar

#初始化
func start():
	scene = load("res://Scripts/Extends/EvenState/download.tscn").instantiate()
	progress = scene.get_child(0)

#设置进度
func set_progress(_value:float):
	progress.value = _value
	if progress.value == progress.max_value:
		download_finshed()

#结束
func download_finshed():
	finshed.emit()
	destory.emit(self)
