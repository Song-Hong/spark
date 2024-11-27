# 提示配置文件
extends Control
class_name ITip

#信号
signal destory

#场景
var scene
var drag_area

#Tips设置
var can_move = true     #窗口是否可以移动
var close_time = 3      #窗口关闭时间

#窗口移动变量
var isdown    = false   #检测鼠标是否按下
var offset              #偏移值

func init():
	if can_move && drag_area != null:
		if drag_area.has_signal("button_down") and drag_area.has_signal("button_up"):
			drag_area.connect("button_down",Callable(self,"_on_button_down"))
			drag_area.connect("button_up",Callable(self,"_on_button_up"))
			drag_area.connect("gui_input",Callable(self,"_input"))
	if close_time > 0:
		Tip.init.update.connect(Callable(self,"update"))
		Thread.new().start(Callable(self,"waitClose"))

##regin 窗口的移动操作
#当鼠标按下时候,开始跟手
func _on_button_down():
	offset = drag_area.get_global_mouse_position() - scene.position
	isdown = true

#当鼠标抬起时,停止跟手
func _on_button_up():
	isdown = false

#当鼠标按下时,持续跟手操作
func _input(_event):
	if isdown:
		scene.position = drag_area.get_global_mouse_position()-offset
##endregin

##regin 用户可扩展方法

#初始化
func start():pass

#显示提示窗口
func showTip():pass

func update(_delta):
	if close_time==0:
		close()

func waitClose():
	sleep(close_time)
	close_time = 0

#关闭窗口
func close():
	Tip.init.update.disconnect(Callable(self,"update"))
	Tip.init.destory(self)

#显示窗口出现动画
func showAnimation(tween:Tween):
	scene.scale = Vector2(0.1,0.1)
	scene.pivot_offset = scene.size/2
	tween.tween_property(scene, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(scene, "scale", Vector2(0.9, 0.9), 0.2)
	tween.tween_property(scene, "scale", Vector2(1.03, 1.03), 0.1)
	tween.tween_property(scene, "scale", Vector2(0.97, 0.97), 0.1)
	tween.tween_property(scene, "scale", Vector2(1.01, 1.01), 0.05)
	tween.tween_property(scene, "scale", Vector2(0.99, 0.99), 0.05)
	tween.tween_property(scene, "scale", Vector2(1, 1), 0.02)

#显示窗口关闭动画
func destoryAnimation(tween:Tween)->Tween:
	scene.pivot_offset = scene.size/2
	tween.tween_property(scene,"scale",Vector2(0.1,0.1),0.3)
	return tween
##endregin

##regin 工具类
#删除自身
func destory_self():
	destory.emit(self)

#睡眠
func sleep(time):
	time *= 1000000
	OS.delay_usec(time)
##endregin
