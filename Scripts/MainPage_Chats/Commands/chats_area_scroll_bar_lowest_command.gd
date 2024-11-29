#滚动消息显示至最底部
extends ACommand
class_name chats_area_scroll_bar_lowest_command

#初始化
func _init():
	Blackboard.init.get_data("ChatContentScroll").get_v_scroll_bar().ratio = 1
	exec_finshed()
