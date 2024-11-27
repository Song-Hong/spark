#软件初始化流程
extends AProcess
class_name InitAppProcess

#流程开始
func start():
	# 添加自定义模块
	Core.init.add_CustomModule(SparkServer.new()) # Spark服务器
	Core.init.add_CustomModule(DB.new()) #数据库
	# 读取配置文件设置
	var ac = DB.init.read_core()
	TranslationServer.set_locale(ac.language)
	
	#切换流程
	change_process(LoginPageProcess.new())
	
#流程结束
func exit(): pass
