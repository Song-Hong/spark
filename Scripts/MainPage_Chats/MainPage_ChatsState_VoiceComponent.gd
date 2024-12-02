#消息界面语音输入管理
extends AComponent
class_name MainPage_ChatsState_VoiceComponent

var effect
var recording

#初始化
func start():
	#初始化
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	#监听按钮事件
	Blackboard.init.get_data("MainChat_Voice_Button").button_down.connect(Callable(self,"on_voice_btn_down"))
	Blackboard.init.get_data("MainChat_Voice_Button").button_up.connect(Callable(self,"on_voice_btn_up"))
	
#退出
func exit():
	Blackboard.init.get_data("MainChat_Voice_Button").button_down.disconnect(Callable(self,"on_voice_btn_down"))
	Blackboard.init.get_data("MainChat_Voice_Button").button_up.disconnect(Callable(self,"on_voice_btn_up"))

#当按钮按下时
func on_voice_btn_down():
	#开始录音
	record()

#当按钮抬起时
func on_voice_btn_up():
	#结束录音
	record()
	play()

# 录音开启以及关闭
func record():
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
	else:
		effect.set_recording_active(true)

# 播放录音
func play():
	var data = recording.get_data()
	var asp = Blackboard.init.get_data("AudioStreamPlayer")
	asp.stream = recording
	asp.play()
