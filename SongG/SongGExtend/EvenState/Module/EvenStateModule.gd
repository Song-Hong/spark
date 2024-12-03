# 灵动状态栏
extends IModule
class_name EvenState
static var init:EvenState
func _init():init = self

signal update

var even_states:Array[IEvenState]
var width = 2
var area

func create(evenState:IEvenState):
	if !area:
		area = Blackboard.init.get_data("EvenState")
	even_states.append(evenState)
	evenState.start()
	evenState.connect("destory",Callable(self,"on_destory"))
	var w = evenState.scene.size.x
	area.add_child(evenState.scene)
	evenState.scene.position = Vector2(width+10,2)
	width += w +10
	evenState.showAnimation(get_tree().create_tween())

func _process(delta):
	update.emit(delta)
	
func on_destory(evenState:IEvenState):
	await evenState.destoryAnimation(get_tree().create_tween()).finished
	area.remove_child(evenState.scene)
	even_states.erase(evenState)
	sort_even_states()

func sort_even_states():
	width = 80
	var i = 0
	for even_state in even_states:
		var tween = get_tree().create_tween()
		tween.set_trans(tween.TRANS_BACK)
		tween.tween_property(even_state.scene,"position",Vector2(width+12,8) ,0.3+i)
		width += even_state.scene.size.x +10
		i+=0.04

#刷新
func reload():
	width = 80
	for even_state in even_states:
		var vec = Vector2(width,8)
		even_state.scene.position = vec
		width += even_state.scene.size.x +10
