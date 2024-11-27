extends IEvenState
class_name EvenStateTip

var tip = "res://SongGExtend/EvenState/Icons/Tip.svg"
var war = "res://SongGExtend/EvenState/Icons/Warring.svg"
var err = "res://SongGExtend/EvenState/Icons/Error.svg"

var icon     : TextureRect 
var content  : Label
var tip_type : type

var tip_content:String
var close_time:int
var is_show:bool

enum type{
	TIP,
	WAR,
	ERR
}

func _init(t:type,_content,_close_time=3):
	tip_type = t
	tip_content = _content
	close_time = _close_time
	is_show = true

func start():
	scene   = preload("res://SongG/SongGExtend/EvenState/Scenes/tip.tscn").instantiate()
	icon    = scene.get_child(0)
	content = scene.get_child(1)
	var tex
	var color
	match tip_type:
		type.TIP:
			tex = load(tip)
			color = Color("#6A6C6F")
		type.WAR:
			tex = load(war)
			color = Color("#FDC339")
		type.ERR:
			tex = load(err)
			color = Color("#FB635B")
	icon.texture  = tex
	icon.modulate = color
	content.text = tip_content
	content.add_theme_color_override("font_color",color)
	close()

func showAnimation(tween:Tween):
	await content.resized
	scene.size += Vector2(content.size.x-52,0)
	EvenState.init.reload()
	super.showAnimation(tween)

func close():
	if close_time <= 0:
		return
	else:
		EvenState.init.update.connect(Callable(self,"on_process"))
		#connect("process",Callable(self,"on_process"))
		Thread.new().start(Callable(self,"wait"))

func on_process(_delta):
	if !is_show:
		de_self()

func wait():
	sleep(close_time)
	is_show = false

func de_self():
	EvenState.init.update.disconnect(Callable(self,"on_process"))
	#disconnect("process",Callable(self,"on_process"))
	finshed.emit()
	destory.emit(self)
