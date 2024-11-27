extends Node
class_name AppConfig

var language # 软件语言
var logined # 是否登陆
var user_username # 用户名
var user_password # 密码

func to_json()->String:
	var dir:Dictionary
	dir.language = language
	dir.logined   = logined
	dir.user_username = user_username
	dir.user_password = user_password
	return JSON.stringify(dir)
