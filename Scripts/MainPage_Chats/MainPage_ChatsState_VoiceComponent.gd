#消息界面语音输入管理
extends AComponent
class_name MainPage_ChatsState_VoiceComponent

var effect #录音总线
var recording #音频
var voice_button#录音按钮

#初始化
func start():
	#初始化
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	voice_button = Blackboard.init.get_data("MainChat_Voice_Button")
	#监听按钮事件
	voice_button.button_down.connect(Callable(self,"on_voice_btn_down"))
	voice_button.button_up.connect(Callable(self,"on_voice_btn_up"))
	
#退出
func exit():
	voice_button.button_down.disconnect(Callable(self,"on_voice_btn_down"))
	voice_button.button_up.disconnect(Callable(self,"on_voice_btn_up"))

#当按钮按下时
func on_voice_btn_down():
	#开始录音
	record()

#当按钮抬起时
func on_voice_btn_up():
	#结束录音
	record()
	#play()
	save()

# 录音开启以及关闭
func record():
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		voice_button.text = ""
	else:
		effect.set_recording_active(true)
		voice_button.text = "Recording"

# 文件存储
func save():
	#格式化消息
	var md  = MessageData.Voice("")
	md.data = DB.init.NowUserPath+"/"+md.gen_only_id()+".wav"
	#存储消息
	recording.save_to_wav(md.data)
	#向服务器发送语音文件
	upload_file_to_server_command.new(md.data)
	#创建消息气泡
	create_chat_item_command.new(md)
	#更新最后消息
	update_friend_last_message_command.new(Global.TargetID,"[语音]")
	#存储当前消息
	DB.init.save_md(Global.TargetID,md)
	#发送消息
	md.data = md.gen_only_id()+".wav"
	send_md_command.new(md)
	#滚动消息
	await Core.init.get_tree().create_timer(0.1).timeout
	chats_area_scroll_bar_lowest_command.new()
