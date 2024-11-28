#创建聊天气泡
extends ACommand
class_name create_chat_item_command

#0_文本 1_表情 2_图片 3_语音 4_文件 5_链接
func _init(md:MessageData):
	var item = null
	match str(md.type):
		'0': #文本消息
			item = Scene.init.load_scene("/prefabs/chat_item")
			item.text = md.data
		'1':
			pass
		'2': #图片消息
			item = Scene.init.load_scene("/prefabs/img_item")
			var img = Image.load_from_file(md.data)
			item.icon = ImageTexture.create_from_image(img)
		'3':
			pass
	if item == null:return
	#将气泡添加至场景
	Blackboard.init.get_data("ChatContentArea").add_child(item)
	#设置气泡的位置
	if md.own:
		item.size_flags_horizontal = Control.SIZE_SHRINK_END
	else:
		item.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	exec_finshed()
