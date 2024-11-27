##
# type   : class
# de_zh  : 状态机
# author : HongSong
# time   : 2023/12/20 14:46
##
class_name Finite

signal state_change_start
signal state_change_end

var own
var nowState:AState
var states:Dictionary

#初始化
func _init(_own): 
	own = _own

#添加状态
func add_state(state_name:String,state:AState):
	if states.has(state_name):return
	states[state_name] = state
	state.finite = self

#删除状态
func del_state(state_name:String):
	if !states.has(state_name):return
	states.erase(state_name)

#是否存在状态
func exist_state(state_name:String):
	return states.has(state_name)

#开始状态
func start(state_name):
	if !states.has(state_name):return
	nowState = states[state_name]
	nowState.start()

#更新
func update(_delta):
	if nowState != null:
		nowState.update(_delta)

#改变状态
func change_state(state_name:String):
	if !states.has(state_name):return
	if nowState!=null:nowState.exit()
	nowState = states[state_name]
	state_change_start.emit()
	nowState.start()
	state_change_end.emit()

#改变状态
func changeState(state:AState):
	if nowState     != null : nowState.exit()
	if state.finite == null : state.finite = self
	nowState = state
	state_change_start.emit()
	nowState.start()
	state_change_end.emit()

#清除当前状态机
func clear():
	nowState.exit()
	states.clear()
	own = null
