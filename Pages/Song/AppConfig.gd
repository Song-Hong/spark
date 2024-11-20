#软件配置文件
class_name AppConfig

var language      #软件语言
var logined       #是否登陆
var user_username #用户名
var user_password #密码

#转换为json格式
func to_json()->String:
	return JSON.stringify({"language":language,
	"logined":logined,
	"user_username":user_username,
	"user_password":user_password})
