##
# type   : class
# de_zh  : 组件集
# author : HongSong
# time   : 2023/12/20 15:50
##
extends Node
class_name ComponentArray

#集合名称
var array_name  : String
#名称
var components    : Dictionary

#快速添加
static func Q(_array_name:String,_components:Array[AComponent])->ComponentArray:
	var component_array = ComponentArray.new()
	component_array.array_name = _array_name
	var index = 0
	for component in _components:
		component_array.append(component,str(index))
		index += 1
	return component_array

#添加命令
func append(component:AComponent,component_name=""):
	component.component_name = component_name
	components[component_name] = component
	component.start()
	Core.init.update.connect(Callable(component, "update"))

#重新开启命令
func restart(component_name:String):
	if !components.has(component_name): return
	stop(component_name)
	start(component_name)

#开启
func start(component_name:String):
	if !components.has(component_name): return
	components[component_name].start()
	Nd(component_name)

#停止
func stop(component_name:String):
	if !components.has(component_name): return
	components[component_name].exit()
	Up(component_name)

# 挂起
# 取消绑定update
func Up(component_name:String):
	if !components.has(component_name): return
	Core.init.update.disconnect(Callable(components[component_name], "update"))

# 解除挂起
# 重新绑定update
func Nd(component_name:String):
	if !components.has(component_name): return
	Core.init.update.connect(Callable(components[component_name], "update"))

#删除命令
func destory(component_name:String):
	if !components.has(component_name): return
	stop(component_name)
	components.erase(component_name)

#是否存在命令
func has(component_name)->bool:
	return components.has(component_name)

#清空全部命令
func clear():
	for component_name in components:
		stop(component_name)
	components.clear()
