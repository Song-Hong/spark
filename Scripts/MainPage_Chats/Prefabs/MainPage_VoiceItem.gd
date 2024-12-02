# 语音消息
extends Button

var voice_path = "res://test.wav" #语音位置
var tween:Tween #动画

#初始化
func init(_voice_path):
	voice_path = _voice_path

#初始化—订阅
func _ready():
	pressed.connect(Callable(self,"on_pressed"))
	if FileAccess.file_exists(voice_path):
		text = str(round(load_wav().get_length()))+"''"
	else:
		text = "Loading..."
		await Core.init.get_tree().create_timer(1).timeout
		if FileAccess.file_exists(voice_path):
			text = str(round(load_wav().get_length()))+"''"
		else:
			text = ""
#退出场景
func _exit_tree():
	animation_stop()
	pressed.disconnect(Callable(self,"on_pressed"))

#当按钮点击时
func on_pressed():
	var asp:AudioStreamPlayer = Blackboard.init.get_data("AudioStreamPlayer")
	asp.stream = load_wav()
	asp.finished.connect(Callable(self,"animation_stop"),4)
	asp.play()
	animation_play()

#加载wav文件
func load_wav()->AudioStreamWAV:
	var file = FileAccess.open(ProjectSettings.globalize_path(voice_path),FileAccess.READ)
	var data = file.get_buffer(file.get_length())
	var asw := AudioStreamWAV.new()
	asw.format = AudioStreamWAV.FORMAT_16_BITS
	asw.loop_mode = AudioStreamWAV.LOOP_DISABLED
	asw.loop_begin = 0
	asw.loop_end = 0
	asw.mix_rate = 48000
	asw.stereo = true
	asw.data = data
	return asw

#当语音播放时播放动效
func animation_play():
	tween = Core.init.create_tween()
	tween.tween_property(self,"scale",Vector2.ONE*1.02,0.1)
	tween.tween_property(self,"scale",Vector2.ONE,0.1)
	tween.tween_property(self,"scale",Vector2.ONE*0.98,0.1)
	tween.set_loops(10)

#结束动画播放
func animation_stop():
	if tween != null:
		tween.stop()
		tween = null
	scale = Vector2.ONE
