#搜索输入
extends Node

var SearchInput:LineEdit #输入框

#初始化
func _ready():
	SearchInput = $"../..".SearchInput

#当结束输入,发送好友查询
func _on_text_submitted(text):
	# 清除搜索框
	SearchInput.clear()
	# 发送好友请求
	return
	var json = '{"App"  : "Spark","Type" : 10008,"Data" : {"U":"%s"}}'%text
	Song.Module.Net.send(json)
