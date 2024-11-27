extends ITip
class_name TipPanel

signal agreeTip 
signal cancelTip

var title  :Label
var content:Label
var cancel :Button
var agree  :Button
var closew :Button

func _init(_title="通知",_content="这是一条通知",AgreeText="",CancelText="",AgreeCall=null,CancelCall=null):
	scene   = preload("res://SongG/SongGExtend/Tip/Scenes/TipPanel.tscn").instantiate()
	
	#设置基本信息
	close_time = -1 #不自动关闭

	#获取基本信息
	drag_area = scene.get_child(0)
	title     = scene.get_child(1)
	content   = scene.get_child(2)
	cancel    = scene.get_child(3)
	agree     = scene.get_child(4)
	closew    = scene.get_child(5)

	#绑定事件
	closew.connect("pressed",Callable(self,"close"))
	agree.connect("pressed",Callable(self,"on_agreeTip"))
	cancel.connect("pressed",Callable(self,"on_cancelTip"))

	#显示内容
	title.text   = _title
	content.text = _content

	var showcount = 0

	#设置按钮内容
	if AgreeText!= "":
		agree.text = AgreeText
		showcount+=1
		if AgreeCall!= null:
			agreeTip.connect(AgreeCall)
	else:
		agree.hide()
	
	if CancelText!= "":
		cancel.text = CancelText
		showcount+=1
		if CancelCall!= null:
			cancelTip.connect(CancelCall)
	else:
		cancel.hide()
	
	if showcount == 1:
		if AgreeText!= "":
			agree.position = Vector2(scene.size.x/2-agree.size.x/2,scene.size.y-agree.size.y-14)
		else:
			cancel.position = Vector2(scene.size.x/2-cancel.size.x/2,scene.size.y-cancel.size.y-14)


func showAnimation(tween):
	var area       = Blackboard.init.get_data("Tips")
	var wnd        = area.get_window().size
	var tip_size   = scene.size
	scene.position = Vector2(wnd.x/2-tip_size.x/2,wnd.y/2-tip_size.y/2)
	scene.scale = Vector2(0.1,0.1)
	scene.pivot_offset = scene.size/2
	tween.tween_property(scene, "scale",Vector2.ONE * 1.06, 0.15)
	tween.tween_property(scene, "scale",Vector2.ONE * 0.98, 0.12)
	tween.tween_property(scene, "scale",Vector2.ONE * 1.00, 0.03)

func destoryAnimation(tween):
	tween.tween_property(scene,"scale",Vector2.ZERO,0.15)
	return tween

func on_agreeTip():
	agreeTip.emit()
	close()

func on_cancelTip():
	cancelTip.emit()
	close()

func close():
	Tip.init.destory(self)
