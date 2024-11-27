##
# type   : 抽象类
# de_zh  : 状态机_状态
# author : HongSong
# time   : 2023/12/20 14:46
##
extends    IState
class_name AState

#状态机
var finite:Finite

#获取持有者
func own(): 
	return finite.own

#切换状态
func change_state(state_name:String):
	finite.change_state(state_name)

#改变状态
func changeState(state:AState):
	finite.changeState(state)
