#灵动状态栏 时间
extends IEvenState
class_name EvenStateTimer

#显示节点
var lable

#时间变量
var time

func _init(t=30):
	time = t

func start():
	scene = preload("res://SongG/SongGExtend/EvenState/Scenes/timer.tscn").instantiate()
	EvenState.init.update.connect(Callable(self,"on_process"))
	#connect("process",Callable(self,"on_process"))
	lable = scene.get_child(1)
	Thread.new().start(Callable(self,"timer"))

func on_process(_delta):
	covter2String()

func timer():
	while time:
		sleep(1)     
		time-=1

func covter2String():
	var m = time/60
	var s = time-m*60
	lable.text = time2str2(m)+":"+time2str2(s)
	if !time:
		#disconnect("process",Callable(self,"on_process"))
		EvenState.init.update.disconnect(Callable(self,"on_process"))
		finshed.emit()
		destory.emit(self)
		
func time2str2(_time:int)->String:
	var t = str(_time) 
	if _time == 0:
		t = "00"
	elif len(t) < 2:
		t = "0"+t
	return t
