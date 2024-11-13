extends Node

func _ready():
	$"../NetConnectionController".connect("receive_data",Callable(self,"_on_receive_data"))

#消息接收
func _on_receive_data(msg):
	print(msg)
