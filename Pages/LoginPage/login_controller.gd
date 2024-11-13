#登陆管理
extends Node

func _ready():
	$"../..".LoginBtn.connect("pressed",Callable(self,"login_request"))

func login_request():
	var data = '{"App"  : "Spark","Type" : 10001,"Data" : {'
	data    += '"U":'+$"../..".Username.text+',"P":'+$"../..".Password.text+"}}"
	$"../ServerConnect".send(data)
