#搜索输入
extends Node

var SearchInput:LineEdit    #输入框
var ShowArea:VBoxContainer #搜索结果区域

#初始化
func _ready():
	ShowArea    = $"../..".ShowArea
	SearchInput = $"../..".SearchInput
	Song.Module.Net.receive.connect("friend_search_receive",Callable(self,"_on_friend_search_receive"))

#断开监听
func _exit_tree():
	Song.Module.Net.receive.disconnect("friend_search_receive",Callable(self,"_on_friend_search_receive"))

#当结束输入,发送好友查询
func _on_text_submitted(text):
	# 清除搜索框
	SearchInput.clear()
	#清除之前搜索结果
	clear_search_show_item_area()
	# 发送好友请求
	var json    = NetJson.new()
	json.Type   = 10008
	json.Data.U = text
	Song.Module.Net.send(json.to_json())

#接收到搜索结果
func _on_friend_search_receive(data):
	for item in data:
		if ShowArea.get_node_or_null(str(item.id)):
			continue
		
		var person_card = load("res://Pages/Search/Perfabs/person_card.tscn").instantiate()
		ShowArea.add_child(person_card)
		person_card.init(item.id,item.Name,item.Username)
		person_card.name = str(item.id)

#清除搜索区域
func clear_search_show_item_area():
	for item in ShowArea.get_children():
		ShowArea.remove_child(item)
