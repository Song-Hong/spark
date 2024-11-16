#搜索
extends Node

var SearchArea:Button #搜索区域

#初始化
func _ready():
	SearchArea = $"../..".SearchPanel
	
	$"../..".SearchButton.connect("pressed",Callable(self,"_on_pressed"))

#当按钮点击时
func _on_pressed():
	SearchArea.display()

#TEST 
func _exit_tree():
	$"../..".SearchButton.disconnect("pressed",Callable(self,"_on_pressed"))
